function REAVER_GUI

%%%%% Start: Get Initial "Values"
if true
	% Get the screen size. The first two values are the position ( always
	% (1,1) so unneeded )
	screenSize = get( 0 , 'ScreenSize' ) ;
	screenSize(1:2) = [] ;
	
	% Find the greatest power of 2 less than the minimum screen dimension
	initialAxSizePower = nextpow2( min( screenSize ) ) - 2 ;
	
	% Determine the size of the initial axis in pixels using the power of 2
	initialAxSize = 2^( initialAxSizePower ) ;
	
	% Loading the gear icon
	load('GUI_Icons.mat','gearIcon') 
	
	% Setting the default values
    image_resolution = 1;
    if ~isempty(dir([getappdata(0,'proj_path') '/temp/default_image_resolution.mat']))
        st = load([getappdata(0,'proj_path') '/temp/default_image_resolution.mat']);
        image_resolution = st.image_resolution;
    end
	fig_position = [screenSize(1)/8,screenSize(2)/4,screenSize(1)/2,screenSize(2)/2] ;
	ax_position  = [(screenSize(1)/4)-(initialAxSize/2),(screenSize(2)/4)-(initialAxSize/2),initialAxSize,initialAxSize] ;
% 	default_value_names = {'image_resolution','fig_position','ax_position'} ;
	default_value_names = {'image_resolution'} ;

	% Checking for temp folder and acting accordingly
	if ~isfolder('temp')
		mkdir('temp')
	end
	
	% Checking through the default values
	for i = 1:length(default_value_names)
		temp_filename = ['temp\default_',default_value_names{i},'.mat'] ;
		if ~isfile(temp_filename)
			save(temp_filename,default_value_names{i})
		else
			load(temp_filename,default_value_names{i})
		end
	end
end
%%%%% End: Get Initial "Values"

%%%%% Start: Create Graphics Objects
	%---- Start: Figure and CENTER Object Creation
		if true	
		%~~~~ Start: Figure Creation
			REAVER_Fig = ...
				  figure('Tag','REAVER_Fig'...
						,'Color',[0.8 0.8 0.8]...
						,'Colormap',gray(2040)...
						,'NumberTitle','off'...
						,'Name','REAVER'...
						,'MenuBar','none'...
						,'Units','Pixels'...
						,'Position',fig_position...
						,'CloseRequestFcn',@closeRequest...
						,'WindowButtonDownFcn',@figButtonDown...
						,'WindowButtonUpFcn',@figButtonUp...
						,'WindowButtonMotionFcn',@figButtonMotion...
						,'KeyPressFcn',@figKeyPress...
					    ,'WindowScrollWheelFcn',@figScrollWheel...
						) ;
		%~~~~ End: Figure Creation

		%~~~~ Start: Main Axes Creation
			axes('Parent',REAVER_Fig...
				,'Tag','REAVER_MainAx'...
				,'Units','Pixels'...
				,'Position',ax_position...
				,'XColor','None'...
				,'YColor','None'...
				)
		%~~~~ End: Main Axes Creation
		end
	%---- End: Figure and CENTER Object Creation

	%---- Start: LEFT Objects Creation
		if true		
		%~~~~ Start: Directory Name Text
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','text'...
					 ,'Tag','directoryName'...
					 ,'BackgroundColor',[0.8,0.8,0.8]...
					 ,'Units','Normalized'...
					 ,'Position',[66,908,256,40+12]./[1800,1036,1800,1036]...
					 ,'String','Directory Name'...
					 ,'FontSize',8 ...
					 ,'FontWeight','Bold'...
					 ,'FontAngle','italic'...
					 ,'FontUnits','Normalized'...
					 ,'Enable','on'...
					 )
		%~~~~ End: Directory Name Text
		
		%~~~~ Start: Image Directory Table
			uitable('Parent',REAVER_Fig...
				   ,'Tag','imageDirectoryTable'...
				   ,'RowName',{}...
				   ,'ColumnName',{'Image';'Existing Data';'Verified'}...
				   ,'ColumnWidth',num2cell(floor([45,45,45]*screenSize(1)/1920)-6)...
				   ,'ColumnEditable',[false,false,true]...
				   ,'BackgroundColor',[0.95,0.95,0.95]...
				   ,'Interruptible','off'...
				   ,'Enable','off'...
				   ,'FontSize',10 ...
                   ,'FontWeight','Bold'...
				   ,'Units','Normalized'...
				   ,'Position',[66,642,256,256]./[1800,1036,1800,1036]...
				   ,'CellSelectionCallback',@imageDirectoryTableSelection_Callback...
				   ,'CellEditCallback',@imageDirectoryTableEdit_Callback...
				   ) ;
		%~~~~ End: Image Directory Table
		
		%~~~~ Start: Segment Button
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','Pushbutton'...
					 ,'Tag','segmentationButton'...
					 ,'String','Segment Image'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'Units','Normalized'...
					 ,'Position',[66,530,256,40]./[1800,1036,1800,1036]...
					 ,'Enable','off'...
					 ,'Callback',@segmentationButton_Callback...
					 )
		%~~~~ End: Segment Button

		%~~~~ Start: Displayed Image Button Group
			displayedImageButtonGroup = ...
				uibuttongroup('Parent',REAVER_Fig...
							 ,'Tag','displayedImageButtonGroup'...
							 ,'Units','Normalized'...
							 ,'Position',[66,164,256,345]./[1800,1036,1800,1036]...
							 ,'BackgroundColor',[0.95,0.95,0.95]...
							 ,'Title','Displayed Image'...
							 ,'TitlePosition','CenterTop'...
							 ,'FontSize',10 ...
							 ,'FontWeight','Bold'...
							 ,'SelectionChangedFcn',@displayedImageButtonGroupSelectionChanged...
							 ) ;
						 
				% Individual buttons
				if true
				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Displayed Channels'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 131/154 1 20/154]...
						 )

				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Input Channel'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 113/154 1 20/154]...
						 )

				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Grey'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 95/154 1 20/154]...
						 )

				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Grey Neighbors'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 77/154 1 20/154]...
						 )

				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','First Binary'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 59/154 1 20/154]...
						 )

				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','First Binary Neighbors'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 41/154 1 20/154]...
						 )

				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Second Binary'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 23/154 1 20/154]...
						 )

				uicontrol('Parent',displayedImageButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Wire Frame'...
						 ,'FontWeight','Bold'...
						 ,'Units','Normalized'...
						 ,'Position',[6/256 5/154 1 20/154]...
						 )
				end
				
			set( displayedImageButtonGroup.Children , 'Enable' , 'off' )
		%~~~~ End: Displayed Image Button Group
		end
	%---- End: LEFT Objects Creation

	%---- Start: RIGHT Objects Creation
		if true
		%~~~~ Start: Update Wire Button Creation
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','Pushbutton'...
					 ,'Tag','updateWireButton'...
					 ,'String','Update Wire Frame'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'Units','Normalized'...
					 ,'Position',[1478,976,256,40]./[1800,1036,1800,1036]...
					 ,'Enable','off'...
					 ,'Callback',@updateWireButton_Callback...
					 )
		%~~~~ End: Update Wire Button Creation
		
		%~~~~ Start: Undo Last Edit Button Creation
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','Pushbutton'...
					 ,'Tag','undoLastEditButton'...
					 ,'String','Undo Last Edits'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'Units','Normalized'...
					 ,'Position',[1478,920,256,40]./[1800,1036,1800,1036]...
					 ,'Enable','off'...
					 ,'Callback',@undoLastEditButton_Callback...
					 )
		%~~~~ End: Undo Last Edit Button Creation
		
		%~~~~ Start: Edit Size Slider Creation
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','text'...
					 ,'Tag','editSizeSliderTitle'...
					 ,'BackgroundColor',[0.8,0.8,0.8]...
					 ,'Units','Normalized'...
					 ,'Position',[1478,838+12+12,256,40]./[1800,1036,1800,1036]...
					 ,'String','Cursor Edit Size:'...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'FontUnits','Normalized'...
					 ,'Enable','on'...
					 )
				 
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','Slider'...
					 ,'Tag','editSizeSlider'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'Units','Normalized'...
					 ,'Position',[1478,808+12+12,216,30]./[1800,1036,1800,1036]...
					 ,'Max',15 ...
					 ,'SliderStep',[1/16,2/16]...
					 ,'Enable','on'...
					 ,'Callback',@editSizeSlider_Callback...
					 )
				 
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','text'...
					 ,'Tag','editSizeSliderValue'...
					 ,'BackgroundColor',[0.8,0.8,0.8]...
					 ,'Units','Normalized'...
					 ,'Position',[1704,794+12+12,30,44]./[1800,1036,1800,1036]...
					 ,'String','1'...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'FontUnits','Normalized'...
					 ,'Enable','on'...
					 )
		%~~~~ End: Edit Size Slider Creation
		
		%~~~~ Start: Create um/pix Text Box
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','text'...
					 ,'Tag','imageResolutionValueText'...
					 ,'BackgroundColor',[0.8,0.8,0.8]...
					 ,'Units','Normalized'...
					 ,'Position',[1478,736+29+16,256,36]./[1800,1036,1800,1036]...
					 ,'String','Image Resolution:'...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'FontUnits','Normalized'...
					 ,'HorizontalAlignment','Center'...
					 )
				 
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','edit'...
					 ,'Tag','imageResolutionValueEdit'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'Units','Normalized'...
					 ,'Position',[1478,696+29+16,136,38]./[1800,1036,1800,1036]...
					 ,'String',num2str(image_resolution)...
					 ,'FontSize',9 ...
					 ,'FontWeight','Bold'...
					 ,'FontUnits','Normalized'...
					 ,'HorizontalAlignment','Center'...
					 ,'Callback',@imageResolutionValueEdit_Callback...
					 )
				 
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','text'...
					 ,'Tag','imageResolutionUnitText'...
					 ,'BackgroundColor',[0.8,0.8,0.8]...
					 ,'Units','Normalized'...
					 ,'Position',[1624,696+29+16,110,36]./[1800,1036,1800,1036]...
					 ,'String',sprintf('\x3bcm / pixel')...
					 ,'FontSize',9 ...
					 ,'FontWeight','Bold'...
					 ,'FontUnits','Normalized'...
					 ,'HorizontalAlignment','Center'...
					 )
		%~~~~ End: Create um/pix Text Box
		
		%~~~~ Start: Edit Grey2Binary Threshold Slider Creation
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','text'...
					 ,'Tag','grey2binaryThresholdSliderTitle'...
					 ,'BackgroundColor',[0.8,0.8,0.8]...
					 ,'Units','Normalized'...
					 ,'Position',[1478,614+50+22,256,40]./[1800,1036,1800,1036]...
					 ,'String','Grey Threshold:'...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'FontUnits','Normalized'...
					 ,'Enable','on'...
					 )
				 
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','Slider'...
					 ,'Tag','grey2binaryThresholdSlider'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'Units','Normalized'...
					 ,'Position',[1478,584+50+22,186,30]./[1800,1036,1800,1036]...
					 ,'Max',0.4 ...
					 ,'Value',0.045 ...
					 ,'SliderStep',[1/50,1/20]...
					 ,'Enable','on'...
					 ,'Callback',@grey2binaryThresholdSlider_Callback...
					 )
				 
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','edit'...
					 ,'Tag','grey2binaryThresholdSliderValue'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'Units','Normalized'...
					 ,'Position',[1670,584+50+22,64,30]./[1800,1036,1800,1036]...
					 ,'String','0.045'...
					 ,'FontSize',8 ...
					 ,'FontWeight','Bold'...
					 ,'FontUnits','Normalized'...
					 ,'Enable','on'...
					 ,'Callback',@grey2binaryThresholdSliderValue_Callback...
					 )
		%~~~~ End: Edit Grey2Binary Threshold Slider Creation
		
		%~~~~ Start: Displayed Color Channel Panel and Checkboxes
			colorPanel = ...
				uipanel('Parent',REAVER_Fig...
					   ,'Tag','displayedChannelsPanel'...
					   ,'Title','Displayed Channels'...
					   ,'Units','Normalized'...
					   ,'Position',[1478,496,256,134]./[1800,1036,1800,1036] ...
					   ,'FontSize',9 ...
					   ,'FontWeight','Bold'...
					   ) ;

				uicontrol('Parent',colorPanel...
						 ,'Style','checkbox'...
						 ,'Tag','redChannel'...
						 ,'String','Red' ...
						 ,'FontSize',9 ...
						 ,'FontUnits','Normalized'...
						 ,'Units','Normalized'...
						 ,'Position',[0,0.65,1,0.33]...
						 ,'Value',1 ...
						 ,'Callback',@redChannelCheckbox_Callback...
						 )

				uicontrol('Parent',colorPanel...
						 ,'Style','checkbox'...
						 ,'Tag','greenChannel'...
						 ,'String','Green' ...
						 ,'FontSize',9 ...
						 ,'FontUnits','Normalized'...
						 ,'Units','Normalized'...
						 ,'Position',[0,0.33,1,0.33]...
						 ,'Value',1 ...
						 ,'Callback',@greenChannelCheckbox_Callback...
						 )

				uicontrol('Parent',colorPanel...
						 ,'Style','checkbox'...
						 ,'Tag','blueChannel'...
						 ,'String','Blue' ...
						 ,'FontSize',9 ...
						 ,'FontUnits','Normalized'...
						 ,'Units','Normalized'...
						 ,'Position',[0,0.03,1,0.33]...
						 ,'Value',1 ...
						 ,'Callback',@blueChannelCheckbox_Callback...
						 )
		%~~~~ End: Displayed Color Channel Panel and Checkboxes
		
		
		
		%~~~~ Start: Displayed Image Button Group
			inputChannelButtonGroup = ...
				uibuttongroup('Parent',REAVER_Fig...
							 ,'Tag','inputChannelButtonGroup'...
							 ,'Units','Normalized'...
							 ,'Position',[1478,346,256,134]./[1800,1036,1800,1036] ...
							 ,'BackgroundColor',[0.95,0.95,0.95]...
							 ,'Title','Input Channel'...
							 ,'FontSize',9 ...
							 ,'FontWeight','Bold'...
							 ,'SelectionChangedFcn',@inputChannelButtonGroupSelectionChanged...
							 );
						 
				% Individual buttons
				uicontrol('Parent',inputChannelButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Red'...
						 ,'FontSize',9 ...
						 ,'FontUnits','Normalized'...
						 ,'Units','Normalized'...
						 ,'Position',[0,0.65,1,0.33]...
						 )

				uicontrol('Parent',inputChannelButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Green'...
						 ,'FontSize',9 ...
						 ,'FontUnits','Normalized'...
						 ,'Units','Normalized'...
						 ,'Position',[0,0.33,1,0.33]...
						 )

				uicontrol('Parent',inputChannelButtonGroup...
						 ,'Style','radiobutton'...
						 ,'String','Blue'...
						 ,'FontSize',9 ...
						 ,'FontUnits','Normalized'...
						 ,'Units','Normalized'...
						 ,'Position',[0,0.03,1,0.33]...
						 )
		%~~~~ End: Displayed Image Button Group
		
		
		
		%~~~~ Start: Settings Button Creation
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','Pushbutton'...
					 ,'Tag','settingsButton'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'CData',gearIcon...
					 ,'ToolTipString','Settings'...
					 ,'FontSize',10 ...
					 ,'Units','Normalized'...
					 ,'Position',[1478,360-150,120,120]./[1800,1036,1800,1036]...
					 ,'Callback',@settingsButton_Callback...
					 )
		%~~~~ End: Settings Button Creation
		
		%~~~~ Start: Save Data Button Creation
			uicontrol('Parent',REAVER_Fig...
					 ,'Style','Pushbutton'...
					 ,'Tag','saveDataButton'...
					 ,'String','Save Data'...
					 ,'BackgroundColor',[0.95,0.95,0.95]...
					 ,'FontSize',10 ...
					 ,'FontWeight','Bold'...
					 ,'Units','Normalized'...
					 ,'Position',[1478,136,256,40]./[1800,1036,1800,1036]...
					 ,'Enable','off'...
					 ,'Callback',@saveDataButton_Callback...
					 )
		%~~~~ Start: Save Data Button Creation
		end
	%---- End: RIGHT Objects Creation
%%%%% End: Create Graphics Objects

%%%%% Start: Create Menu
if true
	fileMenu = ...
		uimenu('Parent',REAVER_Fig...
			  ,'Tag','fileMenu'...
			  ,'Text','&File'...
			  ) ;
				  
		uimenu('Parent',fileMenu...
			  ,'Tag','loadDirectoryItem'...
			  ,'Text','&Load directory'...
			  ,'MenuSelectedFcn',@loadDirectory_Callback...
			  ) ;
	
				  
	dataMenu = ...
		uimenu('Parent',REAVER_Fig...
			  ,'Tag','dataMenu'...
			  ,'Text','&Data'...
			  ,'Enable','off'...
			  ) ;
		  
		uimenu('Parent',dataMenu...
			  ,'Tag','processAllImagesItem'...
			  ,'Text','&Process All Images'...
			  ,'MenuSelectedFcn',@processAllImages_Callback...
			  )
		  
		uimenu('Parent',dataMenu...
			  ,'Tag','quantifyAllImagesItem'...
			  ,'Text','&Quantify Verified Images'...
			  ,'MenuSelectedFcn',@quantifyAllImage_Callback...
			  )
		 
         uimenu('Parent',dataMenu...
			  ,'Tag','exportBinarySegmentation'...
			  ,'Text','&Export Binary of All Images'...
			  ,'MenuSelectedFcn',@exportBinarySegmentation_Callback...
			  )
		  
	imageMenu = ...
		uimenu('Parent',REAVER_Fig...
			  ,'Text','&Image'...
			  ,'Tag','imageMenu'...
			  ) ;
		  
		uimenu('Parent',imageMenu...
			  ,'Tag','blindImageNamesItem'...
			  ,'Text','&Blind Image Names'...
			  ,'Checked','off'...
			  ,'MenuSelectedFcn',@blindImageNamesItem_Callback...
			  )
		  
		uimenu('Parent',imageMenu...
			  ,'Tag','gammaAdjustItem'...
			  ,'Text','&Gamma Adjust'...
			  ,'Checked','off'...
			  ,'MenuSelectedFcn',@gammaAdjustItem_Callback...
			  )
		  
		uimenu('Parent',imageMenu...
			  ,'Tag','centerLineColorItem'...
			  ,'Text','&Center Line Color'...
			  ,'MenuSelectedFcn',@centerLineColor_Callback...
			  )
		  
		uimenu('Parent',imageMenu...
			  ,'Tag','edgeLineColorItem'...
			  ,'Text','&Edge Line Color'...
			  ,'MenuSelectedFcn',@edgeLineColor_Callback...
			  )
		  
		uimenu('Parent',imageMenu...
			  ,'Tag','exportDisplayedImageItem'...
			  ,'Text','Export &Displayed Image'...
			  ,'Enable','off'...
			  ,'MenuSelectedFcn',@exportDisplayedImage_Callback...
			  )
end
%%%%% End: Create Menu

%%%%% Start: Initialize Handles
if true
	handles = guihandles(REAVER_Fig) ;
	
	%---- Start: Store OS and Size Information
		handles.screenSize     = screenSize ;
		handles.currentAxPower = initialAxSizePower ;
		
		softwareVersion = ['R' version('-release')] ;
		
		if str2double(softwareVersion(5)) > 7
			handles.versionNew = 1 ;
		elseif isequal(softwareVersion(6),'b') && isequal(softwareVersion(5),'7')
			handles.versionNew = 1 ;
		elseif str2double(softwareVersion(5)) < 5
			handles.imageResolutionUnitText.String = 'um / pixel' ;
			handles.versionNew = 0 ;
		else
			handles.versionNew = 0 ;
		end
		
		if ismac
			handles.slash = '/' ;
		else
			handles.slash = '\' ;
		end
	%---- End: Store OS and Size Information
	
	%---- Start: Create Pan Enabled Identifier
		handles.panEnabled = 0 ;
	%---- End: Create Pan Enabled Identifier
	
	%---- Start: Create Border Image
		handles.borderImage				   = zeros(1024,1024,'uint8') ;
		handles.borderImage(2:1023,2:1023) = ones(1022,1022,'uint8') ;
		
		handles.basePic.ySize = 1024 ;
		handles.basePic.xSize = 1024 ;
	%---- End: Create Border Image
	
	%---- Start: Image Segmentation First Stage Constants
		handles.constants.selectedColors = [true,false,false] ;
		handles.grayImage				 = 0 ;
		
		handles.constants.averagingFilterSize  = 128 ; % Size of averaging neighborhood
		handles.constants.grey2BWthreshold     = 0.045 ; % Threshold used for converting grey neighbors to BW
		handles.constants.minCCArea			   = 1600 ; % Minimum Connected Component Area to Keep
	%---- End: Image Segmentation First Stage Constants

	%---- Start: Image Segmentation Second Stage Constants
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
		
		handles.constants.fileExtensionLength = 3 ;
	%---- End: Image Segmentation Second Stage Constants

	%---- Start: Create Empty Line Objects
		handles.derivedPic.branchpoints.line = plot([],[],'ro','MarkerFaceColor','r') ;
		handles.derivedPic.endpoints.line	 = plot([],[],'co','MarkerFaceColor','c') ;
	%---- End: Create Empty Line Objects
	
	%---- Start: Create Image Editing Variables
		handles.editVariables.heldDown = 0 ;
		handles.editVariables.previousBackupState = 0 ;
		handles.editVariables.pixelEditNeighbors = 0 ;
		handles.editVariables.editTool = 0 ;
	%---- End: Create Image Editing Variables

	%---- Start: Make Main Axes the Current Axes and Initialize Loaded Image Variable
		axes( handles.REAVER_MainAx )
		handles.imageLoaded	= 0 ;
		handles.imageSegmented = 0 ;
		handles.dataSaving = 0 ;
		
		handles.REAVER_Fig.SizeChangedFcn = @figSizeChanged ;
		addlistener(handles.grey2binaryThresholdSlider,'Value','PostSet',@grey2binarySliderDrag_Callback) ;
	%---- End: Make Main Axes the Current Axes and Initialize Loaded Image Variable
	
	%---- Start: Intialize Miscellaneous Constants
		handles.miscValues.centerLineColor  = [255,255,255] ;
		handles.miscValues.lineEdgeColor = [0,255,0] ;
		handles.miscValues.colorMemory = [true,true,true] ;
		handles.miscValues.oldResolution = image_resolution ;
		
		handles.time.time_trials = 0 ;
	%---- End: Intialize Miscellaneous Constants
end	
%%%%% End: Initialize Handles

%%%%% Start: Update Handles
	guidata(REAVER_Fig,handles)
%%%%% End: Update Handles

end



%% Menu Items
function loadDirectory_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Get Image Directory
	currentPath = pwd ;
	selectedDirectory = uigetdir(currentPath) ;
	if isequal(selectedDirectory,0)
       return
	end
	handles.imageDirectory.directory = selectedDirectory ;
%%%%% End: Get Image Directory

%%%%% Start: Get and Process Directory Contents
	directoryContentsImages = [dir( [selectedDirectory,handles.slash,'*.tif'] );...
							   dir( [selectedDirectory,handles.slash,'*.jpg'] );...
							   dir( [selectedDirectory,handles.slash,'*.bmp'] )];

	if ispc % If it's a Windows computer, ignore the hidden files
		[~,fileAttributes] = arrayfun( @(x) fileattrib([x.folder,handles.slash,x.name]) , directoryContentsImages ) ;
		if ~isempty(fileAttributes)
			ishidden = [fileAttributes.hidden]' ;
			directoryContentsImages( ishidden ) = [] ;
		else
			return
		end
	end
	
	handles.imageDirectory.validFiles = {directoryContentsImages.name}' ;
    
	% Using the directory path as the random seed for reproducibility 
    rng( sum(double(selectedDirectory(:))) )
    randomOrder = randperm( max(size(handles.imageDirectory.validFiles)) ) ;
	handles.imageDirectory.randomOrder = randomOrder' ;
	
	blindImageNamesItem = findobj(handles.REAVER_Fig,'Tag','blindImageNamesItem') ;
	blind = isequal(blindImageNamesItem.Checked,'on') ;
	
	if blind
		handles.imageDirectory.validFiles = handles.imageDirectory.validFiles( randomOrder ) ;
	end

	trimmedValidImageFiles = cellfun( @(cll) cll(1:(end-4)) , handles.imageDirectory.validFiles , 'UniformOutput' , 0 ) ;
	
	directoryContentsData = dir( [selectedDirectory,handles.slash,'*.mat'] ) ;
	trimmedValidDataFiles = cellfun( @(cll) cll(1:(end-4)) , {directoryContentsData.name}' , 'UniformOutput' , 0 ) ;
	
	userVerified = [ handles.imageDirectory.validFiles , num2cell(false(length(trimmedValidImageFiles),1)) ] ;
	
	if ismember('User Verified Table',trimmedValidDataFiles)
		loadedData   = load([selectedDirectory,handles.slash,'User Verified Table.mat']) ;
		loadedUserVerified = loadedData.userVerified ;
		
		[Lia,Locb] = ismember( userVerified(:,1) , loadedUserVerified(:,1) ) ;
		Locb( Locb==0 ) = [] ;
		
		userVerified(Lia,2) = loadedUserVerified(Locb,2) ;
		
	else
		save([selectedDirectory,handles.slash,'User Verified Table.mat'],'userVerified') ;
	end
	
	if isempty( trimmedValidImageFiles )
		return
	end
	
	random_filenames = sprintf('Image_%03.0f,',1:length(randomOrder)) ;
	random_filenames = strsplit(random_filenames,',')' ;
	random_filenames(end) = [] ;
    
	tableData = cell(length(trimmedValidImageFiles),3) ;
	
	if blind
		tableData(:,1) = random_filenames ;
	else
		tableData(:,1) = trimmedValidImageFiles ;
	end

	tableData(:,2) = num2cell( ismember( trimmedValidImageFiles , trimmedValidDataFiles ) ) ;
	tableData(:,3) = userVerified(:,2) ;
%%%%% End: Get and Process Directory Contents

%%%%% Start: Alter UI Properties
	set(handles.imageDirectoryTable,'Enable','on')
	set(handles.imageDirectoryTable,'Data',tableData)
	dataMenu = findobj(handles.REAVER_Fig,'Tag','dataMenu') ;
	dataMenu.Enable = 'on' ;

	folderName = strsplit(selectedDirectory,'\\') ;
	folderName = strsplit(folderName{end},'/') ;
	set(handles.directoryName,'String',folderName{1})
%%%%% End: Alter UI Properties

	guidata(hObject,handles)
end


function processAllImages_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Find the images that need to be processed
% 	noData = find(~cell2mat(handles.imageDirectoryTable.Data(:,2))) ;
% 	if isempty(noData)
% 		return
% 	end
%%%%% End: Find the images that need to be processed
	
%%%%% Start: Confirm Desired Action
	confirmResponse = questdlg('Do you wish to process all images with the current settings?', ...
							   'Confirm', ...
							   'Yes' , 'No' , 'No' ) ;
	if ~isequal(confirmResponse,'Yes')
		return
	end
%%%%% End: Confirm Desired Action
	
%%%%% Start: Iterate Through Each Image
	relevantFiles = handles.imageDirectory.validFiles ;
	filepaths = cellfun(@(c) [handles.imageDirectory.directory,handles.slash,c],relevantFiles,'UniformOut',false) ;

	for i = 1:length(filepaths)

	%---- Start: Read Image
		% Getting the image info
		info = imfinfo(filepaths{i}) ;

		% If the image is a .tif file...
		if isequal(info(1).Format,'tif')
			% ...import it as a Tiff object
			warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
			t_file = Tiff( filepaths{i} ) ;

			% Create a blank matrix for the image to go
			handles.basePic.data = [] ;

			% Read the image in channel by channel
			for j = 1:length(info)
				setDirectory(t_file,j)
				handles.basePic.data = cat(3, handles.basePic.data, im2uint8(read(t_file))) ;
			end
			warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning')
			% If the image only has 2 channels, create a 3rd 0 channel
			if size(handles.basePic.data,3) == 2
				handles.basePic.data(:,:,3) = 0 ;
			end

		else
			handles.basePic.data = imread(filepaths{i}) ;

		end
	%---- End: Read Image

	%---- Start: Checking if image is gray
		if size(handles.basePic.data,3)==1
			handles.grayImage = 1 ;
		else
			handles.grayImage = 0 ;
		end
	%---- End: Checking if image is gray


	%---- Start: Get Image Properties
		handles.basePic.ySize = size(handles.basePic.data,1) ;
		handles.basePic.xSize = size(handles.basePic.data,2) ;
		row = handles.basePic.ySize ;
		col = handles.basePic.xSize ;

		handles.borderImage	= zeros(row,col,'uint8') ;
		handles.borderImage(2:(row-1),2:(col-1)) = ones(row-2,col-2,'uint8') ;

		currentFigSize		= handles.REAVER_Fig.Position ;
		currentFigSize(1:2) = [] ;
	%---- End: Get Image Properties

	%---- Start: Resize Axes Up or Down and Display Image
		if ~( (currentFigSize(2)-16) > row ) || ~( col/currentFigSize(1) < 0.6 )
			%---- This condition checks if (1) there are at least 16 pixels above
			%     and below the axis and (2) the new axis would take up no more
			%     than 60% of the new figure in the width dimension. (1) and (2)

			newWidth  = currentFigSize(1)*0.6 ;
			newHeight = currentFigSize(2)-16 ;

			if newHeight < row
				factor = newHeight/row ;
				row = row*factor ;
				col = col*factor ;
			end

			if newWidth < col
				factor = newWidth/col ;
				row = row*factor ;
				col = col*factor ;
			end

			row = round(row) ;
			col = round(col) ;
		end

		handles.REAVER_MainAx.Position = [(currentFigSize(1)/2)-(col/2),...
            (currentFigSize(2)/2)-(row/2),col,row] ;

		handles.image = imagesc( handles.basePic.data , 'HitTest' , 'off' ) ;
		axis off
		drawnow
		handles.imageLoaded = 1 ;
	%~~~~ End: Resize Axes Up or Down and Display Image

	%---- Start: Reset Derived Image
		handles.derivedPic					 = [] ;
		handles.derivedPic.branchpoints.line = plot([],[],'ro') ;
		handles.derivedPic.endpoints.line	 = plot([],[],'co') ;
	%---- End: Reset Derived Image
		
	%---- Start: Determine Greyscale Image using only Selected Colors
		handles.derivedPic.selectedColors = handles.basePic.data ;

		if handles.grayImage
			handles.derivedPic.grey = double( handles.derivedPic.selectedColors ) ;
		else
			handles.derivedPic.selectedColors(:,:,~handles.constants.selectedColors) = 0 ;
			handles.derivedPic.grey = double( rgb2gray( handles.derivedPic.selectedColors ) ) ;
		end
	%---- End: Determine Greyscale Image using only Selected Colors

	%---- Start: Alter UIControl Properties
		set(handles.segmentationButton,'Enable','on')
		handles.displayedImageButtonGroup.Children(8).Value = 1 ;
		set( handles.displayedImageButtonGroup.Children , 'Enable' , 'off' )
		set( handles.saveDataButton , 'Enable' , 'off' )
	%---- End: Alter UIControl Properties

	%---- Start: Segment Image
		handles = segmentImage( handles ) ;
	%---- End: Segment Image
	
	%---- Start: Find Mean Vessel Diameter
		distanceImage	   = bwdist(~handles.derivedPic.BW_2) ;
		distanceValues	   = distanceImage .* handles.derivedPic.wire * 2 ;
		meanVesselDiameter = mean( distanceValues(distanceValues>0) ) ;
	%---- End: Find Mean Vessel Diameter

	%---- Start: Create References to Variables to Save
		saveVariables.imageDirectory		  = handles.imageDirectory ;

		saveVariables.derivedPic.branchpoints = handles.derivedPic.branchpoints.coords ;
		saveVariables.derivedPic.endpoints	  = handles.derivedPic.endpoints.coords ;
		saveVariables.derivedPic.BW_2		  = handles.derivedPic.BW_2 ;
		saveVariables.derivedPic.wire		  = handles.derivedPic.wire ;
		
		saveVariables.metrics.vesselLength	  = sum(full(handles.derivedPic.wire(:))) ;
		saveVariables.metrics.vesselArea	  = sum((handles.derivedPic.BW_2(:))) ;
		saveVariables.metrics.numBranchPoints = max(size(handles.derivedPic.branchpoints.coords)) ;
		saveVariables.metrics.meanVesselDiam  = meanVesselDiameter ;
		
		saveVariables.constants				  = handles.constants ;
		saveVariables.image_resolution		  = str2double(handles.imageResolutionValueEdit.String) ;

		saveVariables.imageSize				  = [ handles.basePic.ySize , handles.basePic.xSize ] ;
	%---- End: Create References to Variables to Save

	%---- Start: Save Relevant Data		
		save( [filepaths{i}(1:(end-4)) , '.mat' ] , '-struct' , 'saveVariables' ) ;
		
		handles.imageDirectoryTable.Data{ i , 2 } = true ;
	%---- End: Save Relevant Data
	end

%%%%% End: Iterate Through Each Image

	guidata(hObject,handles)
end

function quantifyAllImage_Callback(hObject,~)
	handles = guidata(hObject) ;

	% Get input directory and image names
	validFiles = cell2mat(handles.imageDirectoryTable.Data(:,2)) ;
	processedImageDataFiles = cellfun(@(c) [c,'.mat'] , ...
		handles.imageDirectoryTable.Data(validFiles,1) , 'UniformOutput' , false ) ;
	imageDirectory = handles.imageDirectory.directory ;

	
	wtbr = waitbar(0,'Please wait...') ;
    
	% Load metadata for whether images were peer verified
    st_dir = load([imageDirectory '/User Verified Table.mat']);
    user_verified_image_names = st_dir.userVerified(:,1);
    user_verified_image_basenames = cellfun(@(x) regexprep(x, '\.(\w+)$',''), ...
        user_verified_image_names, "UniformOutput", false);
    
    % For each image from processedImages, find userVerified value from
    % User Verified Table
    bv_user_verified=zeros(1,numel(processedImageDataFiles));
    tmp_index = 1:numel(user_verified_image_names); 
    for n=1:numel(processedImageDataFiles)
        match_str = regexprep(processedImageDataFiles{n}, '\.(\w+)$','');
        tf = strncmp(match_str,user_verified_image_basenames,numel( match_str));
        
        bv_user_verified(n) = st_dir.userVerified{tmp_index(tf),2};
    end
    
    
    results_tbl = table;
	results_tbl.image_name = processedImageDataFiles(logical(bv_user_verified));
	
    
    
    % Process images
    for n=1:numel(results_tbl.image_name)
        % Load analysis data of image
%         st = load([imageDirectory '/' processedImageDataFiles{n}]);

        % Load matlab file of image and quantify network
        [metric_st, short_lbl_st] = reaver_quantify_network([imageDirectory '/' ...
            results_tbl.image_name{n}]) ; %#ok<ASGLU>
        
        % Export all quantification fields to table
        f = fields(metric_st) ;
        for k=1:numel(f); results_tbl.(f{k})(n) = metric_st.(f{k});  end

        waitbar(n/numel(processedImageDataFiles),wtbr,'Quantifying...') ;
    end

    % Delete empty rows in result table. 
    
    try
	writetable(results_tbl,[imageDirectory '/image_results.csv'])
    catch ME
        errordlg("Output CSV file is open in another program. Please close.");
    end
	% 	keyboard
	
	waitbar(1,wtbr,'Finished!')
	pause(0.75)
	close(wtbr)
	
	guidata(hObject,handles)
end

function exportBinarySegmentation_Callback(hObject,~)
	handles = guidata(hObject) ;

	% Get input directory and image names
	validFiles = cell2mat(handles.imageDirectoryTable.Data(:,2)) ;
	processedImageDataFiles = cellfun(@(c) [c,'.mat'] , ...
		handles.imageDirectoryTable.Data(validFiles,1) , 'UniformOutput' , false ) ;
	imageDirectory = handles.imageDirectory.directory ;

	% Checking for temp folder and acting accordingly
	if ~isfolder([imageDirectory '/bw'])
		mkdir([imageDirectory '/bw']) ;
	end
	
	% Quantify All images from mat file data
	for n=1:numel(processedImageDataFiles)
		st = load([imageDirectory '/' ...
			processedImageDataFiles{n}]) ;
		imwrite(st.derivedPic.BW_2,[imageDirectory '/bw/' ...
			regexprep(processedImageDataFiles{n},'.mat','.tif')]) ;
	end

end


function blindImageNamesItem_Callback(hObject,~)
handles = guidata(hObject) ;

% If it is currently off then it is being switched to on
blind = isequal(hObject.Checked,'off') ;

	if blind
		set(hObject,'Checked','on')
	else
		set(hObject,'Checked','off')		
	end
	
	if isfield(handles,'imageDirectory')
		if blind
			newValidFiles = handles.imageDirectory.validFiles(handles.imageDirectory.randomOrder) ;

			newTableData = handles.imageDirectoryTable.Data(handles.imageDirectory.randomOrder,:) ;

			random_filenames = sprintf('Image_%03.0f,',1:length(handles.imageDirectory.randomOrder)) ;
			random_filenames = strsplit(random_filenames,',')' ;
			random_filenames(end) = [] ;
			newTableData(:,1) = random_filenames ;

		else 
			newValidFiles(handles.imageDirectory.randomOrder) = handles.imageDirectory.validFiles ;
			newValidFiles = newValidFiles' ;

			newTableData = handles.imageDirectoryTable.Data ;
			newTableData(handles.imageDirectory.randomOrder,:) = handles.imageDirectoryTable.Data ;

			trimmedValidImageFiles = cellfun( @(cll) cll(1:(end-4)) , newValidFiles , 'UniformOutput' , 0 ) ;
			newTableData(:,1) = trimmedValidImageFiles ;
		end

		handles.imageDirectory.validFiles = newValidFiles ;
		handles.imageDirectoryTable.Data = newTableData ;
	end
	
	guidata(hObject,handles)
end

function gammaAdjustItem_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	% If it is currently off then it is being switched to on
	gammaAdjust = isequal(hObject.Checked,'off') ;
	
	if gammaAdjust
		set(hObject,'Checked','on')
	else
		set(hObject,'Checked','off')		
	end
	
%%%%% Start: Update image if necessary
	if handles.displayedImageButtonGroup.Children(2).Value
		handles.image.CData = createNewBW2( handles ) ;
		drawnow
	end
%%%%% End: Update image if necessary
	
	guidata(hObject,handles)
end

function centerLineColor_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	newcenterLineColor = uisetcolor( [1,1,1] ) ;
	handles.miscValues.centerLineColor = uint8( newcenterLineColor * 255 ) ;
	
	
	if handles.displayedImageButtonGroup.Children(2).Value
		handles.image.CData = createNewBW2( handles ) ;
	end
	
	guidata(hObject,handles)
end

function edgeLineColor_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	newLineEdgeColor = uisetcolor( [0,1,0] ) ;
	handles.miscValues.lineEdgeColor = uint8( newLineEdgeColor * 255 ) ;
	
	if handles.displayedImageButtonGroup.Children(2).Value
		handles.image.CData = createNewBW2( handles ) ;
	end
	
	guidata(hObject,handles)
end

function exportDisplayedImage_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	% Kill the timer object immediately
	if isfield(handles.time,'timer')
		try
			stop(handles.time.timer)
			delete(handles.time.timer)
		catch
			
		end
	end

%%%%% Start: Change Cursor to "Saving" Cursor
	set( handles.REAVER_Fig , 'Pointer' , 'watch' )
	drawnow
%%%%% End: Change Cursor to "Saving" Cursor

%%%%% Start: Create References to Variables to Save
	% I realize the following method for building this string seems
	% terribly overcomplicated, but it's the simplest solution I could
	% find to a problem which I could not identify
	imageName = join([handles.basePic.filename(1:(end-4)), strrep(string(datetime('now')),':','-')],' - ') ;
	imagePathAndName = handles.imageDirectory.directory + ( handles.slash + imageName + '.tif' ) ;
%%%%% End: Create References to Variables to Save

%%%%% Start: Save Image
	imwrite(handles.image.CData, imagePathAndName)
%%%%% End: Save Image


%%%%% Start: Change Cursor to Default Cursor
	set( handles.REAVER_Fig , 'Pointer' , 'arrow' )
	drawnow
%%%%% End: Change Cursor to Default Cursor

	guidata(hObject,handles)
end



%% Left Objects
function imageDirectoryTableSelection_Callback(hObject,eventdata)
	handles = guidata(hObject) ;
	
	% Confirming this callback wasn't triggered by "Save Data"
	if handles.dataSaving
		return
	end
	
%%%%% Start: Confirm Selection and Get Image File- and Path- name

	Value = eventdata.Indices ; % Retrieve Cell Selection(s)
	
	%---- Start: Change User Verification if Applicable
		if (size( Value , 1 ) == 1) && ( Value(1,2) == 3 )
			if hObject.Data{ Value(1) , 2 }
				hObject.Data{ Value(1) , 3 } = ~hObject.Data{ Value(1) , 3 } ;

				userVerified = [ handles.imageDirectory.validFiles , hObject.Data(:,3) ] ;

				save([handles.imageDirectory.directory,handles.slash,'User Verified Table.mat'],'userVerified')
				
				fixTableScroll(handles.imageDirectoryTable,Value(1))
				
			end

			return
		end
	%---- End: Change User Verification if Applicable
	
	%---- Start: Trim Cell Selection(s) to First Valid File Cell
		Value( Value(:,2)~=1 , : ) = [] ;
		Value( 2:end , : )		   = [] ;

		if isempty( Value ) % If no valid file cells are selected, return
			return
		end
	%---- End: Trim Cell Selection(s) to First Valid File Cell

	%---- Start: Confirm Desired Action
% 		if isequal( handles.saveDataButton.Enable , 'on' )
% 			confirmResponse = questdlg('This action will erase any unsaved data. Do you wish to proceed?', ...
% 									   'Confirm', ...
% 									   'Save and Leave' , 'Leave without saving' , 'No' , 'No' ) ;
% 			if isequal(confirmResponse,'No') || isempty(confirmResponse)
% 				return
% 			elseif isequal(confirmResponse,'Save and Leave')
% 				saveDataButton_Callback(handles.saveDataButton,1) ;
% 				handles = guidata(hObject) ;
% 			end
% 		end
	%---- End: Confirm Desired Action

	filename				   = handles.imageDirectory.validFiles{ Value(1) } ;
	pathname				   = [ handles.imageDirectory.directory , handles.slash ] ;
	
	handles.basePic.filename   = filename ;
	handles.lastImage = [] ;
%%%%% End: Confirm Selection and Get Image File- and Path- name

%%%%% Start: Determine if Data Already Exists and Execute Accordingly
	% Get the state of the displayed channels panel
		displayedChannels = ...
			logical(fliplr(cell2mat(get(handles.displayedChannelsPanel.Children,'Value'))')) ;

	%---- Start: DOES NOT EXIST
		if ~handles.imageDirectoryTable.Data{ Value(1) , 2 }

		%~~~~ Start: Read Image and Reset Constants
			% Getting the image info
			info = imfinfo([pathname,filename]) ;
			
			% If the image is a .tif file...
			if isequal(info(1).Format,'tif')
				% ...import it as a Tiff object
				warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
				t_file = Tiff([pathname,filename]) ;
				
				% Create a blank matrix for the image to go
				handles.basePic.data = [] ;
				
				% Read the image in channel by channel
				for i = 1:length(info)
					setDirectory(t_file,i)
					handles.basePic.data = cat(3, handles.basePic.data, im2uint8(read(t_file))) ;
				end
				warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning')
				
				% If the image only has 2 channels, create a 3rd 0 channel
				if size(handles.basePic.data,3) == 2
					handles.basePic.data(:,:,3) = 0 ;
				end
			else
				handles.basePic.data = imread([pathname,filename]) ;
			end
			
			% Checking if image is gray
			if size(handles.basePic.data,3)==1
				handles.grayImage = 1 ;
			else
				handles.grayImage = 0 ;
			end
			
			% (Dis/En)abling the channel checkboxes and radio buttons
			if handles.grayImage
				set( handles.displayedChannelsPanel.Children , 'Enable' , 'off' )
				handles.constants.selectedColors = [true,true,true] ;
				set( handles.displayedChannelsPanel.Children , 'Value' , 1 )
				set( handles.inputChannelButtonGroup.Children , 'Enable' , 'off' )
				
				handles.displayedChannelsImage = handles.basePic.data ;
			else
				set( handles.displayedChannelsPanel.Children , 'Enable' , 'on' )
				set( handles.inputChannelButtonGroup.Children , 'Enable' , 'on' )
				
				handles.displayedChannelsImage = handles.basePic.data ;
				handles.displayedChannelsImage(:,:,~displayedChannels) = 0 ;
			end
		%~~~~ End: Read Image and Reset Constants

		%~~~~ Start: Get Image Properties
			handles.basePic.ySize = size(handles.basePic.data,1) ;
			handles.basePic.xSize = size(handles.basePic.data,2) ;
			row = handles.basePic.ySize ;
			col = handles.basePic.xSize ;

			handles.borderImage	= zeros(row,col,'uint8') ;
			handles.borderImage(2:(row-1),2:(col-1)) = ones(row-2,col-2,'uint8') ;

			currentFigSize = handles.REAVER_Fig.Position ;
			currentFigSize(1:2) = [] ;
		%~~~~ End: Get Image Properties

		%~~~~ Start: Resize Axes Up or Down and Display Image
			if ~( (currentFigSize(2)-16) > row ) || ~( col/currentFigSize(1) < 0.6 )
				%---- This condition checks if (1) there are at least 16 pixels above
				%     and below the axis and (2) the new axis would take up no more
				%     than 60% of the new figure in the width dimension. (1) and (2)

				newWidth  = currentFigSize(1)*0.6 ;
				newHeight = currentFigSize(2)-16 ;

				if newHeight < row
					factor = newHeight/row ;
					row = row*factor ;
					col = col*factor ;
				end

				if newWidth < col
					factor = newWidth/col ;
					row = row*factor ;
					col = col*factor ;
				end

				row = round(row) ;
				col = round(col) ;
			end

			handles.REAVER_MainAx.Position = [(currentFigSize(1)/2)-(col/2),(currentFigSize(2)/2)-(row/2),col,row] ;

			handles.image = imagesc( handles.displayedChannelsImage , 'HitTest' , 'off' ) ;
			axis off
			axes( handles.REAVER_MainAx )
			handles.imageLoaded = 1 ;
		%~~~~ End: Resize Axes Up or Down and Display Image

		%~~~~ Start: Reset Derived Image
			handles.derivedPic					 = [] ;
			handles.derivedPic.branchpoints.line = plot([],[],'ro') ;
			handles.derivedPic.endpoints.line	 = plot([],[],'co') ;
			
			handles.imageSegmented = 0 ;
		%~~~~ End: Reset Derived Image
		
		%~~~~ Start: Determine Greyscale Image using only Selected Colors
			handles.derivedPic.selectedColors = handles.basePic.data ;

			if handles.grayImage
				handles.derivedPic.grey = double( handles.derivedPic.selectedColors ) ;
			else
				handles.derivedPic.selectedColors(:,:,~handles.constants.selectedColors) = 0 ;
				handles.derivedPic.grey = double( rgb2gray( handles.derivedPic.selectedColors ) ) ;
			end
		%~~~~ End: Determine Greyscale Image using only Selected Colors
		
		%~~~~ Start: Alter UIControl Properties
			set( handles.segmentationButton,'Enable','on' )
			handles.displayedImageButtonGroup.Children(8).Value = 1 ;
			set( handles.displayedImageButtonGroup.Children , 'Enable' , 'off' )
			set( handles.displayedImageButtonGroup.Children(6:8) , 'Enable' , 'on' )
			set( handles.saveDataButton , 'Enable' , 'off' )
			
			% De-enabling the export image menu ITEM
			exportDisplayedImageItem = findobj(handles.REAVER_Fig,'Tag','exportDisplayedImageItem') ;
			exportDisplayedImageItem.Enable = 'off' ;
		%~~~~ End: Alter UIControl Properties

		end
	%---- End: DOES NOT EXIST
	
	%---- Start: DOES EXIST
		if handles.imageDirectoryTable.Data{ Value(1) , 2 }
		%~~~~ Start: Load Data From File
			loadedData = load( [pathname,filename(1:(end-3)),'mat'] ) ;

			handles.constants = loadedData.constants ;

            % Set image resolution from loaded file
               set(handles.imageResolutionValueEdit,'String',...
                   loadedData.image_resolution);
			if ~isfield(handles.constants,'vesselThicknessThreshold')
				handles.constants.vesselThicknessThreshold = 3 ;
			end
			if ~isfield(handles.constants,'wireDilationThreshold')
				handles.constants.wireDilationThreshold = 0 ;
			end
			
			tempSelectedColors = [false,false,false] ;
			tempSelectedColors(handles.constants.selectedColors) = true ;
			handles.constants.selectedColors = tempSelectedColors ;
			handles.miscValues.colorMemory = tempSelectedColors ;
			handles.lastImage = 8 ;
		%~~~~ End: Load Data From File

		%~~~~ Start: Process Loaded Data
			%++++ Start: Change Cursor to "Loading" Cursor
				set( handles.REAVER_Fig , 'Pointer' , 'watch' )
				drawnow
			%++++ End: Change Cursor to "Loading" Cursor
			
			%++++ Start: Read Image
				% Getting the image info
				info = imfinfo([pathname,filename]) ;

				% If the image is a .tif file...
				if isequal(info(1).Format,'tif')
					% ...import it as a Tiff object
					warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
					t_file = Tiff([pathname,filename]) ;

					% Create a blank matrix for the image to go
					handles.basePic.data = [] ;

					% Read the image in channel by channel
					for i = 1:length(info)
						setDirectory(t_file,i)
						handles.basePic.data = cat(3, handles.basePic.data, im2uint8(read(t_file))) ;
					end
					warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning')
					% If the image only has 2 channels, create a 3rd 0 channel
					if size(handles.basePic.data,3) == 2
						handles.basePic.data(:,:,3) = 0 ;
					end
				else
					handles.basePic.data = imread([pathname,filename]) ;
				end
			%++++ End: Read Image

			%++++ Start: Checking if image is gray
				if (size(handles.basePic.data,3)==1)
					handles.grayImage = 1 ;
					set( handles.displayedChannelsPanel.Children , 'Enable' , 'off' )
					set( handles.displayedChannelsPanel.Children , 'Value' , 1 )
					set( handles.inputChannelButtonGroup.Children , 'Enable' , 'off' )
					
					handles.displayedChannelsImage = handles.basePic.data ;
				else
					handles.grayImage = 0 ;
					set( handles.displayedChannelsPanel.Children , 'Enable' , 'on' )
					set( handles.displayedChannelsPanel.Children(fliplr(tempSelectedColors)) , 'Value' , 1 )
					set( handles.displayedChannelsPanel.Children(fliplr(~tempSelectedColors)) , 'Value' , 0 )
					set( handles.inputChannelButtonGroup.Children , 'Enable' , 'on' )
					set( handles.inputChannelButtonGroup.Children(fliplr(tempSelectedColors)) , 'Value' , 1 )
					
					handles.displayedChannelsImage = handles.basePic.data ;
					handles.displayedChannelsImage(:,:,~tempSelectedColors) = 0 ;
				end
			%++++ End: Checking if image is gray
			
			%++++ Start: Get Image Properties
				handles.basePic.ySize = size(handles.basePic.data,1) ;
				handles.basePic.xSize = size(handles.basePic.data,2) ;

				currentFigSize = handles.REAVER_Fig.Position ;
				currentFigSize(1:2) = [] ;
			%++++ End: Get Image Properties

			%++++ Start: Reset Derived Image
				handles.derivedPic					 = [] ;
				handles.derivedPic.branchpoints.line = plot([],[],'ro','MarkerFaceColor','r') ;
				handles.derivedPic.endpoints.line	 = plot([],[],'co','MarkerFaceColor','c') ;
			%++++ End: Reset Derived Image

			%++++ Start: Perform First Stage of Image Segmentation
			if true
				%**** Start: Create Vectors Necessary for Proper Neighbor Tallying
					row = handles.basePic.ySize ;
					col = handles.basePic.xSize ;

					handles.borderImage	= zeros(row,col,'uint8') ;
					handles.borderImage(2:(row-1),2:(col-1)) = ones(row-2,col-2,'uint8') ;

					pR = [1 1:row-1] ;
					qR = [2:row row] ;
					pC = [1 1:col-1] ;
					qC = [2:col col] ;
				%**** End: Create Vectors Necessary for Proper Neighbor Tallying
				
				%**** Start: Determine Greyscale Image
					handles.derivedPic.selectedColors = handles.basePic.data ;

					if handles.grayImage
						handles.derivedPic.grey = double( handles.derivedPic.selectedColors ) ;
					else
						handles.derivedPic.selectedColors(:,:,~handles.constants.selectedColors) = 0 ;
						handles.derivedPic.grey = double( rgb2gray( handles.derivedPic.selectedColors ) ) ;
					end
				%**** End: Determine Greyscale Image

				%**** Start: Determine Greyscale Total Neighbor Values
					handles.derivedPic.greynbrs = ...
						handles.derivedPic.grey(:,pC)  + handles.derivedPic.grey(:,qC) + ...
						handles.derivedPic.grey(pR,:)  + handles.derivedPic.grey(qR,:) + ...
						handles.derivedPic.grey(pR,pC) + handles.derivedPic.grey(qR,qC) + ...
						handles.derivedPic.grey(pR,qC) + handles.derivedPic.grey(qR,pC);

					handles.derivedPic.greynbrs = handles.derivedPic.greynbrs / (255*8) ; % Each neighbor is 0-255 so you have to average and normalize
				%**** End: Determine Greyscale Total Neighbor Values

				%**** Start: Local Thresholding of Greyscale Neighbors to get First Binary Image
					handles.derivedPic.mean = 0.4*imfilter( handles.derivedPic.greynbrs , ...
						fspecial('average', [handles.constants.averagingFilterSize handles.constants.averagingFilterSize]) , 'symmetric' ) ;

					handles.derivedPic.BW_1 = ( handles.derivedPic.greynbrs - handles.derivedPic.mean ) > handles.constants.grey2BWthreshold ;
				%**** End: Local Thresholding of Greyscale Neighbors to get First Binary Image

				%**** Start: Determine Total Neighbor Values of First Binary Image
					handles.derivedPic.BW_1nbrs = ...
						handles.derivedPic.BW_1(:,pC)  + handles.derivedPic.BW_1(:,qC) + ...
						handles.derivedPic.BW_1(pR,:)  + handles.derivedPic.BW_1(qR,:) + ...
						handles.derivedPic.BW_1(pR,pC) + handles.derivedPic.BW_1(qR,qC) + ...
						handles.derivedPic.BW_1(pR,qC) + handles.derivedPic.BW_1(qR,pC);
					
					handles.derivedPic.BW_1nbrs = handles.derivedPic.BW_1nbrs > 3 ;
				%**** End: Determine Total Neighbor Values of First Binary Image

				%**** Start: Apply Loaded BW_2 to handles
					handles.derivedPic.BW_2 = loadedData.derivedPic.BW_2 ;
					handles.imageSegmented = 1 ;
				%**** End: Apply Loaded BW_2 to handles
			end
			%++++ End: Perform First Stage of Image Segmentation

			%++++ Start: Perform Second Stage of Image Segmentation
			if true
				%**** Start: Reset Previous Version Marker
					handles.editVariables.previousBackupState = 0 ;
				%**** End: Reset Previous Version Marker

				%**** Start: Apply Wire Image to handles
					handles.derivedPic.wire = full( loadedData.derivedPic.wire ) ;
				%**** End: Apply Wire Image to handles

				%**** Start: Find Branch and End Points
					[Bx,By] = deal( loadedData.derivedPic.branchpoints(:,1) , loadedData.derivedPic.branchpoints(:,2) ) ;
					[Ex,Ey] = deal( loadedData.derivedPic.endpoints(:,1) , loadedData.derivedPic.endpoints(:,2) ) ;

					handles.derivedPic.branchpoints.coords = [Bx,By] ;
					handles.derivedPic.endpoints.coords	   = [Ex,Ey] ;
				%**** End: Find Branch and End Points

				%++++ Start: Created Dilated Wire Images for Display Purposes
					handles.derivedPic.dilated  = uint8(imdilate( handles.derivedPic.wire , strel('disk',1) )) ;
					handles.derivedPic.dilated2 = uint8(imdilate( handles.derivedPic.wire , strel('disk',2) )) ;

					handles.derivedPic.newWire  = 1 ;
				%**** End: Created Dilated Wire Images for Display Purposes
			end
			%++++ End: Perform Second Stage of Image Segmentation


			%++++ Start: Update Displayed Image
				%**** Start: Resize Axes Up or Down
					if ~( (currentFigSize(2)-16) > row ) || ~( col/currentFigSize(1) < 0.6 )
						%---- This condition checks if (1) there are at least 16 pixels above
						%     and below the axis and (2) the new axis would take up no more
						%     than 60% of the new figure in the width dimension. (1) and (2)

						newWidth  = currentFigSize(1)*0.6 ;
						newHeight = currentFigSize(2)-16 ;

						if newHeight < row
							factor = newHeight/row ;
							row = row*factor ;
							col = col*factor ;
						end

						if newWidth < col
							factor = newWidth/col ;
							row = row*factor ;
							col = col*factor ;
						end

						row = round(row) ;
						col = round(col) ;
					end

					handles.REAVER_MainAx.Position = [(currentFigSize(1)/2)-(col/2),(currentFigSize(2)/2)-(row/2),col,row] ;
					handles.image = imagesc( createNewBW2( handles ) , 'HitTest' , 'off' ) ;
					axis off
					axes( handles.REAVER_MainAx )
					handles.imageLoaded = 1 ;
				%**** End: Resize Axes Up or Down

				%**** Start: Update Branch and End Point Line Objects
					hold on
						handles.derivedPic.branchpoints.line = plot(Bx,By,'ro','MarkerFaceColor','r') ;
						handles.derivedPic.endpoints.line	 = plot(Ex,Ey,'co','MarkerFaceColor','c') ;
					hold off
					handles.derivedPic.branchpoints.line.Visible = 'off' ;
					handles.derivedPic.endpoints.line.Visible = 'off' ;
				%**** Start: Update Branch and End Point Line Objects
			%++++ End: Update Displayed Image

			%++++ Start: Make Unedited Copies of the Segmented Data
				handles.uneditedDerivedPic = handles.derivedPic ;
				handles.previousDerivedPic = handles.derivedPic ;
				handles.editVariables.previousBackupState = 1 ;
			%++++ End: Make Unedited Copies of the Segmented Data

			%++++ Start: Reset Cursor to Default Cursor
				set( handles.REAVER_Fig , 'Pointer' , 'arrow' )
			%++++ End: Reset Cursor to Default Cursor

			%++++ Start: Alter Graphics Objects Properties
				set( handles.updateWireButton , 'Enable' , 'off' )
				set( handles.saveDataButton , 'Enable' , 'off' )
				set( handles.displayedImageButtonGroup.Children , 'Enable' , 'on' )
				set( handles.displayedImageButtonGroup.Children(2) , 'Value' , 1 )
				set( handles.segmentationButton,'Enable','off' )
				% Enabling the export image menu item
				exportDisplayedImageItem = ...
					findobj(handles.REAVER_Fig,'Tag','exportDisplayedImageItem') ;
				exportDisplayedImageItem.Enable = 'on' ;
			%++++ End: Alter Graphics Objects Properties
		%~~~~ End: Process Loaded Data
		end
	%---- End: DOES EXIST
	
%%%%% End: Determine if Data Already Exists and Execute Accordingly

%%%%% Start: Change UIControl Aspects
	imageDirectoryTableData = get(handles.imageDirectoryTable,'Data') ;

	set(handles.updateWireButton,'Enable','off') ;
	set(handles.undoLastEditButton,'Enable','off') ;
	handles.displayedImageButtonGroup.Title = imageDirectoryTableData{ Value(1) , 1 } ;
	
	%---- Start: Adjust Grey2Binary Slider and Edit Box
		currentNum = round(1e3*handles.constants.grey2BWthreshold)/1e3 ;

		if currentNum >= 0.2
			newXNum = (currentNum+0.6)/4 ;
		else
			newXNum = currentNum ;
		end
		
		segmentationButtonEnabled = get( handles.segmentationButton,'Enable' ) ;
		handles.constants.grey2BWthreshold = round(1e3*currentNum)/1e3 ;
		set(handles.grey2binaryThresholdSlider,'Value', round(1e3*newXNum)/1e3 )
		set(handles.grey2binaryThresholdSliderValue,'String',num2str( round(1e3*currentNum)/1e3 ))
		set(handles.segmentationButton,'Enable',segmentationButtonEnabled)
	%---- Start: Adjust Grey2Binary Slider and Edit Box
%%%%% End: Change UIControl Aspects

	guidata(hObject,handles)
end

function imageDirectoryTableEdit_Callback(hObject,eventdata)
	handles = guidata(hObject) ;
	
%%%%% Start: Confirm User Verification is Allowed, then Execute Change
	Value = eventdata.Indices ;
	if hObject.Data{ Value(1) , 2 }
		hObject.Data{ Value(1) , 3 } = ~hObject.Data{ Value(1) , 3 } ;

		userVerified = [ handles.imageDirectory.validFiles , hObject.Data(:,3) ] ;

		save([handles.imageDirectory.directory,handles.slash,'User Verified Table.mat'],'userVerified')
	else
		hObject.Data{ Value(1) , 3 } = eventdata.PreviousData ;
	end
%%%%% End: Confirm User Verification is Allowed, then Execute Change

	fixTableScroll(handles.imageDirectoryTable,Value(1))

	guidata(hObject,handles)
end


function segmentationButton_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Move Focus Around
	set(hObject, 'Enable', 'off') ;
	drawnow;
	set(hObject, 'Enable', 'on') ;
%%%%% End: Move Focus Around

%%%%% Start: Change Cursor to "Loading" Cursor
	set( handles.REAVER_Fig , 'Pointer' , 'watch' )
	drawnow
%%%%% End: Change Cursor to "Loading" Cursor
	
%%%%% Start: Call External Image Segmentation Function
	newHandles = segmentImage( handles ) ;
	
	if isequal(newHandles,-1)
		set( handles.REAVER_Fig , 'Pointer' , 'arrow' )
		return
	else
		handles = newHandles ;
		handles.miscValues.colorMemory = ...
			logical(fliplr(cell2mat(get(handles.inputChannelButtonGroup.Children,'Value'))')) ;
	end
%%%%% End: Call External Image Segmentation Function

%%%%% Start: Make Unedited Copies of the Segmented Data
	handles.uneditedDerivedPic = handles.derivedPic ;
	handles.previousDerivedPic = handles.derivedPic ;
	handles.editVariables.previousBackupState = 1 ;
%%%%% End: Make Unedited Copies of the Segmented Data

%%%%% Start: Reset Cursor to Default Cursor
	set( handles.REAVER_Fig , 'Pointer' , 'arrow' )
%%%%% End: Reset Cursor to Default Cursor

%%%%% Start: Alter UIControl Properties
	set( handles.segmentationButton , 'Enable' , 'off' )
	set( handles.updateWireButton , 'Enable' , 'off' )
	set( handles.undoLastEditButton , 'Enable' , 'off' )
	
	% Changes are conditioned on if the segmentation was "successful"
	if isfield(handles.derivedPic.branchpoints,'line')
		if isempty(handles.derivedPic.branchpoints.line) || ...
				isempty(handles.derivedPic.branchpoints.line.XData)
			% Turning off the derived images display options
			set( handles.displayedImageButtonGroup.Children , 'Enable', 'off' )
			set( handles.displayedImageButtonGroup.Children(6:8) , 'Enable' , 'on' )
			% Turning off the save data button and export image menu item
			set( handles.saveDataButton , 'Enable' , 'off' )
			exportDisplayedImageItem = ...
				findobj(handles.REAVER_Fig,'Tag','exportDisplayedImageItem') ;
			exportDisplayedImageItem.Enable = 'off' ;
		else
			% Turning on the derived images display options
			set( handles.displayedImageButtonGroup.Children , 'Enable' , 'on' )
			% Turning on the save data button and export image menu item
			set( handles.saveDataButton , 'Enable' , 'on' )
			exportDisplayedImageItem = ...
				findobj(handles.REAVER_Fig,'Tag','exportDisplayedImageItem') ;
			exportDisplayedImageItem.Enable = 'on' ;
			
			handles.image.CData = createNewBW2( handles ) ;
			handles.displayedImageButtonGroup.Children(2).Value = 1 ;
			drawnow
			
			handles.lastImage = 8 ;
			
			handles.imageSegmented = 1 ;
		end	
	end
%%%%% End: Alter UIControl Properties

if handles.time.time_trials
	%%%%% Start: Initialize the timer object
		% Make a new folder for the snapshot data files
		warning('off','MATLAB:MKDIR:DirectoryExists')
		eval(sprintf('mkdir ''%s'' %s',handles.imageDirectory.directory,handles.basePic.filename(1:(end-4))))
		warning('on','MATLAB:MKDIR:DirectoryExists')

		% Create the timer object and attach it to the handles
		if isfield(handles,'timer')
			delete(handles.timer)
		end
		handles.time.timer = timer('BusyMode', 'queue', 'ExecutionMode','fixedRate', 'Period', 30,...
							  'TimerFcn', {@saveImageData,gcbf}, 'StartDelay', 30);

		% Start the timer
		handles.time.time_elapsed = tic ;	  
						  
		% Update the handles
		guidata(hObject,handles)

		% Call the timer callback function to initialize to avoid having to
		% make a timer start function
		saveImageData(0,0,gcbf)

		% Start the timer object
		start(handles.time.timer)
		
	%%%%% End: Initialize the timer object
else
		% Update the handles
		guidata(hObject,handles)
end

end


function displayedImageButtonGroupSelectionChanged(hObject,eventdata)
	handles = guidata(hObject) ;
	
%%%%% Start: Move Focus Around, Preserving Wire Frame Enable Status
	enabledButtons = cellfun(@(c) isequal(c,'on'),get(hObject.Children,'Enable')) ;
	set(hObject.Children, 'Enable', 'off') ;
	drawnow
	set(hObject.Children(enabledButtons), 'Enable', 'on') ;
%%%%% End: Move Focus Around, Preserving Wire Frame Enable Status
	
%%%%% Start: Hide Branch and End Points
	if isfield(handles.derivedPic.branchpoints,'line')
		if ~isempty(handles.derivedPic.branchpoints.line)
			handles.derivedPic.branchpoints.line.Visible = 'off' ;
			handles.derivedPic.endpoints.line.Visible	 = 'off' ;
		end
	end
%%%%% End: Hide Branch and End Points
	
%%%%% Start: Get Last Image
		switch strtrim( eventdata.OldValue.String )
			case 'Displayed Channels'
				handles.lastImage = 8 ;
				
			case 'Input Channel'
				handles.lastImage = 7 ;
				
			case 'Grey'
				handles.lastImage = 6 ;
				
			case 'Grey Neighbors'
				handles.lastImage = 5 ;
				
			case 'First Binary'
				handles.lastImage = 4 ;
				
			case 'First Binary Neighbors'
				handles.lastImage = 3 ;
				
			case 'Second Binary'
				handles.lastImage = 2 ;
				
			case 'Wire Frame'
				handles.lastImage = 1 ;
				
		end
%%%%% End: Get Last Image

%%%%% Start: Display New Image
		switch strtrim( eventdata.NewValue.String )
			case 'Displayed Channels'
				handles.image.CData = handles.displayedChannelsImage ;
				
			case 'Input Channel'
				handles.image.CData = handles.derivedPic.selectedColors ;
				
			case 'Grey'
				handles.image.CData = handles.derivedPic.grey ;
				
			case 'Grey Neighbors'
				handles.image.CData = handles.derivedPic.greynbrs ;
				
			case 'First Binary'
				handles.image.CData = handles.derivedPic.BW_1 ;
				
			case 'First Binary Neighbors'
				handles.image.CData = handles.derivedPic.BW_1nbrs ;
				
			case 'Second Binary'
				handles.image.CData = createNewBW2( handles ) ;
				
			case 'Wire Frame'
				handles.image.CData = imdilate( handles.derivedPic.wire , strel('disk',2) ) ;

				handles.derivedPic.branchpoints.line.Visible = 'on' ;
				handles.derivedPic.endpoints.line.Visible = 'on' ;
				
		end
%%%%% End: Display New Image

	guidata(hObject,handles)
end



%% Right Objects
function updateWireButton_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Move Focus Around
	set(hObject, 'Enable', 'off');
	drawnow;
	set(hObject, 'Enable', 'on');
%%%%% End: Move Focus Around


%%%%% Start: Call External Update Wire Function
	handles = updateWire(handles) ;
%%%%% End: Call External Update Wire Function


%%%%% Start: Alter Graphics Objects Properties
	set( handles.updateWireButton , 'Enable' , 'off' )
	set( handles.undoLastEditButton , 'Enable' , 'on' )
	set( handles.saveDataButton , 'Enable' , 'on' )
	exportDisplayedImageItem = ...
		findobj(handles.REAVER_Fig,'Tag','exportDisplayedImageItem') ;
	exportDisplayedImageItem.Enable = 'on' ;
	set( handles.displayedImageButtonGroup.Children(1) , 'Enable' , 'on' ) ;
	set( handles.displayedImageButtonGroup.Children(2) , 'Value' , 1 ) ;
%%%%% End: Alter Graphics Objects Properties

	guidata(hObject,handles)
end

function undoLastEditButton_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Move Focus Around
	set(hObject, 'Enable', 'off');
	drawnow;
	set(hObject, 'Enable', 'on');
%%%%% End: Move Focus Around

%%%%% Start: Reset Data to Previous
	handles.derivedPic = handles.previousDerivedPic ;

	handles.derivedPic.branchpoints.line.XData = handles.derivedPic.branchpoints.coords(:,1) ;
	handles.derivedPic.branchpoints.line.YData = handles.derivedPic.branchpoints.coords(:,2) ;

	handles.derivedPic.endpoints.line.XData = handles.derivedPic.endpoints.coords(:,1) ;
	handles.derivedPic.endpoints.line.YData = handles.derivedPic.endpoints.coords(:,2) ;
%%%%% End: Reset Data to Previous

%%%%% Start: Update Displayed Image if Necessary
	currentImage = arrayfun( @(x) x.Value , handles.displayedImageButtonGroup.Children ) ;
	currentImage = 9 - find( currentImage ) ;

	switch currentImage
		case 7
			handles.image.CData = createNewBW2( handles ) ;

		case 8
			handles.image.CData = imdilate( handles.derivedPic.wire , strel('disk',2) ) ;

			handles.derivedPic.branchpoints.line.Visible = 'on' ;
			handles.derivedPic.endpoints.line.Visible = 'on' ;
	end

	drawnow
%%%%% End: Update Displayed Image if Necessary

%%%%% Start: Alter Graphics Objects Properties
	set( handles.updateWireButton , 'Enable' , 'off' )
	set( handles.undoLastEditButton , 'Enable' , 'off' )
	set( handles.displayedImageButtonGroup.Children(1) , 'Enable' , 'on' )
	set( handles.saveDataButton , 'Enable' , 'on' )
	exportDisplayedImageItem = ...
		findobj(handles.REAVER_Fig,'Tag','exportDisplayedImageItem') ;
	exportDisplayedImageItem.Enable = 'on' ;
%%%%% End: Alter Graphics Objects Properties

	guidata(hObject,handles)
end


function editSizeSlider_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Move Focus Around
	set(hObject, 'Enable', 'off');
	drawnow;
	set(hObject, 'Enable', 'on');
%%%%% End: Move Focus Around
	
%%%%% Start: Quantize Slider Value and Update Value Text
	currentSliderValue = get(hObject,'Value') ;
	newSliderValue	   = round( currentSliderValue ) ;

	set(hObject,'Value',newSliderValue)
	set(handles.editSizeSliderValue,'String',num2str( newSliderValue + 1 ))
%%%%% End: Quantize Slider Value and Update Value Text

%%%%% Start: Adjust Pixel Editor Neighbors Size
	handles.editVariables.pixelEditNeighbors = newSliderValue ;
%%%%% End: Adjust Pixel Editor Neighbors Size

	% Halve the size for the purpose of making the cursor visual work
	newSliderValue = floor(newSliderValue/2) ;

%%%%% Start: Change Cursor Data if Applicable
	if isequal( handles.REAVER_Fig.Pointer , 'custom' )
		handles.REAVER_Fig.PointerShapeCData = nan(16) ;
		handles.REAVER_Fig.PointerShapeCData( (8-newSliderValue):(8+newSliderValue) , ...
			(8-newSliderValue):(8+newSliderValue) ) = 2 ;
	end
%%%%% End: Change Cursor Data if Applicable

	guidata(hObject,handles)
end


function imageResolutionValueEdit_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Validating the new value
	image_resolution = str2double(hObject.String) ;
	
	% IS NOT a new value
	if isnan(image_resolution) || isinf(image_resolution) || (image_resolution<=0)
		image_resolution = handles.miscValues.oldResolution ;
		
	% IS a new value
	else
		save([getappdata(0,'proj_path') '/temp/default_image_resolution.mat'],...
            'image_resolution')
        % Allow for user to save data with new resolution
        set(handles.saveDataButton,'enable','on');
	end
	
	hObject.String = num2str( image_resolution ) ;
	handles.miscValues.oldResolution = image_resolution ;
	
	guidata(hObject,handles)
end


function grey2binarySliderDrag_Callback(~, eventdata)
	handles = guidata(eventdata.AffectedObject) ;
	
	currentSliderValue = get(eventdata.AffectedObject,'Value') ;
	handles = grey2binarySliderUpdater(handles,currentSliderValue) ;

	guidata(eventdata.AffectedObject,handles)
end

function grey2binaryThresholdSlider_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	currentSliderValue = get(hObject,'Value') ;
	handles = grey2binarySliderUpdater(handles,currentSliderValue) ;
	
	guidata(hObject,handles)
end

function grey2binaryThresholdSliderValue_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Correct string value and update string and slider
	currentString = hObject.String ;
	currentNum = str2double(currentString) ;
	currentXSliderValue = handles.grey2binaryThresholdSlider.Value ;
	
	if isnan(currentNum) || isinf(currentNum) || (currentNum<0) || (currentNum>1)
		newXNum = currentXSliderValue ;
		if newXNum <= 0.2
			newNum = newXNum ;
		else
			newNum = 4*newXNum - 0.6 ;
		end
	else
		if currentNum >= 0.2
			newXNum = (currentNum+0.6)/4 ;
		else
			newXNum = currentNum ;
		end
		
		newNum = currentNum ;
	end
	
	
	handles.constants.grey2BWthreshold = round(1e3*newNum)/1e3 ;
	
	handles.grey2binaryThresholdSlider.Value = round(1e3*newXNum)/1e3 ;
	hObject.String = num2str( round(1e3*newNum)/1e3 ) ;
	
	if handles.imageLoaded
		set(handles.segmentationButton,'Enable','on') ;
	end
%%%%% End: Correct string value and update string and slider
	
	guidata(hObject,handles)
end


function redChannelCheckbox_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	displayedChannels = logical(fliplr(cell2mat(get(hObject.Parent.Children,'Value'))')) ;
	
	% Undoing the change if it would leave none selected
	if ~sum(displayedChannels)
		hObject.Value = 1 ;
		guidata(hObject,handles)
		return
	end
	
	% If "Displayed Channels" is enabled
	if isequal(handles.displayedImageButtonGroup.Children(8).Enable,'on')
		handles.displayedChannelsImage = handles.basePic.data ;
		handles.displayedChannelsImage(:,:,~displayedChannels) = 0 ;
	else
		guidata(hObject,handles)
		return
	end
	
	handles.image.CData = handles.displayedChannelsImage ;
	handles.displayedImageButtonGroup.Children(8).Value = 1 ;
	drawnow
	
	guidata(hObject,handles)
end

function greenChannelCheckbox_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	displayedChannels = logical(fliplr(cell2mat(get(hObject.Parent.Children,'Value'))')) ;
	
	% Undoing the change if it would leave none selected
	if ~sum(displayedChannels)
		hObject.Value = 1 ;
		guidata(hObject,handles)
		return
	end
	
	% If "Displayed Channels" is enabled
	if isequal(handles.displayedImageButtonGroup.Children(8).Enable,'on')
		handles.displayedChannelsImage = handles.basePic.data ;
		handles.displayedChannelsImage(:,:,~displayedChannels) = 0 ;
	else
		guidata(hObject,handles)
		return
	end
	
	handles.image.CData = handles.displayedChannelsImage ;
	handles.displayedImageButtonGroup.Children(8).Value = 1 ;
	drawnow
	
	guidata(hObject,handles)
end

function blueChannelCheckbox_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	displayedChannels = logical(fliplr(cell2mat(get(hObject.Parent.Children,'Value'))')) ;
	
	% Undoing the change if it would leave none selected
	if ~sum(displayedChannels)
		hObject.Value = 1 ;
		guidata(hObject,handles)
		return
	end
	
	% If "Displayed Channels" is enabled
	if isequal(handles.displayedImageButtonGroup.Children(8).Enable,'on')
		handles.displayedChannelsImage = handles.basePic.data ;
		handles.displayedChannelsImage(:,:,~displayedChannels) = 0 ;
	else
		guidata(hObject,handles)
		return
	end
	
	handles.image.CData = handles.displayedChannelsImage ;
	handles.displayedImageButtonGroup.Children(8).Value = 1 ;
	drawnow
	
	guidata(hObject,handles)
end


function inputChannelButtonGroupSelectionChanged(hObject,eventdata)
	handles = guidata(hObject) ;

%%%%% Start: Set new selected channel
	switch strtrim( eventdata.NewValue.String )
		case 'Red'
			handles.constants.selectedColors = [true,false,false] ;
		case 'Green'
			handles.constants.selectedColors = [false,true,false] ;			
		case 'Blue'
			handles.constants.selectedColors = [false,false,true] ;			
	end
%%%%% End: Set new selected channel
	
	% If "Displayed Channels" is enabled, adjust the selected channels
	% image and the grey image
	if isequal(handles.displayedImageButtonGroup.Children(8).Enable,'on')
		handles.derivedPic.selectedColors = handles.basePic.data ;
		handles.derivedPic.selectedColors(:,:,~handles.constants.selectedColors) = 0 ;
		handles.derivedPic.grey = double( rgb2gray( handles.derivedPic.selectedColors ) ) ;
	else
		guidata(hObject,handles)
		return
	end
	
	% Change the displayed image to the selected colors but don't update
	handles.image.CData = handles.derivedPic.selectedColors ;
	handles.displayedImageButtonGroup.Children(7).Value = 1 ;
	
	% Turn on the segmentation button and off the derived image buttons
	set( handles.segmentationButton , 'Enable' , 'on' )
	set( handles.displayedImageButtonGroup.Children(1:5) , 'Enable' , 'off' )
	
	% If the image isn't segmented, return
	if ~handles.imageSegmented
		guidata(hObject,handles)
		return
	end
	
	% If the new selection matches the segmented selection, revert to the
	% segmented image
	if isequal(handles.constants.selectedColors,handles.miscValues.colorMemory)
		handles.image.CData = createNewBW2( handles ) ;
		handles.displayedImageButtonGroup.Children(2).Value = 1 ;
		
		set( handles.segmentationButton , 'Enable' , 'off' )
		set( handles.displayedImageButtonGroup.Children(1:5) , 'Enable' , 'on' )
	end
	
	% Update the image
	drawnow
	
	guidata(hObject,handles)
end


function settingsButton_Callback(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Move Focus Around
	set(hObject, 'Enable', 'off');
	drawnow;
	set(hObject, 'Enable', 'on');
%%%%% End: Move Focus Around

%%%%% Start: Create Prompt Values
	
	%---- Start: Create Prompt
		prompt = {'Averaging Filter Size :',...
				  'Minimum Connected Component Area :'...
				  'Wire Dilation Threshold :'...
				  'Vessel Thickness Threshold:'};

		name = 'Settings' ;
		numlines = [1 40] ;
	%---- End: Create Prompt
		
	%---- Start: Create Default Response
		defaultResponse = [{handles.constants.averagingFilterSize};...
						   {handles.constants.minCCArea};...
						   {handles.constants.wireDilationThreshold};...
						   {handles.constants.vesselThicknessThreshold}] ;
		
		defaultResponse = cellfun( @num2str , defaultResponse , 'UniformOutput' , false ) ;
	%---- End: Create Default Response
		
%%%%% End: Create Prompt Values

%%%%% Start: Prompt and Check Response Validity
	answer = inputdlg( prompt , name , numlines , defaultResponse ) ;

	if isempty( answer )
		return
	end

	answer = cellfun( @str2double , answer , 'UniformOutput' , false ) ;

	logicalChecks = cellfun( @(x) sum( isnan(x) | ~isnumeric(x) ) , answer , 'UniformOutput' , 0 ) ;
	logicalChecks = cell2mat( logicalChecks ) ;

	if sum( logicalChecks )
		return
	end
%%%%% End: Prompt and Check Response Validity

%%%%% Start: Assign Outputs to Proper Fields
	fields = [{'averagingFilterSize'};...
			  {'minCCArea'};...
			  {'wireDilationThreshold'};...
			  {'vesselThicknessThreshold'}] ;

	for i = 1:length(fields)
		handles.constants.(fields{i}) = answer{i} ;
	end
%%%%% End: Assign Outputs to Proper Fields
		
%%%%% Start: Alter Graphics Objects Properties
	if isequal( handles.displayedImageButtonGroup.Children(1).Enable , 'on' )
		set(handles.segmentationButton,'Enable','on')
	end
	
	set( handles.saveDataButton , 'Enable' , 'off' )
	
	if handles.imageLoaded
		set(handles.segmentationButton,'Enable','on') ;
	end
%%%%% End: Alter Graphics Objects Properties

	guidata(hObject,handles)
end


function saveDataButton_Callback(hObject,~)
	handles = guidata(hObject) ;
	
	% Kill the timer object immediately
	if isfield(handles.time,'timer')
		try
			stop(handles.time.timer)
			delete(handles.time.timer)
		catch
			
		end
	end

%%%%% Start: Move Focus Around
	set(hObject, 'Enable', 'off');
	drawnow;
	set(hObject, 'Enable', 'on');
%%%%% End: Move Focus Around
	
%%%%% Start: Change Cursor to "Saving" Cursor
	set( handles.REAVER_Fig , 'Pointer' , 'watch' )
	drawnow
%%%%% End: Change Cursor to "Saving" Cursor
	
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
	saveVariables.derivedPic.wire		  = handles.derivedPic.wire ;
	
	saveVariables.metrics.vesselLength	  = sum(full(handles.derivedPic.wire(:))) ;
	saveVariables.metrics.vesselArea	  = sum((handles.derivedPic.BW_2(:))) ;
	saveVariables.metrics.numBranchPoints = max(size(handles.derivedPic.branchpoints.coords)) ;
	saveVariables.metrics.meanVesselDiam  = meanVesselDiameter ;
	
	saveVariables.constants				  = handles.constants ;
	saveVariables.image_resolution		  = str2double(handles.imageResolutionValueEdit.String) ;
	
	saveVariables.imageSize				  = [ handles.basePic.ySize , handles.basePic.xSize ] ; 
%%%%% End: Create References to Variables to Save


if handles.time.time_trials
	% Find the time elapsed
	time_elapsed = num2str(toc(handles.time.time_elapsed),'%05.0f') ;
	
	%%%%% Start: Save Relevant Data		
		save( [ handles.imageDirectory.directory , handles.slash , handles.basePic.filename(1:(end-4)) , ...
				handles.slash , time_elapsed , '.mat' ] , '-struct' , 'saveVariables' ) ;
	%%%%% End: Save Relevant Data
else
	%%%%% Start: Save Relevant Data		
		save( [ handles.imageDirectory.directory , handles.slash , handles.basePic.filename(1:(end-4)) , '.mat' ] , '-struct' , 'saveVariables' ) ;
	%%%%% End: Save Relevant Data


	%%%%% Start: Change an "Exisitng Data" Cell, if Applicable
		[Lia,Locb] = ismember( handles.basePic.filename , handles.imageDirectory.validFiles ) ;

		if Lia
			handles.imageDirectoryTable.Data{ Locb , 2 } = true ;
		end
		
		% This prevents the scroll fixing from calling the table callback
		handles.dataSaving = 1 ;
		guidata(hObject,handles)
			fixTableScroll(handles.imageDirectoryTable,Locb)
		handles = guidata(hObject) ;
		handles.dataSaving = 0 ;
		
	%%%%% End: Change an "Exisitng Data" Cell, if Applicable
end

%%%%% Start: Change Cursor to Default Cursor
	set( handles.REAVER_Fig , 'Pointer' , 'arrow' )
	drawnow
%%%%% End: Change Cursor to Default Cursor

%%%%% Start: Move Focus Around
	set(handles.segmentationButton,'Enable','off')
	set(handles.saveDataButton,'Enable','off')
	uitable(handles.imageDirectoryTable) ;
%%%%% End: Move Focus Around

	guidata(hObject,handles)
end



%% Figure Callbacks

function figButtonDown(hObject,~)
	handles = guidata(hObject) ;

%%%%% Start: Get Clicktype
	clickType = get(hObject,'SelectionType') ;
%%%%% End: Get Clicktype

	row = handles.basePic.ySize;
	col = handles.basePic.xSize;

if isequal( clickType , 'normal' ) % Left Click
	%%%%% Start: Create Previous Backup if Necessary
		if ~handles.editVariables.previousBackupState
			handles.previousDerivedPic = handles.derivedPic ;
			handles.editVariables.previousBackupState = 1 ;
		end
	%%%%% End: Create Previous Backup if Necessary

	%%%%% Start: Get Cursor Location
		clickedPoint	  = round( handles.REAVER_MainAx.CurrentPoint ) ;
		clickedPoint(2,:) = [] ;
		clickedPoint(3) = [] ;
	%%%%% End: Get Cursor Location

	%%%%% Start: Initialize Color Changing
		if handles.displayedImageButtonGroup.Children(2).Value && ~sum( clickedPoint > [col,row] ) && ~sum( clickedPoint < 1 )

		%---- Start: Enable Buttons and Un-Enable Wire Image
			handles.updateWireButton.Enable		   = 'on' ;
			handles.undoLastEditButton.Enable	   = 'on' ;
			handles.displayedImageButtonGroup.Children(1).Enable = 'off' ;
		%---- End: Enable Segmentation Button and Un-Enable Wire Image

		%---- Start: Update Edit Variables
			handles.editVariables.heldDown   = 1 ;
			handles.editVariables.pixelColor = 0 ;
		%---- End: Update Edit Variables

		%---- Start: Determine and Toggle Relevant Pixels
			[X,Y] = meshgrid( ...
							  ( (clickedPoint(1)-(handles.editVariables.pixelEditNeighbors)) : ...
							    (clickedPoint(1)+(handles.editVariables.pixelEditNeighbors)))' , ...
							  ( (clickedPoint(2)-(handles.editVariables.pixelEditNeighbors)) : ...
							    (clickedPoint(2)+(handles.editVariables.pixelEditNeighbors)))' ) ;

			X = reshape( X , numel(X) , 1 ) ;
			Y = reshape( Y , numel(Y) , 1 ) ;

			relevantPixels = [ Y , X ] ;
			relevantPixels( (Y<1)|(Y>row)|(X<1)|(X>col) , : ) = [] ;

			handles.derivedPic.BW_2( relevantPixels(:,1) , relevantPixels(:,2) ) = ~handles.editVariables.pixelColor ;
		%---- End: Determine and Toggle Relevant Pixels
		
		%---- Start: Update Displayed Image
			handles.image.CData = createNewBW2( handles ) ;
		%---- End: Update Displayed Image
		
		% Setting the last edited point as the current point
		handles.lastPoint = clickedPoint ;

		%---- Start: Alter Graphics Objects Properties
			set( handles.saveDataButton , 'Enable' , 'off' )
		%---- End: Alter Graphics Objects Properties

		end
	%%%%% End: Initialize Color Changing
	
	handles.REAVER_Fig.PointerShapeCData = 2+(0*handles.REAVER_Fig.PointerShapeCData) ;
	
elseif isequal( clickType , 'alt' ) % Right Click
	%%%%% Start: Create Previous Backup if Necessary
		if ~handles.editVariables.previousBackupState
			handles.previousDerivedPic = handles.derivedPic ;
			handles.editVariables.previousBackupState = 1 ;
		end
	%%%%% End: Create Previous Backup if Necessary

	%%%%% Start: Get Cursor Location
		clickedPoint	  = round( handles.REAVER_MainAx.CurrentPoint ) ;
		clickedPoint(2,:) = [] ;
		clickedPoint(3) = [] ;
	%%%%% End: Get Cursor Location

	%%%%% Start: Initialize Color Changing
		if handles.displayedImageButtonGroup.Children(2).Value && ~sum( clickedPoint > clickedPoint > [col,row] ) && ~sum( clickedPoint < 1 )

		%---- Start: Enable Buttons and Un-Enable Wire Image
			handles.updateWireButton.Enable		   = 'on' ;
			handles.undoLastEditButton.Enable	   = 'on' ;
			handles.displayedImageButtonGroup.Children(1).Enable = 'off' ;
		%---- End: Enable Segmentation Button and Un-Enable Wire Image

		%---- Start: Update Edit Variables
			handles.editVariables.heldDown   = 1 ;
			handles.editVariables.pixelColor = 1 ;
		%---- End: Update Edit Variables

		%---- Start: Determine and Toggle Relevant Pixels
			[X,Y] = meshgrid( ...
							  ( (clickedPoint(1)-(handles.editVariables.pixelEditNeighbors)) : ...
							    (clickedPoint(1)+(handles.editVariables.pixelEditNeighbors)))' , ...
							  ( (clickedPoint(2)-(handles.editVariables.pixelEditNeighbors)) : ...
							    (clickedPoint(2)+(handles.editVariables.pixelEditNeighbors)))' ) ;

			X = reshape( X , numel(X) , 1 ) ;
			Y = reshape( Y , numel(Y) , 1 ) ;

			relevantPixels = [ Y , X ] ;
			relevantPixels( (Y<1)|(Y>row)|(X<1)|(X>col) , : ) = [] ;

			handles.derivedPic.BW_2( relevantPixels(:,1) , relevantPixels(:,2) ) = ~handles.editVariables.pixelColor ;
		%---- End: Determine and Toggle Relevant Pixels

		%---- Start: Update Displayed Image
			handles.image.CData = createNewBW2( handles ) ;
		%---- End: Update Displayed Image
		
		% Setting the last edited point as the current point
			handles.lastPoint = clickedPoint ;
		
		%---- Start: Alter Graphics Objects Properties
			set( handles.saveDataButton , 'Enable' , 'off' )
		%---- End: Alter Graphics Objects Properties

		end
	%%%%% End: Initialize Color Changing
	
	handles.REAVER_Fig.PointerShapeCData = 2+(0*handles.REAVER_Fig.PointerShapeCData) ;

elseif isequal( clickType , 'extend' ) % Scroll Click
	%%%%% Start: Edit Pan Variables
		handles.panEnabled    = 1 ;
		
		origXLim = handles.REAVER_MainAx.XLim ;
		origYLim = handles.REAVER_MainAx.YLim ;

		orig_limits  = [origXLim,origYLim] ;
		
		clickedPoint = round( handles.REAVER_Fig.CurrentPoint ) ;
		handles.panVariables.originalPoint = clickedPoint ;
		handles.panVariables.rulerLengths  = handles.REAVER_MainAx.GetLayoutInformation.PlotBox(3:4) ;
		handles.panVariables.originalLimts = orig_limits ;
	%%%%% End: Edit Pan Variables
	
	%%%%% Start: Store Old Cursor Shape and Set it to Hand
		handles.oldCursor.type = handles.REAVER_Fig.Pointer ;
		if isequal( handles.oldCursor.type , 'Custom' )
			handles.oldCursor.cdata   = handles.REAVER_Fig.PointerShapeCData ;
			handles.oldCursor.hotspot = handles.REAVER_Fig.PointerShapeHotSpot ;
		end
		
		handles.REAVER_Fig.Pointer = 'hand' ;
	%%%%% End: Store Old Cursor Shape and Set it to Hand
end

	guidata(hObject,handles)
end

function figButtonUp(hObject,~)
	handles = guidata(hObject) ;

	handles.editVariables.heldDown = 0 ;
	
	%%%%% Start: Reset Pan Enabled Variable and Pointer Data
		if handles.panEnabled
			handles.panEnabled = 0 ;
			handles.REAVER_Fig.Pointer = handles.oldCursor.type ;
			if isequal( handles.oldCursor.type , 'Custom' )
				handles.REAVER_Fig.PointerShapeCData	= handles.oldCursor.cdata ;
				handles.REAVER_Fig.PointerShapeHotSpot = handles.oldCursor.hotspot ;
			end
		end
	%%%%% End: Reset Pan Enabled Variable and Pointer Data

	guidata(hObject,handles)
end

function figButtonMotion(hObject,~)
	handles = guidata(hObject);

	currentPoint	  = round( handles.REAVER_MainAx.CurrentPoint ) ;
	currentPoint(2,:) = [] ;
	currentPoint(3) = [] ;
	
	row = handles.basePic.ySize;
	col = handles.basePic.xSize;
	
%%%%% Start: Pan
	if handles.panEnabled && handles.imageLoaded
		currentFigPoint	  = handles.REAVER_Fig.CurrentPoint ;

		orig_limits  = handles.panVariables.originalLimts ;
		bound_limits = [0.5,col+0.5,0.5,row+0.5] ;
		
		pixelDiff	 = currentFigPoint - handles.panVariables.originalPoint ;
		pixelDiff(2) = -pixelDiff(2);

		if handles.versionNew
			new_limits = matlab.graphics.interaction.internal.pan.panFromPixelToPixel2D(...
				handles.panVariables.originalLimts,...
				pixelDiff,...
				handles.panVariables.rulerLengths) ;
		else
			new_limits = matlab.graphics.interaction.internal.pan.panFromPixelToPixel2D(...
				handles.panVariables.originalLimts,...
				pixelDiff,...
				handles.panVariables.rulerLengths,...
				[false;false;false],...
				[false;false;false]) ;
		end
		
        if bound_limits(1) <= orig_limits(1) && bound_limits(2) >= orig_limits(2) &&...
                bound_limits(3) <= orig_limits(3) && bound_limits(4) >= orig_limits(4)
            
            new_limits(1:2) = matlab.graphics.interaction.internal.boundLimits(new_limits(1:2), bound_limits(1:2), true);
            new_limits(3:4) = matlab.graphics.interaction.internal.boundLimits(new_limits(3:4), bound_limits(3:4), true);
        end
		
		matlab.graphics.interaction.validateAndSetLimits(handles.REAVER_MainAx, new_limits(1:2), new_limits(3:4));
		drawnow update;
		
	end
%%%%% End: Pan
	
%%%%% Start: Toggle Pixels if Cursor is Held Down
	if handles.editVariables.heldDown

		% Blank mask onto which we will draw the relevant pixels
		binaryImage = zeros(row,col,'logical') ;
		
		% Getting the end coordinates of the line segment
		x = [handles.lastPoint(1);currentPoint(1)] ;
		y = [handles.lastPoint(2);currentPoint(2)] ;
		
		if (length(unique(x)) == 1) && (length(unique(y)) == 1)
			% If only one pixel is to be changed
			xi = x(1) ;
			yi = y(1) ;
			
		elseif length(unique(x)) > 1
			% Normal interpolation; most cases
			xi = linspace(min(x),max(x),50)' ;
			yi = interp1(x,y,xi) ;
			
		else
			% If the line segment is exactly vertical
			yi = linspace(min(y),max(y),50)' ;
			xi = linspace(min(x),max(x),50)' ;
			
		end
		
		% Converting the raw coordinates to unique [r,c] values
		pts = unique(round([xi,yi]),'rows') ;
		pts( (pts(:,1)<1)|(pts(:,1)>col)|(pts(:,2)<1)|(pts(:,2)>row) , : ) = [] ;
		
		% "Painting" the unique [r,c] onto the blank mask
		binaryImage(sub2ind([row,col],pts(:,2),pts(:,1))) = 1 ;

		if handles.editVariables.pixelEditNeighbors
			% If the draw tool has a width > 1
			fatLineImage = imdilate(binaryImage, true(2*handles.editVariables.pixelEditNeighbors+1)) ;
		else
			% If the draw tool has a width of exactly 1
			fatLineImage = binaryImage ;
		end
		
		% Using the painted mask to index BW_2 and changing those pixels
		handles.derivedPic.BW_2( fatLineImage ) = ~handles.editVariables.pixelColor ;

	%---- Start: Update Image Data
		handles.image.CData = createNewBW2( handles ) ;
	%---- End: Update Image Data
		
		% Setting the last edited point as the current point
		handles.lastPoint = currentPoint ;
		
	else
		if handles.displayedImageButtonGroup.Children(2).Value % If the BW2 is active
			xLim = handles.REAVER_MainAx.XLim ;
			yLim = handles.REAVER_MainAx.YLim ;
			lowerLim = [xLim(1),yLim(1)] ;
			upperLim = [xLim(2),yLim(2)] ;

			if isequal( handles.REAVER_Fig.Pointer , 'custom' ) && ...
					 ~( sum([sum(lowerLim<currentPoint(1:2)),sum(currentPoint(1:2)<upperLim)]) == 4 )
				% If the cursor is custom and IS NOT inside the axis
				handles.REAVER_Fig.Pointer = 'arrow' ;
				handles.REAVER_Fig.PointerShapeHotSpot = [1,1] ;
			elseif ( sum([sum(lowerLim<currentPoint(1:2)),sum(currentPoint(1:2)<upperLim)]) == 4 )
				% If the cursor is arrow and IS inside the axis

				sliderValue = get( handles.editSizeSlider , 'Value' ) ;
				handles.REAVER_Fig.Pointer = 'custom' ;
				handles.REAVER_Fig.PointerShapeCData = nan(16) ;
				% Halve the size for the purpose of making the cursor visual work
				sliderValue = floor(sliderValue/2) ;
				handles.REAVER_Fig.PointerShapeCData( (8-sliderValue):(8+sliderValue) , ...
					(8-sliderValue):(8+sliderValue) ) = 2 ;
				handles.REAVER_Fig.PointerShapeHotSpot = [8,8] ;
			end
		else % If a different image is active
			if isequal( handles.REAVER_Fig.Pointer , 'custom' )
				% If the cursor is custom and IS NOT inside the axis
				handles.REAVER_Fig.Pointer = 'arrow' ;
				handles.REAVER_Fig.PointerShapeHotSpot = [1,1] ;
			end
		end
	end
%%%%% End: Toggle Pixels if Cursor is Held Down

	guidata(hObject,handles)
end


function figKeyPress(hObject,~)
	handles = guidata(hObject) ;
	
%%%%% Start: Determine Pressed Key and Evaluate Corresponding Condition
	pressedKey  = double(handles.REAVER_Fig.CurrentCharacter) ;
	
	updateImage = false ;
	changeColor = 0 ;
	updateSlider = false ;
		
	if ~isempty( pressedKey )
		switch pressedKey
			case 23 % ctrl + w (23)
				close( handles.REAVER_Fig )
				return
				
			case 26 % ctrl + z (26)
				if isequal(handles.undoLastEditButton.Enable,'on')
					undoLastEditButton_Callback( handles.undoLastEditButton , 1 )
					handles = guidata(hObject) ;
				end
				
			case 30  % up arrow   (30) INCREASE EDIT SIZE SLIDER
				sliderChange = 1 ;
				updateSlider = true ;
				
			case 31  % down arrow (31) DECREASE EDIT SIZE SLIDER
				sliderChange = -1 ;
				updateSlider = true ;
				
			case 113 % q (113)

			case 119 % w (119)

			case 101 % e (101)
				
			case 117 % u (117) UPDATE WIRE FRAME
				if isequal(handles.updateWireButton.Enable,'on')
					updateWireButton_Callback( handles.updateWireButton , 1 )
					handles = guidata(hObject) ;
				end
				
			case 114 % r (114) RED
				if ~handles.grayImage
					changeColor = 1 ;
					updateImage	= true ;
				end
				
			case 103 % g (103) GREEN
				if ~handles.grayImage
					changeColor = 2 ;
					updateImage	= true ;
				end
				
			case 98  % b (98)  BLUE
				if ~handles.grayImage
					changeColor = 3 ;
					updateImage = true ;
				end
				
			case 32 % Space (32)				
				if isequal( handles.displayedImageButtonGroup.Children(8).Enable , 'on' ) && ~handles.editVariables.heldDown
					currentImage = arrayfun( @(x) x.Value , handles.displayedImageButtonGroup.Children ) ;
					currentImage = find( currentImage ) ;

					if ~isfield( handles , 'lastImage' )
% 						handles.image.CData = createNewBW2( handles ) ;
% 
% 						handles.displayedImageButtonGroup.Children(currentImage).Value = 0 ;
% 						handles.displayedImageButtonGroup.Children(2).Value = 1 ;
					elseif ~isempty( handles.lastImage )
						handles.displayedImageButtonGroup.Children(8).Value = 0 ;
						handles.displayedImageButtonGroup.Children(handles.lastImage).Value = 1 ;

						if isfield(handles.derivedPic.branchpoints,'line')
							if ~isempty(handles.derivedPic.branchpoints.line)
								handles.derivedPic.branchpoints.line.Visible = 'off' ;
								handles.derivedPic.endpoints.line.Visible	 = 'off' ;
							end
						end						
						
						switch handles.lastImage
							case 8
								handles.image.CData = handles.displayedChannelsImage ;

							case 7
								handles.image.CData = handles.derivedPic.selectedColors ;

							case 6
								handles.image.CData = handles.derivedPic.grey ;

							case 5
								handles.image.CData = handles.derivedPic.greynbrs ;

							case 4
								handles.image.CData = handles.derivedPic.BW_1 ;

							case 3
								handles.image.CData = handles.derivedPic.BW_1nbrs ;

							case 2
								handles.image.CData = createNewBW2( handles ) ;

							case 1
								handles.image.CData = imdilate( handles.derivedPic.wire , strel('disk',2) ) ;

								handles.derivedPic.branchpoints.line.Visible = 'on' ;
								handles.derivedPic.endpoints.line.Visible = 'on' ;
						end
						
						handles.displayedImageButtonGroup.Children(currentImage).Value = 0 ;
						handles.displayedImageButtonGroup.Children(handles.lastImage).Value = 1 ;

					end
					
					handles.lastImage = currentImage ;

					drawnow
				end
		end
	end
%%%%% End: Determine Pressed Key and Evaluate Corresponding Condition

%%%%% Start: Update displayed channels checkboxes
	if updateImage
		displayedChannels = ...
			logical(fliplr(cell2mat(get(handles.displayedChannelsPanel.Children,'Value'))')) ;

		displayedChannels( changeColor ) = ~displayedChannels( changeColor ) ;

		if sum( displayedChannels )
			changeColor = (-1*(changeColor-2)) + 2 ;
			handles.displayedChannelsPanel.Children(changeColor).Value = ...
				~handles.displayedChannelsPanel.Children(changeColor).Value ;
			
			handles.displayedChannelsImage = handles.basePic.data ;
			handles.displayedChannelsImage(:,:,~displayedChannels) = 0 ;
			
			if handles.displayedImageButtonGroup.Children(8).Value
				handles.image.CData = handles.displayedChannelsImage ;
				drawnow
			end
		end
	end
	
%%%%% End: Update displayed channels checkboxes

%%%%% Start: Check for Necessary Updates
	if updateSlider
		
		% Call the edit size slider change function
		handles = editSizeSliderChange(handles,sliderChange) ;
	
	end
%%%%% End: Check for Necessary Updates


	guidata(hObject,handles)
end

function figScrollWheel(hObject,eventdata)
	handles = guidata(hObject) ;

%%%%% Start: Check if an Image is Loaded
	
	if ~handles.imageLoaded
		tableLoaded = 0 ; %#ok<NASGU>
		axisLoaded = 0 ;
		if isequal(handles.imageDirectoryTable.Enable,'on')
			tableLoaded = 1 ;
		else
			return
		end
	else
		tableLoaded = 1 ;
		axisLoaded = 1 ;
	end
%%%%% End: Check if an Image is Loaded

%%%%% Start: Get Scroll Direction and Cursor Position
	scrollDirection = sign(eventdata.VerticalScrollCount) ;
	% Negative is pushing the scroll wheel away from you. Positive is pulling the scroll wheel towards you
	
	editSizeSliderPosition		= getpixelposition(handles.editSizeSlider) ;
	imageDirectoryTablePosition = getpixelposition(handles.imageDirectoryTable) ;
	axisPosition				= getpixelposition(handles.REAVER_MainAx) ;
	
	% Getting bounding vertices of the three relevant boxes
	ess_xv = editSizeSliderPosition(1) + ...
			 editSizeSliderPosition(3)*[0,1,1,0,0]' ;
	ess_yv = editSizeSliderPosition(2) + ...
			 editSizeSliderPosition(4)*[0,0,1,1,0]' ;
	idt_xv = imageDirectoryTablePosition(1) + ...
			 imageDirectoryTablePosition(3)*[0,1,1,0,0]' ;
	idt_yv = imageDirectoryTablePosition(2) + ...
			 imageDirectoryTablePosition(4)*[0,0,1,1,0]' ;
	a_xv   = axisPosition(1) + ...
			 axisPosition(3)*[0,1,1,0,0]' ;
	a_yv   = axisPosition(2) + ...
			 axisPosition(4)*[0,0,1,1,0]' ;
	
	% Cursor with respect to bottom left of figure
	currentPoint = handles.REAVER_Fig.CurrentPoint ;
	xq = currentPoint(1) ;
	yq = currentPoint(2) ;
	
	cursorPosition		= handles.REAVER_MainAx.CurrentPoint ;
	cursorPosition(2,:) = [] ;  % Cursor with respect to axis
	
	row = handles.basePic.ySize;
	col = handles.basePic.xSize;
	
	xPos = cursorPosition(1) ;
	yPos = cursorPosition(2) ;
	
	% Determine what, if any, modifier keys are currently pressed
	modifiers = get(handles.REAVER_Fig,'currentModifier') ;
	onlyCtrlIsPressed = ismember('control',modifiers) && (length(modifiers)==1) ;
	
%%%%% End: Get Scroll Direction and Cursor Position

%%%%% Start: Perform according action to location of cursor
if inpolygon(xq,yq,a_xv,a_yv) && tableLoaded && axisLoaded && ~onlyCtrlIsPressed % Zooming
	
	% Revert focus to load button control which is hidden and does nothing
	currentObject = gco(handles.REAVER_Fig) ;
	if isequal(currentObject.Tag,'imageDirectoryTable')
		uicontrol(handles.settingsButton) ;
		set(handles.settingsButton, 'Enable', 'off');
		drawnow;
		set(handles.settingsButton, 'Enable', 'on');
		set(handles.settingsButton, 'Enable', 'off');
		drawnow;
		set(handles.settingsButton, 'Enable', 'on');
	end
	%---- Start: Initiate axis zooming procedure
		oldXLim = handles.REAVER_MainAx.XLim ;
		oldYLim = handles.REAVER_MainAx.YLim ;
	
		if xPos < oldXLim(1)
			xPos = oldXLim(1) ;
		elseif xPos > oldXLim(2)
			xPos = oldXLim(2) ;
		end

		if yPos < oldYLim(1)
			yPos = oldYLim(1) ;
		elseif yPos > oldYLim(2)
			yPos = oldYLim(2) ;
		end
	%---- End: Initiate axis zooming procedure

	%---- Start: Change Zoom Factor and Set New x/yLim Size
		if handles.versionNew
			if scrollDirection == -1 % Away / Zoom In
				newXLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldXLim , xPos , 10/9 ) ;
				newYLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldYLim , yPos , 10/9 ) ;

			else					 % Towards / Zoom Out
				newXLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldXLim , xPos , 9/10 ) ;
				newYLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldYLim , yPos , 9/10 ) ;

			%---- Start: Fix limits if necessary	
				if (newXLim(2)-newXLim(1)>col) || (newYLim(2)-newYLim(1)>row) 
					% If the new bounding box is too big, reset axes:
					newXLim = [0.5,col+0.5] ;
					newYLim = [0.5,row+0.5] ;
				elseif (newXLim(1)<0.5) || (newXLim(2)>col+0.5) || (newYLim(1)<0.5) || (newYLim(2)>row+0.5)
					% If any of the new bounds are out of bounds:

					if (newXLim(1)<0.5)
						newXLim(2) = newXLim(2) - (newXLim(1)-0.5) ;
						newXLim(1) = newXLim(1) - (newXLim(1)-0.5) ;
					elseif (newXLim(2)>col+0.5)
						newXLim(1) = newXLim(1) - (newXLim(2)-col-0.5) ;
						newXLim(2) = newXLim(2) - (newXLim(2)-col-0.5) ;
					end

					if (newYLim(1)<0.5)
						newYLim(2) = newYLim(2) - (newYLim(1)-0.5) ;
						newYLim(1) = newYLim(1) - (newYLim(1)-0.5) ;
					elseif (newYLim(2)>row+0.5)
						newYLim(1) = newYLim(1) - (newYLim(2)-row-0.5) ;
						newYLim(2) = newYLim(2) - (newYLim(2)-row-0.5) ;
					end
				end
			%---- End: Fix limits if necessary

			end	
		else
			if scrollDirection == -1 % Away / Zoom In
				newXLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldXLim , xPos , 10/9 , false , [0.5,col+0.5] ) ;
				newYLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldYLim , yPos , 10/9 , false , [0.5,row+0.5] ) ;

			else					 % Towards / Zoom Out
				newXLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldXLim , xPos , 9/10 , false , [0.5,col+0.5] ) ;
				newYLim = matlab.graphics.interaction.internal.zoom.zoomAxisAroundPoint( oldYLim , yPos , 9/10 , false , [0.5,row+0.5] ) ;	
			end
		end
	%---- End: Change Zoom Factor and Set New x/y Limit Size

	%---- Start: Adjust Axis Limits
		if xPos >= 0.5 && xPos <= col+0.5 && yPos >= 0.5 && yPos <= row+0.5
			set(handles.REAVER_MainAx,'XLim',newXLim,'YLim',newYLim) ;
		end
	%---- End: Adjust Axis Limits
elseif inpolygon(xq,yq,idt_xv,idt_yv) && tableLoaded  && ~onlyCtrlIsPressed % Table scrolling
		uitable(handles.imageDirectoryTable) ;
		
elseif (inpolygon(xq,yq,ess_xv,ess_yv) || onlyCtrlIsPressed) && tableLoaded % Slider changing
		% Revert focus to load button control which is hidden and does nothing
		currentObject = gco(handles.REAVER_Fig) ;
		if isequal(currentObject.Tag,'imageDirectoryTable')
			uicontrol(handles.settingsButton) ;
			set(handles.settingsButton, 'Enable', 'off');
			drawnow;
			set(handles.settingsButton, 'Enable', 'on');
			set(handles.settingsButton, 'Enable', 'off');
			drawnow;
			set(handles.settingsButton, 'Enable', 'on');
		end

		% Call the edit size slider change function
		handles = editSizeSliderChange(handles,-scrollDirection) ;
else
		% Revert focus to load button control which is hidden and does nothing
		currentObject = gco(handles.REAVER_Fig) ;
		if isequal(currentObject.Tag,'imageDirectoryTable')
			uicontrol(handles.settingsButton) ;
			set(handles.settingsButton, 'Enable', 'off');
			drawnow;
			set(handles.settingsButton, 'Enable', 'on');
			set(handles.settingsButton, 'Enable', 'off');
			drawnow;
			set(handles.settingsButton, 'Enable', 'on');
		end
end
%%%%% End: Perform according action to location of cursor

	guidata(hObject,handles)
end

function figSizeChanged(hObject,~)
	handles = guidata(hObject) ;

%%%%% Start: Get Image Properties
	if handles.imageLoaded
		handles.basePic.ySize = size(handles.basePic.data,1) ;
		handles.basePic.xSize = size(handles.basePic.data,2) ;
		row = handles.basePic.ySize ;
		col = handles.basePic.xSize ;
	else
		row = 1024 ;
		col = 1024 ;
	end
	currentFigSize = handles.REAVER_Fig.Position ;
	currentFigSize(1:2) = [] ;
%%%%% End: Get Image Properties

%%%%% Start: Resize Axes Up or Down
	if ~( (currentFigSize(2)-16) > row ) || ~( col/currentFigSize(1) < 0.6 )
		%---- This condition checks if (1) there are at least 16 pixels above
		%     and below the axis and (2) the new axis would take up no more
		%     than 60% of the new figure in the width dimension. (1) and (2)

		newWidth  = currentFigSize(1)*0.6 ;
		newHeight = currentFigSize(2)-16 ;

		if newHeight < row
			factor = newHeight/row ;
			row = row*factor ;
			col = col*factor ;
		end

		if newWidth < col
			factor = newWidth/col ;
			row = row*factor ;
			col = col*factor ;
		end

		row = round(row) ;
		col = round(col) ;
	end

	handles.REAVER_MainAx.Position = [(currentFigSize(1)/2)-(col/2),(currentFigSize(2)/2)-(row/2),col,row] ;

%%%%% End: Resize Axes Up or Down


%%%%% Start: Resize Directory Table
	modEqualWidth = mod( handles.imageDirectoryTable.Position(3) * currentFigSize(1) , 3 ) ;
	equalWidth = ( handles.imageDirectoryTable.Position(3) * currentFigSize(1) - modEqualWidth ) / 3 ;
	handles.imageDirectoryTable.ColumnWidth = num2cell( [equalWidth-1,equalWidth,equalWidth]-6 ) ;
%%%%% End: Resize Directory Table


	guidata(hObject,handles)
end


function closeRequest(hObject,~)
	handles = guidata(hObject) ;
	
	% Kill the timer object immediately
	if isfield(handles.time,'timer')
		try
			stop(handles.time.timer)
			delete(handles.time.timer)
		catch
			
		end
	end
	
% 	% Remembering the figure position
% 	fig_position = handles.REAVER_Fig.Position ;
% 	ax_position  = handles.REAVER_MainAx.Position ;
% 	save('temp\default_fig_position.mat','fig_position')
% 	save('temp\default_ax_position.mat','ax_position')

	% Close the figure
	delete(handles.REAVER_Fig)
end


