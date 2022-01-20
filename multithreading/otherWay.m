spmd(2)
if labindex <= 2
    
   A = zeros(2,10);
    
   for i=1:10
       A(labindex, i) = randi([20 150]);
   end
   
   
   disp(A);
   
end
end