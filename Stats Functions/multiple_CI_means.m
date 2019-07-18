function within_range_labels = multiple_CI_means(data_mat, TargetValue,isNormal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~exist('isNormal','Var'); isNormal=1; end

n_comp = size(data_mat,2);
sig = 0.05/n_comp;

if ~isNormal
     [~,~,CI] = ttest(data_mat,0,'Alpha', sig);
%     CI = bootstrap_CI_mean(data_mat,[sig/2 1-sig/2]*100,1e5);

else
    % Create Data
    SEM = std(data_mat,[],1)/sqrt(size(data_mat,1));    % Standard Error
    ts = tinv([sig/2 1-sig/2],size(data_mat,1)-1);      % T-Score
    CI = [mean(data_mat,1) + ts(1)*SEM; mean(data_mat,1) + ts(2)*SEM]; % CI
    
end
within_range_labels = repmat({''},[1 size(data_mat,2)]);
within_range_labels(CI(1,:)<TargetValue & CI(2,:)>TargetValue)={'#'};

end

