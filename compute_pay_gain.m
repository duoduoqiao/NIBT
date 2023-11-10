function [path_gain] = compute_pay_gain(balance_ranges, pay_upper, pay_amount)

balance_num = length(pay_upper);

for i=1:balance_num
    if pay_amount >= pay_upper(i)
        gain(i) = 0;
        gain_i(i) = 0;
        success_prob(i) = 0;
        continue;
    end
    if pay_amount <= balance_ranges(i,1)
        gain(i) = 0;
        gain_i(i) = 0;
        success_prob(i) = 1;
        continue;
    end
    if balance_ranges(i,2) - balance_ranges(i,1)<=2
        gain_i(i) = 0;
        gain(i) = 0;
        if pay_amount >= balance_ranges(i,2)
            success_prob(i) = 1;
        else
            success_prob(i) = 0;
        end
        continue;
    end
    p1 = max((pay_amount - balance_ranges(i,1)),0);
    p2 = min(max((balance_ranges(i,2) - pay_amount),0) / (balance_ranges(i,2) - balance_ranges(i,1)),1);

    gain_i(i) = 2 * p1 * p2;
    success_prob(i) = p2;
    gain(i) = prod(success_prob(1:i-1)) * gain_i(i);
    if prod(success_prob(1:i)) < 10^(-6)
        gain(i + 1:balance_num) = zeros(1, balance_num-i);
        break;
    end
end
path_gain = sum(gain);