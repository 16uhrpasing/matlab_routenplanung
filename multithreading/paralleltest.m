clear;
clc;


solutions = zeros(2,5000);

duplicateFound = false;

tic
parfor i=1:2

    currentIndex = 1;
    while ~duplicateFound
        solutions(i, currentIndex) = randi([20 150]);
        currentIndex = currentIndex + 1;
        if currentIndex == 20 
        duplicateFound = true;
        end
    end
    
end
toc

disp(solutions);
