function [p, PairwiseSigTable] = test_diff_means_block(data_mat)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% keyboard
% friedman(
    [p,tbl,stats_tbl] = friedman(data_mat,1,'off');
   PairwiseSigTable =  pairwise_ttest(data_mat);
%     [p,tbl,stats_tbl] = kruskalwallis(data_mat,1:size(data_mat,2),'off');
%     PairwiseSigTable = multcompare(stats_tbl,'Display','off','CType','bonferroni');
    
end

