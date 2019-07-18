function compare_retina_locations()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


dataset_path = get_dataset_path();
imgs_path = [ dataset_path '\17. REAVER Data\Exp_300 C57Bl6 Lectin@647 Retina\zsnap'];

img_items = dir([imgs_path '/*.tif']);
metric_tbl = table();
elem = @(x) x{1};

for n=1:numel(img_items)
    % USe basename of image to load mat file
    [~, fname,~] = fileparts(img_items(n).name);
    
    % Wuantify metrics
    [metric_st,short_lbl_st] = reaver_quantify_network([imgs_path '/' fname '.mat']); 
    
    
%     fname
    metric_tbl.img_name{n} = img_items(n).name;
    metric_tbl.loc_depth{n} =  elem(regexp(fname,'_([^_]*)_$','tokens', 'once'));
    metric_tbl.loc_radial{n} = elem(regexp(fname,'_([PC])\d*\.','tokens', 'once'));

    % assign metrics to table
    for f=fields(metric_st)'
       metric_tbl.(f{1})(n) = metric_st.(f{1}); 
        
    end
    
end

[a,ix] = sortrows([metric_tbl.loc_radial metric_tbl.loc_depth]);


% keyboard
elem = @(x) x(:);
ind = elem(repmat(1:6,[10 1]));

f = fields(metric_st);
group_labels = {'Cent.\newline Bot.','Cent.\newline Mid.','Cent.\newline Top',...
    'Peri.\newline Bot.','Peri.\newline Mid.','Peri.\newline Top',};


close(gcf)
hf = figure('Units', 'Inches', ...
    'PaperUnits', 'Inches', 'PaperSize', [8, 8.125]);
set(gcf,'position', [0, 0, 8, 6]);

col1_args = {'Padding',.0,'MarginLeft',0.03,'MarginRight',-0.00,...
    'SpacingHoriz',-.00,'SpacingVert', 0.09};
x_ax_scale = 1.7;
for n=1:numel(f)
    %     keyboard
    [data_mat, group_ids] = table_2_obsvar_mat(metric_tbl, f{n},{'loc_depth','loc_radial'});
    
%     [p,tbl,stats] =anova1(data_mat(:),ind,'off');
%     [c,m,h,gnames] = multcompare(stats,'Display','off');
%     pwt = c(:,[1 2 6])%
    
    [PairwiseSigTable,~] = pwise_2tail_test(data_mat,...
                @(x,y) ttest2(x,y,'tail','both'));    
            
            
    ytext = short_lbl_st.(f{n});
    subaxis(3,3,n,col1_args{:});
    set(gca, 'FontName', 'Arial')
    boxplot_multcompare(data_mat, group_ids, ...
        'PairwiseSigTable',PairwiseSigTable,'IncludeTopRank',0,'group_labels',group_labels,...
        'y_axis_text',[ytext '      '],'TargetValue', 0);
    pbaspect(gca, [x_ax_scale 1 1])
end


%% PCA Analysis
inds  = cellstrfind(fields(metric_st), metric_tbl.Properties.VariableNames,'exact');
pca_data = table2array(metric_tbl(:,inds));
% [pca_coeff,pca_score,pca_latent,pca_tsquared,pca_explained,pca_mu] = ...
%     pca(zscore(pca_data),'NumComponents',2);
% Each column of pca_coeff is a component
% Each column of pca_data is a variable
% pca_score is representation of pca_data in PCA space
% manual_pca_score = zscore(pca_data)*pca_coeff;

% Combine both group labels to find unique combinations
comb_group_id =strcat(metric_tbl.loc_radial,metric_tbl.loc_depth);

% Do PCA on averaged of replicates (one datapoint per location)
avg_metric_tbl = grpstats(metric_tbl,{'loc_depth','loc_radial'},'mean',...
    'DataVars',fields(metric_st));
inds  = cellstrfind(fields(metric_st), avg_metric_tbl.Properties.VariableNames,'within');
% Calculate pca score for all sampled calculated from PCA with replciates
avg_pca_data = table2array(avg_metric_tbl(:,inds));


% PCA Analysus
figure;
[avg_pca_coeff,avg_pca_score,avg_pca_latent,avg_pca_tsquared,...
    avg_pca_explained,avg_pca_mu] = pca(avg_pca_data,'NumComponents',2);%'VariableWeights','variance');
pca_score = zscore(pca_data)*avg_pca_coeff;
marker_annot = marker_annot_by_group(metric_tbl.loc_radial,metric_tbl.loc_depth);
plot_2d_components(pca_score, comb_group_id, marker_annot,avg_pca_explained);
% keyboard

%% PLS Analysis
% need to do O-PLS-DA in R, this is just PLS
% Y = group_vect_2_group_bin_mat(metric_tbl.loc_depth,'InOutValues',[1 -1]);
% [XL,YL,XS,YS,BETA,PCTVAR,MSE] = plsregress(pca_data,Y,size(Y,2));
% 
% pls_score = zscore(pca_data)*XL;
% plot_2d_components(pls_score, comb_group_id, marker_annot,PCTVAR(1,:));


