function [ fitness ] = fitnessFunction ( tour , CostMatrixMM)
fitness = 0;
for i = 1 : length(tour) -1
    
    currentNode = tour(i);
    nextNode = tour(i+1);
    
    fitness = fitness + CostMatrixMM( currentNode, nextNode );
    
end
end