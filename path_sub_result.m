function [result, result_info] = path_sub_result(channels_info, pay_amt, path)
result = 0;
result_info.success = zeros(1,channels_info.n);
result_info.fail = zeros(1,channels_info.n);
for i = 1:length(path) - 1
    node_1 = path(i);
    node_2 = path(i+1); 
    
    channel_index = find(channels_info.channels(:,1)==node_1 & channels_info.channels(:,2)==node_2);
    
    balance_i = channels_info.balances(channel_index);
    if balance_i >= pay_amt
        result_info.success(channel_index) = 1;
    else
        result_info.fail(channel_index) = 1;
        result = 1;
        break;
    end
end