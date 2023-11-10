function [A_set,channels_info_set] = par_graph(A, n, channels_info, delta)
% Edge partitioning using Neighbor Expansion

A(logical(eye(size(A)))) = 0;
[channels_a, channels_b] = find(triu(A));
channels = [channels_a,channels_b];
channels_n = size(channels,1);
thd = delta * (channels_n/n);
channels_id = 1:channels_n;
all_channels = channels;
for i=1:n
    [edge_set{i}] = expand_edgeset(A, channels, channels_id, thd);
    A_set{i} = zeros(size(A));
    channels_sub_indx = all_channels(edge_set{i},:);
    A_set{i}(sub2ind(size(A_set{i}),channels_sub_indx(:,1),channels_sub_indx(:,2))) = 1;
    A_set{i}(sub2ind(size(A_set{i}),channels_sub_indx(:,2),channels_sub_indx(:,1))) = 1;
    node_0 = find(sum(A_set{i},1)==0);
    A_set{i}(node_0,:) = [];
    A_set{i}(:,node_0) = [];
    link_in = find(ismember(channels_id,edge_set{i}));
    channels(link_in,:) = [];
    channels_id(link_in) = [];
    channels_sub = [edge_set{i},edge_set{i}+channels_info.n/2];
    
    [channels_sub_a,channels_sub_b] = find(triu(A_set{i}));
    channels_index_1 = [channels_sub_a,channels_sub_b];
    channels_index_2 = [channels_sub_b,channels_sub_a];
    channels_n = size(channels_index_1,1)*2;
    channels_info_set{i}.channels = [channels_index_1;channels_index_2];
    channels_info_set{i}.n = length(edge_set{i})*2;
    channels_info_set{i}.capacities = channels_info.capacities(channels_sub);
    channels_info_set{i}.balances = channels_info.balances(channels_sub);
    channels_info_set{i}.ranges = channels_info.ranges(channels_sub,:);
    channels_info_set{i}.channels_org = edge_set{i};
end