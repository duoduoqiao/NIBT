function [reward, goal, pay_amt] = compute_reward(c_path, ns, m2, channels_info, max_tran, pay_step)
goal = 0;
if ns==m2
    [pay_amt, reward] = compute_opt_pay_gain([c_path,ns], channels_info, max_tran, pay_step);
    goal = 1;
else
    pay_amt = 0;
    reward = 0;
end