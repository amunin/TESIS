function [NUT, FlowNUT] = importNUT(filetoread)
%  Imports data from the specified file
%  FILETOREAD1:  file to read
% Import the file

% Se almacenan las posiciones de las NUTS y los datos de coste, tiempo y
% probabilidad

sheetName1 = "NUTS_Europa";

NUT = struct;

data = readcell(filetoread,'Sheet',sheetName1,'Range','B2:C81');

[nNut,m] = size (data);

 for i = 1:nNut
     NUT(i).Name = cell2mat (data(i, 1) );
     NUT(i).Port = cell2mat (data(i, 2));
 end
 
sheetName2 = "Flujo multimodal semanal";

data = readcell(filetoread, 'Sheet',sheetName2, 'Range', 'C3:AP42');
idxs = nchoosek(1:nNut,2);
convNut = size(idxs,1);
FlowNUT = zeros(convNut,1);
i = 1;
m = nNut/2 - 1;
while i < convNut
    for j = 1:m
        FlowNUT(i) = cell2mat ( data(idxs(j,1),idxs(j,2)) );
%         FlowNUT(i) = FlowNUT(i)/14.5;
        i = i + 1;
    end
end
FlowNUT(convNut) = cell2mat ( data(idxs(39,1),idxs(39,2)) );
     
     %      NUT(i).Longitude = cell2mat (data(i, 3) )/10^6;
%      NUT(i).Latitude = cell2mat (data(i, 4) )/10^6;

TruckCost = 1.313; % coste en €/km camión cargado. Tara 25 t.

sheetName2 = 'Distancia NUT - puerto';

data = readcell(filetoread,'Sheet',sheetName2,'Range','B3:D82');

[nNut,m] = size (data);

for i = 1:nNut
     NUT(i).Road = cell2mat (data(i, 3) ) * TruckCost; % € por viaje
end


end




