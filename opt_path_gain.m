function [max_gain, opt_pay] = opt_path_gain(path_matrix, channels_info, selected_paths, update_balance, max_gain, opt_pay, max_tran, pay_step)

update_path = find(sum(path_matrix(:,update_balance),2));

for i=1:length(update_path)
    path_balances = selected_paths{update_path(i)};
    [opt_pay(update_path(i)), max_gain(update_path(i))] = compute_opt_pay_gain(path_balances, channels_info, max_tran, pay_step);
end
end
