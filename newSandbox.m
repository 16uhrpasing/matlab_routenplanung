addTraversalCache(0,5123,[1 2 3 4]);

load('traversalCache.mat');

[found, traversal] = searchTraversalCache(0,5123);

disp(traversal);