% script ip2VolDat
%
% AUTHOR:  Boynton
% DATE:  01.98?
% PURPOSE: 
%   Supersamples volume anatomy pixels, and then 
%   uses linear interpolation in the inplanes.
% 
% Using point sampling to map co, amp, and ph to volCo, volAmp,
% and volPh.  Writes them out in volCorAnal.mat
% 

% Here is a test set we will use
% 
% chdir('/usr/local/mri/retinotopy/poirson/011598')

% Load up the data and experimental parameter values
% 

if ~exist('co'),  load CorAnal, end

% mrLoadRet parameters
load ExpParams
load anat

mrLoadAlignParams;

% This is created by mrAlign
% 
load bestrotvol

nScans = numofexps/numofanats;

% The algorithm works like this ... more words here
% 
%  This refers to the number of samples we will add within each
%  volume voxel.  So, if there is only one sample, we do
%  nothing.  If there are two, then we will position the voxels
%  at -0.25 and 0.25 relative to the origin.  If there are four
%  supersamples we will replicate the array at positions 
%    -0.375,-0.1250, 0.125, 0.3750.
%  Think of the volume as being shifted and replicated in each
%  dimension by the number defined in sampFactor.
% 

% Here we set the spatial supersampling factor
% 
sampFactor = 1; 			%supersampling factor 
sampList = [1:sampFactor]/sampFactor - (sampFactor+1)/(2*sampFactor);

% Next, we compute the positions of the volume gray matter
% data in the inplane coordinate frame.  This computation will be
% done using a 4x4 homogeneous transform.
% 
% So, if the volume coords are (u,v,w), then we will have a
% transformation to inplane coordinates (x,y,z) via
% 
%        x             u
%        y             v
%        z   = [ 4x4 ] w
%        1             1
% 
% This is the complete 4x4.
% 
Xform = inv(inplane2VolXform(rot,trans,scaleFac));

% We don't care about the last coordinate in (x,y,z,1), so we
% toss the fourth row of Xform.  Then our outputs will be (x,y,z).
% 
Xform = Xform(1:3,:);

% For each hemisphere, transform the volume coordinates to
% inplane coordinates.  Then assign values.

for hemnum = 1
  if hemnum ==1
    hemisphere = 'right';
  else
    hemisphere = 'left';
  end

  % gLocs3d is loaded here.
  % 
  estr = ['load Fanat_',hemisphere];
  eval(estr);

  % This is the number of gray matter points
  % 
  nGrays = size(gLocs3d,1);

  % Now, we allocate space for the variables we will assign to
  % the volume data
  % 
  volCo =  zeros(nGrays,nScans);
  volPh =  zeros(nGrays,nScans);
  volAmp = zeros(nGrays,nScans);
  

  % Loop through each scan
  % curScan = 1
  for curScan = 1:nScans
    
    disp(sprintf('Hemisphere: %s, Scan number %d\n',hemisphere,curScan));

    % These represent the real and imaginary parts of the amp/ph
    % representation for the volume voxels. They are interpolated
    % from the inplane data via interp3, below.
    % 
    realInterpVol = zeros(nGrays,1);
    imagInterpVol = zeros(nGrays,1);
    coInterpVol = zeros(nGrays,1);
    
    % Figure out which rows of the data matrices contains the
    % values for this scan and all anatomical slices
    % 
    seriesNums=scanSlice2Series(curScan,1:numofanats,numofexps,numofanats);

    % Pull out the correlations, phases, and amplitudes of the
    % inplane data for this scan and all anatomical slices
    % 
    subco=co(seriesNums,:)';
    subph=ph(seriesNums,:)';
    subamp=amp(seriesNums,:)';

    % Convert the data to a form we will use in trilinear
    % interpolation. 
    % 
    subco =reshape(subco,curSize(2),curSize(1),numofanats);
    subph =reshape(subph,curSize(2),curSize(1),numofanats);
    subamp=reshape(subamp,curSize(2),curSize(1),numofanats);

    % xs,ys, and zs refer to the shifts in these dimensions
    % introduced by the supersampling.  As you will see below,
    % if we are supersampling, we will copy the inplane data to
    % various shifted versions the volume coordinates.  Otherwise, sampList
    % is all zeros and we don't need x,y, and z shifts.

    % xs = 0, ys = 0, zs = 0
    for xs = sampList
      for ys = sampList
	for zs = sampList

	  % Convert the 3d coordinates into homogeneous form.
	  % 
	  % 
	  volCoords=[gLocs3d(:,1:3)'; ones(1,nGrays)];

	  % Now, if we are supersampling, we create the shifted
	  % version of the volume coordinates
	  % 
	  volCoords(1,:) = volCoords(1,:) + xs;
	  volCoords(2,:) = volCoords(2,:) + ys;
	  volCoords(3,:) = volCoords(3,:) + zs;

	  % Show the positions of the volume coords
	  % 
	  % plot3(volCoords(1,:),volCoords(2,:),volCoords(3,:))
	  
	  % Print out the shift to comfort yourself
	  % disp(sprintf('xs %5.2f, ys %5.2f, zs %5.2f\n',xs,ys,zs));

	  % transform volCoord positions to inplane coordinates.
	  % Hence, inplaneCoords contains the inplane position of
	  % each of the gray matter voxels.
	  % 
	  % GMB had this comment:  look into this '-.5' business
	  % 
	  volInplaneCoords=Xform*volCoords; 

	  % Convert the inplane data sets for amp and ph into a
	  % real and imaginary part of a complex number.
	  % 
	  realInplaneData = subamp.*cos(subph);
	  imagInplaneData = subamp.*sin(subph);
	  
	  % Use the inplane data set values in realInplaneData
	  % and imagInplaneData to assign (using trilinear
	  % interpolation) values to the volume voxels in
	  % realInterpVol and imagInterpVol and volCo.  If there are
	  % several (supersampled) measurements within each
	  % voxel, then they all get added into the same voxel
	  % representation as we interpolate for the different
	  % shifted copies.

	  realInterpVol = ...
	      realInterpVol + ...
	      interp3(realInplaneData,...
	      volInplaneCoords(1,:),volInplaneCoords(2,:),volInplaneCoords(3,:)+1)';

	  imagInterpVol = ...
	      imagInterpVol + ...
	      interp3(imagInplaneData,...
	      volInplaneCoords(1,:),volInplaneCoords(2,:),volInplaneCoords(3,:)+1)';

	  coInterpVol = ...
	      coInterpVol + ...
	      interp3(subco, ...
	      volInplaneCoords(1,:),volInplaneCoords(2,:),volInplaneCoords(3,:)+1)';

	end 				%zs
      end 				%ys
    end 				%xs

    %divide by sampFactor.^3 to get average
    %
    realInterpVol = realInterpVol/(sampFactor.^3);
    imagInterpVol = imagInterpVol/(sampFactor.^3);
    coInterpVol   = coInterpVol/(sampFactor.^3);

    volCo(:,curScan) = coInterpVol;
    volPh(:,curScan) = atan2(imagInterpVol,realInterpVol);
    volAmp(:,curScan) = sqrt(realInterpVol.^2 + imagInterpVol.^2);

  end 					%nscans

  % Wrap the phases to be all positive.
  % 
  volPh(volPh<0) = volPh(volPh<0) +  (2*pi);

  % Save it
  estr =['save volCorAnal_',hemisphere,' volCo volPh volAmp'];
  disp(estr)
  eval(estr);

end 					%hemnum




