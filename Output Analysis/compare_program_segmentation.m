
% Load metrics
raw_metric_tbl=readtable([getappdata(0,'proj_path') ...
    '/Output Analysis/all_program_results.csv']);
% raw_metric_tbl.Vessel_Length_Density = raw_metric_tbl.Vessel_Length .* raw_metric_tbl.umppix;

[filename,filepath] =  uigetfile('*.xlsx','Select Time Analysis XLSX');
% Load execution time for each image
time_tbl=readtable([filepath '/' filename]);
% For each entry in manual table, add entry for matching image name into
% raw_metric_table

ind=1:size(raw_metric_tbl,1);
for n=1:size(time_tbl,1)
    if isempty(time_tbl.Image_Name{n}); continue; end
    bv = cellfun(@(x) strcmp(time_tbl.Image_Name{n},regexprep(x, '\.[^.]*$','')),...
        raw_metric_tbl.Image_Name);
    inds = ind(bv);
    for k=1:5
    raw_metric_tbl.Execution_Time(inds(k)) = time_tbl.(raw_metric_tbl.Program{inds(k)})(n);
    end
end
% raw_metric_tbl.Vessel_Area_Fraction = raw_metric_tbl.Vessel_Area ./  raw_metric_tbl.pix_dim.^2;
metric_tbl = raw_metric_tbl(cellfun(@(x) ~strcmp(x,'Manual'), raw_metric_tbl.Program),:);

% group_labels = {'Angio\newlineTool','Angio\newlineQuant','RAVE\newline','\newlineREAVER'};

hf = figure('Units', 'Inches', 'Position', [1, -1, 7, 5.], ...
    'PaperUnits', 'Inches', 'PaperSize', [7.5, 9.125],'DefaultTextFontName','Arial');
col1_args = {'Padding',.00,'MarginLeft',0.08,'MarginRight',0.01,...
    'SpacingHoriz',.09,'SpacingVert', 0.2};
x_ax_scale = 1.9;

metrics_cell = {''};
% keyboard

%% Column 1: visualization of bias of error
subaxis(2,2,1,col1_args{:});
[data_mat, group_ids] = table_2_obsvar_mat(metric_tbl, 'Accuracy','Program');
boxplot_multcompare(data_mat, group_ids, 'TargetValue',1,'y_axis_text',...
    'Accuracy','group_labels',prettify_groups(group_ids),'IncludeTopRank',0,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Mean','RankDirection','descend');
pbaspect(gca, [x_ax_scale 1 1])

subaxis(2,2,2,col1_args{:});
[data_mat, group_ids] = table_2_obsvar_mat(metric_tbl, 'Sensitivity','Program');
boxplot_multcompare(data_mat, group_ids, 'TargetValue',1,'y_axis_text',...
    'Sensitivity','group_labels',prettify_groups(group_ids),'IncludeTopRank',0,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Mean','RankDirection','descend');
pbaspect(gca, [x_ax_scale 1 1])

subaxis(2,2,3,col1_args{:});
[data_mat, group_ids] = table_2_obsvar_mat(metric_tbl, 'Specificity','Program');
boxplot_multcompare(data_mat, group_ids, 'TargetValue',1,'y_axis_text',...
    'Specificity','group_labels',prettify_groups(group_ids),'IncludeTopRank',0,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Mean','RankDirection','descend');
pbaspect(gca, [x_ax_scale 1 1])

subaxis(2,2,4,col1_args{:});
[data_mat, group_ids] = table_2_obsvar_mat(metric_tbl, 'Execution_Time','Program');
boxplot_multcompare(data_mat, group_ids, 'TargetValue',0,'y_axis_text',...
    'Ex. Time (sec)','group_labels',prettify_groups(group_ids),'IncludeTopRank',0,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Mean','RankDirection','ascend');
pbaspect(gca, [x_ax_scale 1 1])


saveas(gcf,[getappdata(0,'proj_path') '/temp/output_segmentation.tif'])
close(gcf)
