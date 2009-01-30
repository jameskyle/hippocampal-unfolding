% vol2flatDat.m
%
%HISTORY:
%9/9/97 gmb wrote it.

load ExpParams
nScans = numofexps/numofanats;

%loop through the two hemispheres
selpts_left = [];
selpts_right = [];
for hemnum = 1:2
  if hemnum == 1
    hemisphere = 'left';
  else
    hemisphere = 'right';
  end

  %load flattened anatomy to get gray2flat and gLocs3d
  estr = ['load Fanat_',hemisphere];
  eval(estr);
  nGrays = size(gLocs3d,1);
  co = zeros(nScans,prod(fSize));
  z = zeros(nScans,prod(fSize));
  ph = zeros(nScans,prod(fSize));
  amp = zeros(nScans,prod(fSize));
  count = zeros(1,prod(fSize));
  
  %load volume CorAnal
  estr = ['load volCorAnal_',hemisphere];
  eval(estr);

  for grayPixel= 1:nGrays
    count(gray2flat(grayPixel)) = count(gray2flat(grayPixel)) + 1;
    co(:,gray2flat(grayPixel))  = co(:,gray2flat(grayPixel))  + volCo(grayPixel,:)';
    z(:,gray2flat(grayPixel)) =  z(:,gray2flat(grayPixel)) + ...
	 (volAmp(grayPixel,:).*exp(-sqrt(-1)*volPh(grayPixel,:)))';
  end

  goodvals = (count>0);
  co(:,goodvals)=co(:,goodvals)./(ones(nScans,1)*count(goodvals));
  z(:,goodvals)=z(:,goodvals)./(ones(nScans,1)*count(goodvals));
  amp = abs(z);
  ph = angle(z);
  ph(ph<0) = ph(ph<0)+pi*2;
  
  estr = (['save FCorAnal_',hemisphere,' amp co ph']);
  disp(estr);
  eval(estr);
end %hemispheres



