function [NODES, CostMatrixMM,CostMatrixRoad,TimeMatrixMM,TimeMatrixRoad,ProbabilityMatrix, nodeNo] = importfile(filetoread)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read
% Import the file

% Se almacenan las posiciones de las NUTS y los datos de coste, tiempo y
% probabilidad

sheetName1 = "NUTS_Europa";
sheetName2 = "Tabla_v3";
NODES = struct;


Name = readcell(filetoread,'Sheet',sheetName1,'Range','B2:B41');
longitude = readcell(filetoread,'Sheet', sheetName1,'Range','C2:C41');
Longitude = cell2mat(longitude);
latitude = readcell(filetoread,'Sheet', sheetName1,'Range','D2:D41');
Latitude = cell2mat(latitude);

data = readcell(filetoread,'Sheet',sheetName2,'Range','C3:P1566');

nodeNo = size( Name, 1 );
m = size( data, 1 );

CostMatrixMM = ones(nodeNo);
CostMatrixRoad = ones(nodeNo);
TimeMatrixMM = ones(nodeNo);
TimeMatrixRoad = ones(nodeNo);
ProbabilityMatrix = ones(nodeNo);

for i = 1:nodeNo

    NODES(i).Name = Name(i,1); 
    NODES(i).Longitude = Longitude(i,1);
    NODES(i).Latitude = Latitude(i,1);
   
end

for i = 1:nodeNo
     for j = 1:m
%  % para cada nodo origen busca el nodo destino
         result1 = strcmp( NODES(i).Name, data(j,1) ); 
         if result1 == 1
             for k = 1:nodeNo
                 result2 = strcmp( NODES(k).Name, data(j,2) );
                 if result2 == 1
                      CostMatrixMM (i,k) = cell2mat ( data(j,10) );
                      CostMatrixRoad (i,k) = cell2mat ( data(j,9) );
                      TimeMatrixMM (i,k) = cell2mat ( data(j,7) );
                      TimeMatrixRoad (i,k) = cell2mat ( data(j,8) );
                      ProbabilityMatrix (i,k) = cell2mat ( data(j,14) );
%                     NODES(i).Route(i,k).UnitCostMM = cell2mat ( data(j,10) );
%                     NODES(i).Route(i,k).UnitCostRoad = cell2mat ( data(j,9) );
%                     NODES(i).Route(i,k).TIMEMM = cell2mat ( data(j,7) );
%                     NODES(i).Route(i,k).TIMERoad = cell2mat ( data(j,8) );
%                     NODES(i).Route(i,k).Probability = cell2mat ( data(j,14) );
%                               
                 end
                 
             end
         end
     end
end
% for i = 1:nodeNo
%      for k = 1:nodeNo
%           A = NODES(i).Route(i,k).UnitCostMM;
%           if A == []
%               NODES(i).Route(i,k).UnitCostMM = 0;
%           end
%      end
% end

end

