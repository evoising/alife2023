using Random,Distributions
using Plots
using Compose
using Measures
using Plots.PlotMeasures

plotlyjs()

include("Utilities.jl")


function deltaE(grid,r1,r2,bit)

    state1=grid.grid[r1[1],r1[2]]
    state2=grid.grid[r2[1],r2[2]]
    dEGrid=lam*state1[bit]*state2[bit]

    dEState=0.0
    if grid.lam!=1.0
        otherBits=getStateNeighbours(grid,bit)        
        dEState=0.5*(1.0-lam)*state1[bit]*(state1[otherBits[1]]+state1[otherBits[2]])
    end
    
    dE=grid.lam*dEGrid+(1-grid.lam)*dEState

end

function getBest(grid,pos,neighbours)

    eValues=[similarity(grid[neighbours[i][1],neighbours[i][2]],grid[pos[1],pos[2]]) for i in 1:length(neighbours)]
        
    best=maximum(eValues)

    rand([i for i in 1:length(neighbours) if eValues[i]==best])
    
end


function runGrid(tSteps::Int64,grid::Grid,temperature)

    for t in 1:tSteps
        
        for x in 1:grid.nX
            for y in 1:grid.nY
                r=pick(grid)
                neighbours=getNeighbours([grid.nX,grid.nY],r)
                bestN=getBest(grid.grid,r,neighbours)
                bit=rand(1:grid.l)
                dE=deltaE(grid,r,neighbours[bestN],bit)
                if dE<=0 || rand(Uniform(0.0,1.0))<exp(-dE/temperature)
                    grid.grid[r[1],r[2]][bit]*=-1
                end
            end
        end
    end

    grid
    
end


function getMagnetization(tEquilibrium,tResample,nSample,grid,temperature)

    grid=runGrid(tEquilibrium,grid,temperature)
    
    this_Magnetization=magnetization(grid)

    for sample in 1:nSample-1
        grid=runGrid(tResample,grid,temperature)
        this_Magnetization+=magnetization(grid)
    end

    return this_Magnetization/nSample
    
    
end

function getEnergy(tEquilibrium,tResample,nSample,grid,temperature,bigE)

    grid=runGrid(tEquilibrium,grid,temperature)
    
    thisEnergy=bigE(grid)

    for sample in 1:nSample-1
        grid=runGrid(tResample,grid,temperature)
        thisEnergy+=bigE(grid)
    end

    return thisEnergy/nSample
        
end

nX=50

stateL=25

lam=1.0


#tEpoch=200000
#nEpoch=250


temperature=0.45

tEpoch=25000

doEdges=true

if doEdges
    
    edges=zeros(Float64,stateL+1)

    for _ in 1:10
        global edges
        grid=makeGrid([nX,nX],stateL,lam)
        grid=runGrid(tEpoch,grid,temperature)
        edges+=countEdgeSimilarity(grid)
        #print(edges)
    end
    println()    
    println(edges/sum(edges))
    
    exit()

end


temperatures=[0.01*i for i in 1:150]
restarts=1
tResample=100
nSample=1
tEquilibrium=125000

for temperature in temperatures

    thisEnergy=0.0

    print(temperature," ")
    
    for _ in 1:restarts
        grid=makeGrid([nX,nX],stateL,lam)
        trialEnergy=getEnergy(tEquilibrium,tResample,nSample,grid,temperature,bigENearest)
        print(trialEnergy," ")
        thisEnergy+=trialEnergy
    end
    
    println(thisEnergy/restarts)

end

exit()



grid=makeGrid([nX,nX],stateL,lam)

println(0," ",bigEAll(grid))

for e in 1:nEpoch
    
    global grid
    
    grid=runGrid(tEpoch,grid,temperature)
    thisEnergyAll=bigEAll(grid)
    println(e," ",thisEnergy)

    
end




#---------------------------------------------------------

#exit()

#temperature=0.2

#grid=makeGrid([nX,nX],stateL,lam)

#thisEnergy=getEnergy(tEquilibrium,tResample,nSample,grid,temperature)


#plotGrid(grid,"test.png")


#---------------------------------------------------------

#exit()

#temperatures=[0.01*i for i in 1:150]



#for temperature in temperatures

#    thisEnergy=0.0
    
#    for _ in 1:restarts
#        grid=makeGrid([nX,nX],stateL,lam)
#        thisEnergy+=getEnergy(tEquilibrium,tResample,nSample,grid,temperature)
#    end
    
#    println(temperature," ",thisEnergy/restarts)

#end


#old stuff

#println("initial plot")

#p = plotGrid(grid)
#savefig("initial.png")

#println("starting loop")

#anim = @animate for t in 1:tFinal



#gif(anim, "animation.gif", fps=200)


    
