function quantify_image_folder(input_path)
% first channel is the segmentation and the second channel is the skeleton,

if ~exist('input_path','var');
    input_path = uigetdir(pwd,'select input image folder');
    
end
    
img_items = dir([input_path '/*.tif']);

% Program		Image_Name	Vessel_Length	Vessel_Area	Mean_Diameter	Num_BranchPoints	

tbl = table();
tbl.Program = repmat({'Mixed_Manual'},[numel(img_items),1]);
tbl.Image_Name = {img_items(:).name}';
tbl.Vessel_Length = zeros(numel(img_items),1);
tbl.Vessel_Area = zeros(numel(img_items),1);
tbl.Mean_Diameter = zeros(numel(img_items),1);
tbl.Num_BranchPoints = zeros(numel(img_items),1);
tbl.umppix = zeros(numel(img_items),1);
tbl.pix_dim = zeros(numel(img_items),1);

for n = 1:numel(img_items)
   
    st = imfinfo([input_path '/' tbl.Image_Name{n}] );
    img = zeros(st(1).Width, st(1).Height, numel(st),['uint' '8']);
    if strcmp(st(1).PhotometricInterpretation,'RGB')
        img = imread([input_path '/' tbl.Image_Name{n}]); 
    else
        for k=1:numel(st); img(:,:,k) = imread([input_path '/' tbl.Image_Name{n}],k);    end
    end
    tbl.pix_dim(n) = size(img,1);
    
    % Read xm data into struct
    if ~isempty(dir([input_path '/CellCounter_' regexprep(tbl.Image_Name{n},'.tif','.xml')]))
    xdoc = xmlread([input_path '/CellCounter_' regexprep(tbl.Image_Name{n},'.tif','.xml')]);
    st = xml2struct(xdoc);
    
    % Count instances of each marker class
    for k = 1
        if (k<= numel(st.CellCounter_Marker_File.Marker_Data.Marker_Type)) && ...
                isfield(st.CellCounter_Marker_File.Marker_Data.Marker_Type{k},'Marker');
            counts(n,k) = numel(st.CellCounter_Marker_File.Marker_Data.Marker_Type{k}.Marker);
        end
    end
        tbl.Num_BranchPoints(n) = counts(n,1); 
    elseif ~isempty(dir([input_path '/BranchpointsByName.mat'])) 
        st = load([input_path '/BranchpointsByName.mat'],...
             regexprep(tbl.Image_Name{n},'.tif',''));
         tbl.Num_BranchPoints(n) = size(...
             st.(regexprep(tbl.Image_Name{n},'.tif','')),1);
%         keyboard
    else
        tbl.Num_BranchPoints(n) = NaN; 
    end
  
  
    img_table = quantify_image_simple(img);
    f=fields(img_table); 
    for k=1:numel(f)
        tbl.(f{k})(n) = img_table.(f{k});
    end
    

    
    % Converts to units of mm/pp2
    if ~isempty(regexp(tbl.Image_Name{n},'60x', 'once'))
        umppix = 0.207194025;
    else
       umppix = 0.310791038; 
    end
    tbl.Vessel_Length_Density(n) = (tbl.Vessel_Length(n) * umppix/1000)./ ...
        (tbl.pix_dim(n)*umppix/1000).^2;
    tbl.Vessel_Area_Fraction(n) = tbl.Vessel_Area(n) ./ tbl.pix_dim(n).^2;
    tbl.umppix(n) = umppix;
end

writetable(tbl,[input_path '/image_quantification.csv']);

%     keyboard
end