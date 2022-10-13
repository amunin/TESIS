%clear all
%close all
clc
%% Problem preparation
%Filename = "OneDrive - Universidade da Coruña/Documentos/Documents/Tesis/Optimizacion Matlab/Matlab/ACO_1/Datos optimizacion.xlsx";
Filename = "Datos optimizacion_AntColony.xlsx";
[NODES, CostMatrixMM, CostMatrixRoad, TimeMatrixMM, TimeMatrixRoad, ProbabilityMatrix, nodeNo] = importfile(Filename);
% Create the graph 
[ graph ]  = createGraph(NODES, nodeNo);
% Draw the graph 
figure 
 
subplot(1,3,1)
drawGraph( graph); 
%% ACO algorithm 
%% Initial parameters of ACO 
maxIter = 250;
antNo = 100;
tau0 = 10 * 1 / (  graph.n * mean ( TimeMatrixMM (:) ) );  % Initial phromone concentration
tau = tau0 * ones( graph.n , graph.n); % Phromone matrix 
rho = 0.5; % Evaporation rate 
alpha = 1;  % Phromone exponential parameters 
beta = 1.727;  % Desirability exponetial paramter
%% Main loop of ACO 
bestFitness = inf;
bestTour = [];
for t = 1 : maxIter
    % Create Ants 
    
    colony = [];
    colony = createColony( ProbabilityMatrix, nodeNo, colony , antNo, tau, alpha,  beta);
    
    % Calculate the fitness values of all ants 
    for i = 1 : antNo 
        colony.ant(i).fitness = fitnessFunction(colony.ant(i).tour , TimeMatrixMM );
    end
    
    % Find the best ant (queen)
    allAntsFitness = [ colony.ant(:).fitness ];
    [ minVal , minIndex ] = min( allAntsFitness );
    if minVal < bestFitness 
        bestFitness = colony.ant(minIndex).fitness;
        bestTour = colony.ant(minIndex).tour;
    end
    
    colony.queen.tour = bestTour;
    colony.queen.fitness = bestFitness;
        
    % Update phromone matrix 
    tau = updatePhromone( tau , colony );  
    
    % Evaporation 
    tau  = ( 1 - rho ) .* tau;
    
    % Display the results 
    
    outmsg = [ 'Iteration #' , num2str(t) , ' Shortest length = ' , num2str(colony.queen.fitness)  ];
    disp(outmsg)
    subplot(1,3,1)
    title(['Iteration #' , num2str(t) ])
    % Visualize best tour and phromone concentration
    subplot(1,3,2)
    cla
    drawBestTour( colony, graph );
       
    subplot(1,3,3)
    cla
    drawPhromone( tau , graph );
   
   drawnow
end
disp(bestTour);
