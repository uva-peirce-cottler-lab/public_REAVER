function [ng2_proc_rads,col4_proc_rads] = skel_2_proc_segs(bw_skel,...
         bw_curr_thresh, bw_proc_thresh,gs_proc_region)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% keyboard


bw_skel = full(bw_skel);



% Find Ecludiean Distance Radius for skeleton
ed_gs = bwdist(~bw_curr_thresh);
gs_skel_rad = ceil(ed_gs .*bw_skel);

% Dilate pixels at each skeleton point
ind=1:numel(bw_skel);
skel_lind = ind(gs_skel_rad>0);
[rind, cind] = ind2sub(size(bw_skel), skel_lind);

getnhood = @(x) x.Neighborhood;
bw_skel_filled = zeros(size(bw_skel));
for n=1:numel(skel_lind)
    bw_skel_filled = im_restricted_add(bw_skel_filled, ...
        getnhood(strel('disk', double(gs_skel_rad(skel_lind(n))),0)),...
        [rind(n) cind(n)], 1); 

end


% Isolate processes
bw_procs = bw_proc_thresh & ~imdilate(bw_curr_thresh,strel('disk',4));
bw_procs_skel = bwareaopen(bwmorph(bw_procs,'Thin',Inf),5);

% figure;imshow(bw_procs_skel)
% figure; imshow(bw_curr_thresh)


gs_ed_proc_thresh = bwdist(~bw_procs) .* bw_procs_skel;

cc = bwconncomp(gs_ed_proc_thresh);

all_proc_seg_rads = cellfun(@(x) mean(gs_ed_proc_thresh(x)), cc.PixelIdxList);
% proc_seg_rad = mean(all_proc_seg_rads);

ng2_bv =  cellfun(@(x) sum((gs_proc_region(x)==5)) > numel(x)/2, cc.PixelIdxList);

ng2_proc_rads = mean(all_proc_seg_rads(ng2_bv));
col4_proc_rads = mean(all_proc_seg_rads(~ng2_bv));
% Classify each process
% keyboard
% 
% outputArg1 = inputArg1;
% outputArg2 = inputArg2;
end

