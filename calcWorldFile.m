%basic math to solve for the needed ESRI world file information
%to georeference my custom map cutout
function [world_file] = calcWorldFile(info1, info2, info3)
   format long;
   digits(64);

   lat = [info1(1); info2(1); info3(1)];
   lon = [info1(2); info2(2); info3(2)];
  
   M = [info1(3), info1(4), 1;
        info2(3), info2(4), 1;
        info3(3), info3(4), 1];
    

    solveLat = linsolve(M, lat);
    solveLon = linsolve(M, lon);
    
    world_file = [solveLat(1); solveLon(1); solveLat(2); solveLon(2); solveLat(3); solveLon(3) ];
    
    disp(world_file);
end