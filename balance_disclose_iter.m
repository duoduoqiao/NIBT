function [channels_info, transactions_info, update_balances_all] = balance_disclose_iter(path_matrix, channels_info, selected_path_batch, atk_options, LN_options)
% Disclose all balances on the paths

[path_num,balance_num] = size(path_matrix);
update_balance = 1:balance_num;
max_gain = zeros(1,path_num);
opt_pay = max_gain;
max_gain_i = 10^8;
pay_step = atk_options.pay_step;
max_tran = LN_options.max_tran;
fee_base = LN_options.fee_base;
fee_p = LN_options.fee_unit;

transactions_info.pay_num = 0;
transactions_info.pay_success_n = 0;
transactions_info.pay_cost = [];
transactions_info.pay_fail_n = 0;
transactions_info.reduce = [];
transactions_info.range_frac = [];

update_balances_all = [];

while max_gain_i>=atk_options.granularity
    
    % record the numbers of balances in various ranges
    range_frac_i(1,1) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)<=10));
    range_frac_i(1,2) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)<=100));
    range_frac_i(1,3) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)<=1000));
    range_frac_i(1,4) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)<=10000));
    range_frac_i(1,5) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)<=100000));
    range_frac_i(1,6) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)<=1000000));
    range_frac_i(1,7) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)<=10000000));
    range_frac_i(1,8) = length(find(channels_info.ranges(:,2) - channels_info.ranges(:,1)>10000000));
    transactions_info.range_frac = [transactions_info.range_frac;range_frac_i];
    
    % select the optimal path with the maximum gain
    [max_gain, opt_pay] = opt_path_gain(path_matrix, channels_info, selected_path_batch, update_balance, max_gain, opt_pay, max_tran, pay_step);
    [max_gain_i, path_opt_i] = max(max_gain);
    opt_pay_i = opt_pay(path_opt_i);  
    selected_path = selected_path_batch{path_opt_i};

    % make the optimal payment amount on the path and observe the result
    [pay_result,pay_result_info] = obtain_path_result(channels_info, opt_pay_i, selected_path, max_tran);
    transactions_info.pay_num = transactions_info.pay_num + 1;

    if pay_result==0 % if the payment is success, update the ranges of balances on the path
        transactions_info.pay_success_n = transactions_info.pay_success_n + 1;
        [channels_info, update_balance] = update_channel_success(channels_info, pay_result_info.success, opt_pay_i);
        hops_n = 2*length(selected_path);
        if opt_pay_i>max_tran
            transactions_info.pay_cost = [transactions_info.pay_cost; hops_n * (fee_base + fee_p * max_tran) * (pay_result_info.pay_n - 1) + hops_n * (fee_base + fee_p * (opt_pay_i - max_tran * (pay_result_info.pay_n - 1)))];
        else
            transactions_info.pay_cost = [transactions_info.pay_cost; hops_n * (fee_base + fee_p * opt_pay_i)];
        end         
    else % if the payment is fail, update the ranges of balances on the path
        transactions_info.pay_fail_n = transactions_info.pay_fail_n + 1;
        [channels_info, update_balances_success] = update_channels_sub_success(channels_info, pay_result_info);
        [channels_info, update_balances_fail] = update_channels_fail(channels_info, pay_result_info);
        update_balance = [update_balances_success, update_balances_fail];
         transactions_info.pay_cost = [transactions_info.pay_cost;0];
        if pay_result_info.pay_n>1
            hops_n = length(selected_path) * 2;
            transactions_info.pay_cost = [transactions_info.pay_cost; hops_n * (fee_base + fee_p * max_tran) * (pay_result_info.pay_n - 1)];
        end        
    end
    update_balances_all = [update_balances_all, update_balance];
end