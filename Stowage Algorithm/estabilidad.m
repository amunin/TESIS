function [caso, Desp, Tf, Kgf,kb, trim, Tpp, Tpr, angesc, T0, cb, ygf, gm, MCTC] = estabilidad(L, B, D, Desp0, Despmax, Vb, matriz_slot)

%Variables



% inicialización de variables

caso = 0;
Desp = 0;
Tf = 0;
Kgf = 0;
kb = 0;
trim = 0;
Tpp = 0;
Tpr = 0;
angesc = 0;
T0 = 0;
cb = 0;
ygf = 0;
gm = 0;


% Desp0 = 1766; %peso en rosca en toneladas
% Despmax = 3687; %desplazamiento máximo en toneladas
% Vb = 19; % knots
% MCTC = 160; % t/cm
Yg0 = 0; %suponiendo el barco sin escora inicial
trimmax = 0.01*L;
angescmax = 10*pi/180;



[Desp, Tf, Kgf] = desplazamiento(Desp0, matriz_slot, L, B, D);
 if Desp > Despmax
     caso = 1;
     return
 else
     caso = 0;
 end

[cb, lcb, T0, MCTC] = coeficientes(Desp0, Desp, Tf, Vb, L, B);

[angesc, kb, ygf, gm] = escora(Desp0, Yg0, Tf, T0, B, cb, Kgf, matriz_slot);

if abs(angesc) > abs (angescmax)
     caso = 3;
     return
else
    caso = 0;
end

[Tpp, Tpr, trim] = trimado (L, Desp0, Tf, Tf, MCTC, matriz_slot);
if abs(trim) > abs(trimmax)
    caso = 2;
    return
else
    caso = 0;
end

end


