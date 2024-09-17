function rcind_seg_cell = skel_2_linesegs(sp_wire,rc_bp,rc_ep)
%{
Function to extract all segments (longer than 5 px) from a wire frame. for
each segment coordinates of all points in segment are saved.

Input arguements:
    sp_wire = vessel wireframe, logical array with dimensions equal to 
                those of the image.
    rc_bp = branchpoint coordinates specified as [row,column] couples vector
    rc_ep = endpoints coordinates specified as [row,column] couples vector

Output arguements:
    rcind_seg_cell = vertical cell array with every cell containing 
                    [row, col] coordinates of all points belonging to that
                    segment
%}
% Get wire/skeleton and trace
bw_init_skel = full(sp_wire);
bw_skel_index = 1:numel(bw_init_skel);


% get coordinates of both endpoints and branchpoints
rc_pts = vertcat(rc_bp,rc_ep);

bw_border = false(size(bw_init_skel));  % Generate a logical image of borders
bw_border(1,:)=1; bw_border(:,1)=1;
bw_border(end,:)=1; bw_border(:,end)=1;
%     imshow()
[re, ce]= ind2sub(size(bw_init_skel), ...
    bw_skel_index(bwmorph(bw_init_skel,'endpoints') & bw_border)); % Get coordinates of all borders and end points.
rc_pts = vertcat(rc_pts, [re' ce']); % rc_pts contains all the ends of segments
rc_pts = unique(rc_pts,'rows');    % remove doubles

bw_pts = false(size(sp_wire));
bw_pts(sub2ind(size(sp_wire),rc_pts(:,1),rc_pts(:,2)))=1;   % bw_pts is a logical array with only the rc_pts as true


% Initialize place holders
rcind_seg_cell = cell(1,1);  

% Initilize skeleton image of the wireframe where parts get iteratively processed
bw_skel_rem = bw_init_skel;

% Need to loop on skeleton until all of it is traced
n = 1;
while 1  %
    
    % Find first element of skeleton
    skel_lind = bw_skel_index(bw_skel_rem); % Indexes of pixels in the wireframe BW image that are logical 1
    
    [ri, ci] = ind2sub(size(bw_skel_rem),skel_lind(1));     % get the coordinates of the 1st logical 1 pixel in the list
    seg_trace = bwtraceboundary(bw_skel_rem,[ri ci],'W');   % get a trace of the line containing this point
     
    is_bp = false(size(seg_trace,1),1);
    % Check which points of the trace are end-points or branch-points
    for k=1:size(seg_trace,1)
        is_bp(k) = ismember(seg_trace(k,:),rc_pts,'rows');
    end
    bp_ind = find(is_bp);
    shortdist_ind = find(diff(bp_ind)==1);
    if numel(shortdist_ind) > 0
        bp_ind(shortdist_ind + 1) = [];
    end
    rcind_seg_cell{n} = cell(numel(bp_ind)-1,1);
    % Segments are trace pixels in between a couple of rc_pts
    if length(bp_ind) >= 2
        tr = seg_trace(bp_ind(1):bp_ind(2),1:2);  % get all elements in the seg_trace that are between the 2 first rc_pts
    else
        tr = seg_trace;     % If for some reason we are left with a segment not containing 2 rc_pts
    end
    rcind_seg_cell{n} = sortrows(tr); % Save all wire-frame points between 2 adjacent branchpoints (as segment)
%     %% Plotting for debugging
%     figure(1);
%     imshow(bw_skel_rem);
%     hold on;
%     plot(tr(:,2),tr(:,1),'g');
%     plot(tr(1,2),tr(1,1),'o');
%     plot(tr(end,2),tr(end,1),'o');
%     hold off;
%     pause(0.1);
%     %%
    % Remove current segment from remaining trace image
    bw_skel_rem(sub2ind(size(bw_skel_rem), tr(:,1),tr(:,2)))=0;

    % Add end points back in, then remove lone points (particles smaller than 9 px)
    bw_skel_rem = bwareaopen(bw_skel_rem |  bw_pts,9);
    
    % Loop stop condition
    if sum(bw_skel_rem,'all')==0
        break 
    end
    n = n+1 ;

end   

% delete segments less than 5 pixels in length
rcind_seg_cell(cellfun(@(x) size(x,1) <=5, rcind_seg_cell))=[];
rcind_seg_cell = rcind_seg_cell';
end


