function pretty_text = variable_2_pretty_label(txt);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Break up string by '_'
split_text = regexp(txt,'_','split');

% Capitalize each letter of clause except for um and mmpmm2
for n=1:numel(split_text)
   if n<numel(split_text); sp = ' '; else sp=''; end
   if ~ismember(split_text{n}, {'um','mmpmm2'})
       pretty_split_txt{n} = [upper(split_text{n}(1)) split_text{n}(2:end) sp];
   else
       pretty_split_txt{n} = ['(' split_text{n} ')' sp];
   end
end

% Put prenthesis around units
pretty_text = [pretty_split_txt{:}];
end

