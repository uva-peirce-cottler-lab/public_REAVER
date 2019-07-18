function [metric_st, short_lbl_st] = reaver_quantify_network(mat_path)


if isempty(dir(mat_path))
    error('File not found in specified path: %s\n' , mat_path);
end



% Load matlab 
st=load(mat_path);

fov_um=530.2;
fov_mm = fov_um/1000;
umppix = fov_um./st.imageSize(1);

metric_st=struct();

% keyboard
% Vessel length and Branchpoint density
metric_st.vessel_area_fraction = sum(st.derivedPic.BW_2(:))./prod(st.imageSize);
metric_st.vessel_length_density_mmpmm2 = nnz(st.derivedPic.wire) * ...
    (fov_mm/st.imageSize(1))./(fov_mm).^2;
metric_st.branchpoint_count=size(st.derivedPic.branchpoints,1);


% Vessel tortuosity and # segments
% Add average radius and calssify each lineseg
rcind_seg_cell = skel_2_linesegs(st.derivedPic.wire,...
    fliplr(st.derivedPic.branchpoints),fliplr(st.derivedPic.endpoints));
metric_st.segment_count = size(rcind_seg_cell,1);
% keyboard
metric_st.mean_segment_length_um = mean(cellfun(@(x) size(x,1),rcind_seg_cell)).*umppix;
metric_st.mean_tortuosity = mean(rcind_seg_tortuosity(rcind_seg_cell));
metric_st.mean_valency = size(st.derivedPic.branchpoints,1)./size(rcind_seg_cell,1);


% metric_st.bp_p_segments = metric_st.branchpoint_count ./metric_st.segment_count;

% Measure segment radii and record diameter
[all_seg_rads, index_tbl] = measure_segment_rad(rcind_seg_cell,...
    st.derivedPic.BW_2, fliplr(st.derivedPic.endpoints));
all_seg_diams = 2.*all_seg_rads+1;
metric_st.mean_segment_diam_um = mean(all_seg_diams) .* (fov_um ./ st.imageSize(1));
% metric_st.end_vessel_diam_um = mean(all_seg_diams(index_tbl.end_seg_idx)) .*...
%     (fov_um ./ st.imageSize(1));
% metric_st.cont_vessel_diam_um = mean(all_seg_diams(~index_tbl.end_seg_idx)) .*...
%     (fov_um ./ st.imageSize(1));


% Mean of max diffusion distance for each hole in network
ed_vessel_seg = bwdist(st.derivedPic.BW_2);
cc = bwconncomp(ed_vessel_seg);
mean_diff_dist_pix = cellfun(@(x) max(ed_vessel_seg(x)),cc.PixelIdxList);
metric_st.max_diffusion_dist_um = mean(double(mean_diff_dist_pix)) * umppix;

% Short hand labels for plotting/display
short_lbl_st.vessel_area_fraction = 'VAF';
short_lbl_st.vessel_length_density_mmpmm2 = 'VLD (mm/mm2)';
short_lbl_st.branchpoint_count = 'BP Count';
short_lbl_st.segment_count = 'Segment Count';
% short_lbl_st.bp_p_segments = 'BP/ Segments';
short_lbl_st.mean_segment_length_um = 'Mean Segment Len. (um)';
short_lbl_st.mean_tortuosity = 'Tortuosity';
short_lbl_st.mean_valency = 'Valency';
short_lbl_st.mean_segment_diam_um = 'Mean Segment Diam (um)';
short_lbl_st.max_diffusion_dist_um = 'Mean Max Diff Dist (um)';

% Build adjacency matrix
% https://www.nas.ewi.tudelft.nl/people/Piet/papers/TUDreport20111111_MetricList.pdf
end

