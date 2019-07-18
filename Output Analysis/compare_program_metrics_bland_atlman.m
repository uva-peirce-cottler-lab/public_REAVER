function compare_program_metrics_bland_atlman(tbl)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

metric_cell = {'Vessel_Length_Density','Vessel_Area_Fraction','Mean_Diameter','Num_BranchPoints'};

diff_tbl = normalize_matched_table(tbl,'Program','Manual','Image_Name',...
    metric_cell,@(x,y) x-y);
mean_tbl = normalize_matched_table(tbl,'Program','Manual','Image_Name',...
   metric_cell,@(x,y) (x+y)/2);

program_cell = unique(diff_tbl.Program);


%for each metric, plot bland altman compared to each variable
% Rows: metric
% Columns: program
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.5, 8.5], ...
    'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
for v = 1:numel(metric_cell)
    
    for p=1:numel(program_cell)
%         numel(p)*(v-1)+p 
        subaxis(numel(metric_cell),numel(program_cell),numel(program_cell)*(v-1)+p,...
    'Padding',.01,'MarginLeft',0.06,'MarginRight',0.06,'SpacingHoriz',.04,'SpacingVert', 0.06);
        ix = strcmp(program_cell{p}, diff_tbl.Program);
        diff_y = diff_tbl.(metric_cell{v})(ix);
        mean_y = mean_tbl.(metric_cell{v})(ix);
%         set(gca,'FontSize', 8);

        bland_altman(diff_y, mean_y, 'DataFormat', 'dyuy');
        
    end
end


% keyboard



end

