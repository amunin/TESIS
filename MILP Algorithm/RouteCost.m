function [TRIPS, ODport, NUT] = RouteCost() 

TRIPS = struct;

% definición de variables %
Filename = 'Datos optimizacion.xlsx';

% Variables del buque %

[L, B, TPM, Vb, PMP, PMMAA, CMP, CMMAA, GT, CComb, CCHT] = importship(Filename);

% Variables de las grúas %

[Velevcarga, Velevacia, Vtras, Vcarro] = importcrane (Filename);
hspreader = 25; % altura bajo spreader en  m

% Variables de los puertos

[PORT, ODport] = importport(Filename);

[n, P] = size(PORT); % número total de puertos

for i= 1:P
    Ttraslado = (L/PORT(i).NGpk)/Vtras; 
    Televacio = hspreader/Velevacia;
    Televcarga = hspreader/Velevcarga;
    Tmovcarro = (B/Vcarro)*2;
    PORT(i).TpkCD = (Ttraslado + Televcarga + Televacio + Tmovcarro)/60; % tiempo C/D por TEU en horas
end

% Coste de combustible
[D] = importdist(Filename);
[n,m] = size(D);

% Flujos entre NUTs y sus coordenadas
[NUT, FlowNUT] = importNUT(Filename);
[n,NNut] = size (NUT);
idxs = nchoosek(1:NNut,2); % hay buscar la combinación de coste para todos los tramos
nTrips = size (idxs,1);
TRIPS(nTrips).Flow = ones (nTrips,1);

for i = 1:nTrips   % flujo para cada link
    TRIPS(i).Flow = FlowNUT(i);    
end


ConsNav = zeros(n,m);
PortConsf = 0;
PortConsv = 0;

for k = 1:nTrips  % coste de cada link
        for j = 1:P
           if NUT(idxs(k,1)).Port == PORT(j).ID  % busca el puerto de origen
                n = 1;
                while n < P+1                   
                    if PORT(n).ID == NUT(idxs(k,2)).Port % busca el puerto de destino
                        TRIPS(k).TnavOD  = D(j,n)/Vb;
                        ConsNav (j,n) = (TRIPS(k).TnavOD*PMP*CMP)/10^6; % en toneladas
                        TRIPS(k).CCombNUT = ConsNav(j,n)*CComb; % asignación de costes de combustibles entre NUTS
    
                        TRIPS(k).TiempoPORT = (PORT(j).TET + PORT(j).TFondeo + PORT(j).TES + PORT(j).TAmarre) * PORT(j).Eff + (PORT(n).TET + PORT(n).TFondeo + PORT(n).TES + PORT(n).TAmarre) * PORT(n).Eff;
                        TRIPS(k).TiempoCD = PORT(j).TpkCD * PORT(j).Eff + PORT(n).TpkCD * PORT(n).Eff;
                        TBASC = (PORT(j).BaseCostSC*(GT/100) * PORT(j).RTA*PORT(j).CorrCoefSC + PORT(n).BaseCostSC*(GT/100) * PORT(n).RTA*PORT(n).CorrCoefSC) * TRIPS(k).TiempoPORT;
                        TBASCk = PORT(j).BaseCostSC*(GT/100) * PORT(j).RTA * PORT(j).CorrCoefSC + PORT(n).BaseCostSC*(GT/100) * PORT(n).RTA * PORT(n).CorrCoefSC;
                        TBFSC = (PORT(j).BaseCostFSC *(GT/100)*PORT(j).RF * PORT(j).CorrCoefFSC) * PORT(j).TFondeo + (PORT(n).BaseCostFSC *(GT/100)*PORT(n).RF * PORT(n).CorrCoefFSC) * PORT(n).TFondeo;
                        TCOM = PORT(j).COM20TEU + PORT(n).COM20TEU; % no aplica coeficiente reductor por volumen de carga (bonificaciones)
                        CGp = PORT(j).CGpk * PORT(j).TpkCD + PORT(n).CGpk * PORT(n).TpkCD;
                        TUZT = PORT(j).AUZT * PORT(j).TUZT * PORT(j).DUZT + PORT(n).AUZT * PORT(n).TUZT * PORT(n).DUZT;
                        if PORT(j).TAN < 1 && PORT(n).TAN < 1
                            TAN = PORT(j).TAN * GT + PORT(n).TAN * GT;
                        end
                        if PORT(j).TAN < 1 && PORT(n).TAN > 1
                            TAN = PORT(j).TAN * GT + PORT(n).TAN;                        
                        end
                        if PORT(j).TAN > 1 && PORT(n).TAN < 1
                            TAN = PORT(j).TAN  + PORT(n).TAN * GT;
                        end
                        if PORT(j).TAN > 1 && PORT(n).TAN > 1
                            TAN = PORT(j).TAN + PORT(n).TAN;
                        end
                        PortConsf = TRIPS(k).TiempoPORT * PMMAA * (CMMAA/10^6) * CComb; 
                        PortConsv = TRIPS(k).TiempoCD * PMMAA * (CMMAA/10^6) * CComb; 
                        TPORTf = TBASC + TBFSC + TUZT + TAN + PORT(j).TDB + PORT(j).TA + PORT(j).Tremol + PORT(j).TP + PORT(n).TDB + PORT(n).TA + PORT(n).Tremol + PORT(n).TP + PortConsf;                    
                        TRIPS(k).Costf = TRIPS(k).CCombNUT + TPORTf + PortConsv; 
                        TRIPS(k).Costv = TBASCk * TRIPS(k).TiempoCD + TCOM + CGp;
                        TRIPS(k).TPM = TPM;
                        TRIPS(k).NNut = NNut;
                        TRIPS(k).CCHT = CCHT;
                        TRIPS(k).Offer = 0;
%                         TRIPS(k).Offer = PORT(n).Throughput;
                        TRIPS(k).Road = NUT(idxs(k,1)).Road + NUT(idxs(k,2)).Road;
                    end
                    n = n+1;
                end            
            end 
        end
end



end

