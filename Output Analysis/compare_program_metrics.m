
raw_metric_tbl=readtable([getappdata(0,'proj_path') ...
    '/Output Analysis/all_program_results.csv']);



raw_metric_tbl.Vessel_Length_Density = raw_metric_tbl.Vessel_Length .* ...
    (raw_metric_tbl.umppix./1000)./(raw_metric_tbl.pix_dim.*raw_metric_tbl.umppix/1000).^2;
raw_metric_tbl.Vessel_Area_Fraction = raw_metric_tbl.Vessel_Area ./  raw_metric_tbl.pix_dim.^2;


%% Produce blan altman plots
% compare_program_metrics_bland_atlman(raw_metric_tbl);

if ~isempty(dir(['Output.txt'])); delete('Output.txt'); end

%% Plots for bias and variance of output error compared to manul ground truth
diary('Output.txt');
compare_program_metrics_bias_variance(raw_metric_tbl);
diary off
