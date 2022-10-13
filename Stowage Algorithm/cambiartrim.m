function [matriz_slot] = cambiartrim(trimi, matriz_slot, L, Desp0, Tpp0, Tpr0, tpcm)


double peso1;
double peso2;
double trim;
double row;
double tier;
double puerto;
double xg;
double yg;
double zg;

peso2 = 0;
[o,p,q]=size(matriz_slot); 

if trimi > 0 % si el trimado es positivo es que el calado por popa es superior al calado por proa
   for i= o:-1:floor(o/2)
        for j= 1:p
            for k = 1:q
                if isempty(matriz_slot(i,j,k).zz)== 1 % slot vacío
                    continue
                else
                    if matriz_slot(i,j,k).Peso == 0 % doble comprobación de slot vacío
                        continue
                    else
                        peso1 = matriz_slot(i,j,k).Peso;
                        if peso2 < peso1
                            peso2 = peso1;
                            row = j;
                            tier = k;
                            puerto = matriz_slot(i,j,k).Puerto;
                            xg = matriz_slot(i,j,k).XG;
                            yg = matriz_slot(i,j,k).YG;
                            zg = matriz_slot(i,j,k).ZG;
                        end
                    end
                end
            end
        end % aquí se tiene el contenedor más pesado de la bahía i
%            if isempty(matriz_slot(m,row,tier).zz) == 0 % slot ocupado
        for n = i-1:1
            for j= 1:p
                for k = 1:q
                    if peso2 > matriz_slot(n,j,k).Peso
                        matriz_slot(i,row,tier).Peso = matriz_slot(n,j,k).Peso;
                        matriz_slot(i,row,tier).Puerto = matriz_slot(n,j,k).Puerto;
                        matriz_slot(i,row,tier).XG = matriz_slot(n,j,k).XG;
                        matriz_slot(i,row,tier).YG = matriz_slot(n,j,k).YG;
                        matriz_slot(i,row,tier).ZG = matriz_slot(n,j,k).ZG;
                        matriz_slot(n,j,k).Peso = peso2;
                        matriz_slot(n,j,k).Puerto = puerto;
                        matriz_slot(n,j,k).XG = xg;
                        matriz_slot(n,j,k).YG = yg;
                        matriz_slot(n,j,k).ZG = zg;
                        peso2 = 0;                        
                    end
                end
            end
        end
   end
             
         %el siguiente contenedor a mover se coloca en una bahía más a proa
else % trimado negativo, trimado por proa
    for i= 1:floor(o/2)+1
        for j= 1:p
            for k = 1:q
                if isempty(matriz_slot(i,j,k).zz)== 1 % slot vacío
                    continue
                else
                    if matriz_slot(i,j,k).Peso == 0 %doble comprobación de slot vacío
                        continue
                    else
                        peso1 = matriz_slot(i,j,k).Peso;
                        if peso2 < peso1
                            peso2 = peso1;
                            row = j;
                            tier = k;
                            puerto = matriz_slot(i,j,k).Puerto;
                            xg = matriz_slot(i,j,k).XG;
                            yg = matriz_slot(i,j,k).YG;
                            zg = matriz_slot(i,j,k).ZG;
                        end
                    end
                end
            end
        end % aquí se tiene el contenedor más pesado de la bahía i
%            if isempty(matriz_slot(m,row,tier).zz) == 0 % slot ocupado
        for n = o:-1:i+1        
            for m = 1:p
                for l = 1:q
                    if peso2 > matriz_slot(n,m,l).Peso
                        matriz_slot(i,row,tier).Peso = matriz_slot(n,m,l).Peso;
                        matriz_slot(i,row,tier).Puerto = matriz_slot(n,m,l).Puerto;
                        matriz_slot(i,row,tier).XG = matriz_slot(n,m,l).XG;
                        matriz_slot(i,row,tier).YG = matriz_slot(n,m,l).YG;
                        matriz_slot(i,row,tier).ZG = matriz_slot(n,m,l).ZG;
                        matriz_slot(n,m,l).Peso = peso2;
                        matriz_slot(n,m,l).Puerto = puerto;
                        matriz_slot(n,m,l).XG = xg;
                        matriz_slot(n,m,l).YG = yg;
                        matriz_slot(n,m,l).ZG = zg;
                        peso2 = 0;                                
                    end                
                end
            end
        end
        [Tpp, Tpr, trim] = trimado (L, Desp0, Tpp0, Tpr0, tpcm, matriz_slot);      
        if abs(trim) < 0.01*L
            return;
        end
    end
end  
end
