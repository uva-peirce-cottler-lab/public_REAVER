function [ha,st] = hierarchical_plot(Y,labels)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
PAIRED_PLOT=1;




n_groups = size(Y,2);
n_points = size(Y,1);

figure;
x_coords = 1:n_groups;
for n=1:n_groups
   plot(x_coords(n)*ones(n_points,1),Y(:,n),'.','Color', [0 0 0]) 
   hold on
end

if PAIRED_PLOT
    for n=1:2:n_groups-1
        for k=1:n_points
            plot([x_coords(n) x_coords(n+1)],[Y(k,n) Y(k,n)],'-',...
                'Color',[0.2 0.2 0.2])
        end
    end
    
end

keyboard

end

