function errorplot(y,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% ARGUMENT PARSING
p = inputParser;
p.addParameter('BarColors', [], @iscell);
p.addParameter('PointColors', [], @iscell);
p.addParameter('ABSOLUTE_WIDTH', 1, @iscell);
p.addParameter('target_value', [], @isnumeric);
p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end

n_groups = size(y,2);
n_obs = size(y,1);

if isempty(BarColors); BarColors = repmat({[0 0 0]},[1 n_groups]); end
if isempty(PointColors); PointColors = repmat({[.1 .1 .1]},[1 n_groups]); end

figure; 
hold on

for n=1:n_groups
    plot(n+(rand([n_obs 1])-0.5)*ABSOLUTE_WIDTH/6,y(:,n),'.','color',PointColors{n});
    add_errorbar(gcf,n,y(:,n),.35,'ABSOLUTE_WIDTH',ABSOLUTE_WIDTH,...
        'Color', BarColors{n});
end

if ~isempty(target_value); plot(xlim, [target_value target_value],'k-'); end

axis([0.5 n_groups+0.5 ylim]);
st = beautifyAxis_Struct();
st.h_axes.XMinorTick = 'off';
st.h_axes.YGrid='off';
beautifyAxis(gca,st)
set(gcf,'position',[100 100 200 200])

end

