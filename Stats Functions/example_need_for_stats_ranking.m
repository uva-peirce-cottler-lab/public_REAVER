

n_groups = 5;
n_samples = 36;
alpha_lvl = 0.05;

st = struct('mean', num2cell(zeros(1,5),1), 'std',num2cell(ones(1,5),1));
% Generate values
Y0=0;
for n=1:numel(st)
Y0(1:n_samples, n) = normrnd(st(n).mean,st(n).std,[n_samples 1]);
end



% save('justification_for_ranking.mat');
load('justification_for_ranking.mat');

Y = zeros(size(Y0));
Y(:,1) = 7+Y0(:,1)*3;
Y(:,2) = 3 + Y0(:,2)*10;
Y(:,3) = 6.5+Y0(:,3)*1.5;
Y(:,4) = 8+Y0(:,4)*1;
Y(:,5) = 9.5+Y0(:,5)*1.5;

close(gcf)
absY = abs(Y);

% Plotting
crossplot(absY,'PLOT_DATAPOINTS',1,'DatapointMarkerSize',5)
set(gcf,'position',[100 100 260 160])
[PairwiseSigTable, p_vals] = pairwise_ttest(absY );
% Make multiple comparisons labels
sig_sign_cell = cellstr(char(97:numel(1:n_groups)+97-1)')';
for n=1:n_groups
    
     % Less than wins
     diffs_ind = PairwiseSigTable((PairwiseSigTable(:,1)==n & ...
         PairwiseSigTable(:,6)<alpha_lvl),2);
     diffs2_ind = PairwiseSigTable((PairwiseSigTable(:,2)==n & ...
         PairwiseSigTable(:,6)<alpha_lvl),1);
     
    
    sig_group_id = sort([diffs_ind' diffs2_ind']);
    % Compile string of sig values
    mc_labels{n} = strjoin(sig_sign_cell(sig_group_id),'');
end
xticklabels(cellstr(char(65:65+numel(1:n_groups)-1)'));
ylabel('| Error |')
xlabel('Group')
add_annotations_above_data(gca,mc_labels,...
    1:n_groups, 8,4);

% Plotting 2
close(gcf)
[~,~,st] = boxplot_multcompare(absY, cellstr(char(65:65+numel(1:n_groups)-1)')',...
    'y_axis_text','| Error |','TargetValue',0,'group_labels',...
    cellstr(char(65:65+numel(1:n_groups)-1)')','IncludeTopRank',1,'IncludeGroupLetterLabels',0);
    close(gcf);
crossplot(absY,'PLOT_DATAPOINTS',1,'DatapointMarkerSize',5)
set(gcf,'position',[100 100 260 180])    
 add_annotations_above_data(gca,vertcat(st.mc_labels, ...
     arrayfun(@(x) sprintf('%d',x), st.ranks','UniformOutput',0), st.leader_labels),...
    1:n_groups, [8 8 8],[3 2 0]);   
 xticklabels(cellstr(char(65:65+numel(1:n_groups)-1)'));
ylabel('| Error |')
xlabel('Group')   

