     
function [] = ...
aStarCollector()
       
        
        duplicateFound = false;
        listFromT1 = [];
        listFromT2 = [];
        newDataFromT1 = [];
        newDataFromT2 = [];
        %incoming
        
        while ~duplicateFound
            disp("waiting to receive new buffers...");
            newDataFromT1 = labReceive(1);
            newDataFromT2 = labReceive(2);
            disp("received new buffers :)");
            
            %concat new incoming data to existing
            listFromT1 = [listFromT1; newDataFromT1];
            listFromT2 = [listFromT2; newDataFromT2];
            
            %disp(listFromT1);
            %duplicateFound = true;

            %find duplicate
            [valT1, positionT1]=intersect(listFromT1,listFromT2);
          
            
            
            %if there is a value, it is the index of the 
            %startEndList, iterate through aSTList to aStarCollect
            %all the predecessors

            % did not find duplicate
            if isempty(valT1)
                labSend(0, 1);
                labSend(0, 2);
            % sucess !!! found duplicate
            else
                 %if more have been found, take first one
                %disp("found duplicate");
                %disp("valueT1: " + valT1);
                valT1 = valT1(1,1);
                
                labSend(valT1, 1);
                labSend(valT1, 2);
                duplicateFound = true;
                %disp("duplicate: " + valT);
                %disp("Sent the duplicate position... terminating");
            end
            
            
        end
        
end