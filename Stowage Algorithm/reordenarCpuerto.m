function [matriz_slot] = reordenarCpuerto(matriz_slot)

% Se ordenan los contenedores en las tiers para que los que van a ser
% descargados primero queden arriba. Al no varíar los contenedores entre
% bahías no se deberían modificar ni el trimado ni la escora


double puerto1;
double puerto2;
double peso;
double xg;
double yg;
double zg;

[o,p,q]=size(matriz_slot); 
flag1 = 1;

while (flag1 == 1)
    
    for i= o:-1:1  %bays
        flag2 = 0;
        for j= 1:p      %rows
            for k = 1:q  %tiers
                if k + 1 > q 
                    continue;
                end
                if isempty(matriz_slot(i,j,k).zz)== 0 && isempty(matriz_slot(i,j,k+1).zz)== 0 %comprobación de que dos slots contiguos en columna están ocupado
                    puerto1 = matriz_slot(i,j,k).Puerto;
                    puerto2 = matriz_slot(i,j,k+1).Puerto;
                    if puerto2 > puerto1;
                        peso = matriz_slot(i,j,k).Peso;
                        xg = matriz_slot(i,j,k).XG;
                        yg = matriz_slot(i,j,k).YG;
                        zg = matriz_slot(i,j,k).ZG;

                        matriz_slot(i,j,k).Peso = matriz_slot(i,j,k+1).Peso;
                        matriz_slot(i,j,k).Puerto = matriz_slot(i,j,k+1).Puerto;
                        matriz_slot(i,j,k).XG = matriz_slot(i,j,k+1).XG;
                        matriz_slot(i,j,k).YG = matriz_slot(i,j,k+1).YG;
                        matriz_slot(i,j,k).ZG = matriz_slot(i,j,k+1).ZG;
                        matriz_slot(i,j,k+1).Puerto = puerto1;
                        matriz_slot(i,j,k+1).Peso = peso;
                        matriz_slot(i,j,k+1).XG = xg;
                        matriz_slot(i,j,k+1).YG = yg;
                        matriz_slot(i,j,k+1).ZG = zg;
                        flag2 = 1;
                     end
                end
            end
        end
    end
    if flag2 == 0
        flag1 = 0;
    end
    
end

end
