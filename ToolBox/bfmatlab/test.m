


st = imageinfo('60x_m1L_8_top.ids')

txt = fileread('60x_m1L_8_top.ics');

elem = @(x) x{1};
dim_cell = regexp(txt,'layout\ssizes\s*(\d*)\s*(\d*)\s*(\d*)\s*(\d*)','once','tokens');
dims = cellfun(@str2num, dim_cell,'UniformOutput', 0);
[z, ch, r, c] = deal(dims{:});

img = zeros(r,c,ch,z,'uint8');
for n = 1:z
    img(:,:,:,n) = imread('60x_m1L_8_top.ids',n);
    
end