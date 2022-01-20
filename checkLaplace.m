function res = checkLaplace(Lap)

    [evec, eval] = eig(Lap);

    % check eigenvals
    if min(eval) < 0 then
        res = [false, []];
    end

    % check Eigenvector [1, .. ,1]
    res = [true, Lap*[1,..,1]‘];

    if res ~= 0 then
        res = [false, []];
    end

end