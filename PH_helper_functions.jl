## Functions to make running and analyzing persistent homology a little easier.



function createSimplexLists(incidenceMatrix,simplex_named_list)

    # Will make lists of edges, 2-simplices, and 3-simplices
    edge_list = Any[]
    simp2_list = Any[]
    simp3_list = Any[]

    for (index,simplex_name) in enumerate(simplex_named_list)

        indices_of_simplex_nodes = findall(incidenceMatrix[index,:].>0)

        edges_from_simplex = collect(combinations(indices_of_simplex_nodes,2))
        simp2_from_simplex = collect(combinations(indices_of_simplex_nodes,3))
        simp3_from_simplex = collect(combinations(indices_of_simplex_nodes,4))


        for (index2,edge) in enumerate(edges_from_simplex)
            push!(edge_list,edge)
        end
        for (index2,simp2) in enumerate(simp2_from_simplex)
            push!(simp2_list,simp2)
        end
        for (index2,simp3) in enumerate(simp3_from_simplex)
            push!(simp3_list,simp3)
        end
    end
    edge_list = unique(edge_list)
    simp2_list = unique(simp2_list)
    simp3_list = unique(simp3_list)



    return edge_list, simp2_list, simp3_list
end


function createCellList(nNodes,edgeList,keepTriangles)
    n2Simps = length(keepTriangles)
    nEdges = length(edgeList)
    #E = Array{Array{Float64}}((Int(nNodes+nEdges+n2Simps)),1)
    E = Array{Array{Float64,1},1}(undef,Int(nNodes+nEdges+n2Simps))
    nCells = length(E)
    for a0 in collect(1:nCells)

        if a0 <= nNodes
            E[a0] = [a0]
        elseif a0 > (nNodes) && a0<=(nNodes+nEdges)
            E[a0] = edgeList[a0-nNodes]
        else
            E[a0] = keepTriangles[a0-(nNodes+nEdges)]

        end

    end
    E
end

function createDMatrix(E,nNodes,nEdges)
    D_01 = Int.(issubset.(E[1:nNodes],E[(nNodes+1):(nNodes+nEdges)]'))
    D_12 = Int.(issubset.(E[(nNodes+1):(nNodes+nEdges)],E[(nNodes+nEdges+1):length(E)]'))
    D = zeros(length(E),length(E))
    D[1:nNodes,(nNodes+1):(nNodes+nEdges)] = D_01
    D[(nNodes+1):(nNodes+nEdges),(nNodes+nEdges+1):length(E)] = D_12
    D = sparse(D)
end

function determineCellWeight(cell)
    cellWeight = maximum(node_weights[Int.(cell)])
end


function bettiCurveFromBarcode(barcode,nNodes,node_weights)

    nNodes = Int(nNodes)
    bettiCurve = zeros(nNodes+1,1)
    ordered_weights = sort(unique(node_weights))

    for bar in collect(1:size(barcode,1))

        birth_index = Int(findall(ordered_weights.==barcode[bar,1])[1])

        if barcode[bar,2]>nNodes

            bettiCurve[birth_index:Int(nNodes+1),1] = bettiCurve[birth_index:Int(nNodes+1),1] .+1
        else

            death_index = Int(findall(ordered_weights.==barcode[bar,2])[1])
            bettiCurve[birth_index:death_index,1] = bettiCurve[birth_index:death_index,1].+1

        end
    end

    return bettiCurve
end


function plotBarcode(barcode,nNodes)

    nNodes = Int(nNodes)
    pbar = plot(1:6,zeros(6,1),c=:black)

    barcode_sorted = barcode[sortperm(barcode[:,1]),:]
    nbars = size(barcode)[1]


    for bar_index in collect(1:nbars)
        birth = barcode[bar_index,1]
        death = barcode[bar_index,2]
        if death>nNodes
            death = nNodes+1
        end

        plot!([birth, death],[bar_index, bar_index], legend = false,
                            xlim = (0,nNodes))
    end


    return pbar
end
