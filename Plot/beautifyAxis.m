function beautifyAxis(h_fig,st)
% h_fig = figure(h_axes);


if ~exist('st','var')
   st = beautifyAxis_Struct(); 
end

% keyboard
h_axes = findall(h_fig, 'type', 'axes');

% Set axes properties
f = fields(st.h_axes);
for n=1:numel(f)
   set(h_axes, f{n}, st.h_axes.(f{n}));
end

% % h_fig = figure(h_fig);

% keyboard
% Set Figure properties
% f = fields(st.h_fig);
% for n=1:numel(f)
% %    set(gcf, f{n}, st.h_fig.(f{n}));
% end


h_legend = get(h_axes,'Legend');
h_xlabel = get(h_axes,'XLabel');
h_ylabel = get(h_axes, 'YLabel');
% h_yruler = h_axes.YRuler;
 
set(h_xlabel, 'FontSize',st.h_xlabel.FontSize);
set(h_ylabel, 'FontSize',st.h_ylabel.FontSize);
if ~isempty(h_legend);
set(h_legend,'FontSize',h_legend.FontSize);
end
% set(h_yruler,'Linewidth',h_yruler.Linewidth)


end