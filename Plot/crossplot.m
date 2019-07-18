function handles = crossplot(x, varargin)
% errorplot(x) creates a cross plot(Mean+Error) of the data in x. If x is a
% vector, errorplot plots one group. If x is a matrix, errorplot plots one 
% cross for each column of x.
% isOption=@(x) ischar(x) && ~logical(sum(strcmp(x, {'RESET_PATH'})));
p = inputParser;
p.addOptional('group_labels', [], @(x) iscell(x));
p.addParameter('y_label', [], @ischar);
p.addParameter('ubar_width', 0.33, @isnumeric);
p.addParameter('bar_width_rat', 0.85, @isnumeric);
p.addParameter('bar_width', 0.33, @isnumeric);
p.addParameter('box_width_rat', 0.85, @isnumeric);
% p.addParameter('error_fcn', @std, @isfunction);
p.addParameter('TargetValue', [], @isnumeric);
p.addParameter('BootStrapCISamples', 500, @isnumeric);
p.addParameter('PLOT_DATAPOINTS', 0, @(x) x==0 || x==1);
p.addParameter('DatapointMarkerSize',8,@isnumeric)
p.addParameter('PLOT_CI_MEAN', 0, @(x) x==0 || x==1);

p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end


% Bar width parameters
errbar_width = ubar_width*bar_width_rat;
box_width = ubar_width*box_width_rat;

[n_obs, n_groups] = size(x);

mean_x = mean(x,1);
std_x=std(x,[],1);
x_std_range = [mean_x-std_x/2; mean_x+std_x/2];

% keyboard
if PLOT_CI_MEAN
    for n=1:n_groups
        %     qtile_range(1:2,n) = bootstrap_quantile(x(:,n),[25 75],1e3);
        CI95_mean_range(1:2,n) = bootstrap_CI_mean(x(:,n),95,BootStrapCISamples);
    end
end



x_pos = 1:n_groups;

hf = gcf;

%Plot Target Value if it exists
if ~isempty(TargetValue);
    plot([0.5 n_groups+0.5],[TargetValue TargetValue],'k--')
end

hold on
for n = 1:n_groups
    % Plot scatter
    
    % Plot rectangle for 95% CI of mean
    if PLOT_CI_MEAN
    rectangle('Position',[x_pos(n)-box_width/2 CI95_mean_range(1,n) ...
        box_width CI95_mean_range(2,n)-CI95_mean_range(1,n)],...
        'Curvature',0.2,'EdgeColor',[.75 .75 .75],'FaceColor',[.6 .6 .6]);
    end
    
    %     keyboard
    if PLOT_DATAPOINTS
        x_offsets = x_pos(n) + plot_x_scatter(x(:,n),ubar_width);
        handles.hscatter{n} = plot(x_offsets,x(:,n),'.',...
            'Markersize',DatapointMarkerSize,'Color',[0 0 1]);
    end
    
    %Plot mean bar
     handles.ubars(n) = plot([x_pos(n)-ubar_width x_pos(n)+ubar_width],...
         [mean_x(n) mean_x(n)],'k-','Linewidth',2);
    
    %Plot vertical bar
     handles.vertbars(n) = plot([x_pos(n) x_pos(n)],...
         [x_std_range(1,n) x_std_range(2,n)],'k-','Linewidth',1);
     
    % Plot Err Bars
     handles.lowerrbars(n) = plot([x_pos(n)-errbar_width x_pos(n)+errbar_width],...
         [x_std_range(1,n) x_std_range(1,n)],'k-','Linewidth',1);
      handles.higherrbars(n) = plot([x_pos(n)-errbar_width x_pos(n)+errbar_width],...
         [x_std_range(2,n) x_std_range(2,n)],'k-','Linewidth',1);
end
yr = ylim; xr = xlim;
yd = diff(ylim);
axis([0.5 n_groups+.5 yr(1) yr(2)+.2*yd])

st = beautifyAxis_Struct();
beautifyAxis(gcf,beautifyAxis_Struct());
ylabel(y_label)
set(gca, 'XTick', 1:n_groups);
set(gca,'xminortick','off');
set(gca,'xticklabel',group_labels)
hold off

% keyboard




end

