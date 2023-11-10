function [h_1, h_2, h_3, h_4] = plot_balance_accuracy(channels_info, max_tran)

balance_range_before = [zeros(channels_info.n,1), channels_info.capacities];
balance_range_after = channels_info.ranges;

small_balances = find(channels_info.balances <= max_tran);
large_balances = find(channels_info.balances > max_tran);

all_length_before = balance_range_before(:,2) - balance_range_before(:,1);
all_length_after = balance_range_after(:,2) - balance_range_after(:,1);

small_length_before = all_length_before(small_balances);
large_length_before = all_length_before(large_balances);

small_length_after = all_length_after(small_balances);
large_length_after = all_length_after(large_balances);

figure(1)
subplot(1,2,1)

pie_total_before(1) = length(find(all_length_before<=1000));
pie_total_before(2) =length(find(all_length_before>1000&all_length_before<=10000));
pie_total_before(3) =length(find(all_length_before>10000&all_length_before<=100000));
pie_total_before(4) =length(find(all_length_before>100000&all_length_before<=1000000));
pie_total_before(5) =length(find(all_length_before>1000000&all_length_before<=10000000));
pie_total_before(6) =length(find(all_length_before>10000000));

pie_total_label_before{1} = '[0,10^3]';
pie_total_label_before{2} = '[10^3,10^4]';
pie_total_label_before{3} = '[10^4,10^5]';
pie_total_label_before{4} = '[10^5,10^6]';
pie_total_label_before{5} = '[10^6,10^7]';
pie_total_label_before{6} = '>10^7';
k = 0;

for i=1:6
    for j=1:pie_total_before(i)
        k = k+1;
        range_total_before{k} = pie_total_label_before{i};
    end
end
x = categorical(range_total_before);
h_1 = pie(x,[1,1,1,1,1,1]);
title('Ranges of all balances before inference','Position',[0,1.3])
set(gcf,'color','w')

subplot(1,2,2)

pie_total(1) = length(find(all_length_after<=10));
pie_total(2) =length(find(all_length_after>10));

pie_total_label{1} = '[0,10]';
pie_total_label{2} = '>10';
k = 0;
for i=1:2
    for j=1:pie_total(i)
        k = k+1;
        range_total{k} = pie_total_label{i};
    end
end
x = categorical(range_total);
h_2 = pie(x,[1,1]);
title('Ranges of all balances after inference','Position',[0,1.3])
set(gcf,'color','w')

figure(2)
subplot(1,2,1)

pie_small(1) = length(find(small_length_after<=10));
pie_small(2) = length(find(small_length_after>10));

pie_small_label{1} = '[0,10]';
pie_small_label{2} = '>10';
k = 0;
for i=1:2
    for j=1:pie_small(i)
        k = k+1;
        range_small{k} = pie_small_label{i};
    end
end
x = categorical(range_small);
h_3 = pie(x,[1,1]);
title('Ranges of small balances after inference','Position',[0,1.3])
set(gcf,'color','w')

subplot(1,2,2)

pie_large(1) = length(find(large_length_after<=10));
pie_large(2) = length(find(large_length_after>10&large_length_after<=1000000));
pie_large(3) = length(find(large_length_after>1000000&large_length_after<=10000000));
pie_large(4) = length(find(large_length_after>10000000));
  
pie_large_label{1}='(0,10]';
pie_large_label{2}='(10,10^6]';
pie_large_label{3}='(10^6,10^7]';
pie_large_label{4}='>10^7';

k = 0;
for i=1:4
    for j=1:pie_large(i)
        k = k+1;
        range_large{k} = pie_large_label{i};
    end
end
x = categorical(range_large);
h_4 = pie(x,[1,1,1,1]);
title('Ranges of large balances after inference','Position',[0,1.3])
set(gcf,'color','w')