function [flag, Posicion, bahia] = MomentosFlectores(bahia, cb, L, B)
% Función para el cálculo de los momentos flectores a partir de las fuerzas
% cortantes



% Cálculo del momento flector máximo en arrufo y quebranto según el DNV
CW = 0.0792*L;
% MFMaxArrufo = (-0.065*CW*L^2*B*(cb+0.7))*0.1;  %tnfm
MFMaxQuebranto = (CW*L^2*B*(0.1225-0.015*cb))*0.1; %tnfm
Posicion = 0;


[x,y,z] = size(bahia);

bahia(y).MomFlector = 0;
bahia(1).MomFlector = 0;

flag = 0;

for i = 2:1:y-1
    bahia(i).MomFlector = bahia(i-1).MomFlector + ((bahia(i-1).FuerzasCortantes + bahia(i).FuerzasCortantes)/2)*(bahia(i-1).Posicion - bahia(i).Posicion);
%     if bahia(i).MomFlector > MFMaxQuebranto || bahia(i).MomFlector > MFMaxArrufo
    if bahia(i).MomFlector > MFMaxQuebranto
        flag = 1;
        Posicion = i;
        break;
    else
        flag = 0;
        continue;
    end
end

end

