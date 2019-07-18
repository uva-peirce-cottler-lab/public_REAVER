function tbl = quantify_image_simple(calculated_image, xml_obj)
% first channel is the segmentation and the second channel is the skeleton,

% Area
tbl.vessel_area   = sum(sum(calculated_image(:,:,1)))/255 ;

% Length
tbl.vessel_length = sum(sum(calculated_image(:,:,2)))/255 ;

% Diameter
distanceImage  = bwdist(~calculated_image(:,:,1)/255) ;
distanceValues = distanceImage .* double(calculated_image(:,:,2)/255) * 2 ;
tbl.mean_diameter  = mean( distanceValues(distanceValues>0));

% Count branchpoints
tbl.branchpoints = 1;

end