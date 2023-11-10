function [channels_info_new, update_channels]=update_channel_success(channels_info, success_tag, pay_amt)
% update balance ranges when the result is success

channels_info_new = channels_info;
balances_range = channels_info.ranges;
success_channels = find(success_tag);

update_channels = [];

for ch_i = success_channels 
    if pay_amt - balances_range(ch_i,1) >= 1
        balances_range(ch_i,1) = pay_amt;
        update_channels = [update_channels, ch_i];
    end
    if ch_i<=channels_info.n/2
        if balances_range(ch_i + channels_info.n/2,2) - (channels_info.capacities(ch_i) - balances_range(ch_i,1)) >= 1
            balances_range(ch_i + channels_info.n/2,2) = channels_info.capacities(ch_i) - balances_range(ch_i,1);
            update_channels = [update_channels, ch_i + channels_info.n/2];
        end
    else
        if balances_range(ch_i - channels_info.n/2,2) - (channels_info.capacities(ch_i) - balances_range(ch_i,1)) >= 1
            balances_range(ch_i - channels_info.n/2,2) = channels_info.capacities(ch_i) - balances_range(ch_i,1);
            update_channels = [update_channels, ch_i - channels_info.n/2];
        end        
    end
   
end
channels_info_new.ranges = balances_range;