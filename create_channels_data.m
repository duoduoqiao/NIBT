function channels_info = create_channels_data(balances_matrix, capacities_matrix)

[channels_a, channels_b, capacities] = find(triu(capacities_matrix, 1));
[~, ~, balances]=find(triu(balances_matrix, 1));
channels_l = [channels_a, channels_b];
channels_2 = [channels_b, channels_a];
channels = [channels_l; channels_2];
channels_num = 2 * length(capacities);

channels_info.channels = channels;
channels_info.n = channels_num;
channels_info.capacities = [capacities; capacities];
channels_info.balances = [balances; capacities - balances];
channels_info.ranges = zeros(channels_num,2);
channels_info.ranges(:,2) = channels_info.capacities;