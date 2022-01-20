%info = array [lat, lon, u, v];
function [resultTraversal] = ...
aStarThread(...
adjMatrix, ...
startEndList,...
startEndListGeo,...
startIndex,...
endIndex...
)

   disp("starting thread");

   format long;
   digits(64);
   
   collectorThread = 3;
   
   roadCount = length(startEndList)/2;

   TraversalIndexList = []; 
   
   closedListBuffer = zeros(1,50);
   closedListBufferIndex = 1;

   
   %1=NAME,         INDEX DER TRAVERSALINDEXLIST
   %2=WEG,          INIT = INFINITY, STARTPOINT = 0
   %3=LUFT,         INIT = INSTANT LOOP
   %4=VORGÄNGER     INIT = -1000
   %5=GESAMTWERT    INIT = INFINITY (WEG + LUFT)
   aStarTrackingList = zeros(length(startEndList), 4);
   
   %startpoint from parameters
   startPoint = startEndList(startIndex,:);
   endPoint = startEndList(endIndex,:);
   %disp("starting point: " + startPoint);
   %disp("ending point: " + endPoint);
   
   
   currentPoint = startPoint;
   currentIndex = startIndex;
   
   
   aStarTrackingList(:,2) = Inf;
   aStarTrackingList(startIndex,2) = 0;
   
   aStarTrackingList(:,4) = -1000;
   aStarTrackingList(:,5) = Inf;
    
   %initialize aStarTrackingList
   for i=1:length(startEndList)
       %get the current euclidian entry
       runnerPoint = startEndList(i,:);
       
       %Name (INDEX DER TRAVERSALINDEXLIST)
       aStarTrackingList(i,1) = i;
       
       %LUFT
       if(i == endIndex)
           %Der euklidische Endpunkt hat eine Luftlinie von 0 zu sich
           %selber
           aStarTrackingList(i,3) = 0;
           %disp("endPoint at " + i);
       elseif(i == startIndex)
           %Der Gesamtweg (eig Weg + Luft) für den Startknoten ist nur der
           %Luftweg (0 + Luft)
           aStarTrackingList(i,5) = aStarTrackingList(i,3);
       else
           %Distanz von jedem anderen Punkt zum Endpunkt
           compareList = [runnerPoint;endPoint];
           distance = pdist(compareList,'euclidean');
           aStarTrackingList(i,3) = distance;
       end
   end
   
   %Verfügbare Optionen
   openList = [];
   %Abgearbeitete Optionen
   closedList = [];
   %Füge den Startpunkt hinzu
   openList(end+1) = startIndex;
   %Index der nächsten gewählten Option
   nextCurrent = 0;
   
   duplicateFound = false;
   %Terminiere wenn die nächste Wahl der Endpunkt ist
   %oder wenn die Liste der verfügbaren Punkte leer ist
   while(~duplicateFound && ~(nextCurrent == endIndex) && ~isempty(openList))
       if closedListBufferIndex > 50
          %buffer an comparer geben und warten
          disp("buffer full, sending");
          labSend(closedListBuffer, collectorThread);
          %auf antwort von comparer thread warten
          disp("receiving from collector thread");
          answer = labReceive(collectorThread);
        
          
          if ~(answer == 0)
             %disp("answer: " + answer);
             duplicateFound = true;
             currentIndex = answer;
             %disp("currentIndex: " + currentIndex);
             traversalList = [];

             traversalList(end+1) = currentIndex; 
             %von endIndex Vorgänger tracken bis startIndex
             while(~(currentIndex == startIndex))
                currentIndex = aStarTrackingList(currentIndex,4);
                traversalList(end+1) = currentIndex;
             end
             
             %disp("traversal list from thread: ");
             disp(traversalList);

            disp("got the traversal list... terminating.");
            resultTraversal = traversalList;
               
          end
          
          disp("reset buffer");
          closedListBufferIndex = 1;
       end
       
       %get neighbours of currentIndex
       for indexOfNeighbour=1:roadCount*2
          %Iteriere durch alle Nachbarn vom momentanen Punkt
          if (adjMatrix(indexOfNeighbour, currentIndex) > 0 && ~any(closedList(:) == indexOfNeighbour) ) 
              %geoshow(startEndListGeo(indexOfNeighbour,1), startEndListGeo(indexOfNeighbour,2), 'DisplayType', 'point');
              %disp("new neighbour: " + indexOfNeighbour);
              %disp(startEndListGeo(indexOfNeighbour,:));

              %Wenn nachbar noch nicht in openList ist -> hinzufügen
              if(~any(openList(:) == indexOfNeighbour))
                openList(end+1) = indexOfNeighbour;
              end

              neighbourPos = startEndList(indexOfNeighbour,:);
              distanceFromMeToNeighbour = pdist([currentPoint; neighbourPos],'euclidean');
              %disp("distanceFromMeToNeighbour " + distanceFromMeToNeighbour);


              %hat keinen vorgänger oder sein gesamter weg ist größer als
              %weg+luft vom momentanen standpunkt aus
              if(aStarTrackingList(indexOfNeighbour,4) == -1000 || aStarTrackingList(indexOfNeighbour,2) > aStarTrackingList(currentIndex,2) + distanceFromMeToNeighbour)
                  %weg, ist meiner + distanz von mir zu ihm
                  aStarTrackingList(indexOfNeighbour,2) = aStarTrackingList(currentIndex,2) + distanceFromMeToNeighbour;
                  %vorgänger bin jetzt ich xD
                  aStarTrackingList(indexOfNeighbour,4) = currentIndex;
                  %sein neues gesamt festlegen
                  %luft + weg
                  aStarTrackingList(indexOfNeighbour,5) = aStarTrackingList(indexOfNeighbour,2) + aStarTrackingList(indexOfNeighbour,3);
              end 
          end
       end

       %add to closed list
       closedList(end+1) = currentIndex;
       closedListBuffer(1, closedListBufferIndex) = currentIndex;
       closedListBufferIndex = closedListBufferIndex + 1;
       
       %remove from openList
       newOpenList = [];
       for i=1:length(openList)
           currentNeighbourOption = openList(i);
           if(~(currentNeighbourOption==nextCurrent))
               newOpenList(end+1) = currentNeighbourOption;
           end
       end
       openList = newOpenList;

       %find the entry from openList with the least gesamtkosten
       totalGesamt = Inf;
       for i=1:length(openList)
           currentNeighbourOption = openList(i);
           if currentNeighbourOption == currentIndex 
               continue; 
           end
           currentGesamt = aStarTrackingList(currentNeighbourOption,5);
           %geoshow(startEndListGeo(currentNeighbourOption,1), startEndListGeo(currentNeighbourOption,2), 'DisplayType', 'point', 'Color', 'blue');
           %disp("neighbour " + currentNeighbourOption + " has a gesamt of " + currentGesamt);
           if(totalGesamt > currentGesamt)
               totalGesamt = currentGesamt;
               nextCurrent = currentNeighbourOption;
           end
       end
       %nächster punkt zum iterieren wurde festgelegt
       %geoshow(startEndListGeo(nextCurrent,1), startEndListGeo(nextCurrent,2), 'DisplayType', 'point','Color', 'green');
        
    

       %disp("the next currentIndex is....!!!:: " + nextCurrent);
       currentIndex = nextCurrent;
       currentPoint = startEndList(currentIndex,:);
       %geoshow(startEndListGeo(currentIndex,1), startEndListGeo(currentIndex,2), 'DisplayType', 'point');
   end
  
   %disp("done");
   
end
   