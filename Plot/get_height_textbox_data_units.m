function [req_vert_pad_datay, data_unit_p_pix] = get_height_textbox_data_units(str,FontSize);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

htext = text(1,1,str,'FontSize',FontSize,'units','pixels');
text_pix_position = get(htext,'Extent');
text_pix_height = text_pix_position(4);

delete(htext);
% Get pixel height of axis
ax_pix_position = getpixelposition(gca);
ax_pix_height = ax_pix_position(4);
% Get fraction of text height relative to height of axis in pixels
fract_text_height_p_line = text_pix_height./ax_pix_height;
% Get Height of text box in data units
height_text_p_line_data_units = diff(ylim).*fract_text_height_p_line;

% Required verticle padding in data units for each line based on fontsize
req_vert_pad_datay = height_text_p_line_data_units; 

data_unit_p_pix = height_text_p_line_data_units/text_pix_height;


