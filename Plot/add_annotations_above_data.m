function add_annotations_above_data(ha,annot_labels,xpos,FontSizes,pix_shift)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lines_of_text = size(annot_labels,1);
if ~exist('FontSizes','var'); FontSizes = 8*ones(1,lines_of_text); end

% If anonnoations already exist delete them
handles = getappdata(gca,'annotation_handle');
if ~isempty(handles); 
    arrayfun(@(x) delete(x), handles);
end

% keyboard

axis(gca);
num_rows = size(annot_labels,1);

% Add test textbox to get its pixel size (needed for vertical spacing
for n=1:max(num_rows,1)
 init_txt_ht_data_units(n)= get_height_textbox_data_units(strcat('8'),...
     FontSizes(n));
end

% Get min and may y position and axis range
yrange_data(1) = min(arrayfun(@(x) min(x.YData),get(gca,'children')));
yrange_data(2) = max(arrayfun(@(x) max(x.YData),get(gca,'children')));
yr_a = ylim;

% New  max y value is max y datapoint plus height for all annotation lines
% plus 10% data axis range
new_ymax =sum(init_txt_ht_data_units)+yrange_data(2) + 0.1*diff(yrange_data);

% Set new axis with space for stats annotations above data
axis([xlim yr_a(1) new_ymax])

for n=1:max([num_rows 1])
 [final_txt_ht_data_units(n), data_unit_p_pix] = ...
     get_height_textbox_data_units(strcat('8'),...
     FontSizes(n));
end

y_text_hts = yrange_data(2)+0.1*diff(yrange_data)...
    +cumsum([0 final_txt_ht_data_units(1:end-1)]);


ret_base_ht = yrange_data(2) + 0.05*diff(yrange_data);

% Plot line seperating data from chart stats annotations
hold on
% keyboard
xr = xlim;
handles(1) = rectangle('Position',[xr(1)  ret_base_ht...
    diff(xr) (new_ymax-ret_base_ht)],'FaceColor','white','Linewidth', 1);
hold off


Interpreter_opts = {'Tex','Latex'};
jj=2;
for n=1:lines_of_text
    for k = 1:numel(xpos)
        if isempty(annot_labels{n,k});continue; end
        isLatex = (annot_labels{n,k}(1)=='$') && (annot_labels{n,k}(end)=='$');
%         if isLatex; keyboard; end
        handles(jj) = text(xpos(k),y_text_hts(n)+pix_shift(n)*data_unit_p_pix,...
            annot_labels{n,k},'FontSize',FontSizes(n),...
            'units','data','HorizontalAlignment','center',...
            'Interpreter',Interpreter_opts{isLatex+1});
        jj=jj+1;
    end
end

setappdata(gca,'annotation_handle',handles);
% keyboard
end

