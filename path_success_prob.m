function success_prob = path_success_prob(pay_amount, balance_ranges)
balance_num = size(balance_ranges,1);
for i=1:balance_num
    if pay_amount<=balance_ranges(i,1)
        prob(i) = 1;
    elseif pay_amount<=balance_ranges(i,2)
        if (balance_ranges(i,2)-balance_ranges(i,1)) < 1
            prob(i) = 1;
        else
            prob(i) = (balance_ranges(i,2) - pay_amount) / (balance_ranges(i,2) - balance_ranges(i,1));
        end
    else
        prob(i) = 0;
    end
end
success_prob = prod(prob);