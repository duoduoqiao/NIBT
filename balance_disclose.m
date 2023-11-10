function [channels_info, selected_paths, transactions_info] = balance_disclose(A, q_table, channels_info, m1, m2, rl_options, atk_options, LN_options)
% Balance disclose in LN 
% by Yan Qiao
% Last Modified by Yan Qiao 10-Nov-2023
%
% This is the main function of the balance tomography
%
% Given a LN environment, the function disclose all balances in the LN
% channels.
%
% Outputs:
%
% channel_info       channel information after balance disclosure 
% selected_paths     selected paths with reinforcement learning
% transactions_info  detailed transactions with our balance tomography
%                    method
% 
% Inputs:
%
% A                  the adjacency matrix of LN
% q_table            the initial of Q table
% channel_info       the initial channel information before balance
%                    disclosure
% m1 m2              the two attacking nodes
% rl_options         parameters in reinforcement learning
% atk_options        parameters in our attacking method
% LN_options         parameters in LN environment


q_table_1 = q_table;
q_table_2 = q_table;
selected_paths = [];
k = 0;

max_tran = LN_options.max_tran;
batch_size = atk_options.batch_size;
pay_step = atk_options.pay_step;
granularity = atk_options.granularity;

while 1
    k = k+1;
    % select paths using reinforcement learning
    [selected_path_1,path_gain_1] = select_path_rl_sasaLam(A, q_table_1, m1, m2, rl_options, channels_info, max_tran, batch_size, pay_step);
    [selected_path_2,path_gain_2] = select_path_rl_sasaLam(A, q_table_2, m2, m1, rl_options, channels_info, max_tran, batch_size, pay_step);
    
    % sort the paths by their gains
    selected_paths = [selected_path_1,selected_path_2];
    path_gain = [path_gain_1,path_gain_2]; 
    [path_gain_sort, path_order] = sort(path_gain,'descend');
    max_gain = path_gain_sort(1);
    
    % if the maximum gain is less than the granlarity the selection
    % terminates
    if max_gain < granularity
        break;
    end  
    
    % select one batch of the paths
    if length(path_gain) < batch_size
        selected_path_batch = selected_paths;
    else
        selected_path_batch = selected_paths(path_order(1:batch_size));
    end
    selected_paths = [selected_paths, selected_path_batch];

    % generate a binary matrix for the selected paths
    path_matrix = create_path_matrix(channels_info, selected_path_batch); 

    % disclose all balances on the current batch of paths
    [channels_info,transactions_info{k}] = balance_disclose_iter(path_matrix, channels_info, selected_path_batch, atk_options, LN_options);    
end
