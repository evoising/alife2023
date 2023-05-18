

struct GridSize
    nX::Int64
    nY::Int64
end

struct Grid
    nX::Int64
    nY::Int64
    l::Int64
    grid::Array{}
    lam::Float64
end


function get(gridSize::GridSize,x::Int64,y::Int64)
    get([gridSize.nX,gridSize.nY],x,y)
end

function get(size::Vector{Int64},x::Int64,y::Int64)

    nX=size[1]
    nY=size[2]
    
    if x<1
        x+=nX
    elseif x>nX
        x-=nX
    end
    
    if y<1
        y+=nY
    elseif y>nY
        y-=nY
    end

    x,y

end

function pick(gridSize::GridSize)
    rand(1:gridSize.nX),rand(1:gridSize.nY)
end

function pick(grid::Grid)
    rand(1:grid.nX),rand(1:grid.nY)
end


function getNeighbours(gridSize::GridSize,r)
    getNeighbours([gridSize.nX,gridSize.nY],r)
end


function getNeighbours(grid::Grid,r)
    getNeighbours([grid.nX,grid.nY],r)
end
    
function getNeighbours(size::Vector{Int64},r)
    
    neighbours=Vector{Vector{Int64}}()
    
    x,y=get(size,r[1]+1,r[2])
    push!(neighbours,[x,y])
    x,y=get(size,r[1],r[2]+1)
    push!(neighbours,[x,y]) 
    x,y=get(size,r[1]-1,r[2])
    push!(neighbours,[x,y]) 
    x,y=get(size,r[1],r[2]-1)
    push!(neighbours,[x,y]) 

    neighbours
end


function getStateNeighbours(grid::Grid,bit::Int64)

    bitM=bit-1
    if bitM<1
        bitM+=grid.l
    end

    bitP=bit+1
    if bitP>grid.l
        bitP-=grid.l
    end

    [bitM,bitP]
end


function makeGrid(gridSize::GridSize,stateSize::Int64)
    makeGrid([gridSize.nX,gridSize.nY],stateSize)
end


function makeGrid(gridSize::Vector{Int64},stateSize::Int64,lam::Float64)
    nX=gridSize[1]
    nY=gridSize[2]
    grid=fill(ones(Int64,stateSize),nX,nY)
    for x in 1:nX
        for y in 1:nY 
            grid[x,y]=rand([-1,1],stateSize)
        end
    end
    Grid(nX,nY,stateSize,grid,lam)
end


function getNeighbours(gridSize::GridSize,r)
    getNeighbours([gridSize.nX,gridSize.nY],r)
end


function getNeighbours(grid::Grid,r)
    getNeighbours([grid.nX,grid.nY],r)
end

function getStateNeighbours(grid::Grid,bit::Int64)

    bitM=bit-1
    if bitM<1
        bitM+=grid.l
    end

    bitP=bit+1
    if bitP>grid.l
        bitP-=grid.l
    end

    [bitM,bitP]
end
    
function getNeighbours(size::Vector{Int64},r)
    
    neighbours=Vector{Vector{Int64}}()
    
    x,y=get(size,r[1]+1,r[2])
    push!(neighbours,[x,y])
    x,y=get(size,r[1],r[2]+1)
    push!(neighbours,[x,y]) 
    x,y=get(size,r[1]-1,r[2])
    push!(neighbours,[x,y]) 
    x,y=get(size,r[1],r[2]-1)
    push!(neighbours,[x,y]) 

    neighbours
end

function makeGrid(gridSize::GridSize,stateSize::Int64)
    makeGrid([gridSize.nX,gridSize.nY],stateSize)
end


function makeGrid(gridSize::Vector{Int64},stateSize::Int64,lam::Float64)
    nX=gridSize[1]
    nY=gridSize[2]
    grid=fill(ones(Int64,stateSize),nX,nY)
    for x in 1:nX
        for y in 1:nY 
            grid[x,y]=rand([-1,1],stateSize)
        end
    end
    Grid(nX,nY,stateSize,grid,lam)
end


function similarity(state1,state2)
    similarity=0
    for i in 1:length(state1)
        if state1[i]==state2[i]
            similarity+=1
        end
    end
    similarity
end

function plotGrid(grid::Grid, nX::Int64,nY::Int64,filename; kwargs...)
    p=plotGrid(grid,nX,nY; kwargs...)
    savefig(p, filename)
end

function plotGrid(grid::Grid,filename; kwargs...)
    p=plotGrid(grid; kwargs...)

    savefig(p, filename)
end



function plotGrid(grid::Grid; kwargs...)
    
    s=Array{Int}(undef,(grid.nX,grid.nY))
    
    for i in 1:grid.nX
        for j in 1:grid.nY
            s[i,j]=toBinary(grid.grid[i,j])
        end
    end

    Plots.heatmap(s,
            colorbar = false, axis = false
                  )
    
    
end


function plotGrid(grid::Grid,nX::Int64,nY::Int64; kwargs...)
    
    s=Array{Int}(undef,(nX,nY))
    
    for i in 1:nX
        for j in 1:nY
            s[i,j]=toBinary(grid.grid[i,j])
        end
    end

    Plots.heatmap(s,
                  colorbar = false, axis = false,
                  size=(250,250)
                  )
    
    
end


function magnetization(grid::Grid)

    total=0

    for bit in 1:grid.l
        bitTotal=0
        for x in 1:grid.nX
            for y in 1:grid.nY
                bitTotal+=grid.grid[x,y][bit]
            end
        end
        total+=abs(bitTotal)
    end
    
    total/(grid.l*grid.nX*grid.nY)
end

    

function toBinary(state)
    power=1
    total=0
    for s in state
        if s==1
            total+=power
        end
        power*=2
    end

    total
end

function countTypes(grid::Grid)

    s=zeros(Int64,2^grid.l)
    
    for i in 1:grid.nX
        for j in 1:grid.nY
            s[toBinary(grid.grid[i,j])+1]+=1
        end
    end

    s
end


function countEdgeSimilarity(grid::Grid)
    histogram=zeros(Int64,grid.l+1)

    for x in 1:grid.nX
        for y in 1:grid.nY
            neighbours=getNeighbours(grid,[x,y])
            for n in neighbours
                s=similarity(grid.grid[x,y],grid.grid[n[1],n[2]])
                histogram[s+1]+=1
            end
        end
    end

    histogram

end


function bigENearest(grid::Grid)
    energyGrid=0.0
    for x in 1:grid.nX
        for y in 1:grid.nY
            neighbours=getNeighbours(grid,[x,y])
            bestN=getBest(grid.grid,[x,y],neighbours)
            n=neighbours[bestN]
            for bit in 1:grid.l
                energyGrid+=-grid.grid[x,y][bit]*grid.grid[n[1],n[2]][bit]
            end
        end
    end
    energyGrid/=grid.nX*grid.nY*grid.l


    
    energyState=0.0
    
    if grid.lam!=1.0
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


function bigEAll(grid::Grid)
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
