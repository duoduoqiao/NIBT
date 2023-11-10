function [channel_balances, channel_capacities] = simulate_channels(A, capacities, capacities_prob)

A(logical(eye(size(A)))) = 0;
[channels_a,channels_b] = find(triu(A));
channels = [channels_a,channels_b];
channels_num = size(channels,1);
channel_balances = zeros(size(A));
channel_capacities = zeros(size(A));
for i=1:channels_num
    prob_rand = rand(1);
    ca_i = find(capacities_prob>=prob_rand,1);
    ca_max = capacities(ca_i);
    if ca_i > 1
        ca_min = capacities(ca_i-1);
    else
        ca_min = 10;
    end
    ca = randi([floor(ca_min), floor(ca_max)]);  
    ba_1 = randi([5,floor(ca) - 5],1,1);
    ba_2 = ca - ba_1;
    channel_balances(channels(i,1),channels(i,2)) = ba_1;
    channel_balances(channels(i,2),channels(i,1)) = ba_2;
    channel_capacities(channels(i,1),channels(i,2)) = ca;
    channel_capacities(channels(i,2),channels(i,1)) = ca;
end


  
