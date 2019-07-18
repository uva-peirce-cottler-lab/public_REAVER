function add_annotations_above_data(ha,annot_labels,xpos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lines_of_text = size(annot_labels,1);

Interpreter_opts = {'Tex','Latex'};
% keyboard
% keyboard
axis(ha);

% Add test textbox to get its pixel size (needed for vertical spacing
htext = text(1,1,'Test','FontSize',8,'units','pixels');
text_pix_position = get(htext,'Extent');
text_pix_height = text_pix_position(4);
delete(htext);
% Get pixel height of axis
ax_pix_position = getpixelposition(gca);
ax_pix_height = ax_pix_position(4);
% Get fraction of text height relative to height of axis in pixels
fract_text_height_p_line = text_pix_height./ax_pix_height;
% Get Height of text box in data units
height_text_p_line_datau = diff(ylim).*fract_text_height_p_line;




yr = ylim;
xr = xlim;
hold on
% rectangle('Position',[xr(1)  yr(2) ...
%     diff(xr) height_text_p_line_datau],'FaceColor','white')
% keyboard
plot(xr,[yr(2) yr(2)],'k')

for k = 1:numel(xpos)
    if isempty(annot_labels{k});continue; end
    isLatex = (annot_labels{k}(1)=='$') && (annot_labels{k}(end)=='$');
    %         if isLatex; keyboard; end
    htext(k) = text(xpos(k),yr(2)+height_text_p_line_datau*.55,annot_labels{k},'FontSize',8,...
        'units','data','HorizontalAlignment','center',...
        'Interpreter',Interpreter_opts{isLatex+1});
end



% % Get pixel height of axis
% ax_pix_position = getpixelposition(gca);
% ax_pix_height = ax_pix_position(4);
% % Get fraction of text height relative to height of axis in pixels
% fract_text_height_p_line = text_pix_height./ax_pix_height;
% % Get Height of text box in data units
% height_text_p_line_datau = diff(ylim).*fract_text_height_p_line;
% 
% % Required verticle padding in data units
% req_vert_pad_datay =height_text_p_line_datau * (lines_of_text+2); 
% 
% 
% % Get min and may y position and axis range
% yr_d(1) = min(arrayfun(@(x) min(x.YData),get(gca,'children')));
% yr_d(2) = max(arrayfun(@(x) max(x.YData),get(gca,'children')));
% yr_a = ylim;
% 
% % new_ymax =max([req_vert_pad_datay+yr_d(2) yr_a(2)]);
% new_ymax =req_vert_pad_datay+yr_d(2);
% 
% % keyboard
% % Set new axis with space for stats annotations above data
% axis([xlim yr_a(1) new_ymax])
% y_test_ht = yr_d(2)+ (1:lines_of_text)*height_text_p_line_datau*1.5;
% 
% 
% ret_base_ht = y_test_ht(1)-height_text_p_line_datau;
% % Plot line seperating data from chart stats annotations
% hold on
% % keyboard
% xr = xlim;
% rectangle('Position',[xr(1)  ret_base_ht...
%     diff(xlim) new_ymax-ret_base_ht],'FaceColor','white')
% % plot(xlim,[y_test_ht(1) y_test_ht(1)]-height_text_p_line_datau/2,...
% %     'Linestyle','-','Color',[0 0 0],'LineWidth',0.5)
% hold off
% 
% 
% Interpreter_opts = {'Tex','Latex'};
% for n=1:lines_of_text
%     for k = 1:numel(xpos)
%         if isempty(annot_labels{n,k});continue; end
%         isLatex = (annot_labels{n,k}(1)=='$') && (annot_labels{n,k}(end)=='$');
% %         if isLatex; keyboard; end
%         htext(n,k) = text(xpos(k),y_test_ht(n),annot_labels{n,k},'FontSize',8,...
%             'units','data','HorizontalAlignment','center',...
%             'Interpreter',Interpreter_opts{isLatex+1});
%     end
% end



end

