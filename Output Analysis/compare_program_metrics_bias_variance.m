function compare_program_metrics_bias_variance(tbl)

metrics_cell = {'Vessel_Length_Density','Vessel_Area_Fraction','Mean_Diameter','Num_BranchPoints'};
metrics_abbrev_cell = {'VLD','VAF','Diam','BP'};

error_from_gt_tbl = normalize_matched_table(tbl,'Program','Manual','Image_Name',...
    metrics_cell,@(x,gt) x-gt);

% abs_error_from_gt_tbl = normalize_matched_table(tbl,'Program','Manual','Image_Name',...
%     metrics_cell,@(x,gt) abs(x-gt));
% diff_from_gt_metric_tbl = diff_from_gt_metric_tbl;

% keyboard
% for each group, abs deviation of error from group mean
% Abs. Dev. of Error from Mean
% error_from_grp_mean = normalize_table_from_group_mean(error_from_gt_tbl,'Program',...
%     metrics_cell);

group_labels = {'Angio\newlineTool','Angio\newlineQuant','RAVE\newline','\newlineREAVER'};
% abs_dev_diff_from_grpmean_metric_tbl = normalize_matched_table(tbl,'Program','Manual','Image_Name',...
%     {'Vessel_Length','Vessel_Area','Mean_Diameter','Num_BranchPoints'},@(x,y) abs(x-mean(x)));
% diff_from_gt_metric_tbl = diff_from_gt_metric_tbl;



hf = figure('Units', 'Inches', 'Position', [1, -1, 5.5, 9.], ...
    'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125],'DefaultTextFontName','Arial');
col1_args = {'Padding',.00,'MarginLeft',0.03,'MarginRight',-0.00,...
    'SpacingHoriz',-.00,'SpacingVert', 0.08};
% col2_args = {'Padding',.00,'MarginLeft',-0.00,'MarginRight',0.00,...
%     'SpacingHoriz',-.00,'SpacingVert', 0.065};
x_ax_scale = 1.68;

% keyboard

%% Vessel Length Density Accuracy and Precision
subaxis(4,2,1,col1_args{:});
fprintf('%s Mean\n',metrics_cell{1})
[data_mat, group_ids] = table_2_obsvar_mat(error_from_gt_tbl, metrics_cell{1},'Program');
boxplot_multcompare(abs(data_mat), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Error VLD |','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',multiple_CI_means(data_mat,0,0));
pbaspect(gca, [x_ax_scale 1 1])

subaxis(4,2,2,col1_args{:});
fprintf('%s Variance\n',metrics_cell{1})
boxplot_multcompare(abs(bsxfun(@minus,data_mat,median(data_mat,1))), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Res. Median Error VLD |     ','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Variance');
pbaspect(gca, [x_ax_scale 1 1])


%% Vessel area fraction Accuracy and Precision
subaxis(4,2,3,col1_args{:});
fprintf('%s Mean\n',metrics_cell{2})
[data_mat, group_ids] = table_2_obsvar_mat(error_from_gt_tbl, metrics_cell{2},'Program');
boxplot_multcompare(abs(data_mat), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Error VAF |','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',multiple_CI_means(data_mat,0,0));
pbaspect(gca, [x_ax_scale 1 1])

subaxis(4,2,4,col1_args{:});
fprintf('%s Variance\n',metrics_cell{2})
boxplot_multcompare(abs(bsxfun(@minus,data_mat,median(data_mat,1))), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Res. Median Error VAF |    ','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Variance');
pbaspect(gca, [x_ax_scale 1 1])

%% Vessel diameter Accuracy and Precision
subaxis(4,2,5,col1_args{:});
fprintf('%s Mean\n',metrics_cell{3})
[data_mat, group_ids] = table_2_obsvar_mat(error_from_gt_tbl, metrics_cell{3},'Program');
boxplot_multcompare(abs(data_mat), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Error Diam. |','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',multiple_CI_means(data_mat,0,0));
pbaspect(gca, [x_ax_scale 1 1])

subaxis(4,2,6,col1_args{:});
fprintf('%s Variance\n',metrics_cell{3})
boxplot_multcompare(abs(bsxfun(@minus,data_mat,median(data_mat,1))), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Res. Median Error Diam. |         ','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Variance');
pbaspect(gca, [x_ax_scale 1 1])


%% Branchpoint Accuracy and Precision
subaxis(4,2,7,col1_args{:});
fprintf('%s Mean\n',metrics_cell{4})
[data_mat, group_ids] = table_2_obsvar_mat(error_from_gt_tbl, metrics_cell{4},'Program');
boxplot_multcompare(abs(data_mat), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Error BP |','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',multiple_CI_means(data_mat,0,0));
pbaspect(gca, [x_ax_scale 1 1])

subaxis(4,2,8,col1_args{:});
fprintf('%s Variance\n',metrics_cell{4})
boxplot_multcompare(abs(bsxfun(@minus,data_mat,median(data_mat,1))), group_ids, 'TargetValue',0,'y_axis_text',...
    '| Res. Median Error BP |  ','group_labels',prettify_groups(group_ids),'IncludeTopRank',1,...
    'IncludeTargetWithinRange',0,'StatAnalysis','Variance');
pbaspect(gca, [x_ax_scale 1 1])

saveas(gcf,[getappdata(0,'proj_path') '/temp/output_bias_precision.tif'])
close(gcf)



% keyboard




% set(gcf,'Position', [1, -1, 10, 8.5]);














