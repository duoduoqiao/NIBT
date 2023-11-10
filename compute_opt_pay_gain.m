function [opt_pay, opt_gain] = compute_opt_pay_gain(paths, channels_info, max_tran, pay_step)

balance_num = length(paths)-1;
search_step = [];
for i=1:balance_num
    node_1 = paths(i);
    node_2 = paths(i+1);
    channel_index = find(channels_info.channels(:,1)==node_1&channels_info.channels(:,2)==node_2);
    if ~isempty(channel_index)
        balances_range(i,:) = channels_info.ranges(channel_index,:);
    end
    pay_upper(i) = min(balances_range(:,2));
end

ba_itv_2 = [balances_range(:,1), pay_upper'];
ba_itv_1 = [balances_range(:,1)', pay_upper];
ba_itv_s = sort(ba_itv_1);
search_itv_all = unique(ba_itv_s);
k=0;
for i = 1:length(search_itv_all) - 1
    itv_1 = search_itv_all(i);
    itv_2 = search_itv_all(i+1);
    balance_in = find(ba_itv_2(:,1) <= itv_1 & ba_itv_2(:,2) >= itv_2);
    if ~isempty(balance_in)
        k = k + 1;
        search_step(k,1) = itv_1;
        search_step(k,2) = itv_2;
    end
end

if isempty(search_step)
    opt_pay = 0;
    opt_gain = 0;
else
    [opt_pay, opt_gain] = search_opt_gain(max_tran, balances_range, pay_upper, search_step, pay_step);
end
