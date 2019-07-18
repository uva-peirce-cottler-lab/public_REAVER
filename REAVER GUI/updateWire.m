function handles = updateWire(handles)
%%%%% Start: Recalculate Wire Image

	%---- Start: Reset Previous Version Marker
		handles.editVariables.previousBackupState = 0 ;
	%---- End: Reset Previous Version Marker

	%---- Start: Create Vectors Necessary for Proper Neighbor Tallying
		row = handles.basePic.ySize;
		col = handles.basePic.xSize;

		pR = [1 1:row-1];
		qR = [2:row row];
		pC = [1 1:col-1];
		qC = [2:col col];
	%---- End: Create Vectors Necessary for Proper Neighbor Tallying
	
	%---- Start: Copy New Second Binary Image and Apply Conway's Rules
		handles.derivedPic.wire = handles.derivedPic.BW_2 ;
		
		for i = 1:handles.constants.ConwaysIterations
			neighbors = handles.derivedPic.wire(:,pC) + handles.derivedPic.wire(:,qC) + ...
				handles.derivedPic.wire(pR,:) + handles.derivedPic.wire(qR,:) + ...
				handles.derivedPic.wire(pR,pC) + handles.derivedPic.wire(qR,qC) + ...
				handles.derivedPic.wire(pR,qC) + handles.derivedPic.wire(qR,pC) ;

			handles.derivedPic.wire = ( ( (ismember(neighbors,handles.constants.survive)) & handles.derivedPic.wire ) | ...
				( (ismember(neighbors,handles.constants.born)) & (~handles.derivedPic.wire) ) ) ;
		end
	%---- End: Copy New Second Binary Image and Apply Conway's Rules

	%---- Start: Apply Morphological Operations
		for i = 1:handles.constants.bridgeFillIterations
			handles.derivedPic.wire = bwmorph( handles.derivedPic.wire , 'bridge' , handles.constants.bridgeIterations ) ;
			handles.derivedPic.wire = bwmorph( handles.derivedPic.wire , 'fill' , handles.constants.fillIterations ) ;
		end
		handles.derivedPic.wire = bwmorph( handles.derivedPic.wire , 'majority' , handles.constants.majorityIterations ) ;
		
		CC = bwconncomp( ~handles.derivedPic.wire ) ;
		numPixels = cellfun(@numel,CC.PixelIdxList) ;
		where = find( numPixels < 80 ) ;
		for i = 1 : length(where)
			handles.derivedPic.wire( CC.PixelIdxList{ where(i) } ) = true ;
		end
		
		
        basic = bwmorph( padarray( handles.derivedPic.wire , [48,48] , 'symmetric' ) , 'thin' , handles.constants.thinIterations ) ;

		
        handles.derivedPic.wire = basic( 49:(end-48) , 49:(end-48) ) ;
		
	%---- End: Apply Morphological Operations

	%---- Start: Find Branch and End Points
		[By,Bx] = find(bwmorph(handles.derivedPic.wire, 'branchpoints')) ;
				
		%~~~~ Start: Remove Thin Vessels and Recalculate Branch- / End- Points
			branchpoints = [Bx,By] ;
			
			paddedBranchpoints = [ branchpoints ; branchpoints+1 ; branchpoints-1 ; ...
				branchpoints(:,1) , branchpoints(:,2)+1 ; branchpoints(:,1) , branchpoints(:,2)-1 ; ...
				branchpoints(:,1)+1 , branchpoints(:,2) ; branchpoints(:,1)-1 , branchpoints(:,2) ; ...
				branchpoints(:,1)-1 , branchpoints(:,2)+1 ; branchpoints(:,1)+1 , branchpoints(:,2)-1 ] ;
			
			paddedBranchpoints( (paddedBranchpoints(:,1)>col)|(paddedBranchpoints(:,1)<1)|...
				(paddedBranchpoints(:,2)>row)|(paddedBranchpoints(:,2)<1) , : ) = [] ;
			
			branchpointsIndex = sub2ind( [row,col] , paddedBranchpoints(:,2) , paddedBranchpoints(:,1) ) ;

			distance = -bwdist( ~handles.derivedPic.BW_2 ) ;
			distance(~handles.derivedPic.BW_2) = -inf ;
			
			vesselThickness = uint8( handles.derivedPic.wire ) ;
			wireLocations = find( vesselThickness ) ;
			
			%%% This section thresholds the distances to above and below 5
			%%% then removes connected components with average distances
			%%% below 5. Make the 5 a number CLOSER TO ZERO to increase
			%%% tolerance 
				vesselThickness( wireLocations( distance( wireLocations ) > -handles.constants.vesselThicknessThreshold ) ) = 2 ;

				vesselConnCompProps = handles.derivedPic.wire ;
				vesselConnCompProps( branchpointsIndex ) = 0 ;

				vesselConnCompProps = regionprops( vesselConnCompProps , 'Area' , 'PixelIdxList' ) ;

				trimmedWire = handles.derivedPic.wire ;

				for i = 1 : length( vesselConnCompProps )
					average = mean( vesselThickness( vesselConnCompProps(i).PixelIdxList ) ) ;

					if average > 1.5
						trimmedWire( vesselConnCompProps(i).PixelIdxList ) = 0 ;
					end
				end
			%%%
				
			handles.derivedPic.wire = bwmorph( bwmorph(trimmedWire,'spur',1) , 'clean' , 1 ) ;
			handles.derivedPic.wire = bwmorph( handles.derivedPic.wire , 'thin' , handles.constants.thinIterations ) ;
			
			if handles.constants.wireDilationThreshold > 0
				handles.derivedPic.BW_2 = handles.derivedPic.BW_2 & imdilate(handles.derivedPic.wire,strel('disk',2*handles.constants.wireDilationThreshold,0)) ;
			end
			
			[By,Bx] = find(bwmorph(handles.derivedPic.wire, 'branchpoints')) ;
			[Ey,Ex] = find(bwmorph(handles.derivedPic.wire, 'endpoints')) ;

			borderSize = 5 ;

			By( (Bx<borderSize) | (Bx>col-borderSize) ) = [] ;
			Bx( (Bx<borderSize) | (Bx>col-borderSize) ) = [] ;
			Bx( (By<borderSize) | (By>row-borderSize) ) = [] ;
			By( (By<borderSize) | (By>row-borderSize) ) = [] ;

			Ey( (Ex<borderSize) | (Ex>col-borderSize) ) = [] ;
			Ex( (Ex<borderSize) | (Ex>col-borderSize) ) = [] ;
			Ex( (Ey<borderSize) | (Ey>row-borderSize) ) = [] ;
			Ey( (Ey<borderSize) | (Ey>row-borderSize) ) = [] ;
		%~~~~ End: Remove Thin Vessels and Recalculate Branch- / End- Points
		
		handles.derivedPic.branchpoints.coords = [Bx,By] ;
		handles.derivedPic.endpoints.coords	   = [Ex,Ey] ;
	%---- End: Find Branch and End Points
		
	%---- Start: Update Branch and End Point Line Objects
		handles.derivedPic.branchpoints.line.XData = Bx ;
		handles.derivedPic.branchpoints.line.YData = By ;

		handles.derivedPic.endpoints.line.XData = Ex ;
		handles.derivedPic.endpoints.line.YData = Ey ;
	%---- Start: Update Branch and End Point Line Objects
	
%%%%% End: Recalculate Wire Image

%%%%% Start: Created Dilated Wire Images for Display Purposes
	handles.derivedPic.dilated  = uint8(imdilate( handles.derivedPic.wire , strel('disk',1) )) ;
	handles.derivedPic.dilated2 = uint8(imdilate( handles.derivedPic.wire , strel('disk',2) )) ;
	
	handles.derivedPic.newWire  = 1 ;
%%%%% End: Created Dilated Wire Images for Display Purposes


%%%%% Start: Update Displayed Image
		handles.image.CData = createNewBW2( handles ) ;
%%%%% End: Update Displayed Image
end