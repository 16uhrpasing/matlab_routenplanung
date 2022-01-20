%info = array [lat, lon, u, v];
function [] = ...
clearPointsAndPaths()
            worldFile = 'myboston.jgw'; 
            img = imread('myboston3.jpg'); 
            R = worldfileread(worldFile); 
            geoshow(img, R); 
end