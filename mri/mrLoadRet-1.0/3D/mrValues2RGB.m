function out = ...
	mrValues2RGB(data_selected,scanNum,pWindow,coThresh,noDataVal)
% function out = ...
%	mrValues2RGB(data_selected,scanNum,pWindow,coThresh,noDataVal)
%
% AUTHOR:	SJC
% DATE:		04.16.98
% PURPOSE:	Loads up all necessary variables and calls function that
%		creates a matrix of (x,y,z) locations and R,G,B values for
%		rendering each of those points out of the data selected
% ARGUMENT:
%	data_selected:		can be 'amp', 'co', 'ph', or 'dc', depending
%				on which data the user wishes to render
%	scanNum:		from which scan you want to extract data
%	pWindow:		phase window threshold required
%	                        for displaying data. (DEFAULT = [0 360])
%	coThresh:		correlation threshold required
%	                        for displaying data. (DEFAULT = 0.23)
%	noDataVal:		value for points with no fMRI data
%
% RETURNS:
%	nothing
%
% MODIFICATIONS:
% 07.01.98 RJT	Modified to use a color map and indexing rather than raw
%               RGB values. Writes out in a more concise, integer format.
% 07.10.98 SJC	Changed to load volCorAnal_HEMISPHERE (output of ip2VolDat.m)
%		instead of VCorAnal_HEMISPHERE
% 07.13.98 SJC  Added check for validity of the scan number, eliminated it as
%		an input to values2index
%

side = input('Create 3D file for [l]eft, [r]ight, or [b]oth hemispheres?  ','s');
if isempty(side)
  side = 'b';
end

fprintf('Experiment number:	%d\n',	   scanNum);
fprintf('Data selected:         %s\n',     data_selected);
fprintf('Correlation threshold: %f\n',     coThresh);
fprintf('Phase window:          [%d %d]\n',pWindow(1),pWindow(2));

if ((side == 'b') | (side == 'l'))
  % 07.10.98 SJC
  % Changed to load volCorAnal_left instead of VCorAnal_left
  % We get volCo, volPh and volAmp.  volDC might be there if
  % the dc values have been calculated.
  %
  load volCorAnal_left
  
  % We get gLocs3d from here
  %
  load Fanat_left
  
  if scanNum > size(volCo,2)
    errordlg(sprintf('values2index:  Asking for scan %d out of %d',...
 	  scanNum,size(volCo,2)));
  end

  if exist('volDC')
    leftXYZ_amp_co_ph_dc = [gLocs3d volAmp(:,scanNum) volCo(:,scanNum) volPh(:,scanNum) volDC(:,scanNum)];
  else
    leftXYZ_amp_co_ph_dc = [gLocs3d volAmp(:,scanNum) volCo(:,scanNum) volPh(:,scanNum) ones(size(gLocs3d,1),1)];
  end
  
  [leftXYZ_index,cMap,nInCmap] = values2index(leftXYZ_amp_co_ph_dc,data_selected,noDataVal,coThresh,pWindow);
  %leftXYZ_RGB  = values2RGB(leftXYZ_amp_co_ph_dc,data_selected,scanNum,noDataVal,coThresh,pWindow);
  
  saveFile = [data_selected '_' num2str(scanNum) '_L.3d'];
  fprintf('Default file name to save left hemisphere 3D data: %s\n',saveFile);
  tempFile = input('Enter new file name [RETURN to keep default]:','s');
  if ~isempty(tempFile)
    saveFile = tempFile;
  end

  fid=fopen(saveFile,'w');    
  % Write the LUT, then the data
  fprintf(fid,'%.0f\n',nInCmap);
  fprintf(fid,'%.0f %.0f %.0f\n',cMap');
  fprintf(fid,'%.0f %.0f %.0f %.0f\n',leftXYZ_index');
  % Close the output file
  fclose(fid)
end

if ((side == 'b') | (side == 'r'))
  % 07.10.98 SJC
  % Changed to load volCorAnal_right instead of VCorAnal_right
  % We get volCo, volPh and volAmp.  volDC might be there if
  % the dc values have been calculated.
  %
  load volCorAnal_right
  % We get gLocs3d from here
  %
  load Fanat_right

  if scanNum > size(volCo,2)
    errordlg(sprintf('values2index:  Asking for scan %d out of %d',...
 	  scanNum,size(volCo,2)));
  end
  
  if exist('volDC')
    rightXYZ_amp_co_ph_dc = [gLocs3d volAmp(:,scanNum) volCo(:,scanNum) volPh(:,scanNum) volDC(:,scanNum)];
  else
    rightXYZ_amp_co_ph_dc = [gLocs3d volAmp(:,scanNum) volCo(:,scanNum) volPh(:,scanNum) ones(size(gLocs3d,1),1)];
  end

  [rightXYZ_index,cMap,nInCmap]  = values2index(rightXYZ_amp_co_ph_dc,data_selected,noDataVal,coThresh,pWindow);
  %rightXYZ_RGB  = values2RGB(rightXYZ_amp_co_ph_dc,data_selected,scanNum,noDataVal,coThresh,pWindow);
  
  saveFile = [data_selected '_' num2str(scanNum) '_R.3d'];
  fprintf('Default file name to save right hemisphere 3D data: %s\n',saveFile);
  tempFile = input('Enter new file name [RETURN to keep default]:','s');
  if ~isempty(tempFile)
    saveFile = tempFile;
  end

  fid=fopen(saveFile,'w');    
  % Write the LUT, then the data
  fprintf(fid,'%.0f\n',nInCmap);
  fprintf(fid,'%.0f %.0f %.0f\n',cMap');
  fprintf(fid,'%.0f %.0f %.0f %.0f\n',rightXYZ_index');
  % Close the output file
  fclose(fid)

end

disp('done.')

return
