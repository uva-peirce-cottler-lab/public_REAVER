function p = pwise_vartest(data_mat,comb_ind)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~exist('comb_ind','var')
     for k = 1:size(n_ombs,1);
        perms_ind(k,:) = randperm(n_groups);
    end
    comb_ind = combnk(1:size(data_mat,2),2);
end

for n=1:size(comb_ind,1)
   [~,p(n,1)] = vartest2(data_mat(:,comb_ind(n,1)),data_mat(:,comb_ind(n,2)));
end
% keyboard

end

