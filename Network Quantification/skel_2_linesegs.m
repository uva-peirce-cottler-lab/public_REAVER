function rcind_seg_cell = skel_2_linesegs(sp_wire,rc_bp,rc_ep)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
INCLUDE_ENDPOINTS=1;
INCLUDE_EDGEPOINTS=1;

% Get wire/skeleton and trace
bw_init_skel = full(sp_wire);
bw_skel_index = 1:numel(bw_init_skel);


% keyboard
% Specify if endpoints can define a segment
if INCLUDE_ENDPOINTS; rc_pts = vertcat(rc_bp,rc_ep); else; rc_pts = rc_bp; end
if INCLUDE_EDGEPOINTS; 
    bw_border = false(size(bw_init_skel)); 
    bw_border(1,:)=1; bw_border(:,1)=1;
    bw_border(end,:)=1; bw_border(:,end)=1;
%     imshow()
    [re, ce]= ind2sub(size(bw_init_skel), ...
        bw_skel_index(bwmorph(bw_init_skel,'endpoints') & bw_border));
    rc_pts = vertcat(rc_pts, [re' ce']);
end

bw_pts = false(size(sp_wire));
bw_pts(sub2ind(size(sp_wire),rc_pts(:,1),rc_pts(:,2)))=1;


% Segments are trace pixels in between branchpoints (inclusive of bp)
rcind_seg_cell_cells = cell(10,1);
    
% Initilize skeleton image where parts get iteratively processed
bw_skel_rem = bw_init_skel;

% Need to loop on skeleton until all of it is traced
for n=1:size(rc_bp.^2)
%     imshow(bw_skel_rem); pause();
    
    % Find first element of skeleton
    skel_lind = bw_skel_index(bw_skel_rem);
    if isempty(skel_lind); break; end
    [ri, ci] = ind2sub(size(bw_skel_rem),skel_lind(1));
    
    % Take remaining wire, trace
    trace = bwtraceboundary(bw_skel_rem,[ri ci],'W');
    trace_index = 1:size(trace,1);
    
    % Find branchpoints in skeleton trace list
    is_bp = false(size(trace,1),1);
    bp_lind = 1:numel(is_bp);
    for k=1:size(trace,1)
        is_bp(k) = ismember(trace(k,:),rc_pts,'rows');
        
    end
    bp_ind = bp_lind(is_bp);
    
    % Segments are trace pixels in between branchpoints (inclusive of bp)
    rcind_seg_cell_cells{n} = cell(numel(bp_ind)-1,1);
    for k=2:numel(bp_ind)
        rcind_seg_cell_cells{n}{k-1} = trace(bp_ind(k-1):bp_ind(k),1:2);
    end
    
    % Remove line segments from remaining trace
    bw_skel_rem(sub2ind(size(bw_skel_rem), trace(:,1),trace(:,2)))=0;
    
    % Add skel points back in, remove lone points
    bw_skel_rem = bwareaopen(bw_skel_rem |  bw_pts,2);
    
    
end   
    
rcind_seg_cell = vertcat(rcind_seg_cell_cells{:});

% Cull segments less than 5 pixels in length
rcind_seg_cell(cellfun(@(x) size(x,1) <=5, rcind_seg_cell))=[];

%  keyboard
%  
%  
%     % Get wire/skeleton and trace
%     bw_skel = full(sp_wire);
%     % [ri, ci] = ind2sub(size(bw_wire),find(bw_wire,1,'first'));
%     
%     
%     % Visualize all of trace
%     bw_trace = zeros(size(bw_skel),'uint8');
%     trace_lind = sub2ind(size(bw_skel), trace(:,1), trace(:,2));
%     bw_trace(trace_lind) = 25+225*trace_lind./max(trace_lind);
%     
%     % Visualize branchpoints
%     gs_bp = zeros(size(bw_skel),'uint8');
%     gs_bp(sub2ind(size(bw_skel), rc_bp(:,2),rc_bp(:,1)))=255;
%     
%     % VIsualize output
%     rgb_seg = zeros([size(bw_skel) 3],'uint8');
%     rgb_seg(:,:,1) = gs_bp;
%     rgb_seg(:,:,2) = bw_trace;
%     rgb_seg(:,:,3) = uint8(bw_skel.*255);
%     
%     imshow(rgb_seg)
%     
%     figure; imshow(bw_skel)
%     figure; imshow(bw_trace)
%     
%     % Concatenate all skel segments
% rcind_seg_cell_cells=1;
% 
%    
end


