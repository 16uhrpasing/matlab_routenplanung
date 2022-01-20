function point = ...
pointMatch(...
selectedPoint, ...
points...
)

currentDist = inf;

for i=1:length(points)
    %current point without its index
    currentPoint = points(i, 1:2);

    compare = [selectedPoint; currentPoint];
    distance = pdist(compare,'euclidean');
    
    if(distance < currentDist)
        currentDist = distance;
        %return with index
        point = points(i,:);
    end


end

        %disp("pointMatch: " + point);

end