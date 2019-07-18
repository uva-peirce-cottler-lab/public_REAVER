function [img, meta] = img_open(img_path)
[~, img_cell] =  evalc('bfopen(img_path)');
 
% keyboard

[~,~,ext] = fileparts(img_path);

if  strcmp(ext,'.lsm'); int_scale = 1; else int_scale = 2^8/2^12; end

% Parse Metadata from bfopen output metadata (slice, channel, z)
[nr, nc] = size(img_cell{1}{1,1});
slice_meta = {img_cell{1,1}{:,2}}';
% Slices (Ch and Z)
slice_tmp = cellfun(@(x) regexp(x,'plane.(\d*)/(\d*)','tokens','once'), slice_meta, 'UniformOutput',0);
slice_info = str2double(vertcat(slice_tmp{:}));
nslices = slice_info(1,2);
% Z slices
z_tmp = cellfun(@(x) regexp(x,'Z\??=(\d*)/(\d*);?','tokens','once'), slice_meta,'UniformOutput',0);
z_info = str2double(vertcat(z_tmp{:}));
if isempty(z_info); z_info = ones(nslices,2); end
nz = z_info(1,2);
% Channels
ch_tmp = cellfun(@(x) regexp(x,'C\??=(\d*)/(\d*)','tokens','once'), slice_meta,'UniformOutput',0);
ch_info = str2double(vertcat(ch_tmp{:}));
% If single channel, metadata will omit any mention of channel index
if isempty(ch_info); ch_info = ones(numel(ch_tmp),2); end
nch = ch_info(1,2);

% Time 
tp_tmp = cellfun(@(x) regexp(x,'T\??=(\d*)/(\d*)','tokens','once'), slice_meta,'UniformOutput',0);
tp_info = str2double(vertcat(tp_tmp{:}));
if isempty(tp_info); tp_info = ones(nslices,2); end
ntp = tp_info(1,2); 

img = zeros(nr,nc,nch,nz,ntp,'uint8');
% keyboard
% keyboard

for n = 1:nslices 
%     fprintf('Ch: %0.f, Z: %0.f\n', ch_info(n,1), z_info(n,1));
%     imshow(img_cell{1}{n,1}); pause;
%   max(max(immultiply(img_cell{1}{n,1}, int_scale)))
  img(:,:, ch_info(n,1),z_info(n,1),tp_info(n,1)) = immultiply(img_cell{1}{n,1}, int_scale);
%   imshow(img_cell{1}{n,1});pause;
end
% imshow(img(:,:,3,1,1))
% keyboard

% history Acquisition Acquire.TimeSeries.Delay = 2.5


if strcmp(ext,'.lsm')
    meta.dz = str2double(regexp(char(img_cell{2}),'VoxelSizeZ=([\d\.]*)','tokens','once'));
    meta.fov_um_x = nc * str2double(regexp(char(img_cell{2}),'VoxelSizeX=([\d\.]*)','tokens','once'));
    meta.fov_um_y = nr * str2double(regexp(char(img_cell{2}),'VoxelSizeY=([\d\.]*)','tokens','once'));
    
else 
   elem = @(x) x{1};
   meta=[];
   try
       meta.dz = str2double(elem(regexp(char(img_cell{2}),...
           'Acquire.ZStack.StepSize.DisplayString=([\d\.]*) um','tokens','once')));
       temp_x = regexp(char(img_cell{2}),...
           'Global history Acquisition Acquire.Scanner.XField.DisplayString=([\d\.]*) ([um]*)','tokens','once');
       meta.fov_um_x = str2double(temp_x{1}) * 10^((sum('m'==temp_x{2})-1) * 3);
       temp_y = regexp(char(img_cell{2}),...
           'Global history Acquisition Acquire.Scanner.YField.DisplayString=([\d\.]*) ([um]*)','tokens','once');
       meta.fov_um_y = str2double(temp_y{1}) * 10^((sum('m'==temp_y{2})-1) * 3);
       meta.dt = str2double(regexp(char(img_cell{2}),...
           'Acquire.TimeSeries.Delay=([\d\.]*)','tokens','once'));
       meta.t_unit = str2double(regexp(char(img_cell{2}),...
           'Acquire.TimeSeries.DelayUnit=([\d\.]*)','tokens','once'));
       
   catch me
   end
% keyboard
end
% 

% for n = 1:nz
%    imshow(img(:,:,:,n)); figure(gcf); pause;
% end