%clear x;
%parpool('local', 3);
%info = array [lat, lon, u, v];

function [returnValue] = ...
exchangingDataFunction(test)

spmd
% Generate different data on each worker
% labIndex = threadIndex, numLabs = total number of threads
% If thread number is above 3 please go away, we only need 3
if labindex <= 3
    
    threadOne = 1;
    threadTwo = 2;
    comparerThread = 3;
    
    isComparerThread = false;
    
    if labindex == comparerThread
        isComparerThread = true;
    end
    
    %Logic for comparer thread
    if(isComparerThread)
        disp("im comparer");
        
        duplicateFound = false;
        listFromT1 = [];
        listFromT2 = [];
        newDataFromT1 = [];
        newDataFromT2 = [];
        %incoming
        
        while ~duplicateFound
            disp("waiting to receive new buffers...");
            newDataFromT1 = labReceive(threadOne);
            newDataFromT2 = labReceive(threadTwo);
            disp("received new buffers :)");
            
            %concat new incoming data to existing
            listFromT1 = [listFromT1; newDataFromT1];
            listFromT2 = [listFromT2; newDataFromT2];
            
            %disp(listFromT1);
            %duplicateFound = true;

            %find duplicate
            [val,pos]=intersect(listFromT1,listFromT2);
            % did not find duplicate
            if isempty(val)
                labSend(false, threadOne);
                labSend(false, threadTwo);
            % sucess !!! found duplicate
            else
                labSend(true, threadOne);
                labSend(true, threadTwo);
                duplicateFound = true;
                disp("I found the duplicate!!!");
                disp("val:");
                disp(val);
                returnValue = val;
                disp("test: " + test);
            end
            
            
        end
            
    %Logic for runner thread
    else
        disp("im runner");
        
        duplicateFound = false;
        newItemBuffer = zeros(10, 1);
    
        currentIndex = 1;
        while ~duplicateFound
            %buffer full, send to compare thread
            if currentIndex > 10
                 % Send data to comparer thread
                 disp("Buffer full, sending...")
                 labSend(newItemBuffer, comparerThread)
                 % Reset index
                 currentIndex = 1;
 
                %Did the comparer Thread find a duplicate?
                %-> Terminate
                disp("Waiting for answer from comparer thread...")
                duplicateFound = labReceive(comparerThread);
                if duplicateFound
                    disp("Duplicate found in comparer thread! terminating");
                    disp("test2: " + test);
                end
            end
            
            %fill buffer
            newItemBuffer(currentIndex) = randi([1 99999]);
            currentIndex = currentIndex + 1;
        end
       
    end
    
   

    
end 
end






end