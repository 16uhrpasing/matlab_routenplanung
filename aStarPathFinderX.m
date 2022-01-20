%info = array [lat, lon, u, v];
function [traversalList1, traversalList2] = ...
aStarPathFinderX(...
adjMatrix, ...
startEndList,...
startEndListGeo,...
startIndex,...
endIndex...
)

geoshow(startEndListGeo(startIndex,1), startEndListGeo(startIndex,2), 'DisplayType', 'Point', 'Marker', '+', 'Color', 'green');
geoshow(startEndListGeo(endIndex,1), startEndListGeo(endIndex,2), 'DisplayType', 'Point', 'Marker', '+', 'Color', 'green');

spmd
if labindex <= 3
%THREAD 1: aStar start to end
%THREAD 2: aStart end to start
%THREAD 3: collector und comparer
%THREAD 4: main thread, gets the traversal lists from thread 1 and thread
%2, then draws

threadOne = 1;
threadTwo = 2;
collectorThread = 3;



if labindex == threadOne 
    [result1] = aStarThread(...
    adjMatrix, ...
    startEndList,...
    startEndListGeo,...
    startIndex,...
    endIndex...
    );

    traversalList1 = result1;
    
    disp("traversalList1: " + result1);
elseif labindex == threadTwo
    [result2] = aStarThread(...
    adjMatrix, ...
    startEndList,...
    startEndListGeo,...
    endIndex,...
    startIndex...
    );

    traversalList2 = result2;
    
    disp("traversalList2: " + result2);
elseif labindex == collectorThread
    aStarCollector();
end
    
    
   %load('nshapefile_ALL.mat');
   %Alle Punkte aus TraversalIndexList zeichnen
   %for i=2:length(TraversalIndexList)-1
   %    currentRoadIndex = TraversalIndexList(i);
   %    if(currentRoadIndex > roadCount) currentRoadIndex = currentRoadIndex - roadCount; end
   %    geoshow(roads_geo_out(currentRoadIndex), 'color', 'green', 'LineWidth', 4);
   %end

end %end thread number check
end %end spmd
end %end function