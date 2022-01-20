testPoint = [42.3537 -71.0716];

for i=5:9
   load(strcat('kd_tree', int2str(i), '.mat'));
   
   disp("tree depth " + i);
   
   tic
   points = search_kd_tree(testPoint, kd_tree);
   found = pointMatch(testPoint, points);
   toc
   
end