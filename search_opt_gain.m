function [opt_pay, opt_gain] = search_opt_gain(max_tran, balance_ranges, pay_upper, search_step, pay_step)
step_n = size(search_step, 1);
for i = 1:step_n
    
    min_pay = floor(max(search_step(i,1)));
    max_pay = floor(min(search_step(i,2)));
    mean_pay = floor(mean([min_pay,max_pay]));
    gain_itv_mean = compute_path_gain(mean_pay, max_tran, balance_ranges, pay_upper);
    gain_itv_min = compute_path_gain(min_pay, max_tran, balance_ranges, pay_upper);
    gain_itv_max = compute_path_gain(max_pay, max_tran, balance_ranges, pay_upper);
    while 1
        if abs(max_pay - min_pay) < 2
            pay(i) = mean_pay;
            gain(i) = gain_itv_mean;
            break;
        end
        if abs(gain_itv_min - gain_itv_mean) < 2 && abs(gain_itv_max - gain_itv_mean) < 2
            pay(i) = mean_pay;
            gain(i) = gain_itv_mean;
            break;
        end
      
        pay_forward = min(mean_pay + pay_step, max_pay);
        pay_backward = max(mean_pay - pay_step, min_pay);
        
        gain_forward = compute_path_gain(pay_forward, max_tran, balance_ranges, pay_upper);
        gain_backward = compute_path_gain(pay_backward, max_tran, balance_ranges, pay_upper);
        if gain_forward > gain_itv_mean && gain_forward > gain_backward
            min_pay = mean_pay;
        elseif gain_backward > gain_itv_mean
            max_pay = mean_pay;
        else
            pay(i) = mean_pay;
            gain(i) = gain_itv_mean;
            break;
        end
        mean_pay = floor(mean([min_pay, max_pay]));
        gain_itv_mean = compute_path_gain(mean_pay, max_tran, balance_ranges, pay_upper);
        gain_itv_min = compute_path_gain(min_pay, max_tran, balance_ranges, pay_upper);
        gain_itv_max = compute_path_gain(max_pay, max_tran, balance_ranges, pay_upper);
    end

end
[opt_gain, opt_i] = max(gain);
opt_pay = pay(opt_i);