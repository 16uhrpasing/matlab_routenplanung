%sender has ID 1

function [] = ...
senderThread(valToSend)

    labSend(valToSend, 2);
    disp("sender sent!");
end