using Random,Distributions
using Plots
import Base.get
plotlyjs()

include("Utilities.jl")

function deltaE(grid,r,bit)

    state=grid.grid[r[1],r[2]]
    dEGrid=0.0
    neighbours=getNeighbours(grid,r)
    for n in neighbours
        nState=grid.grid[n[1],n[2]]
        dEGrid+=0.25*state[bit]*nState[bit]
    end

    dEState=0.0
    
    if grid.lam!=1.0
        otherBits=getStateNeighbours(grid,bit)
        dEState=0.5*state[bit]*(state[otherBits[1]]+state[otherBits[2]])
    end
    dE=grid.lam*dEGrid+(1-grid.lam)*dEState
end

function runGrid(tSteps::Int64,grid::Grid,temperature)

    for t in 1:tSteps
        
        for x in 1:grid.nX
            for y in 1:grid.nY
                r=pick(grid)
                bit=rand(1:grid.l)
                dE=deltaE(grid,r,bit)
                if dE<=0 || rand(Uniform(0.0,1.0))<exp(-dE/temperature)
                    grid.grid[r[1],r[2]][bit]*=-1
                end
            end
        end
    end

    grid
    
end


function histogram(grid)
    hist = Dict{Int, Int}()

    for x in 1:grid.nX
        for y in 1:grid.nY
            state=toBinary(grid.grid[x,y])
            hist[state]=get(hist,state,0)+1
        end
    end
    
    return hist
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


function bigE_all(grid::Grid)
    energyGrid=0.0
    for x in 1:grid.nX
        for y in 1:grid.nY
            neighbours=getNeighbours(grid,[x,y])
            for n in neighbours
                for b in 1:grid.l
                    energyGrid+=-0.25*grid.grid[x,y][b]*grid.grid[n[1],n[2]][b]
                end
            end
        end
    end
    energyGrid/=grid.nX*grid.nY*grid.l

    energyState=0.0
    if grid.lam!=1
        for x in 1:grid.nX
            for y in 1:grid.nY
                for bit in 1:grid.l
                    nBit=getStateNeighbours(grid,bit)
                    energyState-=0.5*grid.grid[x,y][bit]*(grid.grid[x,y][nBit[1]]+grid.grid[x,y][nBit[2]])
                end
            end
        end
        energyState/=grid.nX*grid.nY*grid.l
    end
    
    grid.lam*energyGrid+(1.0-grid.lam)*energyState
    
end


function getEnergy(tEquilibrium,tResample,nSample,grid,temperature)

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


temperature=0.3

tEpoch=25000


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


temperature=0.3

tEpoch=25000

grid=makeGrid([nX,nX],stateL,lam)
grid=runGrid(tEpoch,grid,temperature)
println(countEdgeSimilarity(grid))

plotGrid(grid,20,20,"ord.png")

exit()



tEquilibrium=25000
restarts=10
tResample=100
nSample=1

temperatures=[0.01*i for i in 1:150]

for temperature in temperatures

    thisEnergy=0.0

    print(temperature," ")
    
    for _ in 1:restarts
        grid=makeGrid([nX,nX],stateL,lam)
        trialEnergy=getEnergy(tEquilibrium,tResample,nSample,grid,temperature)
        print(trialEnergy," ")
        thisEnergy+=trialEnergy
    end
    
    println(thisEnergy/restarts)

end

exit()



nX=50

stateL=10

lam=0.99





tEquilibrium=25000




temperature=0.3

grid=makeGrid([nX,nX],stateL,lam)
println(histogram(grid))

grid=runGrid(tEquilibrium,grid,temperature)

plotGrid(grid,"ord_la0.5_states5.png")

h=histogram(grid)
println(h)
println()
println(get(h,0,0))
println(get(h,2^stateL-1,0))

#---------------------------------------
exit()
#----------------------------------------

restarts=10

tResample=100
nSample=1

temperatures=[0.01*i for i in 1:150]

for temperature in temperatures

    thisEnergy=0.0

    print(temperature," ")
    
    for _ in 1:restarts
        grid=makeGrid([nX,nX],stateL,lam)
        trialEnergy=getEnergy(tEquilibrium,tResample,nSample,grid,temperature)
        print(trialEnergy," ")
        thisEnergy+=trialEnergy
    end
    
    println(thisEnergy/restarts)

end



    
