function out_tbl = normalize_matched_table(tbl,norm_varname, norm_val,...
    match_varname,data_varnames,norm_fun)
%normalize_table: normalize values in a table with matched values
%   tbl [table]: input stats table to be normalized
%   norm_varname [string]: data will be normalized based on this variable (cloumn)
%   norm_val [double | string]: the value from norm_varname will be used to normalize other 
% values of norm_varname
%   match_varname [string]: specific samples will be matched based on this variable
%   data_varnames [cellstring]: variable names of data variables to be normalized
%   norm_method [string, divide, subtract]: mathmetical operation done on 
% each datapoint and its corresponding normalization value

DEBUG = 0;

norm_idx = strcmp(tbl.(norm_varname), norm_val);

% Table entries to be normalized
input_tbl=tbl(~norm_idx,:);
% Entries used to normalize input data
ref_tbl = tbl(norm_idx,:);
% Normalized output table, zero out data prior to nromalization
out_tbl = input_tbl;
for v = 1:numel(data_varnames)
    out_tbl.(data_varnames{v})(:)=0;
    out_tbl.(['Ref_Val_' data_varnames{v}])(:)=ones(size(out_tbl,1),1);
    
end

ref_ind = 1:size(ref_tbl,1);

% For each entry to be normalized, find matching enty in normalization
% table, and then apply normalization operation.
for r = 1:size(input_tbl,1)
    % Find matching entry in ref_tbl
    match_inds = ref_ind(strcmp(input_tbl.(match_varname){r}, ref_tbl.(match_varname)));
    
    
    %For each data variable, divide value in input_Tbl
    for v = 1:numel(data_varnames)
       
       input_value = input_tbl.(data_varnames{v})(r);
       ref_value = ref_tbl.(data_varnames{v})(match_inds(1));
       
       % calculate mean of G
       out_tbl.(data_varnames{v})(r) =  norm_fun(input_value,ref_value);
       out_tbl.(['Ref_Val_' data_varnames{v}])(r)= ref_value;
       
       if DEBUG
       fprintf('%i,\t%.2f,\t%.2f,\tv:%.2f\n', r, input_value,...
           ref_value,out_tbl.(data_varnames{v})(r));
%        keyboard
       end
    end

end
% keyboard
