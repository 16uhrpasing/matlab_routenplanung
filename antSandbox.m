roads = shaperead('boston_roads.shp'); 
   
worldFile = 'myboston.jgw'; 
img = imread('myboston3.jpg'); 
R = worldfileread(worldFile); 

geoshow(img, R); 
title('Boston roads (geographic)'); 

[adjMatrix, startEndList, startEndListGeo] = shpToGeoEucAdj(roads);


indices = [2; 1000; 1300; 500; 4];
alpha = 0.3;
beta = 0.7;
rho = 0.1;
delta = 0.4;
maxIter = 10;

bestTour =...
    antAlgo(indices, startEndList, alpha, beta, rho, delta, maxIter);

disp(bestTour);