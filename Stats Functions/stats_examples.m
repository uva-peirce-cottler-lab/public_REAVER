
clear all 
close all

n_groups = 3;
n_obs = 25;

% Multiple comparisons


data_path = [getappdata(0,'proj_path') '/temp/accuracy_stats_examples.mat'];

if isempty(dir(data_path))
   x=normrnd(0,1,[n_obs n_groups]);
    save(data_path);
else
    load(data_path);
end

elem = @(x) x(:);
unq_group_ids = {'a','b','c'};
group_ids = elem(repmat(unq_group_ids,[n_obs 1]));



fig_size = [180 180];

%% Absolute Value Transform
x1(:,1) = x(:,1)/4+.5; x1(:,2) = x(:,2)*1.5; x1(:,3) = x(:,3)+4;
figure; set(gcf,'position',[100 100 fig_size]);
[p,tbl,stats] = anova1(x1(:),group_ids,'off');
pwsig_table = multcompare(stats,'CType','hsd','Display','off');
[~, xpos] = boxplot_multcompare(x1, unique(group_ids), 'TargetValue',0,'y_axis_text',...
    'Error','IncludeLevelPackRanks',1,'PairwiseSigTable',pwsig_table,...
    'IncludeTargetWithinRange',0,'group_labels',unq_group_ids);
ax = gca; ax.YAxis.Exponent=0;
[~,ix] = sort(mean(x1,1)); [~,rnk] = sort(ix); lbls = regexp(num2str(rnk),'\s*','split');
add_annotations_above_axis(gca,lbls, xpos);

abs_x1 = abs(x1);
figure; set(gcf,'position',[100 100 fig_size]);
[~, xpos] = boxplot_multcompare(abs_x1, unique(group_ids), 'TargetValue',0,'y_axis_text',...
    'Abs(Error)','IncludeLevelPackRanks',1,'PairwiseSigTable',pwsig_table,...
    'IncludeTargetWithinRange',0,'group_labels',unq_group_ids);
ax = gca; ax.YAxis.Exponent=0;
[~,ix] = sort(mean(abs_x1,1)); [~,rnk] = sort(ix); lbls = regexp(num2str(rnk),'\s*','split');
add_annotations_above_axis(gca,lbls, xpos);


%% No Transform, 2-T multiple comparisons
x2(:,1) = x(:,1)+1.6; x2(:,2) = x(:,2)-1.2; x2(:,3) = x(:,3)+4;
figure; set(gcf,'position',[100 100 fig_size]);
[p,tbl,stats] = anova1(x2(:),group_ids,'off');
pwsig_table = multcompare(stats,'CType','hsd','Display','off');
boxplot_multcompare(x2, unique(group_ids), 'TargetValue',0,'y_axis_text',...
    'Error','IncludeLevelPackRanks',1,'PairwiseSigTable',pwsig_table,...
    'IncludeTargetWithinRange',0,'group_labels',unq_group_ids);
ax = gca; ax.YAxis.Exponent=0;

figure; set(gcf,'position',[100 100 fig_size]);
abs_x1 = abs(x2);
[p,tbl,stats] = anova1(abs_x1(:),group_ids,'off');
pwsig_table = multcompare(stats,'CType','hsd','Display','off');
boxplot_multcompare(abs_x1, unique(group_ids), 'TargetValue',0,'y_axis_text',...
    'Abs(Error)','IncludeLevelPackRanks',1,'PairwiseSigTable',pwsig_table,...
    'IncludeTargetWithinRange',0,'group_labels',unq_group_ids);
ax = gca; ax.YAxis.Exponent=0;



% errorplot(x1,'target_value', 0);
% Add multiple comaprisons, rank, and top performing group

ux1 = mean(x2,1);
% boxplot(x1)
