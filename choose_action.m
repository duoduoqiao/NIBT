function ns = choose_action(ns_avlb, cs, q_table, epsilon)
ns_avlb_node = find(ns_avlb);
ns_avlb_number = sum(ns_avlb);
if rand(1) > epsilon
    if ns_avlb_number==1
        ns = ns_avlb_node;
    else
        ns = randsample(ns_avlb_node, 1);       
    end
else  
    q_cs = q_table(cs, ns_avlb_node);
    ns_q_avlb = ns_avlb_node(find(q_cs==max(q_cs)));
    
    if length(ns_q_avlb)==1
        ns = ns_q_avlb;
    else
        ns = randsample(ns_q_avlb, 1);
    end
end