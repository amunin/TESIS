function [matriz_slot] = vaciar(Desp, Despf, matriz_slot)

global NCD NC1 NCHO1 NCSC1

double peso1;
double peso2;
double bay;
double row;
double tier;

% Despf = 3687; %desplazamiento total en toneladas
peso2 = 0;
[o,p,q]=size(matriz_slot); %Hay que extraer de matriz_slot la columna
%correspondiente al peso de los contenedores para obtener el nuevo
%desplazamiento del buque 


for i= 1:1:o
    for j= 1:p/2 %estribor
        for k = 1:q
            if isempty(matriz_slot(i,j,k).zz)==0
                peso1 = matriz_slot(i,j,k).Peso;
                if peso2 < peso1
                    peso2 = matriz_slot(i,j,k).Peso;
                    bay = i;
                    row = j;
                    tier = k;
                else continue
                end
            end
        end
       
        Desp = Desp - peso2;
        matriz_slot(bay,row,tier).Peso = 0;
        if tier <= NCD 
            NCHO1 = NCHO1 - 1;  
            NC1 = NCHO1 + NCSC1;
        else
            NCSC1 = NCSC1 - 1;
            NC1 = NCHO1 + NCSC1;
        end
        peso2 = 0;
        if Desp > Despf 
            continue
        else return
        end
    end
    for j= p/2+1:p %babor
        for k = 1:q
            if isempty(matriz_slot(i,j,k).zz) == 0
                peso1 = matriz_slot(i,j,k).Peso;
                if peso2 < peso1
                    peso2 = matriz_slot(i,j,k).Peso;
                    bay = i;
                    row = j;
                    tier = k;
                else continue
                end
            end
        end
        Desp = Desp - peso2;
        
        matriz_slot(bay,row,tier).Peso = 0;
        if tier <= NCD 
            NCHO1 = NCHO1 - 1;
            NC1 = NCHO1 + NCSC1;
        else
            NCSC1 = NCSC1 - 1;
            NC1 = NCHO1 + NCSC1;
        end
        peso2 = 0;
        if Desp > Despf 
            continue
        else return
        end
    end
end    
  
end