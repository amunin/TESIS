function [] = Slots_par(NCB1,NCBS1,NCL1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Variables

%barco
global BRU ET2 ET1 Lcc HDF1 HES L D TFBM HSE NCD NCSC1 NCHO1 NC1 NSL1 NTMAX NBCC1

%contenedores
global DC11 DC12 DC21 DC31 matriz_slot

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
% double NCD; % número de contenedores de cualquier tipo bajo cubierta en la dirección del puntal
% double NCHO1; % número de contenedores totales bajo cubierta en función del 
double NCHO2; % tipo de contenedor y de si tiene grúas o no el buque
double NCL1; % número de contenedores bajo cubierta a lo largo de la eslora
double NCL2; % en función del tipo de contenedor
double NCSC1; % número total de contenedores sobre cubierta de ambos tipos
double NCSC2;
double NSL1; % número de contenedores en cubierta en la dirección
double NSL2; % de la eslora en función del tipo de contenedor
% double NBCC1; % número de contenedores en la dirección de la eslora a popa
double NBCC2; % de la bodega
double NBSC1; % número de contenedores en la dirección de la eslora a proa
double NBSC2; % de la bodega
double NTMAX[]; % número máximo de contenedores apilados sobre cubierta por bahía

% coordenadas de los slots
double posxg; % medida desde la perpendicular de popa
double posyg; % medida desde crujía
double poszg; % medida desde la línea base

double Peso; %peso del contenedor en toneladas
%coordendas del cdg
double XG;
double YG;
double ZG;

double Puerto;

double NPTOS; % número de puertos de la ruta
double NCPTOS[]; % número de contenedores a descargar en cada puerto
double PTO;

% Cálculos para buque con/sin grúas (sólo TEU's)

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


% Lectura del número de puertos y cuántos contenedores van a cada puerto
str1 = 'C';
str2 = strcat(str1,'3');
NPTOS = xlsread ('Calculos portacontenedores.xlsx','Puertos',str2);
for i = 1:1:NPTOS
    j = i + 3;
    k = int2str(j); 
    str2 = strcat(str1,k);
    NCPTOS (i) = xlsread('Calculos portacontenedores.xlsx','Puertos', str2); 
end  
% j = j + 1;
% k = int2str(j); 
% str2 = strcat(str1,k);
% NCPTOSTOTAL = xlsread('Calculos portacontenedores.xlsx','Puertos', str2);

PTO = 4;

% contenedores a popa de la zona de bodega
if NBCC1 > 0
   for i = NSL1:-1:ind_mat+1
        matriz_slot(i,1,1).posxg = ET2+(DC11/2)+(NSL1 - i)*DC11; %posición de la primera bahía a popa de la bodega
        imin =  matriz_slot(i,1,1).posxg - (DC11/2);
        imin = floor(imin);
        imax =  matriz_slot(i,1,1).posxg + (DC11/2);
        imax = floor (imax);
        matriz_slot(i,1,1).XG = randi([imin,imax],1);
        NTMAX(i) = ((3*L-matriz_slot(i,1,1).posxg)*tan(Teta)-D+TFBM)/DC31; %tiers sobre cubierta
        NTMAX(i) = floor (NTMAX(i));
        for j = 1:floor(NCBS1/2) % estribor
            for k = 1:NTMAX(i)   % se rellenan las bahías desde línea de base
                matriz_slot(i,j,k).posxg = matriz_slot(i,1,1).posxg;
                imin =  matriz_slot(i,j,k).posxg - (DC11/2);
                imin = floor (imin);
                imax =  matriz_slot(i,j,k).posxg + (DC11/2);
                imax = floor (imax);
                matriz_slot(i,j,k).XG = randi([imin,imax],1);
                matriz_slot(i,j,k).xx = i*2-1;
                matriz_slot(i,j,k).poszg = D + BRU + HES + (DC31/2) + (k-1)*DC31;
                imin =  matriz_slot(i,j,k).poszg - (DC31/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j,k).poszg + (DC31/2);
                imax = floor(imax);
                matriz_slot(i,j,k).ZG = randi([imin,imax],1);
                matriz_slot(i,j,k).zz = 80 + k*2;
                matriz_slot(i,j,k).posyg = (DC21/2) + (j-1)*DC21;
                imin =  matriz_slot(i,j,k).posyg - (DC21/2);
                imin = floor (imin);
                imax =  matriz_slot(i,j,k).posyg + (DC21/2);
                imax = floor(imax);
                matriz_slot(i,j,k).YG = randi([imin,imax],1);
                matriz_slot(i,j,k).yy = 2*j-1;
                matriz_slot(i,j,k).Peso = randi(20,1);
                matriz_slot(i,j,k).Puerto = PTO;
               
                if NCPTOS(PTO) == 0 && PTO == 0
                    NC1 = NCSC1 + NCHO1;
                    return;
                end
                
                NCPTOS(PTO)= NCPTOS(PTO)-1;
                
                if NCPTOS(PTO)== 0
                    PTO = PTO - 1;
                end
                
                NCSC1 = NCSC1 + 1;
            end
        end
        for j = 1:floor(NCBS1/2) % babor
            for k = 1:NTMAX(i)
                matriz_slot(i,j+floor(NCBS1/2),k).posxg = matriz_slot(i,1,1).posxg;
                imin =  matriz_slot(i,j+floor(NCBS1/2),k).posxg - (DC11/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j+floor(NCBS1/2),k).posxg + (DC11/2);
                imax = floor(imax);
                matriz_slot(i,j+floor(NCBS1/2),k).XG = randi([imin,imax],1);
                matriz_slot(i,j+floor(NCBS1/2),k).xx = 2*i-1;
                matriz_slot(i,j+floor(NCBS1/2),k).poszg = D + BRU + HES + (DC31/2) + (k-1)*DC31;
                imin =  matriz_slot(i,j+floor(NCBS1/2),k).poszg - (DC31/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j+floor(NCBS1/2),k).poszg + (DC31/2);
                imax = floor(imax);
                matriz_slot(i,j+floor(NCBS1/2),k).ZG = randi([imin,imax],1);
                matriz_slot(i,j+floor(NCBS1/2),k).zz = 80 + k*2;
                matriz_slot(i,j+floor(NCBS1/2),k).posyg = -(DC21/2) - (j-1)*DC21;
                imin =  matriz_slot(i,j+floor(NCBS1/2),k).posyg - (DC21/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j+floor(NCBS1/2),k).posyg + (DC21/2);
                imax = floor(imax);
                matriz_slot(i,j+floor(NCBS1/2),k).YG = randi([imin,imax],1);
                matriz_slot(i,j+floor(NCBS1/2),k).yy = 2*j;
                matriz_slot(i,j+floor(NCBS1/2),k).Peso = randi(20,1);
                matriz_slot(i,j+floor(NCBS1/2),k).Puerto = PTO;
                
                if NCPTOS(PTO)==0 && PTO == 0
                   NC1 = NCSC1 + NCHO1;
                   return;
                end
                
                NCPTOS(PTO)= NCPTOS(PTO)-1;
                
                if NCPTOS(PTO)== 0
                   PTO = PTO - 1;
                end
                
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
    matriz_slot(i,1,1).posxg = Lcc+(DC11/2)+ (ind_mat-i)*DC11;%posición de la primera bahía en bodega
    for j = 1:floor(NCB1/2) % estribor
        for k = 1:NCD
            matriz_slot(i,j,k).xx = i*2-1;
            matriz_slot(i,j,k).posxg = matriz_slot(i,1,1).posxg;
            imin =  matriz_slot(i,j,k).posxg - (DC11/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j,k).posxg + (DC11/2);
            imax = floor(imax);
            matriz_slot(i,j,k).XG = randi([imin,imax],1);
            matriz_slot(i,j,k).posyg = DC21/2 + (j-1)*DC21; 
            imin =  matriz_slot(i,j,k).posyg - (DC21/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j,k).posyg + (DC21/2);
            imax = floor(imax);
            matriz_slot(i,j,k).YG = randi([imin,imax],1);
            matriz_slot(i,j,k).yy = 2*j-1;
            matriz_slot(i,j,k).poszg = HDF1 + (DC31/2) + (k-1)*DC31;
            imin =  matriz_slot(i,j,k).poszg - (DC31/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j,k).poszg + (DC31/2);
            imax = floor (imax);
            matriz_slot(i,j,k).ZG = randi([imin,imax],1);
            matriz_slot(i,j,k).zz = 2*k; 
            matriz_slot(i,j,k).Peso = randi(20,1);
            matriz_slot(i,j,k).Puerto = PTO;
           
            if NCPTOS(PTO)==0 && PTO == 0
                NC1 = NCSC1 + NCHO1;
                return;
            end
            
            NCPTOS(PTO)= NCPTOS(PTO)-1;
            
            if NCPTOS(PTO)== 0
                PTO = PTO - 1;
            end
            
            NCHO1 = NCHO1 + 1;
        end
    end
    for j = 1:floor(NCB1/2) %babor
         for k = 1:NCD
             matriz_slot(i,j+floor(NCBS1/2),k).xx = i*2-1;
             matriz_slot(i,j+floor(NCBS1/2),k).posxg = matriz_slot(i,1,1).posxg;
             imin =  matriz_slot(i,j+floor(NCBS1/2),k).posxg - (DC11/2);
             imin = floor(imin);
             imax =  matriz_slot(i,j+floor(NCBS1/2),k).posxg + (DC11/2);
             imax = floor(imax);
             matriz_slot(i,j+floor(NCBS1/2),k).XG = randi([imin,imax],1);
             matriz_slot(i,j+floor(NCBS1/2),k).posyg = -DC21/2 - (j-1)*DC21; 
             imin =  matriz_slot(i,j+floor(NCBS1/2),k).posyg - (DC21/2);
             imin = floor(imin);
             imax =  matriz_slot(i,j+floor(NCBS1/2),k).posyg + (DC21/2);
             imax = floor(imax);
             matriz_slot(i,j+floor(NCBS1/2),k).YG = randi([imin,imax],1);
             matriz_slot(i,j+floor(NCBS1/2),k).yy = 2*j;
             matriz_slot(i,j+floor(NCBS1/2),k).poszg = HDF1 + (DC31/2) + (k-1)*DC31;
             imin =  matriz_slot(i,j+floor(NCBS1/2),k).poszg - (DC31/2);
             imin = floor(imin);
             imax =  matriz_slot(i,j+floor(NCBS1/2),k).poszg + (DC31/2);
             imax = floor(imax);
             matriz_slot(i,j+floor(NCBS1/2),k).ZG = randi([imin,imax],1);
             matriz_slot(i,j+floor(NCBS1/2),k).zz = 2*k;
             matriz_slot(i,j+floor(NCBS1/2),k).Peso = randi(20,1);
             matriz_slot(i,j+floor(NCBS1/2),k).Puerto = PTO;
            
             if NCPTOS(PTO) == 0 && PTO == 0
                 NC1 = NCSC1 + NCHO1;
                 return;
             end
             
             NCPTOS(PTO)= NCPTOS(PTO)-1;
             
             if NCPTOS(PTO) == 0
                 PTO = PTO - 1;
             end
             NCHO1 = NCHO1 + 1;
         end
    end
end

% slots sobre cubierta en zona de bodega

for i = ind_mat:-1:ub
    matriz_slot(i,1,1).posxg = matriz_slot(ind_mat,1,1).posxg + (ind_mat-i)*DC11;
    NTMAX(i) = ((3*L-matriz_slot(i,1,1).posxg)*tan(Teta)-D+TFBM)/DC31; %tiers sobre cubierta
    NTMAX(i) = floor (NTMAX(i));
    for j = 1:floor(NCBS1/2) % estribor
        for k = NCD+1:NTMAX(i)+NCD
            matriz_slot(i,j,k).xx = 2*i-1;
            matriz_slot(i,j,k).posxg = matriz_slot(i,1,1).posxg;
            imin =  matriz_slot(i,j,k).posxg - (DC11/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j,k).posxg + (DC11/2);
            imax = floor(imax);
            matriz_slot(i,j,k).XG = randi([imin,imax],1);
            matriz_slot(i,j,k).posyg = matriz_slot(ind_mat,1,1).posyg + (j-1)*DC21; 
            imin =  matriz_slot(i,j,k).posyg - (DC21/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j,k).posyg + (DC21/2);
            imax = floor(imax);
            matriz_slot(i,j,k).YG = randi([imin,imax],1);
            matriz_slot(i,j,k).yy = 2*j-1;
            matriz_slot(i,j,k).poszg = matriz_slot(NSL1,1,1).poszg + (k-(NCD+1))*DC31;
            imin =  matriz_slot(i,j,k).poszg - (DC31/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j,k).poszg + (DC31/2);
            imax = floor(imax);
            matriz_slot(i,j,k).ZG = randi([imin,imax],1);
            matriz_slot(i,j,k).zz = 80 + (k-NCD)*2;
            matriz_slot(i,j,k).Peso = randi(20,1);
            matriz_slot(i,j,k).Puerto = PTO;
            NCSC1 = NCSC1 + 1;
            NCPTOS(PTO)= NCPTOS(PTO)-1; 
            
            if NCPTOS(PTO) == 0
               PTO = PTO - 1;
            end
            
            if PTO == 0
               NC1 = NCSC1 + NCHO1;
               return;
            end
                      
        end
    end
    for j = 1:floor(NCBS1/2) % babor
        for k = NCD+1:NTMAX(i)+NCD
            matriz_slot(i,j+floor(NCBS1/2),k).xx = 2*i-1;
            matriz_slot(i,j+floor(NCBS1/2),k).posxg = matriz_slot(i,1,1).posxg;
            imin =  matriz_slot(i,j+floor(NCBS1/2),k).posxg - (DC11/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j+floor(NCBS1/2),k).posxg + (DC11/2);
            imax = floor(imax);
            matriz_slot(i,j+floor(NCBS1/2),k).XG = randi([imin,imax],1);
            matriz_slot(i,j+floor(NCBS1/2),k).posyg = -matriz_slot(ind_mat,1,1).posyg - (j-1)*DC21;  
            imin =  matriz_slot(i,j+floor(NCBS1/2),k).posyg - (DC21/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j+floor(NCBS1/2),k).posyg + (DC21/2);
            imax = floor(imax);
            matriz_slot(i,j+floor(NCBS1/2),k).YG = randi([imin,imax],1);
            matriz_slot(i,j+floor(NCBS1/2),k).yy = 2*j;
            matriz_slot(i,j+floor(NCBS1/2),k).poszg = matriz_slot(NSL1,1,1).poszg + (k-(NCD+1))*DC31;
            imin =  matriz_slot(i,j+floor(NCBS1/2),k).poszg - (DC31/2);
            imin = floor(imin);
            imax =  matriz_slot(i,j+floor(NCBS1/2),k).poszg + (DC31/2);
            imax = floor(imax);
            matriz_slot(i,j+floor(NCBS1/2),k).ZG = randi([imin,imax],1);
            matriz_slot(i,j+floor(NCBS1/2),k).zz = 80 + (k-NCD)*2;
            matriz_slot(i,j+floor(NCBS1/2),k).Peso = randi(20,1);
            matriz_slot(i,j+floor(NCBS1/2),k).Puerto = PTO;
            NCSC1 = NCSC1 + 1; 
            NCPTOS(PTO)= NCPTOS(PTO)-1; 
            
            if NCPTOS(PTO) == 0
               PTO = PTO - 1;
            end
            
            if PTO == 0
               NC1 = NCSC1 + NCHO1;
               return;
            end
            
        end
    end
end

%slots sobre cubierta en la zona a proa de la bodega

if (NBSC1>0)
    for i = NBSC1:-1:1
        matriz_slot(i,1,1).posxg = (L-ET1) + DC11/2 + (NBSC1-i)*DC11;%primer slot sobre castillo
        NTMAX(i) = ((3*L-matriz_slot(i,1,1).posxg)*tan(Teta)-D+TFBM)/DC31; %tiers sobre cubierta
        NTMAX(i) = floor (NTMAX(i));
        for j = 1:floor(NCBS1/2)-1 % estribor, se considera que hay una row menos en el castillo por las formas
            for k = 1:NTMAX(i)
                matriz_slot(i,j,k).xx = 2*i-1;
                matriz_slot(i,j,k).posxg = matriz_slot(i,1,1).posxg;
                imin =  matriz_slot(i,j,k).posxg - (DC11/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j,k).posxg + (DC11/2);
                imax = floor(imax);
                matriz_slot(i,j,k).XG = randi([imin,imax],1);
                matriz_slot(i,j,k).posyg = matriz_slot(ind_mat,1,1).posyg + (j-1)*DC21; 
                imin =  matriz_slot(i,j,k).posyg - (DC21/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j,k).posyg + (DC21/2);
                imax = floor(imax);
                matriz_slot(i,j,k).YG = randi([imin,imax],1);
                matriz_slot(i,j,k).yy = 2*j-1;
                matriz_slot(i,j,k).poszg = matriz_slot(NSL1,1,1).poszg + (k-1)*DC31;
                imin =  matriz_slot(i,j,k).poszg - (DC31/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j,k).poszg + (DC31/2);
                imax = floor(imax);
                matriz_slot(i,j,k).ZG = randi([imin,imax],1);
                matriz_slot(i,j,k).zz = 80 + k*2;
                matriz_slot(i,j,k).Peso = randi(20,1);
                matriz_slot(i,j,k).Puerto = PTO;
                NCSC1 = NCSC11 + 1;
               
                NCPTOS(PTO)= NCPTOS(PTO)-1; 
            
                if NCPTOS(PTO) == 0
                   PTO = PTO - 1;
                end

                if PTO == 0
                   NC1 = NCSC1 + NCHO1;
                   return;
                end
            end
        end
        for j = 1:floor(NCBS1/2)-1 % babor
            for k = 1:NTMAX(i)
                matriz_slot(i,j+floor(NCBS1/2),k).xx = 2*i-1;
                matriz_slot(i,j+floor(NCBS1/2),k).posxg = matriz_slot(i,1,1).posxg;
                imin =  matriz_slot(i,j+floor(NCBS1/2),k).posxg - (DC11/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j+floor(NCBS1/2),k).posxg + (DC11/2);
                imax = floor(imax);
                matriz_slot(i,j+floor(NCBS1/2),k).XG = randi([imin,imax],1);
                matriz_slot(i,j+floor(NCBS1/2),k).posyg = -matriz_slot(ind_mat,1,1).posyg - (j-1)*DC21;  
                imin =  matriz_slot(i,j+floor(NCBS1/2),k).posyg - (DC21/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j+floor(NCBS1/2),k).posyg + (DC21/2);
                imax = floor(imax);
                matriz_slot(i,j+floor(NCBS1/2),k).YG = randi([imin,imax],1);
                matriz_slot(i,j+floor(NCBS1/2),k).yy = 2*j;
                matriz_slot(i,j+floor(NCBS1/2),k).poszg = matriz_slot(NSL1,1,1).poszg + (k-1)*DC31;
                imin =  matriz_slot(i,j+floor(NCBS1/2),k).poszg - (DC31/2);
                imin = floor(imin);
                imax =  matriz_slot(i,j+floor(NCBS1/2),k).poszg + (DC31/2);
                imax = floor(imax);
                matriz_slot(i,j+floor(NCBS1/2),k).ZG = randi([imin,imax],1);
                matriz_slot(i,j+floor(NCBS1/2),k).zz = 80 + k*2;
                matriz_slot(i,j+floor(NCBS1/2),k).Peso = randi(20,1);
                matriz_slot(i,j+floor(NCBS1/2),k).Puerto = PTO;
                NCSC1 = NCSC11 + 1;
                
                NCPTOS(PTO)= NCPTOS(PTO)-1; 
            
                if NCPTOS(PTO) == 0
                   PTO = PTO - 1;
                end

                if PTO == 0
                   NC1 = NCSC1 + NCHO1;
                   return;
                end
            end
        end
    end
end

NC1 = NCSC1 + NCHO1;


    

end


