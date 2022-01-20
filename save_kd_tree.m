roads = shaperead('boston_roads.shp'); 

[adjMatrix, startEndList, startEndListGeo] = shpToGeoEucAdj(roads);
roads = shaperead('boston_roads.shp'); 

startEndListWithIndices = [startEndListGeo, (1:(length(startEndListGeo)))'];


kd_tree = create_kd_tree(startEndListWithIndices, 1, 9);

save("kd_tree9.mat", 'kd_tree');

kd_tree = create_kd_tree(startEndListWithIndices, 1, 8);

save("kd_tree8.mat", 'kd_tree');

kd_tree = create_kd_tree(startEndListWithIndices, 1, 7);

save("kd_tree7.mat", 'kd_tree');

kd_tree = create_kd_tree(startEndListWithIndices, 1, 6);

save("kd_tree6.mat", 'kd_tree');

kd_tree = create_kd_tree(startEndListWithIndices, 1, 5);

save("kd_tree5.mat", 'kd_tree');


%points = search_kd_tree(clickPoint, kd_tree);

%found = pointMatch(clickPoint, points);

%disp(found);