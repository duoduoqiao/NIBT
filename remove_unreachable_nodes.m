function A = remove_unreachable_nodes(A)

leaf_nodes = find(sum(A,1)==1);
A(leaf_nodes,:) = [];
A(:,leaf_nodes) = [];
A_con = conncomp(graph(A));
max_con = mode(A_con);
sub_nodes = find(A_con==max_con);
A = A(sub_nodes,sub_nodes);

end