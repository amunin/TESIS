function [bahia] = FuerzasCortantes(NCL1, Desp, matriz_slot)
%Cálculo de las fuerzas cortantes generadas en cada bahía a lo largo de la
%eslora
%Inputs: NBSC1(número de bahías a proa de la bodega)
%        NCL1 (número de bahías en la zona de bodega)
%        NCB1 (número de filas en bodega)
%        NCBS1 (número de filas sobre cubierta)
%        NBCC1 (número de bahías a popa de la zona de bodega)

global NSL1 NCB1 NBCC1 NBSC1 NCBS1 DC11


PR = 1766;
L = 82;
PRDistribuido = PR/L; %el peso en rosca distribuido a lo largo de la eslora
DespDistribuido = Desp/L; %flotabilidad

[o,p,q]=size(matriz_slot);

if NBSC1==0
    ub = 1;
else
    ub = NBSC1+1;
end

% Peso de los contenedores a popa de la zona de bodega
if(NBCC1>0)
   for i=NSL1:-1:NCL1+NBSC1
       bahia(i).PesoTotal = 0;
       for j = 1:1:floor(NCBS1/2) %estribor
            for k = 1:1:q
                if isempty(matriz_slot(i,j,k).yy)==1 || matriz_slot(i,j,k).Peso == 0
                    continue
                else
                    bahia(i).PesoTotal= bahia(i).PesoTotal + matriz_slot(i,j,k).Peso;
                end
            end
        end
        for j = 1:1:floor(NCBS1/2) %babor
            for k = 1:1:q
                if isempty(matriz_slot(i,j+floor(NCBS1/2),k).yy)==1 || matriz_slot(i,j+floor(NCBS1/2),k).Peso == 0
                    continue
                else
                    bahia(i).PesoTotal= bahia(i).PesoTotal + matriz_slot(i,j+floor(NCBS1/2),k).Peso;
                end
            end
        end
        bahia(i).Posicion = matriz_slot(i,1,1).posxg;        
   end
  
end

%Peso de contenedores en bodega bajo cubierta y sobre cubierta
for i=NCL1:-1:ub
    bahia(i).PesoTotal = 0;
    for j = 1:1:floor(NCBS1/2) %babor
        for k =1:1:q
            if isempty(matriz_slot(i,j+floor(NCBS1/2),k).yy)==1
                continue
            else
                bahia(i).PesoTotal = bahia(i).PesoTotal + matriz_slot(i,j+floor(NCBS1/2),k).Peso;
            end
        end
    end
    for j = 1:1:floor(NCBS1/2) %estribor
        for k =1:1:q
            if isempty(matriz_slot(i,j,k).yy)==1
                continue
            else
                bahia(i).PesoTotal= bahia(i).PesoTotal + matriz_slot(i,j,k).Peso;
            end
        end    
    end
    bahia(i).Posicion = matriz_slot(i,1,1).posxg;
end

%Peso de contenedores a proa de la zona de bodega
if(NBSC1>0)
    for i=NBSC1:-1:2
        bahia(i).PesoTotal = 0;
        for j = 1:floor(NCB1/2) %babor
            for k = 1:1:q
                if isempty(matriz_slot(i,j+floor(NCB1/2),k).yy)==1
                    continue
                else
                    bahia(i).PesoTotal= bahia(i).PesoTotal + matriz_slot(i,j+floor(NCB1/2),k).Peso;
                end
            end
        end
        for j = 1:floor(NCB1/2) %estribor
            for k =1:1:q
                 if isempty(matriz_slot(i,j+floor(NCB1/2),k).yy)==1
                    continue
                 else
                    bahia(i).PesoTotal= bahia(i).PesoTotal + matriz_slot(i,j,k).Peso;
                 end
            end
        end 
    end
    bahia(i).Posicion = matriz_slot(i,1,1).posxg;
end

[x,y,z]= size(bahia);

bahia(y+3).PesoDistribuido = DespDistribuido - PRDistribuido;
bahia(y+4).PesoDistribuido = 0;
bahia(y+3).Posicion = bahia(y).Posicion/2;
bahia(y+4).Posicion = 0;


for i = y+2:-1:3
    bahia(i).Posicion = bahia(y).Posicion;
    bahia(i).PesoDistribuido = DespDistribuido - PRDistribuido - bahia(y).PesoTotal/DC11;%t/m
    y = y - 1;
end

bahia(2).PesoDistribuido = DespDistribuido - PRDistribuido;
bahia(1).PesoDistribuido = 0;
bahia(2).Posicion = bahia(3).Posicion + (L - bahia(3).Posicion)/2;
bahia(1).Posicion = L;

[x,y,z]= size(bahia);

str1 = 'M';
j = 40;

for i=1:y
    x = int2str(j); 
    str2 = strcat(str1,x);
    xlswrite('C:\Users\Alicia Munín\Documents\Tesis\Capítulos\ESTIBA\SLOTS_7_MomFlectores\Calculos portacontenedores.xlsx', bahia(i).PesoDistribuido, 'Hoja1', str2);
    j = j+1;
end

bahia(y).FuerzasCortantes = 0;
bahia(1).FuerzasCortantes = 0;

for i = 2:1:y-1
    bahia(i).FuerzasCortantes = bahia(i-1).FuerzasCortantes + bahia(i).PesoDistribuido*(bahia(i-1).Posicion - bahia(i).Posicion);%t
end

for i=1:y
    bahia(i).PesoTotal =0;
end
end

