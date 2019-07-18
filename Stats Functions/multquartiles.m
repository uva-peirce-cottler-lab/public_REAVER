function x_quartiles = multquartiles(x, quartiles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

xs = sort(x);

x_quartiles = arrayfun(@(y) xs(fix(y*numel(x)-numel(x)/2)+numel(x)/2),quartiles);

end

