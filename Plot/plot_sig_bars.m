function [ output_args ] = plot_sig_bars(cohort_index, signif_table,hf)
%PLOT_SIG_BARS Summary of this function goes here
%   cohort_index: [table columns]: % Index tP group xcoord
%   signif_table: [signif_table]: cohort_index cohort_index num_stars p_val
% keyboard
% get all data points from graph, find max data point
% keyboard
children = get(gca,'Children');
min_ys = NaN(1,numel(children),'double');
max_ys = NaN(1,numel(children),'double');
for n=1:numel(children);
  child = get(children(n));

  if isfield(child, 'XData')
    min_ys(n) = min(get(children(n), 'YData'));
    max_ys(n) = max(get(children(n), 'YData'));
  end

end

% bv = all_one_x_bv | more_one_pt; 
% data_by_group = getappdata(hf,'data_by_group');

% Get min and may y values
max_y = max( max_ys);
min_y = min(min_ys);
axis([xlim min_y-(max_y-min_y)/10 max_y+(max_y-min_y)/5]);


% Print text to get height
 ht=text(1,1,'*','HorizontalAlignment','center','FontSize',10,'Fontweight','bold');
ext = get(ht,'extent');
lvl_height = ext(4)*2;
delete(ht);

%increase hiehgt of graph split into 4 levels
nlvls = max([sum(signif_table(:,3)>0) 1]);  %size(signif_table,1);
% lvl_height = (max_y-min_y)/2/(nlvls+1);
% keyboard
% signif_table

% if any(signif_table(:,3)); keyboard; end

% Plot sig bar between each sig relationship
hold on
for n = 1:size(signif_table,1)
    if (signif_table(n,3)>0)

       y = max_y+lvl_height*n;
       pt_xx =  [cohort_index(signif_table(n,1),4)...
           cohort_index(signif_table(n,2),4)];
       pt_yy =  [y y];
    
       
    plot(pt_xx,pt_yy,'k','LineWidth',1);
    
    text(mean(pt_xx),pt_yy(1)+lvl_height/4,repmat('*',[1 signif_table(n,3)]),'HorizontalAlignment',...
        'center','FontSize',10,'Fontweight','bold');
   
    end
end
hold off

xa=xlim; ya=ylim;
axis([xa min_y-(max_y-min_y)/10 max_y+lvl_height*(nlvls+1)]);
% keyboard
% signif_table

end

