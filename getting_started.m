%////////////////////////////////////////////////////
%decide whether to Export the road classes
exportMats = true;

if exportMats
    %export road classes in .mat files via shaperead
    for roadClass = 1:7
        S = shaperead('boston_roads.shp','Selector',...
               {@(v1) (v1 == roadClass),'CLASS'});
    save(strcat('ROADCLASS',num2str(roadClass), '.mat'),'S');
    disp(strcat('Saved ROADCLASS',num2str(roadClass),'.mat'));
    end
end

%////////////////////////////////////////////////////
%symbolSpec example
roadspec = makesymbolspec('Line',...
                          {'ADMIN_TYPE',0,'Color','cyan'},...
                          {'ADMIN_TYPE',3,'Color','red'},...
                          {'CLASS',6,'Visible','off'},...
                          {'CLASS',[1 4],'LineWidth',2});
                      
                     
%mapshow('boston_roads.shp','SymbolSpec',roadspec);
%////////////////////////////////////////////////////

%Load ROADCLASS file that was saved to a .mat file
%(var S is implicitly loaded)
load('ROADCLASS6.mat');

mapshow(S);
