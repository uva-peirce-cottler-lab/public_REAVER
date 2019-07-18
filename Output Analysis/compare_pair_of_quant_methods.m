function ci_95 = compare_pair_quant_methods(first_csv_path,second_csv_path, first_name, second_name)
% Compare two methods of analysis of dataset images (used to compare manual
% methods, mixed versus complete)
 
first_tbl = readtable(first_csv_path);
second_tbl = readtable(second_csv_path);
ix = strcmp(second_tbl.Program,'Mixed_Manual');
second_tbl = second_tbl(ix,:);



shared_img_names = intersect(first_tbl.Image_Name,second_tbl.Image_Name);
first_shared_ind = cellfun(@(x) find(strcmp(x,first_tbl.Image_Name)),shared_img_names,'UniformOutput',1);
second_shared_ind = cellfun(@(x) find(strcmp(x,second_tbl.Image_Name)),shared_img_names,'UniformOutput',1);
shared_img_names

metrics = {'Vessel_Length_Density','Vessel_Area_Fraction','Mean_Diameter','Num_BranchPoints'};
y_label =  {'VLD','VAF','Diam.','BP'};

st = beautifyAxis_Struct();
st.h_axes.XMinorTick='off';

% keyboard
figure;
for n=1:numel(metrics)
    subplot(2,2,n)
    hold on
    % absolut value of GT - value
    first_y = first_tbl.(metrics{n})(first_shared_ind);
    second_y = second_tbl.(metrics{n})(second_shared_ind);
    second_y-first_y
    ci_95(n,1:2) = bland_altman(second_y-first_y, mean([first_y second_y],2), 'DataFormat',...
        'dyuy','X_Label', '(Mm+Mc)/2','Y_Label',[y_label{n} ' (Mm-Mc)'],'CI_Method', 'sem',...
        'Include_CI95',0,'Include_LinearFit',0);
%     keyboard
    beautifyAxis(gca,st);
end

set(gcf,'position', [100 100 600 300])

ci_95

end


