function [selected_b_path, path_gain, q_table]=select_path_rl_sasaLam(A, q_table, m1, m2, rl_options, channels_info, max_tran, batch_size, pay_step)
% Select paths using reinforcement learning

n = size(A,1);
p_n = 0;
for i=1:rl_options.maxItr
   
    cs = m1;
    path_c = zeros(1,n);
    path_c_node = m1;
    path_c(1,m1) = 1;
   
    ns_all = A(cs,:);
    ns = choose_action(ns_all, cs, q_table, rl_options.epsilon);
    path_trace = [cs, ns, 1];  
    while(1)      
        if sum(path_c) > rl_options.path_max_len
            break;
        end
        path_c(1,ns) = 1;
        nns_all = A(ns,:);
        nns_avlb = zeros(1,n);
        nns_avlb_node = find(nns_all-path_c==1);
        nns_avlb(nns_avlb_node)=1;
        if isempty(nns_avlb_node)
            nns_max_q = 0;
            nns = -1;
        else
            nns = choose_action_m(nns_avlb, ns, q_table, rl_options.epsilon);
            nns_max_q = q_table(ns, nns);
        end
 
        [c_reward, goal, pay_amt] = compute_reward(path_c_node, ns, m2, channels_info, max_tran, pay_step);
  
        path_trace(find(path_trace(:,1)==cs),:) = [];
        
        path_trace = [path_trace; cs, ns, 1];
        
        if goal == 1           
            q_table(sub2ind(size(q_table),path_trace(:,1),path_trace(:,2))) = q_table(sub2ind(size(q_table),path_trace(:,1),path_trace(:,2))) + rl_options.lr*(c_reward-q_table(cs,ns)).*path_trace(:,3); 
            if p_n<batch_size
                p_n = p_n + 1;
                selected_b_path{p_n} = [path_c_node, ns];
                path_gain(p_n) = c_reward;
            else
                [min_gain,min_i] = min(path_gain);
                if c_reward>min_gain
                    selected_b_path{min_i} = [path_c_node, ns];
                    path_gain(min_i) = c_reward;
                end
            end
            path_trace(:,3) = path_trace(:,3) .* rl_options.gamma * rl_options.lambda; 

            break;
        else       
            q_table(sub2ind(size(q_table),path_trace(:,1),path_trace(:,2)))=q_table(sub2ind(size(q_table),path_trace(:,1),path_trace(:,2))) + rl_options.lr * (c_reward + rl_options.gamma * nns_max_q - q_table(cs,ns)) .* path_trace(:,3);                  
            path_trace(:,3) = path_trace(:,3) .* (rl_options.gamma * rl_options.lambda);          
        end
        if nns==-1
            break;
        else
            path_c_node = [path_c_node, ns];
            cs = ns;
            ns = nns;
        end

    end
    
end
