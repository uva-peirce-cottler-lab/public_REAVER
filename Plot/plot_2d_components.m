function plot_2d_components(comp_score, group_id, marker_annot,var_explained)

unq_group_vals = unique(group_id);


% marker
% Plotting
% marker_type = {'o','x','*'};
% marker_color = {'b','r'};

ind = 1:numel(group_id);
elem = @(x) x(1);

hold on
for n=1:numel(unq_group_vals)

    ix = cellfun(@(x) strcmp(unq_group_vals{n},x),group_id);
    plot(comp_score(ix,1),comp_score(ix,2),marker_annot{elem(ind(ix))});

end
xlabel(sprintf('PC 1 (%.2f%% Variance)',var_explained(1)))
ylabel(sprintf('PC 2 (%.2f%% Variance)',var_explained(2)))

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );
set(gcf,'position',[100 100 250 250]); axis square



end

