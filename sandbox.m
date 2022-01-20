roads = shaperead('boston_roads.shp'); 

[adjMatrix, startEndList, startEndListGeo] = shpToGeoEucAdj(roads);
roads = shaperead('boston_roads.shp'); 

startEndListWithIndices = [startEndListGeo, (1:(length(startEndListGeo)))'];

clickPoint = [42.368722094003 -71.050250878100];

%zuerst nach Y gesplittet
kd_tree = create_kd_tree(startEndListWithIndices, 1, 7);

points = search_kd_tree(clickPoint, kd_tree);

found = pointMatch(clickPoint, points);

disp(found);

%disp(startEndListGeo(5079,:));
%disp(length(startEndListGeo));  
%worldFile = 'myboston.jgw'; 
%img = imread('myboston3.jpg'); 
%R = worldfileread(worldFile);



%geoshow(img, R); 
%title('Boston roads (geographic)'); 


%load and show geographical shapefile
% ## example jpg mit jgw ## 
%{
worldFile = 'myboston.jgw'; 
img = imread('myboston.jpg'); 
R = worldfileread(worldFile); 


geoshow(img, R); 
title('Boston roads (geographic)'); 

load('shapefile_HIGHWAY.mat');
geoshow(roads_geo_out, 'Color', 'green');

load('shapefile_LOCAL.mat');
geoshow(roads_geo_out, 'Color', 'blue');


for i=1:roadCount
   for j=1:roadCount*2
       if(adjMatrix(i,j) == 2) %kreuzung
           geoshow(startEndListGeo(i,1), startEndListGeo(i,2), 'DisplayType', 'point', 'color', 'r');
           geoshow(startEndListGeo(j,1), startEndListGeo(j,2), 'DisplayType', 'point', 'color', 'r');
       end
   end
end 
%}
