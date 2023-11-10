function [m1,m2] = connect_to_LN(A)

node_degree = sum(A,1);
[~, node_degree_s] = sort(node_degree,'descend');
m1 = (node_degree_s(1));
m2 = (node_degree_s(2));
