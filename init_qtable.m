function q_table = init_qtable(A)

q_table = A;
q_table(find(q_table==0)) =-Inf;
q_table(find(q_table==1)) = 0;