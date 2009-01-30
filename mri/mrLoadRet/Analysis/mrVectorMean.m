function [m,sd,num,z]=mrVectorMean(selpts,co,amp,ph,numofanats,curSer);
%[m,sd,num,z]=mrVectorMean(selpts,co,amp,ph,numofanats,curSer);
%
% Calculates mean, sd and number for the variable 'amp' for
% pixels that are in selpts.  Uses current curSer as the
% reference scan to determine the sign; positive if within
% plus/minus 90 degrees of the reference phase, otherwise
% negative.

% 3/12/96  gmb	wrote it.
% 8/5/97   djh simplified it to use selpts
% 9/18/97  gmb added return argument 'z' which holds the phase 
%              and amplitude of each scan as a complex number.

% Don't use pWindow or cothresh, rely on restrictROI to do that instead
% If exist('refexpnum'), use ref phase to asign pos/neg values
% If exist('dc'), use it (divide by dc before computing vector mean)

% ToDo: 
% - should put dc into CorAnal.mat
% - if exist('refexpnum'), use it to get the ref phase
% - num is now the same for every scan (no need for it to be a
%   vector). 

numscans=size(amp,1)/numofanats;

m=zeros(1,numscans);
sd=zeros(1,numscans);
num=zeros(1,numscans);

%Reference scan experiment number
refExp = mod((curSer-1),numscans)+1;
disp(['Reference: scan ',int2str(refExp)]);

for j=1:numscans
  z=[];
  for i=1:numofanats
    series=(i-1)*numscans+j;
    pts=selpts(1,find(selpts(2,:)==i)); 
    if ~isempty(pts)
      z=[z,amp(series,pts).*exp(sqrt(-1)*ph(series,pts))];
    end
  end
  if ~isempty(z) 
    % *** why toss zeros?
    z=z(z~=0);
    m(j)=mean(z);
    sd(j)= std(z);
    num(j)=size(z,2);
  else
    m(j)=NaN;
    sd(j)=NaN;
    num(j)=0;
  end
end

ReferencePhase = angle(m(refExp));
disp([int2str(num(1)),' pixels in ROI']);
disp(['Reference phase: ',num2str(ReferencePhase*180/pi),' degrees']);

ReferencePhase=ReferencePhase*ones(1,numscans);
z=m;
m=abs(m).*sign(cos(ReferencePhase-angle(m)));
return;

