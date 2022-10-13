function [matriz_slot] = Slots_impar(NCB1,NCBS1,NCL1,NCD, L, D, TFBM)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Variables

%barco
global BRU ET2 ET1 Lcc HDF1 HES HSE

%contenedores
global DC11 DC12 DC21 DC31

% Subindices
double xx;
double yy;
double zz;


%Variables
double Teta; % ángulo de visibilidad
double NC1; % número total de contenedores en el buque en función
double NC2; % del tipo de contenedor y de si lleva grúas o no
double NCB1; % número de contenedores de cualquier tipo bajo cubierta en la dirección de la manga
double NCB2;
double NCBS1; % número de contenedores de cualquier tipo sobre cubierta en la dirección de la manga
double NCBS2;
double NCD; % número de contenedores de cualquier tipo bajo cubierta en la dirección del puntal
double NCHO1; % número de contenedores totales bajo cubierta en función del 
double NCHO2; % tipo de contenedor y de si tiene grúas o no el buque
double NCL1; % número de contenedores bajo cubierta a lo largo de la eslora
double NCL2; % en función del tipo de contenedor 
double NCSC1; % número total de contenedores sobre cubierta de ambos tipos
double NCSC2;
double NSL1; % número de contenedores en cubierta en la dirección
double NSL2; % de la eslora en función del tipo de contenedor
double NBCC1; % número de contenedores en la dirección de la eslora a popa
double NBCC2; % de la bodega
double NBSC1; % número de contenedores en la dirección de la eslora a proa
double NBSC2; % de la bodega
double NTMAX[]; % número máximo de contenedores apilados sobre cubierta por bahía

% coordenadas de los slots
double XG; % medida desde la perpendicular de popa
double YG; % medida desde crujía
double ZG; % medida desde la línea base
double Peso; %peso de cada contenedor

double matriz_slot[];


% Cálculos para buque con/sin grúas y TEUS

NBCC1 = (Lcc-ET2)/DC11; %número de contenedores a popa de la bodega
NBCC1 = floor(NBCC1);
NBSC1 = ET1/DC11;   %número de contenedores a proa de la bodega
NBSC1 = floor(NBSC1);
NSL1 = NCL1 + NBCC1 + NBSC1;

%ángulo de visibilidad
Teta = (HSE+(D-TFBM))/(2*L+(L-ET2));
Teta = atan(Teta);

ind_mat = NCL1 + NBSC1;

NC1 = 0;
NCHO1 = 0;
NCSC1 = 0;
% contenedores a popa de la zona de bodega
if NBCC1 > 0
   for i = NSL1:-1:ind_mat+1
        matriz_slot(i,1,1).XG = ET2+(DC11/2)+(NSL1 - i)*DC11;%posición de la primera bahía a popa de la bodega
        NTMAX(i) = ((3*L-matriz_slot(i,1,1).XG)*tan(Teta)-D+TFBM)/DC31; %tiers sobre cubierta
        NTMAX(i) = floor (NTMAX(i));
        for j = 1:floor(NCBS1/2)+1 % estribor
            for k = 1:NTMAX(i)
                matriz_slot(i,j,k).XG = matriz_slot(i,1,1).XG;
                matriz_slot(i,j,k).xx = i*2-1;
                matriz_slot(i,j,k).ZG = D + BRU + HES + (DC31/2) + (k-1)*DC31;
                matriz_slot(i,j,k).zz = 80 + k*2;
                matriz_slot(i,j,k).YG = 0 + (j-1)*DC21;
                if (j==1)
                    matriz_slot(i,j,k).yy = 0;
                else
                    matriz_slot(i,j,k).yy = 2*(j-1)-1;
                end
                matriz_slot(i,j,k).Peso = randi(20,1);
                NCSC1 = NCSC1 + 1;
            end               
        end
        for j = 1:floor(NCBS1/2) % babor
            for k = 1:NTMAX(i)
                matriz_slot(i,j+floor(NCBS1/2)+1,k).XG = matriz_slot(i,1,1).XG;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).xx = 2*i-1;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).ZG = D + BRU + HES + (DC31/2) + (k-1)*DC31;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).zz = 80 + k*2;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).YG = j*DC21;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).yy = 2*j;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).Peso = randi(20,1);
                NCSC1 = NCSC1 + 1;                    
            end
        end
    end  
end


if NBSC1==0
    ub = 1;
else
    ub = NBSC1+1;
end

% slots bajo cubierta en zona de bodega
for i = ind_mat:-1:ub
    matriz_slot(i,1,1).XG = Lcc+(DC11/2)+ (ind_mat-i)*DC11;%posición de la primera bahía en bodega
    for j = 1:floor(NCB1/2)+1 % estribor
        for k = 1:NCD
            matriz_slot(i,j,k).xx = i*2-1;
            matriz_slot(i,j,k).XG = matriz_slot(i,1,1).XG;
            matriz_slot(i,j,k).YG = 0 + (j-1)*DC21;
            if (j==1)
                matriz_slot(i,j,k).yy = 0;
            else
                matriz_slot(i,j,k).yy = 2*(j-1)-1;
            end
            matriz_slot(i,j,k).ZG = HDF1 + (DC31/2) + (k-1)*DC31;
            matriz_slot(i,j,k).zz = 2*k; 
            matriz_slot(i,j,k).Peso = randi(20,1);
            NCHO1 = NCHO1 + 1;
        end
    end
    for j = 1:floor(NCB1/2) %babor
         for k = 1:NCD
             matriz_slot(i,j+floor(NCBS1/2)+1,k).xx = i*2-1;
             matriz_slot(i,j+floor(NCBS1/2)+1,k).XG = matriz_slot(i,1,1).XG;
             matriz_slot(i,j+floor(NCBS1/2)+1,k).YG = j*DC21;
             matriz_slot(i,j+floor(NCBS1/2)+1,k).yy = 2*j;
             matriz_slot(i,j+floor(NCBS1/2)+1,k).ZG = HDF1 + (DC31/2) + (k-1)*DC31;
             matriz_slot(i,j+floor(NCBS1/2)+1,k).zz = 2*k;
             matriz_slot(i,j+floor(NCBS1/2)+1,k).Peso = randi(20,1);
             NCHO1 = NCHO1 + 1;
         end
    end
end

% slots sobre cubierta en zona de bodega

for i = ind_mat:-1:ub
    matriz_slot(i,1,1).XG = matriz_slot(ind_mat,1,1).XG + (ind_mat-i)*DC11;
    NTMAX(i) = ((3*L-matriz_slot(i,1,1).XG)*tan(Teta)-D+TFBM)/DC31; %tiers sobre cubierta
    NTMAX(i) = floor (NTMAX(i));
    for j = 1:floor(NCBS1/2)+1 % estribor
        for k = NCD+1:NTMAX(i)+NCD
            matriz_slot(i,j,k).xx = 2*i-1;
            matriz_slot(i,j,k).XG = matriz_slot(i,1,1).XG;
            matriz_slot(i,j,k).YG = 0 + (j-1)*DC21;
            if (j==1)
                matriz_slot(i,j,k).yy = 0;
            else
                matriz_slot(i,j,k).yy = 2*(j-1)-1;
            end
            matriz_slot(i,j,k).ZG = matriz_slot(NSL1,1,1).ZG + (k-NCD)*DC31;
            matriz_slot(i,j,k).zz = 80 + (k-NCD)*2;            
            matriz_slot(i,j,k).Peso = randi(20,1);
            NCSC1 = NCSC1 + 1;
        end
    end
    for j = 1:floor(NCBS1/2) % babor
        for k = NCD+1:NTMAX(i)+NCD
            matriz_slot(i,j+floor(NCBS1/2)+1,k).xx = 2*i-1;
            matriz_slot(i,j+floor(NCBS1/2)+1,k).XG = matriz_slot(i,1,1).XG;
            matriz_slot(i,j+floor(NCBS1/2)+1,k).YG = j*DC21;
            matriz_slot(i,j+floor(NCBS1/2)+1,k).yy = 2*j;
            matriz_slot(i,j+floor(NCBS1/2)+1,k).ZG = matriz_slot(NSL1,1,1).ZG + (k-NCD)*DC31;
            matriz_slot(i,j+floor(NCBS1/2)+1,k).zz = 80 + (k-NCD)*2;
            matriz_slot(i,j+floor(NCBS1/2)+1,k).Peso = randi(20,1);
            NCSC1 = NCSC1 + 1;
        end
    end
end

%slots sobre cubierta en la zona a proa de la bodega

if (NBSC1>0)
    for i = NBSC1:-1:1
        matriz_slot(i,1,1).XG = (L-ET1) + DC11/2 + (NBSC1-i)*DC11;%primer slot sobre castillo
        NTMAX(i) = ((3*L-matriz_slot(i,1,1).XG)*tan(Teta)-D+TFBM)/DC31; %tiers sobre cubierta
        NTMAX(i) = floor (NTMAX(i));
        for j = 1:floor(NCBS1/2)+1 % estribor, se considera que hay una row menos en el castillo por las formas
            for k = 1:NTMAX(i)
                matriz_slot(i,j,k).xx = 2*i-1;
                matriz_slot(i,j,k).XG = matriz_slot(i,1,1).XG;
                matriz_slot(i,j,k).YG = 0 + (j-1)*DC21;
                if (j==1)
                    matriz_slot(i,j,k).yy = 0;
                else
                    matriz_slot(i,j,k).yy = 2*(j-1)-1;
                end
                matriz_slot(i,j,k).ZG = matriz_slot(NSL1,1,1).ZG + (k-1)*DC31;
                matriz_slot(i,j,k).zz = 80 + k*2; 
                matriz_slot(i,j,k).Peso = randi(20,1);
                NCSC1 = NCSC1 + 1;
            end
        end
        for j = 1:floor(NCBS1/2) % babor
            for k = 1:NTMAX(i)
                matriz_slot(i,j+floor(NCBS1/2)+1,k).xx = 2*i-1;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).XG = matriz_slot(i,1,1).XG;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).YG = j*DC21;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).yy = 2*j;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).ZG = matriz_slot(NSL1,1,1).ZG + (k-1)*DC31;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).zz = 80 + k*2;
                matriz_slot(i,j+floor(NCBS1/2)+1,k).Peso = randi(20,1);
                NCSC1 = NCSC1 + 1;
            end
        end
    end
end
NC1 = NCSC1 + NCHO1;
y = 9;
for i = NSL1:-1:1
    for j=1:NCBS1
        for k = 1:NTMAX(NSL1)+NCD
            str1 = 'B';
            str2 = 'C';
            str3 = 'D';
            str4 = 'E';
            str5 = 'F';
            str6 = 'G';
            str7 = 'H';
            x = int2str(y); 
            str1 = strcat(str1,x);
            str2 = strcat(str2,x);
            str3 = strcat(str3,x);
            str4 = strcat(str4,x);
            str5 = strcat(str5,x);
            str6 = strcat(str6,x);
            str7 = strcat(str7,x);
            if isempty(matriz_slot(i,j,k).yy)==0 || isempty(matriz_slot(i,j,k).zz)==0 
                xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).xx,'Hoja2',str1);
                xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).XG,'Hoja2',str2);
                xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).yy,'Hoja2',str3);
                xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).YG,'Hoja2',str4);
                xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).zz,'Hoja2',str5);
                xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).ZG,'Hoja2',str6);
                xlswrite('Calculos portacontenedores.xlsx',matriz_slot(i,j,k).Peso,'Hoja2',str7);
                y = y + 1;
            end
        end
     end
end
xlswrite('Calculos portacontenedores.xlsx', NCHO1, 'Hoja2', 'D4');
xlswrite('Calculos portacontenedores.xlsx', NCSC1, 'Hoja2', 'D5');
xlswrite('Calculos portacontenedores.xlsx', NC1, 'Hoja2', 'D6');
end

