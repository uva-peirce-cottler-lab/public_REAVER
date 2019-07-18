function [outputArg1,outputArg2] = reaver_representative_images()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% Find box box
dataset_path = get_dataset_path();

base_path = [dataset_path '/representative_images'];
out_path = [base_path '/out'];
mkdir(out_path);
delete([out_path '/*.*']);

img_items = subdir([base_path '/*.tif']);

% Find all images in folder list
for n=1:numel(img_items)
%     keyboard
    
    % Load all images, dilate 3rd and 4th channel, export as tifs
    info = imfinfo(img_items(n).name);
    nz = length(info);
    img = zeros(info(1).Width,info(2).Height,length(info),'uint8');
    
    for z = 1:length(info)
        img(:,:,z) = imread(img_items(n).name, z, 'Info', info);
    end 
    % Crop Img
    img = img(256:256+512,256:256+512,:);
    
    img_out = img;
    
    img_out(:,:,3) = imdilate(img(:,:,3),strel('disk',2));
    img_out(:,:,4) = imdilate(img(:,:,4),strel('disk',5));
    
    img_out_no_overlap = img_out;
    
    mask = img_out(:,:,3) | img_out(:,:,4);
    
    img_out(:,:,1) = img_out(:,:,1).* uint8(~mask);
    img_out(:,:,2) = img_out(:,:,2).* uint8(~mask);
    img_out(:,:,3) = img_out(:,:,3).* uint8(~img_out(:,:,4));
     
   suff =  regexp(img_items(n).name,'representative_images\\(.*)','once','tokens');
   
   
   
   
   out_img_path = [out_path '/' regexprep(suff{1},'\\','_')];
   if ~isempty(dir(out_img_path)); delete(out_img_path); end
   % Write image into out folder
   out_name = [out_path '/' regexprep(suff{1},'\\','_')];
   img_write(img_out,out_name, 1)
   img_write(img_out_no_overlap,regexprep(out_name,'.tif','_no_ov.tif'), 1)
%    for z = 1:size(img,3)
%        imwrite(img,out_img_path,'WriteMode','append');
%    end
end






end

