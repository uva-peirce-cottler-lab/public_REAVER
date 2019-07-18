function [dataset_path] = get_dataset_path()
proj_path = getappdata(0,'proj_path');
mkdir([proj_path '/temp/']);

if isempty(dir([proj_path '/temp/dataset_path.mat']))
    dataset_path = uigetdir('Select Box Folder');
    if dataset_path==0; return; end
    save([proj_path '/temp/dataset_path.mat'],'dataset_path');
else
    load([proj_path '/temp/dataset_path.mat']);
    if dataset_path==0; 
        dataset_path = uigetdir('Select Box Folder');
        if dataset_path==0; return; end
        save([proj_path '/temp/dataset_path.mat'],'dataset_path');
    end
%     if ~
end
end

