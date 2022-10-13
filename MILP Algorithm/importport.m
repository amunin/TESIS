function [PORT, ODport] = importport(filetoread)
%  Imports data from the specified file
%  FILETOREAD1:  file to read
% Import the file

% Se almacenan las posiciones de las NUTS y los datos de coste, tiempo y
% probabilidad

sheetName1 = "Matlab_Puerto";

PORT = struct;

data = readcell(filetoread,'Sheet',sheetName1,'Range','B3:AT27');
m = size(data, 1);
for p = 1:m
    PORT (p).ID = cell2mat ( data(p,1) );
    PORT (p).BaseCostSC = cell2mat ( data(p,2) ); % Tasa del buque atraque sin concesión 
    PORT (p).RTA = cell2mat ( data(p,4) );
    PORT (p).CorrCoefSC = cell2mat ( data(p,5) );
    PORT (p).BaseCostFSC = cell2mat ( data(p,6) ); % Tasa del buque fondeo sin concesión
    PORT (p).RF = cell2mat ( data(p,8) );
    PORT (p).CorrCoefFSC = cell2mat ( data(p,9) );
    PORT (p).COM20TEU = cell2mat ( data(p,10) ); % Tasa de la mercancía
    PORT (p).CGpk = cell2mat ( data(p,25) ); % tarifa de uso de la grúa k en la terminal del puerto p (€/h)
    PORT (p).NGpk = cell2mat ( data(p,27) ); % número de grúas en la terminal
    PORT (p).TUZT = cell2mat ( data(p,29) ); % Tasa por utilización zona de tránsito
    PORT (p).AUZT = cell2mat ( data(p,30) );
    PORT (p).DUZT = cell2mat ( data(p,31) );
    PORT (p).TDB = cell2mat ( data(p,32) ); % Tarifa por servicio de recepción de desechos
    PORT (p).TAN = cell2mat ( data(p,33) ); % Tarifa por lucen de navegación
    PORT (p).Tremol = cell2mat ( data(p,34) ); % Tarifa por uso de remolcadores
    PORT (p).TA = cell2mat ( data(p,39) ); % Tarifa por amarre
    PORT (p).TP = cell2mat ( data(p,40) ); % Tarifa por practicaje
    PORT (p).TES = cell2mat ( data(p,41) ); % Tiempo de entrada y salida de puerto 
    PORT (p).TET = cell2mat ( data(p,42) );  % Tiempo de espera en la terminal
    PORT (p).TAmarre = cell2mat ( data(p,43) );  % Tiempo de amarre
    PORT (p).TFondeo = cell2mat ( data(p,44) );  % Tiempo de fondeo
    PORT (p).Eff = cell2mat ( data(p,45) );  % Eficiencia
end

sheetName2 = "Carga Puertos OD";
% sheetName3 = "Port Throughput";
ODnames = readcell(filetoread,'Sheet',sheetName2,'Range','A4:A28');
% dataOD = readcell(filetoread,'Sheet',sheetName3,'Range','D4:E28');
dataOD = readcell(filetoread,'Sheet',sheetName2,'Range','B4:Z28');
m = size(dataOD, 1);
idxs = nchoosek(1:m, 2);
npOD = size(idxs,1);

for i = 1:npOD
    ODport(i).Flow = cell2mat( dataOD(idxs(i,1),idxs(i,2)) );
    ODport(i).Flow = ODport(i).Flow * (PORT(idxs(i,1)).Eff + PORT(idxs(i,2)).Eff)/2;
    ODport(i).Origin = cell2mat( ODnames(idxs(i,1)) );
    ODport(i).Destination = cell2mat( ODnames(idxs(i,2)) );
end

% for i = 1:m
%     PORT(i).Throughput = cell2mat(dataOD(i,2));
%     PORT(i).Throughput = PORT(i).Throughput * PORT(i).Eff;
% end


end

