function [adjMatrix, startEndList, startEndListGeo] =...
    shpToGeoEucAdj(roads)

   format long;
   digits(64);
   
   info = geotiffinfo('boston.tif');   
   %mstruct = geotiff2mstruct(info);
   
   %read the count of the roads from the shapefile
   %one road segment contains 2 2d coordinates which describe the segment
   roadCount = length(roads);
   
   %this is why we need an adjacency matrix twice the size of the road
   %count
   adjMatrix = zeros(2*roadCount, 2*roadCount);
   
   %we create 2 lists
   %the first contains the euclidian coordinates
   startEndList = zeros(2*roadCount, 2);
   %the second one contains the geographical coordinates
   startEndListGeo = zeros(2*roadCount, 2);
   %the first half of each list contains all starting points
   %the second half contains all the end points
   %to get the corresponding end point of a starting point add the offset
   %of the road count:
   % endpoint(startpoint) = list[startpoint + roadCount]
   
 
   
%Straßensegmente
load("startEndList.mat");
load("startEndListGeo.mat");
  
if(isempty(startEndList) || isempty(startEndListGeo))
  disp("Filling starting and end point of street segment to list");
  
  %iterate through each road segment
  %save each X, y coord to:
  %the euclidian list 
  %the geographical list
  %the adjacency matrix
  for i=1 : length(roads) 
      %get the last index of the road segment
      lastPointIndex = length(roads(i).X) - 1;
      disp("segment " + i + " has " + lastPointIndex + " XY points");
      
      %
      startPx = roads(i).X(1);
      startPy = roads(i).Y(1);
      
      endPx = roads(i).X(lastPointIndex);
      endPy = roads(i).Y(lastPointIndex);
      
      startEndList(i, 1) = startPx;
      startEndList(i, 2) = startPy;
      startGeoX = startPx * unitsratio('sf','m');;
      startGeoY = startPy * unitsratio('sf','m');;
      
      %...
      %[endPx, endPy]
      startEndList(i + length(roads), 1) = endPx;
      startEndList(i + length(roads), 2) = endPy;
      endGeoX = endPx * unitsratio('sf','m');
      endGeoY = endPy * unitsratio('sf','m');
      
      %convert to euclidian coordinates
      [startEndListGeo(i, 1),startEndListGeo(i, 2)] = projinv(info, startGeoX, startGeoY);
      
      %convert to geographical coordinates
      [startEndListGeo(i + length(roads), 1), startEndListGeo(i+ length(roads), 2)] = projinv(info, endGeoX, endGeoY);
      
      %fill adj matrix
      adjMatrix( i, i + length(roads) ) = 1;
      adjMatrix( i + length(roads), i ) = 1;
  end 
  save("startEndList1.mat", 'startEndList');
  save("startEndListGeo1.mat", 'startEndListGeo');
  disp(startEndListGeo);
end
  
load('adjmatrix05.mat');
if(isempty(adjMatrix))
  disp("matrix is empty")
  for i = 1 : length(startEndList)                                               
    for  j = i+1 : length(startEndList)                                       
        % Falls Kreuzung, dann markiere in Adjazenzmatrix  
        compareList = [startEndList(i,1), startEndList(i,2);startEndList(j,1), startEndList(j,2)];
        distance = pdist(compareList,'euclidean');
        if(distance < 0.3) 
            adjMatrix(i,j) = 2;
            adjMatrix(j,i) = 2; 
            disp("kreuzung at " + i + "x" + j + " dist: " + distance);
        end
        
    end 
  end
  
  disp("adjmatrix finished");
end

%debugging block to show the resulting coordinates on the map
%commented for release version
%{
if true
for i=1:roadCount
   for j=1:roadCount*2
       if(adjMatrix(i,j) == 1) %normaler weg
           %if(i > roadCount) break; end;
           mapshow(roads(i), 'color', 'b');
       elseif(adjMatrix(i,j) == 2) %kreuzung
           mapshow(startEndList(i,1), startEndList(i,2), 'DisplayType', 'point', 'color', 'r');
           mapshow(startEndList(j,1), startEndList(j,2), 'DisplayType', 'point', 'color', 'r');
       end
   end
end
end
%}
 
end