% script
% 
% Initialize the path for running mrLoadRet-1.0
% 

disp('Setting mrLoadRet-1.0 path')

p = path;
pathStr = [];
homeDir = '/usr/local/matlab5.0/toolbox/stanford/mri/mrLoadRet-1.0/';
pathStr = [pathStr homeDir 'Anatomy:'];
pathStr = [pathStr homeDir 'Analysis:'];
pathStr = [pathStr homeDir 'Colormap:'];
pathStr = [pathStr homeDir 'Edit:'];
pathStr = [pathStr homeDir 'File:'];
pathStr = [pathStr homeDir 'Flat:'];
pathStr = [pathStr homeDir 'Init:'];
pathStr = [pathStr homeDir 'ROI:'];
pathStr = [pathStr homeDir 'ROIPlots:'];
pathStr = [pathStr homeDir 'ROIPlots/Bargraphs:'];
pathStr = [pathStr homeDir 'ROIPlots/Linegraphs:'];
pathStr = [pathStr homeDir 'Special:'];
pathStr = [pathStr homeDir 'UI:'];
pathStr = [pathStr homeDir 'UI/Buttons/BlurT:'];
pathStr = [pathStr homeDir 'UI/Buttons/TBlur:'];
pathStr = [pathStr homeDir 'UI/Buttons/ClearROI:'];
pathStr = [pathStr homeDir 'UI/Buttons/ClearROIAll:'];
pathStr = [pathStr homeDir 'UI/Buttons/LoadTS:'];
pathStr = [pathStr homeDir 'UI/Buttons/Flat:'];
pathStr = [pathStr homeDir 'View:'];
pathStr = [pathStr homeDir 'Volume:'];

path(pathStr,p);
path(path)

