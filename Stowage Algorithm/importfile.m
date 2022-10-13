function [L, B, D, V, GT, Desp0, Despmax, TFBM] = importfile(filetoread)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read
% Import the file

% Se almacenan la información del buque

sheetName1 = "Datos";


data = readcell (filetoread,'Sheet',sheetName1,'Range','C6:C15');
L = cell2mat(data(1,1));
B = cell2mat(data(2,1));
D = cell2mat(data(3,1));
V = cell2mat(data(4,1));
Desp0 = cell2mat(data(5,1));
GT = cell2mat(data(6,1));
TPM = cell2mat(data(7,1));
PR = cell2mat(data(8,1));
Despmax = cell2mat(data(9,1));
TFBM = cell2mat(data(10,1));


end

