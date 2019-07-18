function [all_seg_rads, index_tbl] =...
    measure_segment_rad(rcind_seg_cell,bw_seg,rc_ep)

% linearize indices
lind_ep = sub2ind(size(bw_seg), rc_ep(:,1), rc_ep(:,2));

ed_gs = bwdist(~bw_seg);
   
all_seg_rads = zeros(1, size(rcind_seg_cell,1));
is_ep_seg = false(1, size(rcind_seg_cell,1));
for n=1:size(rcind_seg_cell,1)
    lind_seg = sub2ind(size(bw_seg), rcind_seg_cell{n}(:,1),rcind_seg_cell{n}(:,2));
    all_seg_rads(n) = mean(ed_gs(lind_seg));
    % Are first or last seg points and endpoint
    is_ep_seg(n) = ~isempty(intersect([lind_seg(1) lind_seg(end)],lind_ep));
end

index_tbl.end_seg_idx = is_ep_seg;
index_tbl.cont_seg_idx = ~is_ep_seg;

end

