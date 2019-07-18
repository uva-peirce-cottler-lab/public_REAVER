function handles = segmentImage( handles )
%%%%% Start: Perform First Stage of Image Segmentation
if true
	%---- Start: Create Vectors Necessary for Proper Neighbor Tallying
		row = handles.basePic.ySize;
		col = handles.basePic.xSize;

		pR = [1 1:row-1];
		qR = [2:row row];
		pC = [1 1:col-1];
		qC = [2:col col];
	%---- End: Create Vectors Necessary for Proper Neighbor Tallying
	
	%---- Start: Determine Greyscale Total Neighbor Values
		handles.derivedPic.greynbrs = ...
			handles.derivedPic.grey(:,pC)  + handles.derivedPic.grey(:,qC) + ...
			handles.derivedPic.grey(pR,:)  + handles.derivedPic.grey(qR,:) + ...
			handles.derivedPic.grey(pR,pC) + handles.derivedPic.grey(qR,qC) + ...
			handles.derivedPic.grey(pR,qC) + handles.derivedPic.grey(qR,pC);

		handles.derivedPic.greynbrs = handles.derivedPic.greynbrs / (255*8) ; % Each neighbor is 0-255 so you have to average and normalize
	%---- End: Determine Greyscale Total Neighbor Values

	%---- Start: Local Thresholding of Greyscale Neighbors to get First Binary Image
		handles.derivedPic.mean = 0.4*imfilter( handles.derivedPic.greynbrs , ...
			fspecial('average', [handles.constants.averagingFilterSize handles.constants.averagingFilterSize]) , 'replicate' ) ;
		
		handles.derivedPic.BW_1 = ( handles.derivedPic.greynbrs - handles.derivedPic.mean ) > handles.constants.grey2BWthreshold ;
	%---- End: Local Thresholding of Greyscale Neighbors to get First Binary Image

	%---- Start: Determine Total Neighbor Values of First Binary Image
		handles.derivedPic.BW_1nbrs = ...
			handles.derivedPic.BW_1(:,pC)  + handles.derivedPic.BW_1(:,qC) + ...
			handles.derivedPic.BW_1(pR,:)  + handles.derivedPic.BW_1(qR,:) + ...
			handles.derivedPic.BW_1(pR,pC) + handles.derivedPic.BW_1(qR,qC) + ...
			handles.derivedPic.BW_1(pR,qC) + handles.derivedPic.BW_1(qR,pC);

		handles.derivedPic.BW_1nbrs = handles.derivedPic.BW_1nbrs > 3 ;
	%---- End: Determine Total Neighbor Values of First Binary Image
		
	%---- Start: Determine Second Binary Image by Converting Binary Neighbors to Logical and Removing Insufficiently Large Connected Components
		handles.derivedPic.BW_2 = bwareafilt( logical(handles.derivedPic.BW_1nbrs) , [handles.constants.minCCArea , Inf]) ;
	%---- End: Determine Second Binary Image by Converting Binary Neighbors to Logical and Removing Insufficiently Large Connected Components
	
	%---- Start: Fill Holes and Even Out Edges

		bw_2inv = ~handles.derivedPic.BW_2 ;
		bw_2inv = padarray( bw_2inv , [50,50] , 'replicate' ) ;
		windowSize = 11 ;
		kernel = ones(windowSize) / windowSize ^ 2;
		blurryImage = conv2(single(bw_2inv), kernel, 'same');
		bw_2inv = blurryImage > 0.5 ; % Rethreshold
		bw_2inv = bw_2inv( (50+1):(end-50) , (50+1):(end-50) ) ;
		handles.derivedPic.BW_2 = ~bw_2inv ;

		bw_2inv = ~handles.derivedPic.BW_2 ;
		bw_2inv = padarray( bw_2inv , [50,50] , 'replicate' ) ;
		bw_2inv = bw_2inv & bwareafilt( bw_2inv , [ 0 , 800 ] ) ;
		bw_2inv = bw_2inv( (50+1):(end-50) , (50+1):(end-50) ) ;
		handles.derivedPic.BW_2 = handles.derivedPic.BW_2 | bw_2inv ;

	%---- End: Fill Holes and Even Out Edges
	
	%---- Start: Thin the Binary Image
		bw_2 = padarray( handles.derivedPic.BW_2 , [50,50] , 'replicate' ) ;
		bw_2 = bwmorph( bw_2 , 'thin' , 2 ) ;
		handles.derivedPic.BW_2 = bw_2( (50+1):(end-50) , (50+1):(end-50) ) ;
	%---- End: Thin the Binary Image
	
	%---- Start: Determine Second Binary Image by Converting Binary Neighbors to Logical and Removing Insufficiently Large Connected Components
		handles.derivedPic.BW_2 = bwareafilt( logical(handles.derivedPic.BW_2) , [handles.constants.minCCArea , Inf]) ;
	%---- End: Determine Second Binary Image by Converting Binary Neighbors to Logical and Removing Insufficiently Large Connected Components
	
end
%%%%% End: Perform First Stage of Image Segmentation

%%%%% Start: Perform Second Stage of Image Segmentation
if true
	%---- Start: Find Wire Frame
		for k = 1:1
		%~~~~ Start: Copy Second Binary Image and Apply Conway's Rules
			handles.derivedPic.wire = handles.derivedPic.BW_2 ;

			for i = 1:handles.constants.ConwaysIterations
				neighbors = handles.derivedPic.wire(:,pC) + handles.derivedPic.wire(:,qC) + ...
					handles.derivedPic.wire(pR,:) + handles.derivedPic.wire(qR,:) + ...
					handles.derivedPic.wire(pR,pC) + handles.derivedPic.wire(qR,qC) + ...
					handles.derivedPic.wire(pR,qC) + handles.derivedPic.wire(qR,pC) ;

				handles.derivedPic.wire = ( ( (ismember(neighbors,handles.constants.survive)) & handles.derivedPic.wire ) | ...
					( (ismember(neighbors,handles.constants.born)) & (~handles.derivedPic.wire) ) ) ;
			end
		%~~~~ End: Copy Second Binary Image and Apply Conway's Rules

		%~~~~ Start: Apply Morphological Operations
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
			
			padSize = 48 ;
			basic = bwmorph( padarray( handles.derivedPic.wire , [padSize,padSize] , 'replicate' ) , 'thin' , handles.constants.thinIterations ) ;
			handles.derivedPic.wire = basic( (padSize+1):(end-padSize) , (padSize+1):(end-padSize) ) ;
			
		%~~~~ End: Apply Morphological Operations

		%~~~~ Start: Find Branch and End Points
			[By,Bx] = find(bwmorph(handles.derivedPic.wire, 'branchpoints')) ;
		%~~~~ End: Find Branch and End Points

		%~~~~ Start: Remove Thin Vessels
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
			
			%%% This section thresholds the vessel thicknesses to above 
			%%% and below handles.constants.vesselThicknessThreshold then
			%%% removes connected components with average thicknesses 
			%%% below handles.constants.vesselThicknessThreshold
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
				% Wire dilation and & operation to clean out thin vessels with no wire
				handles.derivedPic.BW_2 = handles.derivedPic.BW_2 & imdilate(handles.derivedPic.wire,strel('disk',handles.constants.wireDilationThreshold,0)) ;
			end
		%~~~~ End: Remove Thin Vessels
% 		handles.derivedPic.BW_2 = bwmorph(handles.derivedPic.BW_2,'thin',3) ;
		end
	%---- End: Find Wire Frame	
			
	%---- Start: Find (Final) Branch and End Points
		[By,Bx] = find(bwmorph(handles.derivedPic.wire, 'branchpoints')) ;
		[Ey,Ex] = find(bwmorph(handles.derivedPic.wire, 'endpoints')) ;

		%~~~~ Start: Trim Branch and End Points too Close to the Border
			borderSize = 5 ;

			By( (Bx<borderSize) | (Bx>col-borderSize) ) = [] ;
			Bx( (Bx<borderSize) | (Bx>col-borderSize) ) = [] ;
			Bx( (By<borderSize) | (By>row-borderSize) ) = [] ;
			By( (By<borderSize) | (By>row-borderSize) ) = [] ;

			Ey( (Ex<borderSize) | (Ex>col-borderSize) ) = [] ;
			Ex( (Ex<borderSize) | (Ex>col-borderSize) ) = [] ;
			Ex( (Ey<borderSize) | (Ey>row-borderSize) ) = [] ;
			Ey( (Ey<borderSize) | (Ey>row-borderSize) ) = [] ;
		%~~~~ End: Trim Branch and End Points too Close to the Border		
		
		handles.derivedPic.branchpoints.coords = [Bx,By] ;
		handles.derivedPic.endpoints.coords	   = [Ex,Ey] ;
	%---- End: Find (Final) Branch and End Points
end
%%%%% End: Perform Second Stage of Image Segmentation

%%%%% Start: Update Branch and End Point Line Objects
	if isempty( handles.derivedPic.branchpoints.line )
		hold on
			handles.derivedPic.branchpoints.line = plot(Bx,By,'ro','MarkerFaceColor','r') ;
			handles.derivedPic.endpoints.line	 = plot(Ex,Ey,'co','MarkerFaceColor','c') ;
		hold off
	else
		handles.derivedPic.branchpoints.line.XData = Bx ;
		handles.derivedPic.branchpoints.line.YData = By ;

		handles.derivedPic.endpoints.line.XData = Ex ;
		handles.derivedPic.endpoints.line.YData = Ey ;
	end
	
	if ~isempty(handles.derivedPic.branchpoints.line)		
		handles.derivedPic.branchpoints.line.Visible = 'off' ;
		handles.derivedPic.endpoints.line.Visible	 = 'off' ;
	end
%%%%% End: Update Branch and End Point Line Objects

%%%%% Start: Created Dilated Wire Images for Display Purposes
	handles.derivedPic.dilated  = uint8(imdilate( handles.derivedPic.wire , strel('disk',1) )) ;
	handles.derivedPic.dilated2 = uint8(imdilate( handles.derivedPic.wire , strel('disk',2) )) ;
	
	handles.derivedPic.newWire  = 1 ;
%%%%% End: Created Dilated Wire Images for Display Purposes
end