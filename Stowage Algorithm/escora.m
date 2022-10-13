function [angesc, kb, ygf, gm] = escora(desp, yg0, Tf, T0, B, cb, kg, matriz_slot)

double deltamom;
double ygf;
double bm;
double kb;
double gm;
double c1;
double c2;
double t;


ygf = yg0;
[o,p,q] = size(matriz_slot);

for i=1:o %Cálculo del momento escorante y la nueva posición del cdg%
    for j=1:p
        for k=1:q
           if isempty(matriz_slot(i,j,k).yy) == 0
                if matriz_slot(i,j,k).Peso == 0
                    continue
                else 
                    deltamom =  (matriz_slot(i,j,k).YG - ygf)*matriz_slot(i,j,k).Peso;
                    desp = desp + matriz_slot(i,j,k).Peso;
                    ygf = ygf + (deltamom/desp);    
                end
            end
        end
    end
end
%Cálculo del radio metacéntrico%
c1 = 0.772*cb^0.0803*(Tf/T0)^0.023-0.6914;
% c1 = 0.125; % coeficiente variable según el afinamiento de la flotación, máx 1/12 
c2 = 2.415*cb^0.1434*(Tf/T0)^0.025-1.92;
bm = c1*B^2/(cb*Tf);
kb = c2*Tf/cb;
km = kb + bm;
gm = km - kg; %después de cargado el buque%

% gm = 0.75;
%Cálculo del ángulo de escora%
angesc = (ygf - yg0)/gm;
angesc = atan (angesc);
% angesc = angesc*180/pi();
end
