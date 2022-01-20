function bestTour = antAlgo(indices, startEndList, alpha, beta, rho, delta, maxIter)

indicesCount = height(indices);

% Datenstrukturen initialisieren
distMatrix = zeros(indicesCount, indicesCount); %distanzMatrix
for i=1:indicesCount
    for j=1:indicesCount
            distMatrix(i,j) = pdist([startEndList(i); startEndList(j)],'euclidean');
    end
end


P = zeros(indicesCount, indicesCount); 
P(:) = 0.5; %PheromonMatrix

%antTour = [];


% Für t Iterationen
while (maxIter > 0)
% Für jede Ameise: Tour berechnen
    %antTour = [];
    
    bestTour = [];
    %bestTourIndex = 0;
    bestTourSum = inf;
    
    %Aktuell beste Tour berechnen und ggf merken
    for i = 1 : indicesCount
        result.tour = calcAntTour( i, P, distMatrix, beta, alpha );
        result.sum = sum(result.tour);
        %antTour(end+1) = result;
        
        if result.sum < bestTourSum
           bestTour = result.tour;
           %bestTourIndex = i;
           bestTourSum = result.sum;
        end
    end

    %Pheromone verfliegen
    P = (1-rho) * P;
    
    for i = 1 : indicesCount-1
        P(bestTour(i), bestTour(i+1)) = P(bestTour(i), bestTour(i+1)) + delta;
    end
    P(bestTour(indicesCount), bestTour(1)) =...
        P(bestTour(indicesCount), bestTour(1)) + delta;
    
    maxIter = maxIter-1;
end


end