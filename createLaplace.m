function L = ...
createLaplace(...
adjMatrix...
)

    adjSize = length(A);

    L = zeros(adjSize, adjSize);

    for i=1:adjSize
        for j=i+1:adjSize
            if adjMatrix(j, i) > 0
                L(j,i) = -1;
                L(i,j) = -1;
            end
        end
    end

    for i=1:adjSize
        L(i,i) = abs( sum(L(i,:)) );
    end


end