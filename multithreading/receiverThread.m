%receiver has ID 2

function [] = ...
receiverThread()

    disp("receiver is waiting");
    newData = labReceive(1);
    disp("received!!!: " + newData);

end