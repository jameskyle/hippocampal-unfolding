% mrSaveCut
% script
%
% AUTHOR:	SJC
% DATE:		06.30.98
% PURPOSE:	Callback for cut save button, saves cut node indeces as a
%		'.mat' file for use by Unfold and as a 3D file for rendering
% HISTORY:
% 07.10.98 SJC	Changed name from mrVolSaveCut.m to mrSaveCut.m because
%		mrVol will now be called mrUnfold

cutFilename = get(save_edit,'String');
cmd = ['save ' saveDir '/' cutFilename ' cutNodes'];
eval(cmd);
fprintf('Cut node indeces saved in %s/%s\n',saveDir,cutFilename);

fid = fopen([saveDir '/' cutFilename '.3d'],'w');

% All cut nodes will be black
fprintf(fid,'1\n');
fprintf(fid,'0 0 0\n');

% Print (x,y,z) locations of cut nodes
xyz = [grayStruct.nodes(1,cutNodes)'-1,grayStruct.nodes(2,cutNodes)'-1,grayStruct.nodes(3,cutNodes)'-1];
fprintf(fid,'%.0f %.0f %.0f 1\n',xyz');

fclose(fid);

fprintf('3D data saved in %s\n',[saveDir '/' cutFilename '.3d']);
