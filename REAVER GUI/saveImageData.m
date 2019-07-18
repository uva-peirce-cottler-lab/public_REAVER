function saveImageData(~,~,fig)
	handles = guidata(fig) ;

%%%%% Start: Find Mean Vessel Diameter
	distanceImage	   = bwdist(~handles.derivedPic.BW_2) ;
	distanceValues	   = distanceImage .* handles.derivedPic.wire * 2 ;
	meanVesselDiameter = mean( distanceValues(distanceValues>0) ) ;
%%%%% End: Find Mean Vessel Diameter
	
%%%%% Start: Create References to Variables to Save
	saveVariables.imageDirectory		  = handles.imageDirectory ;

	saveVariables.derivedPic.branchpoints = handles.derivedPic.branchpoints.coords ;
	saveVariables.derivedPic.endpoints	  = handles.derivedPic.endpoints.coords ;
	saveVariables.derivedPic.BW_2		  = handles.derivedPic.BW_2 ;
	saveVariables.derivedPic.wire		  = sparse( handles.derivedPic.wire ) ;
	
	saveVariables.metrics.vesselLength	  = sum(full(handles.derivedPic.wire(:))) ;
	saveVariables.metrics.vesselArea	  = sum((handles.derivedPic.BW_2(:))) ;
	saveVariables.metrics.numBranchPoints = max(size(handles.derivedPic.branchpoints.coords)) ;
	saveVariables.metrics.meanVesselDiam  = meanVesselDiameter ;

	saveVariables.constants				  = handles.constants ;
	saveVariables.image_resolution		  = str2double(handles.imageResolutionValueEdit.String) ;
%%%%% End: Create References to Variables to Save

%%%%% Start: Get the time elapsed
	time_elapsed = sprintf('%05.0f', handles.time.timer.Period*handles.time.timer.TasksExecuted ) ;
%%%%% End: Get the time elapsed


%%%%% Start: Save Relevant Data		
	save( [ handles.imageDirectory.directory , handles.slash , handles.basePic.filename(1:(end-4)) , ...
			handles.slash , time_elapsed , '.mat' ] , '-struct' , 'saveVariables' ) ;
%%%%% End: Save Relevant Data

end