function [pairwise_sig, p_vals] = pairwise_ttest(data_mat)





comb_ind = flipud(combnk(1:size(data_mat,2),2));

alpha = 0.05;
p_actual = pwise_vartest(data_mat,comb_ind);
n_combs = size(comb_ind,1);
n_groups = size(data_mat,2);
n_samples = size(data_mat,1);

% tic
for n=1:n_combs
    
    [h,p(n,1),stats] = ttest(data_mat(:,comb_ind(n,1)),...
        data_mat(:,comb_ind(n,2)));
end

p_vals = p*n_combs;

pairwise_sig = [comb_ind zeros(n_combs,3) p_vals];