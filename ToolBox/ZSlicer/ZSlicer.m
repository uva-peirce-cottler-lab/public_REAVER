function varargout = ZSlicer(varargin)
% ZSlicer MATLAB code for ZSlicer.fig
%      ZSlicer, by itself, creates a new ZSlicer or raises the existing
%      singleton*.
%
%      H = ZSlicer returns the handle to a new ZSlicer or the handle to
%      the existing singleton*.
%
%      ZSlicer('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZSlicer.M with the given input arguments.
%
%      ZSlicer('Property','Value',...) creates a new ZSlicer or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ZSlicer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ZSlicer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ZSlicer

% Last Modified by GUIDE v2.5 01-Dec-2018 00:41:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZSlicer_OpeningFcn, ...
                   'gui_OutputFcn',  @ZSlicer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ZSlicer is made visible.
function ZSlicer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ZSlicer (see VARARGIN)

% Choose default command line output for ZSlicer
handles.output = hObject;

setappdata(0,'ZSlicer_figure_handle',handles);

% jScrollBar = findjobj(handles.zslice_slider);
% jScrollBar.AdjustmentValueChangedCallback = @(x,y) slider_callback(x,'java-zslice_slider',y);
% jScrollBar = findjobj(handles.bot_slider);
% jScrollBar.AdjustmentValueChangedCallback = @(x,y) slider_callback(x,'java-bot_slider',y);
% jScrollBar = findjobj(handles.mid_slider);
% jScrollBar.AdjustmentValueChangedCallback = @(x,y) slider_callback(x,'java-mid_slider',y);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ZSlicer wait for user response (see UIRESUME)
% uiwait(handles.ZSlicer_figure);


% --- Outputs from this function are returned to the command line.
function varargout = ZSlicer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in img_name_listbox.
function img_name_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to img_name_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns img_name_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from img_name_listbox
contents = cellstr(get(hObject,'String'));

img_name = contents{get(hObject,'Value')};
setappdata(handles.ZSlicer_figure,'img_name',img_name);
imgs_path = getappdata(handles.ZSlicer_figure,'imgs_path');


[zimg, meta] =img_open([imgs_path '/' img_name]);

% zimg(:,:,1,:) = zimg(:,:,3,:);
% zimg(:,:,3,:) = 0;
% zimg(:,:,1,:) = immultiply(zimg(:,:,1,:) - 80,256/(256-80));
% zimg(:,:,2,:) = immultiply(zimg(:,:,2,:) - 10,256/(256-10));
% 
% zimg(:,:,2,:) = imfilter(zimg(:,:,2,:),fspecial('gaussian', 3,2)) - imfilter(zimg(:,:,2,:),fspecial('gaussian', 100,50));

setappdata(handles.ZSlicer_figure,'zimg',zimg);
setappdata(handles.ZSlicer_figure,'dz',meta.dz);
set(handles.step_size_text,'String',sprintf('Step Size (um): %0.2f', meta.dz))

% Display total z slices
set(handles.total_z_text,'String', sprintf('Total Z Slices: %.f', size(zimg,4)));
setappdata(handles.ZSlicer_figure,'nz',size(zimg,4));

% Initialize Slider max
set(handles.zslice_slider,'Max',size(zimg,4));
set(handles.zslice_slider,'Value',size(zimg,4));
% Initialize Sliders min
set(handles.zslice_slider,'Min',1);
set(handles.zslice_edit,'String',num2str(size(zimg,4)));
% keyboard
% Update slider index boxes
update_slider_edits(handles)

set(handles.zproj_listbox,'String','1');


set(handles.projected_z_slices_text,'String',sprintf('Projected Z Slices: %.0f',size(zimg,4)));
set(handles.zslice_slider,'Value',size(zimg,4));


% Update orthogonal projection
a = max(zimg,[],2);
B = permute(a,[4 1 3 2]);
C = imresize(B, [512 30]);
imshow(flip(C,1),'Parent',handles.yproj_axes);
drawnow; pause(.01)

% Update main image
update_img(handles);

check_output_file_status(handles)
% Restore keyboard focus to figure
set(hObject, 'Enable', 'off'); drawnow; set(hObject, 'Enable', 'on');
% keyboard  

function update_img(handles)
zimg = getappdata(handles.ZSlicer_figure,'zimg');
z = get(handles.zslice_slider,'Value');
img = zimg(:,:,:,z);

% ID which channels should be viewed
rgb_bv = [get(handles.viewRed_togglebutton,'Value')...
    get(handles.viewGreen_togglebutton,'Value')...
    get(handles.viewBlue_togglebutton,'Value')];

img(:,:, ~rgb_bv) = 0;

imshow(img,'Parent',handles.img_axes);



function update_ortho_projection(handles)

a = max(zimg,[],2);

B = permute(a,[4 1 3 2]);

C = imresize(B, [512 30]);

% keyboard
imshow(flip(C,1),'Parent',handles.yproj_axes);
drawnow
pause(.01)
% set(handles.yproj_axes,'YDir','reverse');



%%%%%%%%%
% nz_proj = top_val - bot_val + 1;
% nz_proj_above = top_val - ceil(mean([top_val bot_val]));
% nz_proj_below = floor(mean([top_val bot_val])) - bot_val;
% 
% % keyboard
% % If top greater than bot, switch
% if top_val < bot_val
%     set(handles.zslice_slider,'Value',bot_val)
%     set(handles.bot_slider,'Value',top_val)
% end
% 
% % If mid is adjusted, shift top and bot rounded by ends
% if ~isempty(regexp(get(hObject,'Tag'),'mid','once'))
%     set(handles.zslice_slider,'Value',min([nz mid_val+nz_proj_above]));
%     set(handles.bot_slider,'Value',max([1 mid_val-nz_proj_below]));
% else
%     % make mid is halfway between top and bot, 1 down from top
%     set(handles.mid_slider,'Value', floor(mean([top_val bot_val])));
% end

function check_output_file_status(handles)

% zproj = getappdata(handles.ZSlicer_figure,'zproj');
imgs_path = getappdata(handles.ZSlicer_figure,'imgs_path');
img_name = getappdata(handles.ZSlicer_figure,'img_name');


if isempty(dir([imgs_path '/ZSlicer']));mkdir([imgs_path '/ZSlicer']); end

suffix_cell = get(handles.autosuffix_listbox,'String');

exist_bv = cellfun(@(x) ~isempty(dir([imgs_path '/ZSlicer/' img_name '_' ...
    x '_all_chan.tif'])),suffix_cell);

ind = find(exist_bv,1,'last')+1;
if isempty(ind); ind=1; end
if ind>numel(suffix_cell); ind = numel(suffix_cell); end
setappdata(handles.ZSlicer_figure,'suffix_str',suffix_cell{ind});

set(handles.autosuffix_listbox,'Value',ind);
% keyboard




function update_slider_edits(handles)
z_val = get(handles.zslice_slider,'Value')
prev_z_val = getappdata(handles.ZSlicer_figure,'prev_z_val');

if z_val < prev_z_val;
    new_z_val = floor(z_val);
else
    new_z_val = ceil(z_val);
end

% fprintf('Cur: %.2f, Prev: %.2f, New: %.2f\n', z_val, prev_z_val, new_z_val);

set(handles.zslice_slider, 'Value', new_z_val);
setappdata(handles.ZSlicer_figure, 'prev_z_val', new_z_val);
set(handles.zslice_edit,'String',sprintf('%.0f',z_val));





function slider_callback(hObject, eventdata, handles)
if ischar(eventdata)&& ~isempty(regexp(eventdata,'java','once'));
    handles = getappdata(0,'ZSlicer_figure_handle');
        elem = @(x) x{1};
    hObject = handles.(elem(regexp(eventdata,'java-(.*)','tokens','once')));
end
fprintf('.');
% z_val = round(get(handles.zslice_slider,'Value'));

% getappdata(handles.ZSlicer_figure,'zimg',zimg);

% Update sliders
update_slider_edits(handles)

% Update image based on sliders
update_img(handles)

% --- Executes during object creation, after setting all properties.
function img_name_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_name_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function zslice_slider_Callback(hObject, eventdata, handles)
% hObject    handle to zslice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function zslice_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




function projected_z_edit_Callback(hObject, eventdata, handles)
% hObject    handle to projected_z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projected_z_edit as text
%        str2double(get(hObject,'String')) returns contents of projected_z_edit as a double


% --- Executes during object creation, after setting all properties.
function projected_z_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projected_z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export_img_pushbutton.
function export_img_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to export_img_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zimg = getappdata(handles.ZSlicer_figure,'zimg');

suffix_cell = get(handles.autosuffix_listbox,'String');


z_inds = sort(unique(cellfun(@(x) str2double(x), cellstr(get(handles.zproj_listbox,'String')))),'ascend');
% keyboard
for n=1:numel(z_inds)/2;
    export_img(max(zimg(:,:,:,z_inds(2*n-1):z_inds(2*n)),[],4),flipud(suffix_cell{n}),handles);
end


function export_img(img,suffix_str,handles)
imgs_path = getappdata(handles.ZSlicer_figure,'imgs_path');
img_name = getappdata(handles.ZSlicer_figure,'img_name');

rgb_bv = logical([get(handles.red_checkbox,'Value')...
    get(handles.green_checkbox,'Value')...
    get(handles.blue_checkbox,'Value')]);
rgb_cell = {'red','green','blue'};
rgb_ind = 1:3;

for n = 1:3
%     chan = zeros(size(img),'uint8');
    img(:,:,n) = imadjust(img(:,:,n));
end

imwrite(img,[imgs_path '/ZSlicer/'  img_name '_' suffix_str '_.tif']);

% Save each channel seperate
% for n = rgb_ind(rgb_bv);
%     chan = zeros(size(img),'uint8');
%     chan(:,:,n) = img(:,:,n);
%     imwrite(chan,[imgs_path '/ZSlicer/'  img_name '_' suffix_str '_' rgb_cell{n} '.tif']);
% end

%Save channels in combo
% imwrite(img,[imgs_path '/ZSlicer/'  img_name '_' suffix_str '_all_chan.tif']);

% Save selected channels in combo
% if any(rgb_bv);
%     chan = zeros(size(img),'uint8');
%     chan(:,:,rgb_bv) = img(:,:,rgb_bv);
%     imwrite(chan,[imgs_path '/ZSlicer/'  img_name '_' suffix_str '_all_sel_chan.tif']);
% end

% keyboard
check_output_file_status(handles)



function zslice_edit_Callback(hObject, eventdata, handles)
% hObject    handle to zslice_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zslice_edit as text
%        str2double(get(hObject,'String')) returns contents of zslice_edit as a double


% --- Executes during object creation, after setting all properties.
function zslice_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslice_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bot_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bot_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bot_edit as text
%        str2double(get(hObject,'String')) returns contents of bot_edit as a double


% --- Executes during object creation, after setting all properties.
function bot_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bot_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mid_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mid_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mid_edit as text
%        str2double(get(hObject,'String')) returns contents of mid_edit as a double


% --- Executes during object creation, after setting all properties.
function mid_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mid_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_pushbutton.
function browse_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to browse_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgs_path = getappdata(handles.ZSlicer_figure,'imgs_path');

% keyboard
imgs_path = uigetdir(imgs_path,'Select Folder of Images');

items = dir([imgs_path '/*.*']);

% Match images by extension (bv=binary vector)
img_bv = cellfun(@(x) ~isempty(regexp(x,'(\.ics)|(\.lsm)','once')),{items.name});
% keyboard
img_sarr = items(img_bv);

setappdata(handles.ZSlicer_figure,'imgs_path',imgs_path);
set(handles.img_name_listbox,'String',{img_sarr(:).name}');
set(handles.img_name_listbox,'Value',1);


function proj_str_edit_Callback(hObject, eventdata, handles)
% hObject    handle to proj_str_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proj_str_edit as text
%        str2double(get(hObject,'String')) returns contents of proj_str_edit as a double


% --- Executes during object creation, after setting all properties.
function proj_str_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proj_str_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in autosuffix_listbox.
function autosuffix_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to autosuffix_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns autosuffix_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from autosuffix_listbox


% --- Executes during object creation, after setting all properties.
function autosuffix_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to autosuffix_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in red_checkbox.
function red_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to red_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of red_checkbox


% --- Executes on button press in green_checkbox.
function green_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to green_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of green_checkbox


% --- Executes on button press in blue_checkbox.
function blue_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to blue_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blue_checkbox


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
mid_val = get(handles.mid_slider,'Value');
set(handles.zslice_slider,'Value',mid_val);
set(handles.bot_slider,'Value',mid_val);
slider_callback(hObject, eventdata, handles);


% --- Executes on key press with focus on ZSlicer_figure and none of its controls.
function ZSlicer_figure_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ZSlicer_figure (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% eventdata.Key
switch eventdata.Key
    
    case 'uparrow'
        z_val = get(handles.zslice_slider,'Value');
        set(handles.zslice_slider,'Value',min([z_val+1 get(handles.zslice_slider,'Max')]));
        slider_callback(hObject, eventdata, handles);
    case 'downarrow'
        z_val = get(handles.zslice_slider,'Value');
        set(handles.zslice_slider,'Value',max([z_val-1 get(handles.zslice_slider,'Min')]));
        slider_callback(hObject, eventdata, handles);
    case 's'
        setZ_pushbutton_Callback(handles.setZ_pushbutton, eventdata, handles);
    case 'return'
        export_img_pushbutton_Callback(handles.export_img_pushbutton, eventdata, handles);
end


% --- Executes on button press in viewRed_togglebutton.
function viewRed_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to viewRed_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_img(handles); 
% Restore keyboard focus to figure
set(hObject, 'Enable', 'off'); drawnow; set(hObject, 'Enable', 'on');
% Hint: get(hObject,'Value') returns toggle state of viewRed_togglebutton


% --- Executes on button press in viewGreen_togglebutton.
function viewGreen_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to viewGreen_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_img(handles) 
% Restore keyboard focus to figure
set(hObject, 'Enable', 'off'); drawnow; set(hObject, 'Enable', 'on');
% Hint: get(hObject,'Value') returns toggle state of viewGreen_togglebutton


% --- Executes on button press in viewBlue_togglebutton.
function viewBlue_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to viewBlue_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_img(handles) 
% Restore keyboard focus to figure
set(hObject, 'Enable', 'off'); drawnow; set(hObject, 'Enable', 'on');
% Hint: get(hObject,'Value') returns toggle state of viewBlue_togglebutton


% --- Executes on selection change in zproj_listbox.
function zproj_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to zproj_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zproj_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zproj_listbox


% --- Executes during object creation, after setting all properties.
function zproj_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zproj_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setZ_pushbutton.
function setZ_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to setZ_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

z_val = get(handles.zslice_slider,'Value');

z_vals_cell = cellstr(get(handles.zproj_listbox,'String'));

if isempty(z_vals_cell{1});
    z_vals = z_val;
else
    z_vals = cellfun(@(x) str2double(x), z_vals_cell);
    z_vals(isnan(z_vals))=[];
    z_vals(end+1,1) = z_val;
end
% keyboard
set(handles.zproj_listbox,'String', num2str(sort(unique(z_vals),'descend')));

% Restore keyboard focus to figure
set(hObject, 'Enable', 'off'); drawnow; set(hObject, 'Enable', 'on');
