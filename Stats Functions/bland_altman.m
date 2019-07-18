function [ci_95, ax] = bland_altman(y1,y2,varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


p = inputParser;
p.addParameter('in_path', pwd, @ischar);
p.addParameter('RecurNum', 1, @isnumeric);
p.addParameter('BlackList', {'user_prefs', 'images','.hg','config\d*','deploy'}, @iscellstr);
p.addParameter('DataFormat', 'y1y2',@(x) strcmp(x,'dyuy') || strcmp(x,'y1y2'));
p.addParameter('n_samples', 1e5, @isnumeric);
p.addParameter('Y_Label', '(X-GT)',@ischar);
p.addParameter('CI_Method', 'boostrap',@(x) strcmp(x,'bootstrap') ||...
    strcmp(x, 'sem'));
p.addParameter('X_Label','(X+GT)/2',@ischar)
p.addParameter('Include_CI95', 1, @(x)(x==0 || x==1));
p.addParameter('Include_PVAL', 1, @(x)(x==0 || x==1));
p.addParameter('Include_LinearFit', 1, @(x)(x==0 || x==1));
p.addParameter('alpha', 0.05, @(x)(x==0 || x==1));
p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end

if strcmp(DataFormat,'y1y2')
   dy = y1-y2; 
   uy = (y1+y2)/2;
else
   dy=y1;
   uy=y2;
end

% Calculate 95% CI on mean, distribution free
switch CI_Method
    case 'bootstrap'
        bs_stats = bootstrp(n_samples,@(x) [mean(x) multquartiles(x, [0.025 0.975])],dy);
        ci_95 = mean(bs_stats(:,2:3),1);
        
        ind = 1:n_samples;
        sort_means = sort(bs_stats(:,1));
        bs_gt_samp = ind(mean(dy) > sort_means);
        prctile_mean = bs_gt_samp(end)./n_samples;
        if prctile_mean <= 0.50
            p = prctile_mean;
            h = p < 0.05;
        else
            p = 1-prctile_mean;
            h = p < 0.05;
        end
        
    case 'sem'
%         95 CI assuming normality
        ci_95 = [mean(dy)-1.96*std(dy) mean(dy)+1.96*std(dy)];
        [h,p] = ttest(dy);
end

ax=gca;

% keyboard

% Axis bounds
xlimits = [min(uy)-(max(uy)-min(uy))*.1...
    max(uy)+(max(uy)-min(uy))*.1];


% Plot fitted line with 95 CI
mdl = fitlm(uy,dy,'linear');
x_fit = linspace(xlimits(1),xlimits(2), 100)';
[ypred,yci] = predict(mdl,x_fit);


%Plot all lines
if Include_LinearFit
    % Fitted line and 95 CI of line first so other lines on top
    plot(x_fit,ypred,'-','Color',[.7 .7 .7])
    hold on
    plot(x_fit,yci(:,1),'--','Color',[.7 .7 .7])
    plot(x_fit,yci(:,2),'--','Color',[.7 .7 .7])
end

% Plot xy points
plot(uy, dy, 'bo','markersize',2);
% CI_95_mean = bootstrap_CI_mean(dy,95);
plot([xlimits' xlimits'], repmat([ci_95(1) ...
    ci_95(2)],[2 1]),'r');
plot(xlimits, [mean(dy) mean(dy)],'k'); 
hold off


xlabel(X_Label,'FontWeight','bold')
ylabel(Y_Label,'FontWeight','bold')


% Reformat x axis
oom = @(x) floor(log(abs(x))./log(10));
xom = max(arrayfun(@(x) oom(x), uy));
ax.XAxis.Exponent = xom;
xtickformat('%2.1f')

% Reformat x axis
yom = max(arrayfun(@(x) oom(x), dy));
ax.YAxis.Exponent = yom;
ytickformat('%2.1f')

% keyboard
% Set axuis limits
% keyboard
miny = min([min(dy) ci_95(1)]);
maxy = max([max(dy) ci_95(2)]);

ylimits = [miny-(maxy-miny)*.1...
    maxy+(maxy-miny)*.1];
axis([xlimits ylimits]);

%% Display bland altman P value on top of plot
% Test of mean being zero assuming normality
% [h, p] = ttest(dy);
% Boostrap Test of mean being zero distribution free

if h; wt = 'normal'; else wt='bold'; end


top_str = '';
if Include_PVAL; top_str = [top_str sprintf('p = %.2e  ',p)]; end
if Include_CI95; top_str = [top_str sprintf('[%.3f %.3f]',ci_95(1),ci_95(2))]; end

ht = text(1,1,top_str,'Units','normalized','Fontsize',7,...
    'FontWeight','normal','HorizontalAlignment','center');
pos = get(ht, 'Extent');
set(ht,'position', get(ht, 'position') + [pos(3:4).*[-0.5 0.5] 0])

% Set ruler fontsize
% ax = ancestor(h, 'axes');
ax = gca;
yrule = ax.YAxis;
yrule.FontSize = 7.5;
xrule = ax.XAxis;
xrule.FontSize = 7.5;


% keyboard
end

