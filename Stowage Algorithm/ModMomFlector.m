function ModMomFlector(Posicion, matriz_slot)
% Funci�n para modificar la posici�n de los contenedores en aquellas bah�as
% que sobrepasen el momento flector m�ximo en aguas tranquilas

global NTMAX

% Posici�n indica qu� bah�a hay que vaciar

[x,y,z]=size(matriz_slot);

for i = 1:1:x 
    if matriz_slot(i,1,1).posxg == Posicion
        for j= 1:y
            for k = z:-1:1
                peso =  matriz_slot(i,j,k).Peso;
                puerto = matriz_slot(i,j,k).Puerto;
                xg = matriz_slot(m,j,k).XG;
                yg = matriz_slot(m,j,k).YG;
                zg = matriz_slot(m,j,k).ZG;
            end
        end
    end
end


for a = i-1:-1:1 
        for b = 1:1:y % estribor
            for c = z+1:1:NTMAX(a)   % se rellenan las bah�as desde l�nea de base
                matriz_slot(a,b,c).poszg = D + BRU + HES + (DC31/2) + (c-1)*DC31;
                matriz_slot(a,b,c).ZG = zg;
                matriz_slot(a,b,c).zz = 80 + c*2;
                matriz_slot(a,b,c).YG = yg;
                matriz_slot(a,b,c).yy = 2*b-1;
                matriz_slot(a,b,c).XG = xg;
                matriz_slot(a,b,c).Peso = peso;
                matriz_slot(a,b,c).Puerto = puerto;

            end
        end
end

end
