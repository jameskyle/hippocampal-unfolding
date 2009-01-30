% mrSaveUnfoldParams.m
% script
%
% AUTHOR:	SJC, 05.26.98
% PURPOSE:	Callback script that creates a paramsFile and saves the unfold
%		parameters specified in mrVol in a .mat file for use by 'Unfold.m'
%

pFile = get(paramsFile_edit,'String');
% Get rid of the '.m' at the end of the file name
idx = length(pFile);
if (pFile(idx-1:idx) == '.m')
  pFile(idx-1:idx) = [];
end

params.filename		= [get(unfSaveDir_edit,'String') '/' get(paramsFile_edit,'String')];
params.unfSaveDir	= get(unfSaveDir_edit,'String');
params.startPoint	= selectedNode.index;
params.radius		= volStruct.radius;
params.dimdist		= str2num(get(dimdist_edit,'String'));
params.P		= str2num(get(plane_edit,'String'));
params.vis		= get(display_chk,'Value');
params.saveFlag		= get(save_chk,'Value');
params.sampSpacing	= str2num(get(sampSpacing_edit,'String'));
params.nIter		= str2num(get(nIter_edit,'String'));
params.rSamp		= str2num(get(rSamp_edit,'String'));
params.flatWeight	= str2num(get(flatWeight_edit,'String'));
params.penalty		= str2num(get(penaltyFunc_edit,'String'));
params.M		= str2num(get(M_edit,'String'));
params.rSeed		= str2num(get(rSeed_edit,'String'));

fid = fopen(params.filename,'w');

fprintf(fid,'%% %s\n',date);
fprintf(fid,'%% Anatomy: %s/%s\n\n',	anatomy.dir,anatomy.file);
fprintf(fid,'graphFile = ''%s'';\n',	[anatomy.dir '/' grayMatter.hemisphere '/' grayMatter.file]);
fprintf(fid,'unfSaveDir = ''%s'';\n',	params.unfSaveDir);
fprintf(fid,'startPoint = %d;\n',	params.startPoint);
fprintf(fid,'radius = %d;\n',		params.radius);
fprintf(fid,'dimdist = [%f %f %f];\n',	params.dimdist);
fprintf(fid,'P = [%d %d %d];\n',	params.P);
fprintf(fid,'vis = %d;\n',		params.vis);
fprintf(fid,'saveFlag = %d;\n',		params.saveFlag);
fprintf(fid,'sampSpacing = %f;\n',	params.sampSpacing);
fprintf(fid,'nIter = %d;\n',		params.nIter);
fprintf(fid,'rSamp = %d;\n',		params.rSamp);
fprintf(fid,'flatWeight = %d;\n',	params.flatWeight);
fprintf(fid,'penalty = %d;\n',		params.penalty);
fprintf(fid,'M = %d;\n',		params.M);
fprintf(fid,'rSeed = %d;\n',		params.rSeed);

fclose(fid);

fprintf('Created parameters file ''%s''.\n',params.filename);