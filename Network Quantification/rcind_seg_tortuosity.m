function [seg_tort] = rcind_seg_tortuosity(rcind_seg_cell)
% tortuosity defined as ratio of real length of segment divided by distance
% between start and end point
all_seg_tort=zeros(1,size(rcind_seg_cell,1));

exclude_bv = false(1, size(rcind_seg_cell,1));
for n=1:size(rcind_seg_cell)
    % euclidean distance between points
    p1 = rcind_seg_cell{n}(1,:);
    p2 = rcind_seg_cell{n}(end,:);
    dist = sqrt(sum(abs(p1-p2).^2));
    % Calculate Tortuosity 
    all_seg_tort(n) = numel(rcind_seg_cell{n})./dist;
    % Exclude segments if endpoints overlap (circle) or too close
    if dist<5; exclude_bv(n)=1; end
end

seg_tort = all_seg_tort(~exclude_bv);

% keyboard

end

