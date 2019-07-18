function handles = editSizeSliderChange(handles,sliderChange)
	%---- Start: Quantize Slider Value and Update Value Text
		currentSliderValue = get(handles.editSizeSlider,'Value') ;
		newSliderValue	   = round( currentSliderValue ) + sliderChange ;
		if newSliderValue < 0
			newSliderValue = 0 ;
		elseif newSliderValue > 15
			newSliderValue = 15 ;
		end

		set(handles.editSizeSlider,'Value',newSliderValue)
		set(handles.editSizeSliderValue,'String',num2str( newSliderValue + 1 ))
	%---- End: Quantize Slider Value and Update Value Text

	%---- Start: Adjust Pixel Editor Neighbors Size
		handles.editVariables.pixelEditNeighbors = newSliderValue ;
	%---- End: Adjust Pixel Editor Neighbors Size
	
		% Halve the size for the purpose of making the cursor visual work
		newSliderValue = floor(newSliderValue/2) ;


	%---- Start: Change Cursor Data if Applicable
		if isequal( handles.REAVER_Fig.Pointer , 'custom' )
			handles.REAVER_Fig.PointerShapeCData = nan(16) ;
			handles.REAVER_Fig.PointerShapeCData( (8-newSliderValue):(8+newSliderValue) , ...
				(8-newSliderValue):(8+newSliderValue) ) = 2 ;
		end
	%---- End: Change Cursor Data if Applicable
end