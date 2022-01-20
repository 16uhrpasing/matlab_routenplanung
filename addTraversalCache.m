function [] = addTraversalCache(startIndex, endIndex, traversalList)
    load('traversalCache.mat');
    
    traversal.startIndex = startIndex;
    traversal.endIndex = endIndex;
    traversal.list = traversalList;
    
    traversalCache(end+1) = traversal;
    save('traversalCache.mat', 'traversalCache');
    disp("added to cache");
end