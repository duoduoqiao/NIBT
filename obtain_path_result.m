function [result, result_info] = obtain_path_result(channels_info, pay_opt, selected_path, max_tran)
result = 0;
result_info.success = zeros(1, channels_info.n);
result_info.fail = zeros(1, channels_info.n);
result_info.pay_n = 0;
pay_l = zeros(1, channels_info.n);
pay_u = 10^8*ones(1, channels_info.n);
pay_i = 0;
if pay_opt>max_tran
    pay_num = ceil(pay_opt/max_tran);
    pay_n = 0;
    success_tag = zeros(1,channels_info.n);
    fail_tag = zeros(1,channels_info.n);
    for i = 1:pay_num - 1
        pay_n = pay_n + 1;
        pay_i = pay_i + max_tran;
        [result_i, path_result_i] = path_sub_result(channels_info, pay_i, selected_path);
        success_i = find(path_result_i.success);
        success_tag(success_i) = 1;
        fail_i = find(path_result_i.fail);
        fail_tag(fail_i) = 1;
        pay_l(success_i) = pay_i;
        if pay_u(fail_i) > pay_i
            pay_u(fail_i) = pay_i;
        end
        if result_i==1
            result = result_i;
            result_info.success = success_tag;
            result_info.fail = fail_tag;
            result_info.pay_l = pay_l;
            result_info.pay_u = pay_u;
            result_info.pay_n = pay_n;
            break;
        end
    end
    if result_i==0
        pay_n = pay_n + 1;
        [result_i,path_result_i] = path_sub_result(channels_info, pay_opt, selected_path);
        pay_l(find(path_result_i.success)) = pay_opt;  
        success_tag(find(path_result_i.success)) = 1;
        fail_tag(find(path_result_i.fail)) = 1;
        if pay_u(find(path_result_i.fail)) > pay_i
            pay_u(find(path_result_i.fail)) = pay_opt;
        end
        result = result_i;
        result_info.success = success_tag;
        result_info.fail = fail_tag;
        result_info.pay_l = pay_l;
        result_info.pay_u = pay_u;
        result_info.pay_n = pay_n;
    end 
else
    [result, result_info] = path_sub_result(channels_info, pay_opt, selected_path);
    pay_l(find(result_info.success)) = pay_opt;
    pay_u(find(result_info.fail)) = pay_opt;
    result_info.pay_l = pay_l;
    result_info.pay_u = pay_u;
    result_info.pay_n = 1;
end