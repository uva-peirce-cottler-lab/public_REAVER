function mc_p_matrix = multcompare_table_2_mat(c)
% Convert multicomparison table to a diagonal matrix row or col index 
% matching that for each group and p values comparing each of the groups.
% For convention, diagonal eelements are all set to 1 (max p value since 
% groups are identical to themselves).
n_groups = numel(unique(c(:,1:2)));
mc_p_matrix = zeros(n_groups,n_groups);

for n=1:size(c,1)
    
    mc_p_matrix(c(n,1),c(n,2)) = c(n,6);
    mc_p_matrix(c(n,2),c(n,1)) = c(n,6);
end

mc_p_matrix(logical(eye(size(mc_p_matrix,1))))=1;
mc_p_matrix = mc_p_matrix + triu(mc_p_matrix,1)';
% keyboard
end

