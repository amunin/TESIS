function [L, B, TPM, Vb, PMP, PMMAA, CMP, CMMAA, GT, CComb, CCHT] = importship(filetoread)
%  Imports data from the specified file
%  FILETOREAD1:  file to read
% Import the file

% Se almacenan las posiciones de las NUTS y los datos de coste, tiempo y
% probabilidad

sheetName1 = "Matlab_Buque";

data = readcell(filetoread,'Sheet',sheetName1,'Range','C1:C12');
L = cell2mat(data(1,1));
B = cell2mat(data(2,1));
T = cell2mat(data(3,1));
TPM = cell2mat(data(4,1));
Vb = cell2mat(data(5,1));
PMP = cell2mat(data(6,1));
PMMAA = cell2mat(data(7,1));
CMP = cell2mat(data(8,1));
CMMAA = cell2mat(data(9,1));
GT = cell2mat(data(10,1));
CComb = cell2mat(data(11,1));
CCHT = cell2mat(data(12,1));
end
