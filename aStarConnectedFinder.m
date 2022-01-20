%info = array [lat, lon, u, v];
function [TraversalIndexList] = ...
aStarConnectedFinder(...
adjMatrix, ...
startEndList,...
startEndListGeo,...
roadCount,...
startIndex,...
endIndex...
)

   format long;
   digits(64);
   
   
   
worldFile = 'myboston.jgw'; 
img = imread('myboston.jpg'); 
R = worldfileread(worldFile); 



geoshow(img, R); 
title('Boston roads (geographic)'); 

load('shapefile_HIGHWAY.mat');
geoshow(roads_geo_out, 'Color', 'green','LineWidth',1);

load('shapefile_LOCAL.mat');
geoshow(roads_geo_out, 'Color', 'blue','LineWidth',1);

geoshow(startEndListGeo(startIndex,1), startEndListGeo(startIndex,2), 'DisplayType', 'point', 'color', 'cyan','LineWidth',3);
geoshow(startEndListGeo(endIndex,1), startEndListGeo(endIndex,2), 'DisplayType', 'point', 'color', 'blue','LineWidth',5);
   
   TraversalIndexList = []; 

   
   %1=NAME,         INDEX DER TRAVERSALINDEXLIST
   %2=WEG,          INIT = INFINITY
   %3=LUFT,         INIT = INSTANT LOOP
   %4=VORGÄNGER     INIT = -1000
   %5=GESAMT        INIT = INFINITY (eig. WEG + LUFT)
   aStarTrackingList = zeros(length(startEndList), 4);
   
   %startpoint from parameters
   startPoint = startEndList(startIndex,:);
   endPoint = startEndList(endIndex,:);
   disp("starting point: " + startPoint);
   disp("ending point: " + endPoint);
   
   currentPoint = startPoint;
   currentIndex = startIndex;
   
   for i=1:length(startEndList)
       %runnerPoint = startEndList(i,:);
       
       %Name
       aStarTrackingList(i,1) = i;
       
       %WEG
       if(i == startIndex)
           aStarTrackingList(i,2) = 0;
       else
           aStarTrackingList(i,2) = Inf;
       end
       
       %LUFT
       if(i == endIndex)
           aStarTrackingList(i,3) = 0;
           disp("endPoint at " + i);
       else

       %distance = pdist(compareList,'euclidean');
       %aStarTrackingList(i,3) = distance;
       aStarTrackingList(i,3) = 1;
       end
       
       %VORGÄNGER
       aStarTrackingList(i,4) = -1000;
       
       %GESAMT
       if(i == startIndex)
           aStarTrackingList(i,5) = aStarTrackingList(i,3);
       else
            aStarTrackingList(i,5) = Inf;
       end
   end
   
   
   openList = [];
   closedList = [];
   openList(end+1) = startIndex;
   nextCurrent = 0;
   
   while(~isempty(openList))
   %get neighbours of currentIndex
   for i=1:roadCount*2
      if (adjMatrix(currentIndex,i) > 0 && ~any(closedList(:) == i) ) 
          geoshow(startEndListGeo(i,1), startEndListGeo(i,2), 'DisplayType', 'point');
          disp("new neighbour: " + i);
          disp(startEndListGeo(i,:));
          
          if(~any(openList(:) == i))
            openList(end+1) = i;
          end
          
          neighbourPos = startEndList(i,:);
          distanceFromMeToHim = pdist([currentPoint; neighbourPos],'euclidean');
          disp("distanceFromMeToHim " + distanceFromMeToHim);
          
            %hat keinen vorgänger oder sein gesamter weg ist größer als meiner + die distanz zu ihm 
          if(aStarTrackingList(i,4) == -1000)
              %weg, ist meiner + distanz von mir zu ihm
              aStarTrackingList(i,2) = 1;
              %vorgänger bin jetzt ich xD
              aStarTrackingList(i,4) = currentIndex;
              %sein neues gesamt festlegen
              %luft + weg
              aStarTrackingList(i,5) = aStarTrackingList(i,2) + aStarTrackingList(i,3);
          end 
      end
   end
   
   %find the entry from openList with the least gesamtkosten
   totalGesamt = Inf;
   for i=1:length(openList)
       openID = openList(i);
       currentGesamt = aStarTrackingList(openID,5);
       disp("neighbour " + openID + " has a gesamt of " + currentGesamt);
       if(totalGesamt > currentGesamt)
           totalGesamt = currentGesamt;
           nextCurrent = openID;
       end
   end
   
   %add to closed list
   closedList(end+1) = currentIndex;
   %remove from openList
   
   newOpenList = [];
   for i=1:length(openList)
       openID = openList(i);
       if(openID==nextCurrent)
       else
           newOpenList(end+1) = openID;
       end
   end
   openList = newOpenList;
   
   disp("the next currentIndex is....!!!:: " + nextCurrent);
   currentIndex = nextCurrent;
   currentPoint = startEndList(currentIndex,:);
   end
   
   disp("finished");
   disp("currentIndex: " + currentIndex);
   
   % TraversalIndexList(end+1) = endIndex; 
   %von endIndex vorgänger tracken bis startIndex
   %while(~(currentIndex == startIndex))
   %   currentIndex = aStarTrackingList(currentIndex,4);
   %   TraversalIndexList(end+1) = currentIndex;
   %end

   %disp(TraversalIndexList);
   disp("done");
   
   load('nshapefile_ALL.mat');
   for i=1:length(closedList)
       currentRoadIndex = closedList(i);
       if(currentRoadIndex > roadCount) currentRoadIndex = currentRoadIndex - roadCount; end
       geoshow(roads_geo_out(currentRoadIndex), 'color', 'green', 'LineWidth', 3);
   end
   
   save("TraversalIndexList1.mat", 'TraversalIndexList');
   
end