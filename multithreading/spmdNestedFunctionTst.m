spmd
if labindex < 3
    
    if labindex == 1
        senderThread([1 2 3]);
    elseif labindex == 2
        receiverThread();
    end
        
end
end