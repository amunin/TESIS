function [D] = importdist(filetoread)
%  Imports data from the specified file
%  FILETOREAD1:  file to read
% Import the file

% Se almacenan las posiciones de las NUTS y los datos de coste, tiempo y
% probabilidad

sheetName1 = "Distancias OD";

data = readcell(filetoread,'Sheet',sheetName1,'Range','D4:AB28');

D = cell2mat ( data() );

end
