function [channels_info_new, update_channels] = update_channels_sub_success(channels_info, pay_result)
channels_info_new = channels_info;
balances_ranges = channels_info.ranges;
success_channels = find(pay_result.success);
update_channels = [];

for ch_i = success_channels 
    if pay_result.pay_l(ch_i) - balances_ranges(ch_i,1) >= 1
        balances_ranges(ch_i,1) = pay_result.pay_l(ch_i);
        update_channels = [update_channels, ch_i];
    end
    if ch_i <= channels_info.n/2
        if balances_ranges(ch_i + channels_info.n/2,2) - (channels_info.capacities(ch_i) - balances_ranges(ch_i,1))>=1
            balances_ranges(ch_i + channels_info.n/2,2) = channels_info.capacities(ch_i) - balances_ranges(ch_i,1);
            update_channels = [update_channels, ch_i + channels_info.n/2];
        end
    else
        if balances_ranges(ch_i - channels_info.n/2,2) - (channels_info.capacities(ch_i) - balances_ranges(ch_i,1)) >= 1
            balances_ranges(ch_i - channels_info.n/2,2) = channels_info.capacities(ch_i) - balances_ranges(ch_i,1);
            update_channels = [update_channels, ch_i - channels_info.n/2];
        end        
    end

end
channels_info_new.ranges = balances_ranges;