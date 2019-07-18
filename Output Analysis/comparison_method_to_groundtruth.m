function comparison_method_to_groundtruth(xlsx_path,gt_xlsx_path)
% Compare output from a single method to groundtruth, used to examine data
% before and after curation.
%   Detailed explanation goes here


% Gt xlsx
auto_tbl = readtable(gt_xlsx_path);
auto_tbl.Vessel_Length_Density = auto_tbl.Vessel_Length .* ...
    auto_tbl.umppix./1000./(auto_tbl.pix_dim.*auto_tbl.umppix/1000).^2;
auto_tbl.Vessel_Area_Fraction = auto_tbl.Vessel_Area ./  auto_tbl.pix_dim.^2;
gt_tbl = auto_tbl(strcmp(auto_tbl.Program,'Manual'),:);


[num,txt,raw] = xlsread(xlsx_path,"collected_data");

bv = cellfun(@(x) ~isempty(x),txt(1,:));
ind = 1:numel(bv);
inds = ind(bv);


raw_tbl = table();
for n=1:numel(inds)
    data = raw(2:end,inds(n));
    if ischar(data{1})
        raw_tbl.(txt{1,inds(n)}) = data;
    else
        raw_tbl.(txt{1,inds(n)}) = cell2mat(data);
    end
end

% Add groundtruth data for each image
raw_tbl.vesselLengthDensity = raw_tbl.vesselLength.* ...
    raw_tbl.umppix./1000./(raw_tbl.pix_dim.*raw_tbl.umppix/1000).^2;
raw_tbl.vesselAreaFraction = raw_tbl.vesselArea./ ...
    raw_tbl.pix_dim.^2;
tp_bv = raw_tbl.time==0;

tbl = table();
tbl.image_name = raw_tbl.image_name(tp_bv);
tbl.vesselLengthDensity_before = raw_tbl.vesselLengthDensity(tp_bv);
tbl.vesselAreaFraction_before = raw_tbl.vesselAreaFraction(tp_bv);
tbl.meanVesselDiam_before = raw_tbl.meanVesselDiam(tp_bv);
tbl.numBranchPoints_before = raw_tbl.numBranchPoints(tp_bv);

tbl.vesselLengthDensity_after = raw_tbl.vesselLengthDensity(~tp_bv);
tbl.vesselAreaFraction_after = raw_tbl.vesselAreaFraction(~tp_bv);
tbl.meanVesselDiam_after = raw_tbl.meanVesselDiam(~tp_bv);
tbl.numBranchPoints_after = raw_tbl.numBranchPoints(~tp_bv);
tbl.pix_dim = raw_tbl.pix_dim(tp_bv);
tbl.umppix = raw_tbl.umppix(tp_bv);

% Fill in groundtriuth values
ind = 1:size(tbl,1);
for n=1:size(tbl,1)
    bv = cellfun(@(x) strcmp(tbl.image_name{n},regexprep(x,'\.tif','')),gt_tbl.Image_Name);
    inds = ind(bv);
    tbl.Manual_vesselLengthDensity(n) = gt_tbl.Vessel_Length_Density(inds(1));
    tbl.Manual_vesselAreaFraction(n) = gt_tbl.Vessel_Area_Fraction(inds(1));
    tbl.Manual_meanVesselDiam(n) = gt_tbl.Mean_Diameter(inds(1));
    tbl.Manual_numBranchPoints(n) = gt_tbl.Num_BranchPoints(inds(1));
end

metrics = {'vesselLengthDensity','vesselAreaFraction','meanVesselDiam','numBranchPoints'};
y_label =  {'| Error VLD |','| Error VAF |','| Error Diam. |','| Error BP |'};

st = beautifyAxis_Struct();
st.h_axes.XMinorTick='off';

figure;
for n=1:numel(metrics)
    subplot(2,2,n)
    hold on
    % absolut value of GT - value
    abs_error_before = abs(tbl.(['Manual_' metrics{n}])-  tbl.([metrics{n} '_before']));
    abs_error_after = abs(tbl.(['Manual_' metrics{n}])-  tbl.([metrics{n} '_after']));
    
    x1 = normrnd(1,.05,[size(tbl,1) 1]);
    x2 = normrnd(2,.05,[size(tbl,1) 1]);
    
    % plot paired lines
    for k=1:size(tbl,1)
        plot([x1(k) x2(k)],[abs_error_before(k) ...
            abs_error_after(k)],'-','Color',[0.9 0.9 0.9]);
    end
    
    % Plot Poits
    plot(x1,abs_error_before,'b.','Color',[0 0 1])
    plot(x2,abs_error_after,'g.','Color',[.2 .6 .2])
    
    xticks([1 2])
    xticklabels({'Pre','Post'})
    xlabel('Curation')
    axis([0.5 2.5 ylim])
    ylabel(y_label{n})
    
    [h,p_val] = ttest(abs_error_before,abs_error_after);
    p_corr = min([p_val*numel(metrics) 1]);
    str = sprintf('%s: p=%.2e, %.1f%%%% reduction',metrics{n}, p_corr,...
        100*(mean(abs_error_before)-mean(abs_error_after))./mean(abs_error_before));
%     keyboard
    fprintf([regexprep(str,'e-0','e-') '\n']);
    % Significance table
    signif_table = [1 2 num_sig_stars(p_corr) p_corr];
    cohort_index = [1 1 1 1; 2 1 1 2]; % Index tP group xcoord
    
    % Arr error bars
    add_errorbar(gcf,[1 2],[abs_error_before abs_error_after],.25,'ABSOLUTE_WIDTH',1);
    
    % Add significance bars
    plot_sig_bars(cohort_index, signif_table,gca);
%     pbaspect([1.5 1 1])
    beautifyAxis(gca,st);
end

set(gcf,'position', [100 100 600 300])

end



% 10-8

