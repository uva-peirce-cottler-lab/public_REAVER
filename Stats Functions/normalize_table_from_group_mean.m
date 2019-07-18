function dev_from_grp_mean_tbl = normalize_table_from_group_mean(tbl,...
    group_varname,data_varnames);

% keyboard
dev_from_grp_mean_tbl = tbl;

for n=1:numel(data_varnames)
    dev_from_grp_mean_tbl.(data_varnames{n})(:)=0; %= zeros(size(tbl,1),1);
end

for n=1:size(tbl,1);
    
    % Find index of all rows belonging to same group
    ix =  cellfun(@(x) ~isempty(regexp(tbl.(group_varname){n},x,'once')),...
        tbl.(group_varname));
    
    for v = 1:numel(data_varnames)
        dev_from_grp_mean_tbl.(data_varnames{v})(n) = ...
            tbl.(data_varnames{v})(n) - mean(tbl.(data_varnames{v})(ix));
    end
    
end

end

