function [edge_set] = expand_edgeset(A, channels, channels_id, thd)
c = [];
s = [];
edge_set = [];
all_nodes = unique([channels(:,1);channels(:,2)]');

while length(edge_set)<=thd
    s_c = setdiff(s,c);
    if isempty(s_c)
        left_nodes = setdiff(all_nodes,c);
        if isempty(left_nodes)
            return;
        end
        x = randsample(left_nodes, 1);
    else
        sc_n = length(s_c);   
        min_diff = 10000;
        for i=1:sc_n
            sc_i = find(A(s_c(i),:));
            sc_i_diff = length(setdiff(sc_i,s));
            if sc_i_diff<min_diff
                min_sc_i = i;
                min_diff = sc_i_diff;
            end
        end
        x = s_c(min_sc_i);        
    end
    [c, s, edge_set, channels, channels_id] = allocedges(A, channels, channels_id, c, s, edge_set, x, thd);
end