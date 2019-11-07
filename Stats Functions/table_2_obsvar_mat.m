function [data_mat,unq_group_ids] = table_2_obsvar_mat(tbl, data_varname, group_varnames)
% Convert a variuable from a table into a matrix with obs as rows and study
% groups columns
% ** Assumes eaach group has same number of observations

if ischar(group_varnames); group_varnames={group_varnames}; end
% keyboard

% If multiple variables form groups (across row) then combine them into one
% metavariable and use that gor group assignment
group_ids = cell(size(tbl,1),1);
% keyboard
for n=1:numel(group_varnames)
    group_ids = strcat(group_ids, tbl.(group_varnames{n}));
end


% Get data colum from table
data_vect = tbl.(data_varname);

unq_group_ids = unique(group_ids);


n_obs = numel(data_vect(cellfun(@(x) strcmp(x,unq_group_ids{1}), group_ids)));

data_mat = zeros(n_obs, numel(unq_group_ids));

for c = 1:numel(unq_group_ids)
    data_mat(:,c) = data_vect(cellfun(@(x) ...
        strcmp(x,unq_group_ids{c}), group_ids));
end




end

