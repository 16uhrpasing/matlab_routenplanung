roads = shaperead('boston_roads.shp'); 

   
worldFile = 'myboston.jgw'; 
img = imread('myboston3.jpg'); 
R = worldfileread(worldFile); 



geoshow(img, R); 
title('Boston roads (geographic)'); 

[adjMatrix, startEndList, startEndListGeo] = shpToGeoEucAdj(roads);

%bad test case
%startIndex = 3309;
%endIndex = 1955;

startIndex = 18;
endIndex = 5569;

%startIndex = 2;
%endIndex = 500;

load('shapefile_HIGHWAY.mat');
geoshow(roads_geo_out, 'Color', 'green','LineWidth',1);

load('shapefile_LOCAL.mat');
geoshow(roads_geo_out, 'Color', 'blue','LineWidth',1);

%geoshow(startEndListGeo(startIndex,1), startEndListGeo(startIndex,2), 'DisplayType', 'point', 'color', 'cyan','LineWidth',3);
%geoshow(startEndListGeo(endIndex,1), startEndListGeo(endIndex,2), 'DisplayType', 'point', 'color', 'blue','LineWidth',5);

parallel = false;

if parallel


[threadResult1, threadResult2] = aStarPathFinderX(...
adjMatrix, ...
startEndList,...
startEndListGeo,...
startIndex,...
endIndex...
);
 traversalList1 = threadResult1{1};
 traversalList2 = threadResult2{2};

 load("roads_geo_out.mat");
 for i=2:length(traversalList1)-1
        currentRoadIndex = traversalList1(i);
        if(currentRoadIndex > roadCount) currentRoadIndex = currentRoadIndex - roadCount; end
        geoshow(roads_geo_out(currentRoadIndex), 'color', 'red', 'LineWidth', 4);
 end
 
 for i=2:length(traversalList2)-1
        currentRoadIndex = traversalList2(i);
        if(currentRoadIndex > roadCount) currentRoadIndex = currentRoadIndex - roadCount; end
        geoshow(roads_geo_out(currentRoadIndex), 'color', 'cyan', 'LineWidth', 4);
 end


else
aStarPathFinder(...
adjMatrix, ...
startEndList,...
startEndListGeo,...
startIndex,...
endIndex...
);
end