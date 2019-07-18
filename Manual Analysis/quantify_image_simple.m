function tbl = quantify_image_simple(calculated_image)
% first channel is the segmentation and the second channel is the skeleton,

% Area
tbl.Vessel_Area   = sum(sum(calculated_image(:,:,1)>0)) ;

% Length
tbl.Vessel_Length = sum(sum(calculated_image(:,:,2)>0)) ;

% Diameter
distanceImage  = bwdist(~(calculated_image(:,:,1)>0)) ;
tbl.Mean_Diameter  =  mean(2*distanceImage(calculated_image(:,:,2)>0)-1);

% keyboard

end