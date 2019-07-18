function CI_95_mean = bootstrap_CI_mean(yData,prc_ci,n_trials)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% https://academic.oup.com/jat/article/39/2/113/762036
% bootstrap_CI_mean(yData,95,1e3)

if ~exist('n_samples','var');
n_trials = 1e5;
end



CI_95_mean = zeros(2,size(yData,2));

% keyboard
for n=1:size(yData,2)
%     tic
    bs_means=bootstrp(n_trials,@mean,yData(:,n));
%     toc
%     CI_95_range = prctile(bs_means,[2.5 97.5]); 
    
    CI_95_mean(1:2,n) = prctile(bs_means,prc_ci)';
    
end
% keyboard

end

