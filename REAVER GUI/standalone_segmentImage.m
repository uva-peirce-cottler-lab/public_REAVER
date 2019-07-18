function derivedPic = standalone_segmentImage( varargin )
%%%%% Start: Process the Input Arguments
if isequal(length(varargin),1) % Only an input image is given; default arguments
	handles.basePic.data = varargin{1} ;
	
	handles.basePic.ySize = 1024 ;
	handles.basePic.xSize = 1024 ;
	
	if size(handles.basePic.data,3)==1
		handles.grayImage = 1 ;
	else
		handles.grayImage = 0 ;
	end

	handles.constants.averagingFilterSize  = 128 ; % Size of averaging neighborhood
	handles.constants.grey2BWthreshold     = 0.045 ; % Threshold used for converting grey neighbors to BW
	handles.constants.minCCArea			   = 1600 ; % Minimum Connected Component Area to Keep
	handles.constants.ConwaysIterations	   = 8 ;
	handles.constants.bridgeFillIterations = 4 ;

	handles.constants.bridgeIterations   = 1 ;
	handles.constants.fillIterations     = 1 ;
	handles.constants.majorityIterations = 1;
	handles.constants.thinIterations     = inf ;

	handles.constants.survive = [4,5,6,7,8] ;
	handles.constants.born    = [4,5,6,7,8] ;

	handles.constants.vesselThicknessThreshold = 3 ;
	handles.constants.wireDilationThreshold = 0 ;

else
	return
end


%%%%% End: Process the Input Arguments


%%%%% Start: Color Selection Prompt
	if handles.grayImage
		selectedColors = 1 ;
	else
		selectedColors = listdlg('ListString',{'Red','Green','Blue'},'ListSize',[300,80],'Name','Color Selection') ;
		if isempty( selectedColors )
			return
		end
	end
	handles.constants.selectedColors = selectedColors ;
	handles.displayedColors = [false,false,false] ;
	handles.displayedColors(selectedColors) = true ;

	blankedColors = ~ismember( [1,2,3] , selectedColors ) ;
	blankedColors = [1,2,3] .* blankedColors ;
	blankedColors( blankedColors == 0 ) = [] ;
%%%%% End: Color Selection Prompt
	
if true
	%---- Start: Create Vectors Necessary for Proper Neighbor Tallying
		row = handles.basePic.ySize;
		col = handles.basePic.xSize;

		pR = [1 1:row-1];
		qR = [2:row row];
		pC = [1 1:col-1];
		qC = [2:col col];
	%---- End: Create Vectors Necessary for Proper Neighbor Tallying

	%---- Start: Determine Greyscale Image using only Selected Colors
		handles.derivedPic.selectedColors = handles.basePic.data ;

		if handles.grayImage
			handles.derivedPic.grey = double( handles.derivedPic.selectedColors ) ;

		else
			for i = blankedColors
				handles.derivedPic.selectedColors(:,:,i) = 0 ;
			end

			handles.derivedPic.grey = double( rgb2gray( handles.derivedPic.selectedColors ) ) ;

		end
	%---- End: Determine Greyscale Image using only Red and Blue Values
	
	%---- Start: Determine Greyscale Total Neighbor Values
		handles.derivedPic.greynbrs = ...
			handles.derivedPic.grey(:,pC)  + handles.derivedPic.grey(:,qC) + ...
			handles.derivedPic.grey(pR,:)  + handles.derivedPic.grey(qR,:) + ...
			handles.derivedPic.grey(pR,pC) + handles.derivedPic.grey(qR,qC) + ...
			handles.derivedPic.grey(pR,qC) + handles.derivedPic.grey(qR,pC);

		handles.derivedPic.greynbrs = handles.derivedPic.greynbrs / (255*8) ; % Each neighbor is 0-255 so you have to average and normalize
	%---- End: Determine Greyscale Total Neighbor Values

	%---- Start: Local Thresholding of Greyscale Neighbors to get First Binary Image
%
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
%
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
			
			%%% This section thresholds the vessel thicknesses to above and below 5
			%%% then removes connected components with average thicknesses
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

%%%%% Start: Finalize Output Argument
	derivedPic = handles.derivedPic ;
%%%%% End: Finalize Output Argument
end