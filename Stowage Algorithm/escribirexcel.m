function [] = escribirexcel(Desp, Tf, Kgf, kb, trim, Tpp, Tpr, angesc,  matriz_slot, gm, bahia)

global NCHO1 NCSC1 NC1


y = 9;

[r,s,t] = size(matriz_slot);

for i = r:-1:1
    for j=1:s
        for k = 1:t
            str1 = 'B';
            str2 = 'C';
            str3 = 'D';
            str4 = 'E';
            str5 = 'F';
            str6 = 'G';
            str7 = 'H';
            str8 = 'I';
            x = int2str(y); 
            str1 = strcat(str1,x);
            str2 = strcat(str2,x);
            str3 = strcat(str3,x);
            str4 = strcat(str4,x);
            str5 = strcat(str5,x);
            str6 = strcat(str6,x);
            str7 = strcat(str7,x);
            str8 = strcat(str8,x);
            if isempty(matriz_slot(i,j,k).yy)==0 || isempty(matriz_slot(i,j,k).zz)==0
                  if matriz_slot(i,j,k).Peso == 0
                      continue
                  else
                     xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).xx,'Hoja1',str1);
                     xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).posxg,'Hoja1',str2);
                     % se escribe la posición real de la bahía , las coordenadas del centro de gravedad se usan sólo para
                     %los cálculos de estabilidad %
                     xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).yy,'Hoja1',str3);
                     xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).posyg,'Hoja1',str4);
                     xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).zz,'Hoja1',str5);
                     xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).posyg,'Hoja1',str6);
                     xlswrite('C:\Users\Alicia Munín\Documents\Tesis\Capítulos\ESTIBA\SLOTS_7_MomFlectores\Calculos portacontenedores.xlsx',matriz_slot(i,j,k).Peso,'Hoja1',str7);
                     xlswrite('C:\Users\Alicia Munín\Documents\Tesis\Capítulos\ESTIBA\SLOTS_7_MomFlectores\Calculos portacontenedores.xlsx',matriz_slot(i,j,k).Puerto,'Hoja1',str8);
                     y = y + 1;
                 end
             end
        end
     end
end

xlswrite('Calculos portacontenedores.xlsx', NCHO1, 'Hoja1', 'D4');
xlswrite('Calculos portacontenedores.xlsx', NCSC1, 'Hoja1', 'D5');
xlswrite('Calculos portacontenedores.xlsx', NC1, 'Hoja1', 'D6');
xlswrite('Calculos portacontenedores.xlsx', Desp, 'Hoja1', 'M8');
xlswrite('Calculos portacontenedores.xlsx', Tf, 'Hoja1', 'M9');
xlswrite('Calculos portacontenedores.xlsx', Kgf, 'Hoja1', 'M10');
xlswrite('Calculos portacontenedores.xlsx', kb, 'Hoja1', 'M11');
xlswrite('Calculos portacontenedores.xlsx', trim, 'Hoja1', 'M12');
xlswrite('Calculos portacontenedores.xlsx', Tpp, 'Hoja1', 'M13');
xlswrite('Calculos portacontenedores.xlsx', Tpr, 'Hoja1', 'M14');
xlswrite('Calculos portacontenedores.xlsx', angesc, 'Hoja1', 'M15');
xlswrite('Calculos portacontenedores.xlsx', gm, 'Hoja1', 'M16');

[x,y,z] = size(bahia);

str1 = 'N';
j = 40;
for i=1:y
    x = int2str(j); 
    str2 = strcat(str1,x);
    xlswrite('Calculos portacontenedores.xlsx', bahia(i).FuerzasCortantes, 'Hoja1', str2);
    j = j+1;
end

f1 = figure;
plot([bahia.Posicion],[bahia.FuerzasCortantes],'Color','r');
% hold on;

str1 = 'O';
j = 40;
for i=1:y
    x = int2str(j); 
    str2 = strcat(str1,x);
    xlswrite('Calculos portacontenedores.xlsx', bahia(i).MomFlector, 'Hoja1', str2);
    j = j+1;
end

f2 = figure;
plot([bahia.Posicion],[bahia.MomFlector],'Color','b');
end