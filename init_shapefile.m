function [roads_geo_out] = init_shapefile(shapeFile, roadClass)
    info = geotiffinfo('boston.tif');   
    %mstruct = geotiff2mstruct(info);

    roads = shaperead(shapeFile); 
    
    %Separate classes
    HIGHWAY = 1:3;
    LOCAL = 4:7;
    ALL = 0:10;
    roadClassArray = ALL;
    
    if(strcmp(roadClass, 'HIGHWAY'))
        roadClassArray = HIGHWAY;
    elseif(strcmp(roadClass, 'LOCAL'))
        roadClassArray = LOCAL;
    else
        roadClassArray = ALL;
    end
    
    %roads = shaperead(shapeFile,'Selector',...
     %          {@(v1) (ismember(v1, roadClassArray)),'CLASS'});
           
    roads_init = roads; 
    
    roadSegmentCount = length(roads);
    
    for i=1 : roadSegmentCount
      for k=1:length(roads(i).X) 

         %X and Y are attributes that save the bijective formparameters 
         x = roads(i).X(k) * unitsratio('sf','m');
         y = roads(i).Y(k) * unitsratio('sf','m');

         [roads_init(i).Lat(k),roads_init(i).Lon(k)] = projinv(info, x, y);
         roads_init(i).BoundingBox = roads(i).BoundingBox;
         roads_init(i).Geometry = roads(i).Geometry;
         roads_init(i).STREETNAME = roads(i).STREETNAME;
         roads_init(i).RT_NUMBER = roads(i).RT_NUMBER;
         roads_init(i).CLASS = roads(i).CLASS;
         roads_init(i).ADMIN_TYPE = roads(i).ADMIN_TYPE;
         roads_init(i).LENGTH = roads(i).LENGTH;
         
      end 
      disp(strcat('init_shapefile: ', num2str(i), '/', num2str(roadSegmentCount)));
    end 
    
    roads_geo_out = roads_init;
    
    %filename = strcat('nshapefile_', roadClass, '.mat');
    filename = strcat('nshapefile_ALL.mat');
    save(filename, 'roads_geo_out');
    
    disp(strcat('init_shapefile saved: ', filename));
end