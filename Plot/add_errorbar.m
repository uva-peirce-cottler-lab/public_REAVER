function add_errorbar(hf, xcords,ydatas, width_rat,varargin)
p = inputParser;
p.addParameter('ABSOLUTE_WIDTH', 0, @(x)(x==0 || x==1));
p.addParameter('Color', [0 0 0], @isnumeric);
p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end

% xcords
% ydatas
% width_rat

figure(hf)
hold on
% Calculate width of bar
xax=xlim;
if ABSOLUTE_WIDTH;
bar_width = width_rat;
else
bar_width = abs(diff(xax))/width_rat;
end

% keyboard
% Draw horizontal bars
for n = 1:numel(xcords)
      add_bar(xcords(n),ydatas(:,n),bar_width,Color)
end

% % Draw vertical bars
% plot(xcords, mean(ydatas,1),'-','Color',Color,'Linewidth',1)
% % hold off
end


function add_bar(xcord,ydata,bar_width,Color)

bar_y_min = mean(ydata(:,1))-std(ydata(:,1))/2;
bar_y_max = mean(ydata(:,1))+std(ydata(:,1))/2;

% Plot vertical for each bar
plot([xcord(1) xcord(1)], [bar_y_min bar_y_max],'-','Color',Color,'Linewidth',1);



% Plot top and bottom 
plot([xcord(1)-bar_width/2 xcord(1)+bar_width/2],[bar_y_max bar_y_max],'-','Color',Color,'Linewidth',1)
plot([xcord(1)-bar_width/2 xcord(1)+bar_width/2],[bar_y_min bar_y_min],'-','Color',Color,'Linewidth',1)

%Plot Mid
plot([xcord(1)-bar_width/1.2 xcord(1)+bar_width/1.2],[mean(ydata(:,1)) ...
    mean(ydata(:,1))],'-','Color',Color,'Linewidth',1.25)

end