function [matriz_slot] = recolocar(matriz_slot)
% Esta función tiene como objetivo que no queden slots vacíos debajo de
% otros llenos para que la estiba sea realista



[o,p,q]=size(matriz_slot);

for i= o-NBCC1:-1:1
    for j= 1:p
        for k = 1:q-1
            if isempty(matriz_slot(i,j,k).zz) == 1
                continue
            else
                if matriz_slot(i,j,k).Peso == 0 && isempty(matriz_slot(i,j,k+1).zz) == 0
                    matriz_slot(i,j,k).Peso = matriz_slot(i,j,k+1).Peso;
                    matriz_slot(i,j,k+1).Peso = 0;
                    matriz_slot(i,j,k).Puerto = matriz_slot(i,j,k+1).Puerto;
                    matriz_slot(i,j,k).XG = matriz_slot(i,j,k+1).XG;
                    matriz_slot(i,j,k).YG = matriz_slot(i,j,k+1).YG;
                    matriz_slot(i,j,k).ZG = matriz_slot(i,j,k+1).ZG;
                end
            end
        end
     end
end
  

end