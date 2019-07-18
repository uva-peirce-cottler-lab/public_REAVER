function splicedImage = createNewBW2( handles )
	% Filter off edges of inverted BW_2 and dilate
	dilationFactor = 1 ;
	removed        = imdilate( uint8(bwmorph(~handles.derivedPic.BW_2,'remove')) .* handles.borderImage , strel('disk',dilationFactor) ) ;
	displayedChannels = double(handles.constants.selectedColors) ;
	
	base_image = handles.basePic.data ;
	RGB_background = [1,0,0] ;
    
	% Normalize color intensity
	gammaAdjustItem = findobj(handles.REAVER_Fig,'Tag','gammaAdjustItem') ;
	if isequal(gammaAdjustItem.Checked,'on')
		for i = 1:size(base_image,3)
			base_image(:,:,i) = imadjust(base_image(:,:,i)) ;
		end
	end
	
	% Determine if a new wire frame has been calculated
	if handles.derivedPic.newWire
		dilated      = uint8(imdilate( handles.derivedPic.wire , strel('disk',dilationFactor) )) ;
		dilated2     = uint8(imdilate( handles.derivedPic.wire , strel('disk',dilationFactor) )) ;
		
		handles.derivedPic.newWire = 0 ;
		
		% Dilate or "fatten" wire frame
		if handles.grayImage % Is gray
			splicedImage = repmat(0*handles.derivedPic.selectedColors,1,1,3) ;
			
			splicedImage(:,:,1) = handles.miscValues.lineEdgeColor(1)*removed .* uint8(~dilated2) + handles.miscValues.centerLineColor(1)*uint8(dilated) ;
			splicedImage(:,:,1) = splicedImage(:,:,1) + RGB_background(1)*(uint8(~splicedImage(:,:,1)).*base_image.*uint8(~dilated)) ;

			splicedImage(:,:,2) = handles.miscValues.lineEdgeColor(2)*removed .* uint8(~dilated2) + handles.miscValues.centerLineColor(2)*uint8(dilated) ;
			splicedImage(:,:,2) = splicedImage(:,:,2) + RGB_background(2)*((uint8(~splicedImage(:,:,2))).*base_image.*uint8(~dilated)) ;

			splicedImage(:,:,3) = handles.miscValues.lineEdgeColor(3)*removed .* uint8(~dilated2) + handles.miscValues.centerLineColor(3)*uint8(dilated) ;
			splicedImage(:,:,3) = splicedImage(:,:,3) + RGB_background(3)*((uint8(~splicedImage(:,:,3))).*base_image.*uint8(~dilated)) ;
			
		else % Is not gray
			splicedImage = 0*handles.derivedPic.selectedColors ;
		
			splicedImage(:,:,1) = handles.miscValues.lineEdgeColor(1)*removed .* uint8(~dilated2) + handles.miscValues.centerLineColor(1)*uint8(dilated) ;
			splicedImage(:,:,1) = splicedImage(:,:,1) + displayedChannels(1)*(uint8(~splicedImage(:,:,1)).*base_image(:,:,1).*uint8(~dilated)) ;

			splicedImage(:,:,2) = handles.miscValues.lineEdgeColor(2)*removed .* uint8(~dilated2) + handles.miscValues.centerLineColor(2)*uint8(dilated) ;
			splicedImage(:,:,2) = splicedImage(:,:,2) + displayedChannels(2)*((uint8(~splicedImage(:,:,2))).*base_image(:,:,2).*uint8(~dilated)) ;

			splicedImage(:,:,3) = handles.miscValues.lineEdgeColor(3)*removed .* uint8(~dilated2) + handles.miscValues.centerLineColor(3)*uint8(dilated) ;
			splicedImage(:,:,3) = splicedImage(:,:,3) + displayedChannels(3)*((uint8(~splicedImage(:,:,3))).*base_image(:,:,3).*uint8(~dilated)) ;
			
		end
		
	else
		dilated      = handles.derivedPic.dilated ;
		dilated2     = handles.derivedPic.dilated2 ;
		

		splicedImage = handles.image.CData ;
		
		splicedImage(:,:,2) = handles.miscValues.lineEdgeColor(2)*removed .* uint8(~dilated2) + handles.miscValues.centerLineColor(2)*uint8(dilated) ;
		splicedImage(:,:,2) = splicedImage(:,:,2) + displayedChannels(2)*((uint8(~splicedImage(:,:,2))).*base_image(:,:,2).*uint8(~dilated)) ;

	end
		

end