function group_bin_mat = group_vect_2_group_bin_mat(group_ids,varargin)
%UNTITLED Summary of this function goes here
% Input
%  group_ids (nx1 double): input vector assigning each observation
%  (element) of vector to a group
%  InOutValues (1x2 double):
% Output
%  group_bin_mat: nxp matrix of binary values defining whether each observation
%  (n,rows) are part of each group (p,columns). So if there are 6
%  unique groups in the group vector, this matrix will have 6 colloumns
%  with values defined by IntOutValues

p = inputParser;
p.addParameter('InOutValues', [1 0], @(x) numel(x)==2 && isnumeric(x));
p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end

unq_group_vals = unique(group_ids);
% keyboard
% Convert group_ids to index of unq_group_ids
if iscell(group_ids)
    for n=1:numel(unq_group_vals); group_id_st.(unq_group_vals{n}) = n; end
    group_ids = cellfun(@(x) group_id_st.(x),group_ids);
    unq_group_vals = 1:numel(unq_group_vals);
end

group_bin_mat = zeros(numel(group_ids),numel(unq_group_vals));

for c = 1:numel(unq_group_vals)
    
    bv = unq_group_vals(c)==group_ids;
   group_bin_mat(bv,c) =  InOutValues(1);
   group_bin_mat(~bv,c) =  InOutValues(2);
end

end

