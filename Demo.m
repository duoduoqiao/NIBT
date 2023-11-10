clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo Non-Intrusive Balance Tomography Using Reinforcement Learning in the
% Lightning Network
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng('shuffle');

% load a LN snapshot
LN_snapshot_file="LN_snapshots\Lightning_20200205.mat";
load(LN_snapshot_file);
A = remove_unreachable_nodes(A);

% set the LN environment
LN_options.max_tran = 0.043*10^8; % the maximum amount in one transaction
LN_options.fee_base = 1000*10^(-6); % the base fee of one transaction
LN_options.fee_unit = 10^(-6); % the unit per transfered Satoshi

capacities = [0.000012,0.0001,0.001,0.005,0.02,0.1,0.167]*10^(8); % the distribution of channel capacities
capacities_prob = [0.01,0.05,0.25,0.5,0.75,0.9,1]; 
[channel_balances,channel_capacities] = simulate_channels(A,capacities,capacities_prob); %simulate the channel capacities and balances 
channels_info = create_channels_data(channel_balances,channel_capacities); % create the channel structures

% set the parallel mode parameters
is_parallel = 0; % 0 means the parallel mode is off; 1 means the parallel mode is on
parallel_num = 10; % the number of partitions in the parallel mode
parallel_id = 1; % partition number (sub-network number) that requires balance disclosure
delta = 1; % the parameter in Neighbore Expansion

if is_parallel==1 % partition LN under parallel mode
    [A_para, channels_info_para] = par_graph(A, parallel_num, channels_info, delta); % Neighbor Expansion
    A = A_para{parallel_id};
    channels_info = channels_info_para{parallel_id};
end

% set the parameters of reinforcement learning
rl_options.lr = 0.3; % the learning rate
rl_options.gamma = 0.8; % the discount rate 
rl_options.epsilon = 0.7; % the epsilon in \epsilon-greedy policy
rl_options.maxItr = 4000; % the maximum number of iterations
rl_options.lambda = 1; % the attenuation parameter
rl_options.path_max_len = 20; % the maximum path length
q_table = init_qtable(A); % initialize the Q table

% set the parameters in our attacking method
atk_options.batch_size = 300; % the batch size
atk_options.granularity = 10; % the stopping granularity
atk_options.pay_step = 100; % step for searching the optimal payment amount

[m1,m2] = connect_to_LN(A); % connect two nodes to LN

% balance disclosure
[channels_info, selected_paths, transactions_info] = balance_disclose(A, q_table, channels_info, m1, m2, ...
    rl_options, atk_options, LN_options); 

% plot the results before and after balance disclosure
[h_total_before, h_total_after, h_small, h_large] = plot_balance_accuracy(channels_info,max_tran);
