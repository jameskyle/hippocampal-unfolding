function [xyz_amp_co_ph_dc,noDataCount] = mrCompressData(xyz_layer_amp_co_ph_dc,layer1map,noDataVal)
% function [xyz_amp_co_ph_dc,noDataCount] = mrCompressData(xyz_layer_amp_co_ph_dc,layer1map,noDataVal)
% 
% AUTHOR: SJC, ABP
% DATE : 04.03.98
% PURPOSE: Averages the data from all the points that are mapped to the
%	   same first layer point.  Places the average as the data for that
%	   first layer point.  First layer points that have no
%	   data are assigned 'noDataVal'
% ARGUMENTS:
%	xyz_layer_amp_co_ph_dc:	[x, y, z, layer, amp, co, ph, dc]
%			This matrix is created by 'flat2volDat'
%	layer1map:	Vector of the layer 1 point closest to each gray
%			matter point.  Created by 'squeeze2layer1'.
%	noDataVal:	value for points with no fMRI data
%
% RETURNS:
%	xyz_amp_co_ph_dc:	[x, y, z, amp, co, ph, dc]
%			The x,y,z locations are for all the layer 1 points
%			and amp, co, ph, dc, are the averaged data values
%			from all the points that were mapped to that
%			particular layer 1 point
%	noDataCount:	number of points in layer 1 with no fMRI data
%

% These are the layer 1 gray matter points
layer1 = find(xyz_layer_amp_co_ph_dc(:,4,1) == 1);

numLayer1Pts = length(layer1);
numberOfScans = size(xyz_layer_amp_co_ph_dc,3);

disp(sprintf('There are %d unfolded points and %d of those are on the first layer.\n',size(xyz_layer_amp_co_ph_dc,1),numLayer1Pts));
disp('Mapping all points to the first layer...')

% Set up output, no layer information because they are all in layer 1
xyz_amp_co_ph_dc = noDataVal * ones(numLayer1Pts,7,numberOfScans);

% Assign x,y,z locations of all unfolded, first layer data
xyz_amp_co_ph_dc(:,1:3,:) = xyz_layer_amp_co_ph_dc(layer1,1:3,:);

% To keep track of how many points have no data
noDataCount = 0;

for ii = 1:numLayer1Pts
  % These are the indeces of the data points that get mapped
  % to this first layer point
  idx = find(layer1map == layer1(ii));

  % Now eliminate the indeces of points with no data assigned
  noDataPoints = find(xyz_layer_amp_co_ph_dc(idx,5,1) == noDataVal);
  idx(noDataPoints) = [];
  
  if isempty(idx)
    noDataCount = noDataCount + 1;
  else
    for jj = 1:numberOfScans
      % For co, just do arithmetic average
      xyz_amp_co_ph_dc(ii,5,jj) = mean(xyz_layer_amp_co_ph_dc(idx,6,jj));
      % For dc, just do arithmetic average
      xyz_amp_co_ph_dc(ii,7,jj) = mean(xyz_layer_amp_co_ph_dc(idx,8,jj));

      % For amp and ph, convert to (real + sqrt(-1) imaginary) and then
      % average in the complex plane
      ampData = xyz_layer_amp_co_ph_dc(idx,5,jj);
      phData = xyz_layer_amp_co_ph_dc(idx,7,jj);
      complexData = ampData .* exp(sqrt(-1)*phData);
      avgData = mean(complexData);
      % This is the amplitude of a complex number
      xyz_amp_co_ph_dc(ii,4,jj) = abs(avgData);
      % This is the phase of a complex number in radians
      xyz_amp_co_ph_dc(ii,6,jj) = angle(avgData);
    end
  end
  
  if (rem(ii,500) == 0)
    disp(sprintf('compressData: compressing data to point %d out of %d...',ii,numLayer1Pts));
  end    

end

% These are the compressed gray matter points that contain data
dataPoints = find(xyz_amp_co_ph_dc(:,4,1) ~= noDataVal);

% Change the phase measure from [-pi, pi] to [0, 2pi].
% This is the convention used everywhere else in 'mrLoadRet'.
% We don't worry about changing to sine phase because this has
% already been done when creating the 'FCorAnal_hemi.mat' file.

ph = xyz_amp_co_ph_dc(dataPoints,6,:);
ph(ph<0)=ph(ph<0)+pi*2;
xyz_amp_co_ph_dc(dataPoints,6,:) = ph;

disp(sprintf('There are %d points on layer 1 with no fMRI data\n', noDataCount));

return
