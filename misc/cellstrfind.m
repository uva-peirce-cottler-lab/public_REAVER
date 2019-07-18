function match_inds  = cellstrfind(in_cell, ref_cell,match_type);
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ref_cell_ind = 1:numel(ref_cell);

match_inds = zeros(size(in_cell));
for n=1:numel(in_cell)
    switch match_type
        case 'exact'
            [ia, match_inds(n)]= ismember(in_cell{n}, ref_cell);
        case 'within'
            bv = cellfun(@(x) ~isempty(regexp(x,in_cell{n},'once')),ref_cell');
            matches = ref_cell_ind(bv);
            match_inds(n) = matches(1);
%             keyboard
    end
end

end

