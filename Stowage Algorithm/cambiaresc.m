function cambiaresc(angesc, ygf, Desp, Tf, T0, cb,  matriz_slot)

global NCBS1

double peso1;
double peso2;
double esc;
double bay;
double row;
double tier;
double angesc;
double deltamon;
double kb;
double km;
double gm;
angescmax = 10*pi/180;

ygf = Ygf;
peso2 = 0;

[o,p,q]=size(matriz_slot); 

if angesc > 0 % si el ángulo de escora es positivo es que la escora está en estribor
    for i= 1:o
        for j= p/2:-1:2
            for k = 1:q
                if isempty(matriz_slot(i,j,k).zz)== 1
                    continue
                else
                    if matriz_slot(i,j,k).Peso == 0
                        continue
                    else
                        peso1 = matriz_slot(i,j,k).Peso;
                        if peso2 < peso1;
                           peso2 = peso1;
                           row = j;
                           tier = k;
                        end
                    end
                end
            end
            if isempty(matriz_slot(i,row+p/2,tier).zz)==0
                    matriz_slot(i,row,tier).Peso = matriz_slot(i,row+p/2,tier).Peso;
                    matriz_slot(i,row+p/2,tier).Peso = peso2;
                    peso2 = 0;  
            else
                    matriz_slot(i,row,tier).Peso = matriz_slot(i,1,tier).Peso;
                    matriz_slot(i,1,tier).Peso = peso2;
                    peso2 = 0; 
            end
            % recalculamos el ángulo de escora
            deltamom =  (matriz_slot(i,row+p/2,tier).YG - ygf)*matriz_slot(i,row+p/2,tier).Peso;
            ygf = ygf + (deltamom/desp);    
            deltamom =  (matriz_slot(i,row,tier).YG - ygf)*matriz_slot(i,row,tier).Peso;
            ygf = ygf + (deltamom/desp);      
                
            %Cálculo del radio metacéntrico%
                 c1 = 0.772*cb^0.0803*(Tf/T0)^0.023-0.6914;
                 c2 = 2.415*cb^0.1434*(Tf/T0)^0.025-1.92;
                 bm = c1*B^2/(cb*Tf);
                 kb = c2*Tf/cb;
                 km = kb + bm;
                 gm = km - kg; %después de cargado el buque%
               % gm = 0.75;
                %Cálculo del ángulo de escora%
                angesc = (ygf - Ygf)/gm;
                angesc = atan (angesc);
%                 angesc = angesc*180/pi();
                if abs(angesc) > abs (angescmax)
                    continue
                else
                    return
                end
        end
    end
else
    for i= 1:o
        for j= p:-1:p/2+1
            for k = 1:q
                if isempty(matriz_slot(i,j,k).zz)== 1
                    continue
                else
                    if matriz_slot(i,j,k).Peso == 0
                        continue
                    else
                        peso1 = matriz_slot(i,j,k).Peso;
                        if peso2 < peso1;
                            peso2 = peso1;
                            row = j;
                            tier = k;
                        end
                    end
                end
            end
            if isempty(matriz_slot(i,row-p/2,tier).zz)==0
                matriz_slot(i,row,tier).Peso = matriz_slot(i,row-p/2,tier).Peso;
                matriz_slot(i,row-p/2,tier).Peso = peso2;
                peso2 = 0;  
            else
                matriz_slot(i,row,tier).Peso = matriz_slot(i,1,tier).Peso;
                matriz_slot(i,1,tier).Peso = peso2;
                peso2 = 0; 
            end
        % recalculamos el ángulo de escora
            deltamom =  (ygf - matriz_slot(i,row-p/2,tier).YG)*matriz_slot(i,row-p/2,tier).Peso;
            ygf = ygf + (deltamom/desp);    
            deltamom =  (ygf - matriz_slot(i,row,tier).YG)*matriz_slot(i,row,tier).Peso;
            ygf = ygf + (deltamom/desp);      
                
            %Cálculo del radio metacéntrico%
%                 c1 = 0.772*cb^0.0803*(Tf/T0)^0.023-0.6914;
%                 c2 = 2.415*cb^0.1434*(Tf/T0)^0.025-1.92;
%                 bm = c1*B^2/(cb*Tf);
%                 kb = c2*Tf/cb;
%                 km = kb + bm;
                % gm = km - kg; %después de cargado el buque%
                gm = 0.75;
                %Cálculo del ángulo de escora%
                angesc = (ygf - Ygf)/gm;
                angesc = atan (angesc);
%                 angesc = angesc*180/pi();
                if abs(angesc) > abs(angescmax)
                    continue
                else
                    return
                end
        end
    end
end

end