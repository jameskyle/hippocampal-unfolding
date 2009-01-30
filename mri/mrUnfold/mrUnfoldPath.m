% script
% 
% Initialize the path for running mrUnfold
% 
% 05.28.98 SJC

disp('Setting mrUnfold path')

p = path;
pathStr = [];

homeDir = '/usr/local/matlab5.0/toolbox/stanford/mri/mrUnfold/';

pathStr = [pathStr homeDir 'Window1:'];

pathStr = [pathStr homeDir 'Window2:'];
pathStr = [pathStr homeDir 'Window2/File:'];
pathStr = [pathStr homeDir 'Window2/Show:'];
pathStr = [pathStr homeDir 'Window2/Clear:'];
pathStr = [pathStr homeDir 'Window2/Set:'];
pathStr = [pathStr homeDir 'Window2/Tools:'];
pathStr = [pathStr homeDir 'Window2/Tools/Cuts:'];
pathStr = [pathStr homeDir 'Window2/Tools/MarkVoxels:'];
pathStr = [pathStr homeDir 'Window2/Tools/Unfold:'];
pathStr = [pathStr homeDir 'Window2/Tools/DispData:'];

pathStr = [pathStr homeDir 'Window3:'];

pathStr = [pathStr homeDir 'utility:'];

pathStr = [pathStr homeDir 'unfold-3.2:'];

pathStr = [pathStr '/usr/local/matlab5.0/toolbox/stanford/mri/utility:'];

path(pathStr,p);
path(path)

