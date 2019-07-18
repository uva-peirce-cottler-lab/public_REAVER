function xpos = plot_x_scatter(Y, width)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dev_y = abs(Y - mean(Y));
rdev_y =1 - dev_y./max(dev_y);

xpos = 2*(rand(size(Y))-.5).*rdev_y*width*.66;

% keyboard
end

