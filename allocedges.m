function [c, s, e, channels, channels_id] = allocedges(A, channels, channels_id, c, s, e, x, thd)
c = union(c,x);
s = union(s,x);
nx = find(A(x,:));
nx_diff = setdiff(nx,s);
for i = 1:length(nx_diff)
    s = [s,nx_diff(i)];
    ny = find(A(nx_diff(i),:));
    ny_in = intersect(s,ny);
    for j=1:length(ny_in)
        channels_index = find(channels(:,1)==nx_diff(i) & channels(:,2)==ny_in(j)|channels(:,2)==nx_diff(i) & channels(:,1)==ny_in(j));
        if ~isempty(channels_index)
            e = [e, channels_id(channels_index)];
        end
        channels(channels_index,:) = [];
        channels_id(channels_index) = [];
        if length(e) > thd
            return;
        end
    end
end
end