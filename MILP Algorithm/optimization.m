function [] = optimization() % una sola variable de optimización

% CCHT = 58000; % charter price per day, 1$ = 1€

% solver para minimizar la función objetivo
[TRIPS, ODport, NUT] = RouteCost();
NNut = TRIPS(1).NNut;
idxs = nchoosek(1:NNut, 2);
nTrips = size(idxs,1);
flag = 1;
j = 1;

while flag == 1
    if TRIPS(j).TnavOD == 0
        idxs(j,:) = [];
        TRIPS(j)= [];
    end
    nTrips = size(idxs,1);    
    if j >= nTrips
        flag = 0;
        break;
    end
    if TRIPS(j).TnavOD > 0
        j = j + 1;
    end
end


[n, nODport] = size(ODport);
CostF = ones(nTrips,1);
CostV = ones(nTrips,1);
nShips = 2;

for i = 1:nTrips
        for k = 1:nODport
            if NUT(idxs(i,1)).Port == ODport(k).Origin && NUT(idxs(i,2)).Port == ODport(k).Destination 
               TRIPS(i).Offer = ODport(k).Flow;
            end
            if NUT(idxs(i,2)).Port == ODport(k).Origin && NUT(idxs(i,1)).Port == ODport(k).Destination 
               TRIPS(i).Offer = ODport(k).Flow;
            end
        end
end

for i = 1:nTrips
    CostV (i,1) = (TRIPS(i).Costv + TRIPS(i).Road) * TRIPS(i).Offer;  
    CostF (i,1) = (TRIPS(i).Costf + TRIPS(i).CCHT)*nShips;
end

tsp = CostF + CostV;

matwid = length(tsp);
Aineq = spalloc(nTrips, matwid, nTrips);
bineq = zeros(nTrips,1);
clearer1 = zeros(size(tsp));
clearer12 = clearer1(:);

counter = 1;
for i = 1:nTrips % frecuencia semanal
    xtemp = clearer1;
    xtemp (i,:) = TRIPS(i).TnavOD + TRIPS(i).TiempoPORT + TRIPS(i).TiempoCD * TRIPS(i).Offer; % sum of trips for all the vessels
    Aineq(counter,:) = xtemp'; % fill the row
    bineq(counter) = 168*nShips; % pasan 168 horas en una semana, 8736h en un año (el flujo es anual, 52 semanas) 
    counter = counter + 1;
end
for i = 1:nTrips % satisfacción de la demanda
    xtemp = clearer1;
    xtemp (i,:) = TRIPS(i).Offer; % sum of trips for all the vessels
    Aineq(counter,:) = xtemp'; % fill the row
    bineq(counter) =  TRIPS(i).Flow; % offer >= demand
    counter = counter + 1;
end

for i = 1:nTrips % Puertos con flujo suficiente
    xtemp = clearer1;
    xtemp (i,:) = 15; % número mínimo de contenedores por los que merece la pena entrar en puerto
    Aineq(counter,:) = xtemp'; % fill the row
    bineq(counter) = 15 + TRIPS(i).Offer; % 15 <= flujo entre puertos
    counter = counter + 1;
end


for i = 1:nTrips % capacidad limitada
    xtemp = clearer1;
    xtemp (i,1) = TRIPS(i).Offer; % sum of trips for all the vessels
    Aineq(counter,:) = xtemp'; 
    bineq(counter) = (TRIPS(i).TPM/14.5)*nShips; 
    counter = counter + 1;
end
% for i = 1:nTrips % capacidad limitada
%     xtemp = clearer1;
%     xtemp (i,1) = (TRIPS(i).TPM/14.5)*nShips; % sum of trips for all the vessels
%     Aineq(counter,:) = xtemp'; 
%     bineq(counter) = TRIPS(i).Offer; 
%     counter = counter + 1;
% end

Aeq = spalloc(NNut, length(idxs), NNut*(NNut-1));

% ruta circular
for i = 1:NNut % puertos
        whichIdxs = (idxs == i); % busca los viajes con el nodo i
        whichIdxs = sparse (sum(whichIdxs, 2)); % cada parada tiene asociado dos viajes
        Aeq (i,:) = whichIdxs'; % matriz de restricción
end

beq = 2*ones(NNut,1);


intcon = 1:nTrips;
lb = zeros(nTrips, 1);
ub = ones(nTrips,1);

opts = optimoptions ('intlinprog','Heuristics','advanced');

[route_tsp, costopt, exitflag, output] = intlinprog (tsp, intcon, Aineq, bineq, Aeq, beq, lb, ub, opts);

route_tsp = logical(round(route_tsp));
    
Gsol = graph(idxs(route_tsp,1), idxs(route_tsp, 2));
hgraph = plot (Gsol);


% % visualización
TiempoNav = zeros(NNut, 1);
TiempoPort = zeros(NNut, 1);
TiempoCD = zeros(NNut, 1);
flow = zeros(NNut, 1);
offer = zeros(NNut, 1);
j = 1;
for i=1:nTrips
    if route_tsp(i) == 1
        TiempoNav (j,:) = TRIPS(i).TnavOD;
        TiempoPort (j,:) = TRIPS(i).TiempoPORT;
        TiempoCD (j,:) = TRIPS(i).TiempoCD * (TRIPS(i).Offer/nShips);
        flow (j,:) =  TRIPS(i).Flow;
        offer(j,:) = TRIPS(i).Offer;
        j = j + 1;
    end
end
T1 = table(idxs(route_tsp,1), idxs(route_tsp,2), CostV(route_tsp), CostF(route_tsp));
T2 = table(flow, TiempoNav, TiempoPort, TiempoCD, offer);

filename = 'Rutas.xlsx';
writetable(T1,filename, 'Range','F3');
writetable(T2,filename,'Range','J3');

end
