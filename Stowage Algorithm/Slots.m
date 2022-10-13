function [ ] = Slots()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Variables
%gruas
global BG LG NG

%barco
global BRU ET2 ET1 Lcc CBD HDF1 HES BDCC HSE NCD NCHO1 NCBS1 NCB1 NBCC1 NBSC1

%contenedores
global DC11 DC12 DC21 DC31


double NCL1; % número de bahías bajo cubierta a lo largo de la eslora
% double NCHO1; % número de contenedores totales bajo cubierta en función del 
double NCHO2; % tipo de contenedor

%double NCD; % número de tiers de cualquier tipo bajo cubierta en la dirección del puntal
% double NCB1; % número de rows de cualquier tipo bajo cubierta en la dirección de la manga
double NCB2;
% double NCBS1; % número de contenedores de cualquier tipo sobre cubierta en la dirección de la manga
double NCBS2;

filetoread = "Calculos portacontenedores.xlsx";
[L, B, D, Vb, GT, Desp0, Despmax, TFBM] = importfile(filetoread);

%Datos
%Grúas
% BG = 1.5;
% LG = 1.5;
% NG = 2;
BG = 0;
LG = 0;
NG = 0;
%Barco
BRU = 0.2;
ET2 = 7.58;
ET1 = 5.10;
Lcc = 21.41;
CBD = 0.62;
HDF1 = 0.98;
HES = 0.7;
% L = 82.04;
% B = 15;
% D = 7.59;
% TFBM = 6.23;
BDCC = 1.5;
HSE = 18;
%Contenedores
DC11 = 6.06;
DC12 = 12.2;
DC21 = 2.44;
DC31 = 3;


% Cálculos para buque con/sin grúas y TEUS
NCL1 = (L-Lcc-ET1-NG*LG)/DC11; %número de bahías en bodega en la dirección de la eslora
NCL1 = floor(NCL1);

NCD = (D+BRU+HES-HDF1)/DC31; %número de tiers en bodega en la dirección del puntal
NCD = floor(NCD);

NCB1 = (B-2*BDCC-BG*NG)/DC21; %número de filas (rows) en bodega en la dirección de la manga
NCB1 = floor(NCB1);

NCHO1 = (NCL1*NCB1*NCD)*(1.06*CBD*0.5+0.4); %aplicando el factor de forma
NCHO1 = floor(NCHO1);
%se recalcula el número de filas (rows) en bodega por manga teniendo en cuenta el factor de
%forma
NCB1 = NCHO1/(NCD*NCL1);
NCB1 = floor(NCB1);

NCBS1 = (B-BG*NG)/DC21; %número de filas (rows) sobre cubierta en la dirección de la manga
NCBS1 = floor(NCBS1);


if (NG == 0)
    celda = '3';
else
    celda = '2';
end
str1 = 'D';
str1 = strcat(str1,celda);
caso = 4;

if (rem(NCB1,2)==0 && rem(NCBS1,2)==0) 
    matriz_slot = Slots_par(NCB1,NCBS1,NCL1, L, D, TFBM);%no existe fila central en crujía
    while caso ~= 0
        [caso, Desp, Tf, Kgf, kb, trim, Tpp, Tpr, angesc, T0, cb, ygf, gm, tpcm] = estabilidad(L, B, D, Desp0, Despmax,Vb, matriz_slot);
        switch caso
            case 1
                   matriz_slot = vaciar(Desp, Despmax, matriz_slot);
                   matriz_slot = recolocar(matriz_slot);
                   matriz_slot = reordenarCpuerto(matriz_slot); 
            case 2
                   matriz_slot = cambiartrim(trim, matriz_slot, L, Desp0, Tf, Tf, tpcm);


                   matriz_slot = reordenarCpuerto(matriz_slot); 
            case 3
                   matriz_slot = cambiaresc(angesc, ygf, Desp, Tf, T0, cb, matriz_slot);
                   matriz_slot = reordenarCpuerto(matriz_slot); 
        end
%         reordenarCpuerto();    
    end
    xlswrite('Calculos portacontenedores.xlsx', '1', 'Hoja1', str1);
else
    if (rem(NCB1,2)==0 && rem(NCBS1,2)==1) % Para hacer cuadrar el número de contenedores en manga bajo cubierta y sobre cubierta
        NCBS1 = NCBS1-1;
        matriz_slot = Slots_par(NCB1,NCBS1,NCL1, L, D, TFBM);
        while caso ~= 0
            [caso, Desp, Tf, Kgf, kb, trim, Tpp, Tpr, angesc, T0, cb, ygf, gm,tpcm] = estabilidad(L, B, D, Desp0, Despmax,Vb, matriz_slot);
            switch caso
                case 1
                    matriz_slot = vaciar(Desp, Despmax, matriz_slot);
                    matriz_slot = recolocar(matriz_slot);
                case 2
                    matriz_slot = cambiartrim(trim, matriz_slot, L, Desp0, Tf, Tf, tpcm);
                case 3
                    matriz_slot = cambiaresc(angesc, ygf, Desp, Tf, T0, cb, matriz_slot);
            end
            matriz_slot = reordenarCpuerto(matriz_slot); 
        end
        xlswrite('Calculos portacontenedores.xlsx', '1', 'Hoja1', str1);
    else
        if (rem(NCB1,2)==1 && rem(NCBS1,2)==0)
            NCBS1 = NCBS1-1;
            xlswrite('Calculos portacontenedores.xlsx', '1', 'Hoja2', str1);
            matriz_slot = Slots_impar(NCB1,NCBS1,NCL1, L, D, TFBM); %si existe fila central en crujía
            while caso ~= 0
                [caso, Desp, Tf, Kgf, kb, trim, Tpp, Tpr, angesc, T0, cb, ygf, gm, tpcm] = estabilidad(L, B, D, Desp0, Despmax,Vb, matriz_slot);
                switch caso
                    case 1
                        matriz_slot = vaciar(Desp, Despmax, matriz_slot);
                        matriz_slot = recolocar(matriz_slot);
                    case 2
                        matriz_slot = cambiartrim(trim, matriz_slot, L, Desp0, Tf, Tf, tpcm);
                    case 3
                        matriz_slot = cambiaresc(angesc, ygf, Desp, Tf, T0, cb, matriz_slot);
                end
                matriz_slot = reordenarCpuerto(matriz_slot); 
            end
        else
            xlswrite('Calculos portacontenedores.xlsx', '1', 'Hoja2', str1);
            matriz_slot = Slots_impar(NCB1,NCBS1,NCL1, L, D, TFBM);
            while caso ~= 0
                [caso, Desp, Tf, Kgf, kb, trim, Tpp, Tpr, angesc, T0, cb, ygf, gm, tpcm] = estabilidad(L, B, D, Desp0, Despmax,Vb, matriz_slot);
                switch caso
                    case 1
                        matriz_slot = vaciar(Desp, Despmax, matriz_slot);
                        matriz_slot = recolocar(matriz_slot);
                    case 2
                        matriz_slot = cambiartrim(trim, matriz_slot, L, Desp0, Tf, Tf, tpcm);
                    case 3
                        matriz_slot = cambiaresc(angesc, ygf, Desp, Tf, T0, cb, matriz_slot);
                end
                matriz_slot = reordenarCpuerto(matriz_slot); 
            end
        end
    end
end

bahia = FuerzasCortantes(NCL1, Desp, matriz_slot);
[flag, Posicion, bahia] = MomentosFlectores (bahia, cb, L, B);
while flag ==1
            ModMomFlector (Posicion, matriz_slot);
            [caso, Desp, Tf, Kgf, kb, trim, Tpp, Tpr, angesc, T0, cb, ygf, gm, tpcm] = estabilidad(L, B, D, Desp0, Despmax,Vb, matriz_slot);
             switch caso
                    case 1
                            matriz_slot = recolocar(matriz_slot);
                            matriz_slot = reordenarCpuerto(matriz_slot); 
                    case 2    
                            matriz_slot = cambiartrim(trim, matriz_slot, L, Desp0, Tf, Tf, tpcm);
                            matriz_slot = reordenarCpuerto(matriz_slot); 
                    case 3
                            matriz_slot = cambiaresc(angesc, ygf, Desp, Tf, T0, cb,  matriz_slot);
                            matriz_slot = reordenarCpuerto(matriz_slot); 
             end
             bahia = FuerzasCortantes(NCL1, Desp);
             [flag, Posicion, bahia] = MomentosFlectores (bahia, cb, L, B);
       
end

escribirexcel(Desp, Tf, Kgf, kb, trim, Tpp, Tpr, angesc,  matriz_slot, gm, bahia);
end





