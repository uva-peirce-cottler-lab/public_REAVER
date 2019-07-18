function [PairwiseSigTable, xpos,out_st] = boxplot_multcompare(data_mat,group_ids, varargin)
% function boxplot_multsig(data_table, ind_var,group_var, type_var,varargin)
% data_mat[2d array]: data with rows for observations and columns for
%  variables (study groups).
% group_names [cell  string]: list of groups names
% group_var[string]: field of group variable (seperates study groups)
% varargin: see comments in aregument parsing

%% ARGUMENT PARSING
p = inputParser;
% y_axis_text: ylabel for resulting plot
p.addParameter('y_axis_text', 'Ind. Var.', @ischar);
% IncludeLegend: boolean for whether to include legend
p.addParameter('IncludeLegend', 0, @isnumeric);
% TargetValue: the ideal value for the dependent variable (data_mat)
p.addParameter('TargetValue', 1, @isnumeric);
% jitter: offset distances of points to avoid overlap
p.addParameter('jitter', [-2 -1.2 -0.4 0.4 1.2 2], @isnumeric);
% colors: set for plotting
p.addParameter('colors',[0.82 0.35 0.71;0.6 0.84 0.29;0.51 0.45 0.85;...
    0.75 0.65 0.27;0.31 0.73 0.43;0.84 0.38 0.24],@isnumeric);
% alpha_lvl: statittical level of significance
p.addParameter('alpha_lvl',0.05,@isnumeric)
% group_spacing_scalar: distance in x between sutdy groups in plot
p.addParameter('group_spacing_scalar',16,@isnumeric);
% SigFontSize: font size of text denoting statistical significance in plot
p.addParameter('SigFontSize',8,@isnumeric);

% Stats Output
% IncludeMultipleComparisons: boolean include multiple comparisons
% annotations
p.addParameter('IncludeMultipleComparisons',1,@(x) x==0||x==1);
% IncludeGroupLetterLabels: multiple comparisons uses letter (a-z) to
% denote different study groups, this includes this label below the label
% for each group
p.addParameter('IncludeGroupLetterLabels',0,@(x) x==0||x==1);
% IncludeTopRank: boolean include results of level pack ranking
p.addParameter('IncludeTopRank',0,@(x) x==0||x==1);
% IncludeTargetWithinRange: iinclude annotation whether target value is
% within 95% CI of mean
p.addParameter('IncludeTargetWithinRange',0,@(x) iscell(x) || x==0 || x==1);
% num_in_axes_label_levels: text lines used for annotations aboive plot
p.addParameter('num_in_axes_label_levels',3,@isnumeric);
% ForceScientificNotationYAxis: boolean forces scientific notation
p.addParameter('ForceScientificNotationYAxis',1,@isnumeric);
% PairwiseSigTable: specify pairwise significance table 
p.addParameter('PairwiseSigTable',[],@(x) size(x,2)==3 && isnumeric(x));
p.addParameter('StatAnalysis','Mean');
p.addParameter('RankDirection','ascend',@ischar);
% group_labels: Version of studyt group names specifically for labeling on 
% axis (multiline)
p.addParameter('group_labels',[],@(x) iscell(x));

p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end
elem = @(x) x(:);

for group_id = 1:size(data_mat,2)
    hold on
    y = data_mat(:,group_id);
    x = group_spacing_scalar*group_id + jitter(randi(numel(jitter),...
        [size(data_mat,1) 1]));
    
    % Add datapoints
    plot(x,y, 'Color', [.35 .35 1], 'Marker' , '.', ...
        'MarkerSize' , 6, 'LineStyle' , 'none') ;
    
    
    uy = mean(y);
    stdy  = std(y);
    
    % Add errorbar
    plot(group_spacing_scalar*group_id+2.5*jitter([1 end])...
        ,[uy,uy],'k','LineWidth',1)
    plot([group_spacing_scalar*group_id,group_spacing_scalar*group_id],...
        uy+[-stdy/2,stdy/2],'k','LineWidth',1)
    plot(group_spacing_scalar*group_id+2*jitter([1 end]),...
        uy+[stdy/2,stdy/2],'k','LineWidth',1)
    plot(group_spacing_scalar*group_id+2*jitter([1 end]),...
        uy-[stdy/2,stdy/2],'k','LineWidth',1)
    
    fprintf(['\t%s, %.2f'  char(177) '%.2f \n'],group_ids{group_id},...
        uy,stdy);
end
mean(data_mat,1)

% Setting Axis Properties
ax = gca;
set(ax,'Units','pixels');
% set(ax, 'DefaultTextInterpreter', 'Latex')

% Test for different distributions between groups
if isempty(PairwiseSigTable)
    
    [PairwiseSigTable,~] = pwise_1tail_test(data_mat,...
        @(x,y) ttest(x,y,'tail','left'));
    
end

if IncludeTopRank
    % Perform round robin ranking
    ranks = pairwise_toprank(PairwiseSigTable);
    
    % If target value is not equal to zero, reverse toprank
    if TargetValue ~= 0; ranks = numel(ranks)-ranks+1;
    end
    
    % Print top ranks
    % ind_1 = find(top_ranks_ind==1);
    % ind_2 = find(top_ranks_ind==2);
    % if isempty(ind_id);
    %    ind_2
    % end
    [~, srt_ranks] = sort(ranks);
    % ordered_ranks =
    udata = mean(data_mat,1);
    fprintf('\t1st -> 2nd(%i,%s): %.1f%% reduction, p=%.2e\n', ranks(srt_ranks(2)),...
        group_ids{srt_ranks(2)},...
        100*(udata(srt_ranks(2))-udata(srt_ranks(1)))./udata(srt_ranks(2)),...
        PairwiseSigTable(PairwiseSigTable(:,1)==srt_ranks(1) & ...
        PairwiseSigTable(:,2)==srt_ranks(2),3))
    fprintf('\t1st -> 3rd(%i,%s): %.1f%% reduction, p=%.2e\n', ranks(srt_ranks(3)),...
        group_ids{srt_ranks(3)},...
        100*(udata(srt_ranks(3))-udata(srt_ranks(1)))./udata(srt_ranks(3)),...
        PairwiseSigTable(PairwiseSigTable(:,1)==srt_ranks(1) & ...
        PairwiseSigTable(:,2)==srt_ranks(3),3))
    fprintf('\t1st -> 4rd(%i,%s): %.1f%% reduction, p=%.2e\n', ranks(srt_ranks(4)),...
        group_ids{srt_ranks(4)},...
        100*(udata(srt_ranks(4))-udata(srt_ranks(1)))./udata(srt_ranks(4)),...
        PairwiseSigTable(PairwiseSigTable(:,1)==srt_ranks(1) & ...
        PairwiseSigTable(:,2)==srt_ranks(4),3))
    % keyboard
end

% Determine which study groups are in top performing collection, defined as the group
% closest to the target value, and any group that is not from a different 
% statistical distribution
if IncludeTopRank
    leader_labels(1:size(data_mat,2)) = {''};
%     keyboard
    leader_labels(ranks==1) = {'\bf\nabla'};
else leader_labels=[];
end

if numel(IncludeTargetWithinRange)==1 && IncludeTargetWithinRange
    
    data_mat_range = bootstrap_CI_mean(data_mat,[2.5 97.5]);
%     data_mat_range = bootstrap_quantile(data_mat,[2.5 97.5],1e5);
    within_range_labels = repmat({''},[1 numel(group_ids)]);
    within_range_labels(data_mat_range(1,:)<TargetValue & data_mat_range(2,:)>TargetValue)={'#'};
elseif numel(IncludeTargetWithinRange)~=1
    within_range_labels = IncludeTargetWithinRange;
else
    within_range_labels=[];
end


% Display multiple comparison stats and mark if study group is part of top
% performers
if IncludeMultipleComparisons
    sig_sign_cell = cellstr(char(97:numel(group_ids)+97-1)')';
    for n=1:numel(group_ids)
        
        % Scan for all groups this group is unique to
        if TargetValue==0;
            % Less than wins
            wins_ind = PairwiseSigTable(PairwiseSigTable(:,1)==n  & PairwiseSigTable(:,3)<alpha_lvl,2)';
        else
            % Greater than wins
            wins_ind = PairwiseSigTable(PairwiseSigTable(:,2)==n  & PairwiseSigTable(:,3)<alpha_lvl,1)';
        end
        
        sig_group_id = sort(wins_ind);
        % Compile string of sig values
        mc_labels{n} = strjoin(sig_sign_cell(sig_group_id),'');
    end
else
    mc_labels={};
end
% Set x axis
xpos = group_spacing_scalar*(1:numel(group_ids));
axis([xpos(1)-diff(xpos(1:2))/2 xpos(end)+diff(xpos(1:2))/2 ylim]);

% Add annotations above plot
all_labels = vertcat(within_range_labels,mc_labels,leader_labels);
% keyboard
all_labels(sum(cellfun(@(x) ~isempty(x),all_labels),2)==0,:)=[];
fontsizes = 8*ones(1,max([size(all_labels,1) 1]));% fontsizes(end)=10;
shifts = 2*ones(1,size(all_labels,1));
shifts(2)=-1;
if numel(shifts)==3; shifts(3)=-3; end

add_annotations_above_data(gca,all_labels,...
    group_spacing_scalar*(1:numel(group_ids)), fontsizes,shifts);

out_st.mc_labels = mc_labels;
out_st.leader_labels = leader_labels;
out_st.within_range_labels = within_range_labels;
if IncludeTopRank; out_st.ranks = ranks; end
out_st.PairwiseSigTable = PairwiseSigTable;

% Plot line at target value
if ~isempty(TargetValue)
hold on;
ht = plot(xlim(),[TargetValue TargetValue],'--','Color',[0.25 0.25 0.25]);
uistack(ht, 'bottom');
hold off
end

% TODO: make code to auto produce this and not manual
ax = gca;
ax.XTick = group_spacing_scalar*(1:numel(group_ids)) ;
% keyboard
if IncludeGroupLetterLabels
    group_letter_lbls = {'\newline   a','newline   b','\newline    c','\newline      d'};
else
    group_letter_lbls = repmat({''},[1 numel(group_ids)]);
end

% Additional Figure Formatting
hold off
set(ax, 'XTickLabel', strcat(group_labels,group_letter_lbls));
set(ax, 'YGrid','on');
set(ax,'box','off');
set(ax,'GridAlpha',0.08');
ylabel(regexprep(y_axis_text,'_',' '),'FontName','Arial','FontSize',9,'Interpreter','Tex');
axis square


% Reformat x axis
if ForceScientificNotationYAxis
%     keyboard
    yom = max(arrayfun(@(x) numel(num2str(round(x))), data_mat(:)))-1;
    ax.YAxis.Exponent = yom;
    if TargetValue==0
        ytickformat('%4.1f')
    else
        ytickformat('%4.2f')
    end
%     get(gca,'Ytick')
end
% keyboard

end