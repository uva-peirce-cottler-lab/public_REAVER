function bs_qtile = bootstrap_quantile(yData,qtile,n_trials)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% https://academic.oup.com/jat/article/39/2/113/762036
% bootstrap_CI_mean(yData,95,1e3)

if ~exist('n_samples','var');
n_trials = 1e5;
end



bs_qtile = zeros(2,size(yData,2));

% keyboard
for n=1:size(yData,2)
    vals = bootstrp(n_trials,@(x) prctile(x,qtile),yData(:,n));
    bs_qtile(1:2,n) = mean(vals,1);
end

end

