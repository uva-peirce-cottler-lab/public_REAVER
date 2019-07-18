function [group_id] = cellstr_2_group_id(cstr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

unq_groups = unique(cstr);
group_id = zeros(size(cstr));
for n=1 : numel(unq_groups)
    ix = cellfun(@(x) strcmp(x, unq_groups{n}),cstr);
    group_id(ix)=n; 
end

end

