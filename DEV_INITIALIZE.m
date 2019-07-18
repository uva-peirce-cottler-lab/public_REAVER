function paths_added = DEV_INITIALIZE(varargin)
% SYNTAX: paths_added = DEV_INITIALIZE(varargin)
%
% METHOD: This script is used for project management in matlab. It is 
% placed in the base folder of a matlab project and when executed will 
% initialize it for development.
%
% Initialization Step include:
%   1. Reset matlab path
%   2. Recursively adding all white listed subfolders to matlab path
%   3. Compile list of all matlab files, compute stats (lines of code)
%   4. Compile any mex files required.
%   5. Download any toolboxes required.
%   6. Delete those pesky matlab asv files (if requested)
%   7. Open any desired files in the matlab editor
%   8. Auto assemble a help file for all matlab files
%   9. Auto assemble all matlab code in one file.
%   10. Add paths to other toolboxes outside of base directory.
%
% INPUT:
%   in_path [o, string]: input directory to start recursive file crawler.
%       Defaults to directory of this file, which is assumed to be placed in
%       the base of project
%   RecurNum [o, integer]: number of recursive calls
%   BlackList [p, cellstring]: list of folder names to specifically
%       blacklist from recurring,  regular expressions supported. 
%   WhiteList [p, cellstring]: list of folder names to specifically
%       whitelist, regular expressions supported. 
%   BlackList [p, cellstring]: list of folder names to specifically
%       blacklist from adding to path, regular expressions supported.
%   WhiteList [p, cellstring]: list of folder names to specifically
%       whitelist for adding to path, regular expressions supported. 
%   RESET_PATH [p, boolean]: reset matlab path to default before
%       initializing this project.  Defaults to TRUE.
% 
% OUTPUT:
%   paths_added
%
% DEPENDENCIES: nones
% Author: Bruce Corliss at GrassRoots Biotech, 2012

% Copyright (c) 2012, GrassRoots Biotech
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met: 
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer. 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution. 
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
% ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% The views and conclusions contained in the software and documentation are those
% of the authors and should not be interpreted as representing official policies, 
% either expressed or implied, of the FreeBSD Project.

%% Get local Directory of Mfile
proj_path = fileparts(mfilename('fullpath'));
setappdata(0, 'proj_path', proj_path);
if isempty([proj_path '/temp/']); mkdir([proj_path '/temp/']); end


%% ARGUMENT PARSING
% What is not an Parameter is an optinal arg (param words must fail
% validation for add optional).
isOption=@(x) ischar(x) && ~logical(sum(strcmp(x, {'RESET_PATH'})));
p = inputParser;
p.addOptional('in_path', proj_path, isOption);
p.addParameter('RecurNum', 1, @isnumeric);
p.addParameter('BlackList', {'user_prefs', 'images','.hg','config\d*','deploy'}, @iscellstr);
p.addParameter('WhiteList', {'.'}, @iscellstr);
p.addParameter('DELETE_ASV', 0, @(x)(x==0 || x==1));
p.addParameter('RESET_PATH', 1, @(x)(x==0 || x==1));
p.addParameter('RunGui', 0, @(x)(x==0 || x==1));
p.parse(varargin{:});
% Import parsed variables into workspace
fargs = fields(p.Results);
for n=1:numel(fargs); eval([fargs{n} '=' 'p.Results.' fargs{n} ';']);  end

% Print header if intial call
if RecurNum==1; fprintf('\n<> Adding the following folders to MATLAB path.\n/\n'); end
% Tab padding for printed output
pad = repmat('\t',1,RecurNum);

% Make *nix Compatible
in_path = regexprep(in_path, '\', '/');

%% CD to proj_path
cd(in_path)

%% Restore Default Path
if RESET_PATH; restoredefaultpath(); end

%% Scan for all folders in current directory
proj_files=dir('*');
proj_names = arrayfun(@(x) x.name, proj_files, 'UniformOutput', 0);
proj_isdir = arrayfun(@(x) x.isdir, proj_files);

% All entries beginning with a '.' in name are not included
dir_ind = cellfun(@(x) isempty(x) || ~strcmp(x(1),'.'), proj_names);

% All entries without a '.' and what MATLAB calls a dir is to be added
proj_dirs=proj_names(dir_ind & proj_isdir);

% List of folders added to path
paths_added = {};

% If no folders found, return
if isempty(proj_dirs); return; end

% Go through folder names, add folder XOR recur
for n = 1:numel(proj_dirs)
    % Added if name DOESN'T match BlackList and DOES match WhiteList
    ADD_PATH = ~any(cellfun(@(x) ~isempty(regexp(proj_dirs{n}, x, 'once')), BlackList)) && ...
        any(cellfun(@(x) ~isempty(regexp(proj_dirs{n}, x, 'once')), WhiteList));
    
    % Recur if name DOESN'T match BlackList and DOES match WhiteList
    RECUR_PATH = ADD_PATH;
    
    % If either tests true print
    if ADD_PATH || RECUR_PATH; fprintf([pad '/%s\n'], proj_dirs{n}); end
        
    % Add folder to path if applicable
    if ADD_PATH;  
        % Add to path
        addpath([in_path '/' proj_dirs{n}]); 
        
        % Concatenate to list of paths (exclude toolboxes)
        if isempty(regexp(in_path, './toolbox/.', 'once'))
            paths_added{numel(paths_added)+1} = [in_path '/' proj_dirs{n}];
        end
    end

    % Recur is applicable
     if RECUR_PATH; cd(proj_path);
       new_paths = DEV_INITIALIZE([in_path '/' proj_dirs{n}], 'RESET_PATH', 0, 'RecurNum', ...
            RecurNum+1);
        paths_added = horzcat(paths_added, new_paths);
        cd(in_path);
     end

end


% Grab custom code or help files
if RecurNum==1;
    

    if DELETE_ASV
        fprintf('\n<> Deleting ASV files...\n')
        cellfun(@(x) delete([x '/*.asv']), paths_added)
        cellfun(@(x) delete([x '/*~']), paths_added)
    end

end


cd(proj_path);


end





function co = flatten(ci)
co = cell(0);
fE= @(x) x{:};
for n=1:numel(ci) 
    if(~iscellstr(ci{n}))
       co = [co,ci{n}];
    else
        temp = flatten(ci{n});
       co = [co,temp{:}];
       
    end
end
end