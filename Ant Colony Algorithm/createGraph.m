function [ graph ]  = createGraph(NODES,nodeNo)
% To create the graph and calculate the distances between each nodes 
  
  
graph.n = nodeNo;
for i = 1 : graph.n
     graph.node(i).x = NODES(i).Longitude;
     graph.node(i).y = NODES(i).Latitude;

end

end