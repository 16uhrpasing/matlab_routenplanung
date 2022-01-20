function [found, traversal] = searchTraversalCache(startIndex, endIndex)

load('traversalCache.mat');

disp(traversalCache);

found = false;
traversal = [];

[rows columns] = size(traversalCache);

for i=1:rows
   currentStart = traversalCache(i).startIndex;
   currentEnd = traversalCache(i).endIndex;
   
   if(startIndex == currentStart && endIndex == currentEnd)
      found = true; 
      traversal = traversalCache(i).list;
   end
end


end