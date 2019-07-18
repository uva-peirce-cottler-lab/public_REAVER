function pretty_groups = prettify_groups(groups)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for n=1:numel(groups)
    switch groups{n}
        case 'AngioTool'
            pretty_groups{n} = 'Angio\newlineTool';
        case 'AngioQuant'
            pretty_groups{n} = 'Angio\newlineQuant';
        case 'RAVE'
            pretty_groups{n} = 'RAVE\newline';
        case 'REAVER'
            pretty_groups{n} = '\newlineREAVER';
        case 'Manual'
            pretty_groups{n} = 'Manual\newline';
        otherwise
            groups{n}
            error("unknown group name")
    end
end
end

