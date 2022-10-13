function [Desp, Tf, Kgf] = desplazamiento(Desp0, matriz_slot, L, B, D)

%Variables

%barco
global CBD

double dens;
double volcar;
double Tf;
double dens;
double Tp;
double Kg0;
double deltamom;
double Desp;
double Tf;
double Kgf;

dens = 1.025;


Kg0 = 1.06*(0.64193*D+1.02109);
Kgf = Kg0;
Desp = Desp0;


[o,p,q]=size(matriz_slot); 

for i = o:-1:1
    for j = 1:p
        for k = 1:q
            if isempty(matriz_slot(i,j,k).ZG)==0
                if matriz_slot(i,j,k).Peso == 0
                    continue
                else
                    deltamom = (matriz_slot(i,j,k).ZG - Kgf) * matriz_slot(i,j,k).Peso; 
                    Desp = Desp + matriz_slot(i,j,k).Peso; 
                    Kgf = Kgf + (deltamom/Desp);
                end
            end
        end
    end
end
volcar = Desp/dens; %cálculo del volumen de carena
Tf = volcar/(CBD*L*B); %cálculo del nuevo calado
    


end




