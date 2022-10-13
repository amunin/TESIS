function [Velevcarga, Velevacia, Vtras, Vcarro] = importcrane(filetoread)
%  Imports data from the specified file
%  FILETOREAD1:  file to read
% Import the file

% Se almacenan las posiciones de las NUTS y los datos de coste, tiempo y
% probabilidad

sheetName1 = "Matlab_Gruas";

data = readcell(filetoread,'Sheet',sheetName1,'Range','C4:C7');
Velevcarga = cell2mat(data(1,1));
Velevacia = cell2mat(data(2,1));
Vtras = cell2mat(data(3,1));
Vcarro = cell2mat(data(4,1));

end
