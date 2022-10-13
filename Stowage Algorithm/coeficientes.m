function [CB, lcb, T0, tpcm] = coeficientes(Desp0, Desp, T, Vb, L , B)

double Volcar;

dens = 1.025; %densidad mar

Fn = Vb*(0.5144/(9.8*L)^0.5); %Cálculo del número de Froud%
CP = 0.4*Fn+0.44; 
CM = 1-2*Fn^4;
CB0 = CP*CM;
T0 = (Desp0/dens)/(L*B*CB0);
Volcar = Desp/dens;
CB = Volcar/(L*B*T); %Cálculo del coeficiente de bloque para el calado t%
CF = 0.248 + 0.778 * CB; % Fórmula de Torroja
Af = CF * (L * B);
tpcm = Af * 0.01 * 1.025;
%if Fn <= 0.35
%    cp = 8.0606*Fn^2-5.6199*Fn+1.517; %Cálculo del coeficiente prismático%
% elseif Fn < 0.5
%    cp = 0.4*Fn;
% else 
%    cp = 0.64;
% end

lcb = -2.55+3.37*CB^(-4.67)-17.667*Fn^5.36-0.29*CB^(-1.3)*Fn^0.32;
end

