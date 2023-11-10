function path_gain = compute_path_gain_rl(pay_amount, max_tran, balance_ranges, pay_upper)

if pay_amount <= max_tran
    path_gain = compute_pay_gain(balance_ranges, pay_upper, pay_amount);
    
else
    tran_num = ceil(pay_amount / max_tran);
    for i=1:tran_num
        pay_amount_i = min(pay_amount, i * max_tran);
        pay_success_prob(i) = compute_path_success_rl(pay_amount_i, balance_ranges);
        if pay_amount_i<pay_amount
            gain_pay(i) = prod(pay_success_prob(1:i-1)) * (1 - pay_success_prob(i)) * compute_pay_gain(balance_ranges, pay_upper, pay_amount_i); 
        else
           gain_pay(i) = prod(pay_success_prob(1:i - 1)) * compute_pay_gain(balance_ranges, pay_upper, pay_amount_i); 
        end
        if pay_success_prob(i)==0
            break;
        end
    end
    path_gain = sum(gain_pay);
end
path_gain = path_gain * 2;