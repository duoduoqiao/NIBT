function [channels_info_new, update_channels] = update_channels_fail(channels_info, pay_result)
channels_info_new = channels_info;
balances_range = channels_info.ranges;

fail_channels = find(pay_result.fail);

update_channels = [];
for ch_i = fail_channels
    if (balances_range(ch_i,2) - pay_result.pay_u(ch_i)) >= 1
        balances_range(ch_i,2) = pay_result.pay_u(ch_i);
        update_channels=[update_channels,ch_i];
    end
    if ch_i <= channels_info.n/2
        if (channels_info.capacities(ch_i) - balances_range(ch_i,2)) - balances_range(ch_i + channels_info.n/2,1) >= 1
            balances_range(ch_i + channels_info.n/2,1) = channels_info.capacities(ch_i) - balances_range(ch_i,2);
            update_channels = [update_channels, ch_i + channels_info.n/2];
        end
    else
        if (channels_info.capacities(ch_i) - balances_range(ch_i,2) - balances_range(ch_i-channels_info.n/2,1)) >= 1
            balances_range(ch_i - channels_info.n/2,1) = channels_info.capacities(ch_i) - balances_range(ch_i,2);
            update_channels = [update_channels, ch_i - channels_info.n/2];
        end
    end
end
channels_info_new.ranges = balances_range;

