function img_write(img,img_path, umppix)

% keyboard
if ~isempty(dir(img_path)); delete(img_path); end

if numel(size(img))==2
    imwrite(img, img_path);
elseif numel(size(img))==3
    if size(img,3)==3
        imwrite(img, img_path);
    else
        for z=1:size(img,3)
            imwrite(img(:,:,z), img_path,'WriteMode','append');
        end
    end
    
else
    for z=1:size(img,4)
        imwrite(img(:,:,:,z), img_path,'WriteMode','append');
    end
    
end

[~,~,ext]=fileparts(img_path);

if ~isempty(regexp(ext,'tif','once'));
t = Tiff(img_path,'r+');
t.setTag('XResolution',1./umppix)
t.setTag('YResolution',1./umppix)
t.setTag('ResolutionUnit',1)
t.rewriteDirectory();
close(t)
end





