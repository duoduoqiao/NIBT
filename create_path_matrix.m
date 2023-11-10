function path_matrix = create_path_matrix(channels_info, paths)
% Generate a binary matrix for the paths

channels = channels_info.channels;
path_num = length(paths);
channel_num = channels_info.n;
path_matrix = [];
for i=1:path_num
    path_i = paths{i};
    path_vec = zeros(1,channel_num);
    for j=1:length(path_i)-1
            node_1 = path_i(j);
            node_2 = path_i(j+1);
            channels_node_id = find(channels(:,1)==node_1&channels(:,2)==node_2);
            path_vec(channels_node_id) = 1;
     end
    path_matrix(i,:) = path_vec;   
end


