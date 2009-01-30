% script ipt2VolDat
%
% like data2Vol, supersamples volume anatomy pixels, and then 
% uses linear interpolation in the inplanes.
% 
% Using point sampling to map co, amp, and ph to volCo, volAmp,
% and volPh.  Writes them out in volCorAnal.mat

sampFactor = 3;  %supersampling factor 
sampList = [1:sampFactor]/sampFactor - 1/(2*sampFactor);

% load corAnal
if ~exist('co')
  load CorAnal
end

load ExpParams
load anat
mrLoadAlignParams;
load bestrotvol

nScans = numofexps/numofanats;
% 4x4 homogeneous tranform that tranforms from volume to inplane.
Xform = inv(inplane2VolXform(rot,trans,scaleFac));
Xform = Xform(1:3,:);

for hemnum = 1:2
  if hemnum ==1
    hemisphere = 'right';
  else
    hemisphere = 'left';
  end
  estr = ['load Fanat_',hemisphere];
  eval(estr);

  nGrays = size(gLocs3d,1);
  
  
  %subsample volume anatomy voxels.
  

  volCo =  zeros(nGrays,nScans);
  volPh =  zeros(nGrays,nScans);
  volAmp = zeros(nGrays,nScans);
  
  for curScan = 1:nScans
    disp(sprintf('Hemisphere: %s, Scan number %d\n',hemisphere,curScan));
    realVolZ = zeros(nGrays,1);
    imagVolZ = zeros(nGrays,1);
    
    % unwrap the data for the current scan
    seriesNums=scanSlice2Series(curScan,1:numofanats,numofexps,numofanats);
    subco=co(seriesNums,:)';
    subph=ph(seriesNums,:)';
    subamp=amp(seriesNums,:)';
    subco=subco(:);
    subph=subph(:);
    subamp=subamp(:);
    
    for xs = sampList
      for ys = sampList
	for zs = sampList
	  volCoords=[gLocs3d(:,1:3)'; ones(1,nGrays)];
	  volCoords(1,:) = volCoords(1,:) - xs;
	  volCoords(1,:) = volCoords(1,:) - ys;
	  volCoords(1,:) = volCoords(1,:) - zs;
	  disp(sprintf('xs %5.2f, ys %5.2f, zs %5.2f\n',xs,ys,zs));
	  % transform volCoord positions to inplanes
	  inplaneCoords=Xform*volCoords; %look into this '-.5' business
	  %Trilinear interpolation here.
	  %Calculate real and imaginary components of amp*exp(i*ph);
	  realZ = subamp.*cos(subph);
	  imagZ = subamp.*sin(subph);
	  realVolZ = realVolZ + ...
	      myCinterp3(realZ,curSize,numofanats,inplaneCoords',NaN)';
	  imagVolZ = imagVolZ + ...
	      myCinterp3(imagZ,curSize,numofanats,inplaneCoords',NaN)';
	  volCo(:,curScan) = volCo(:,curScan) + ...
	      myCinterp3(subco,curSize,numofanats,inplaneCoords',NaN)';
	end 				%zs
      end 				%ys
    end 				%xs
    %divide by sampFactor.^3 to get average
    realVolZ = realVolZ/sampFactor.^3;
    imagVolZ = imagVolZ/sampFactor.^3;
    volCo(:,curScan) = volCo(:,curScan)/sampFactor.^3;
    volPh(:,curScan) = atan2(imagVolZ,realVolZ);
    volAmp(:,curScan) = sqrt(realVolZ.^2 + imagVolZ.^2);
  end %nscans
  volPh(volPh<0) = volPh(volPh<0)+pi*2;

  %save it
  estr =['save volCorAnal_',hemisphere,' volCo volPh volAmp'];
  disp(estr)
  eval(estr);
end                                     %hemnum




