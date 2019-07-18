function marker_annot = marker_annot_by_group(color_group,type_group, varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% ARGUMENT PARSING
p = inputParser;
p.addParameter('marker_type_ref',{'o','+','*'}, @(x) iscell(x));
p.addParameter('marker_color_ref',{'r','b','k'}, @(x) iscell(x));
p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end


% keyboard
% marker_annot_char = cell(size(color_group,1), 2);

marker_annot = cell(size(color_group,1), 1);

unq_color_group = unique(color_group);
unq_type_group = unique(type_group);
% keyboard
color_ind = 1:numel(unq_color_group);
type_ind = 1:numel(unq_type_group);


for n=1:numel(unq_color_group); color_st.(unq_color_group{n}) = marker_color_ref{n}; end
for n=1:numel(unq_type_group); type_st.(unq_type_group{n}) = marker_type_ref{n}; end

for n=1:size(color_group,1)
    color_group_str = color_st.(color_group{n}); 
    type_group_str = type_st.(type_group{n});
    
    
    marker_annot{n}  = strcat(color_group_str,type_group_str);
    
end


% keyboard
end

