function [Tpp, Tpr, trim] = trimado (L, Desp0, Tpp0, Tpr0, tpcm, matriz_slot)

double Lcgf;
double Lcgi;
double trim;
double Trimaft;
double Trimfore;
double deltamom;
double momtrim;
double lcf;
double Desp;



Lcgi = 0.41699*L;   % Centro de gravedad del buque en el eje y. Estimado a partir del valor de la eslora 
Lcgf = Lcgi;
lcf = 0.5*L;    % Centro de flotación del buque en el eje y. Estimado a partir de la eslora
Desp = Desp0;
momtrim = 0;    % Momento que genera el trimado
trim = 0;

[o,p,q] = size (matriz_slot); %para saber las dimensiones de la matriz


%Calcula momentos%

for i=o:-1:1
    for j=1:p
        for k=1:q
            if isempty(matriz_slot(i,j,k).ZG)== 0
                if matriz_slot(i,j,k).Peso == 0
                    continue
                else
                    xg = matriz_slot(i,j,k).XG;
                    peso = matriz_slot(i,j,k).Peso;
                    deltamom = (Lcgf - matriz_slot(i,j,k).XG)*matriz_slot(i,j,k).Peso;   % Diferencial de momento de trimado generado por un contenedor. 
                    T = table(xg,peso, Lcgf);
                    writetable(T,'prueba.xlsx');
                     % Se considera la distancia entre la posición del contenedor y el centro de gravedad del buque, y a esa diferencia se le multiplica el peso del contenedor
                    momtrim = momtrim + deltamom;               % sumatorio de momentos
                    Desp = Desp + matriz_slot(i,j,k).Peso;                   % sumatorio para el desplazamiento
                    Lcgf = Lcgf + (deltamom/Desp);              % cálculo de la variación del centro de gravedad en la dirección longitudinal del buque
                end
            end
        end
    end
end

trim = momtrim/(100*tpcm); %trimado en metros%
Trimaft = trim*lcf/L; %reparto del trimado a popa%
if Trimaft<0   %calados a proa y a popa según sea el trimado positivo o negativo%
    Trimfore = -trim + Trimaft; %reparto de trimado a proa% 
    Tpp = Tpp0 + Trimaft; % el valor es negativo y resta
    Tpr = Tpr0 + Trimfore;
else
    Trimfore = trim - Trimaft; %reparto de trimado a proa% 
    Tpp = Tpp0 + Trimaft; % el valor es positivo
    Tpr = Tpr0 - Trimfore;
end
end

