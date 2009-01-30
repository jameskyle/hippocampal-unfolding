function [m,sd,num,z]=mrMeanProjAmp(selpts,co,amp,ph,numofanats,curSer);
%[m,sd,num,z]=mrMeanProjAmp(selpts,co,amp,ph,numofanats,curSer);
%
% Calculates mean, sd and number for the variable 'amp' for
% pixels that are in selpts.  Projects amp*exp(i*ph) onto 
% reference vector using the current curSer as the
% reference scan.

% 3/12/96  gmb	wrote it.
% 8/5/97   djh simplified it to use selpts
% 9/18/97  gmb added return argument 'z' which holds the phase 
%              and amplitude of each scan as a complex number.
% 11/17/97 gmb Created mrMeanProjAmp from mrVectorMean

% Don't use pWindow or cothresh, rely on restrictROI to do that instead
% If exist('dc'), use it (divide by dc before computing vector mean)

% ToDo: 
% - if exist('refexpnum'), use it to get the ref phase

if isempty(selpts)
  m=NaN*ones(1,1:numscans);
  sd=NaN*ones(1,1:numscans);
  num=0;
  return
end

numscans=size(amp,1)/numofanats;

m=zeros(1,numscans);
sd=zeros(1,numscans);

%Reference scan experiment number
refExp = series2scanSlice(curSer,numscans*numofanats,numofanats);
disp(['Reference: scan ',int2str(refExp)]);

z = [];
for i=1:numofanats
  series = scanSlice2Series(1:numscans,i,numscans*numofanats,numofanats);
  pts=selpts(1,find(selpts(2,:)==i)); 
  if ~isempty(pts)
    z=[z,amp(series,pts).*exp(sqrt(-1)*ph(series,pts))];
  end
end


refZ = mean(z(refExp,:))/abs(mean(z(refExp,:)));
ReferencePhase = angle(refZ);
disp(['Reference phase: ',num2str(ReferencePhase*180/pi),' degrees']);

%project each mean onto the reference scan
projAmp = real(z*conj(refZ));
%m is the mean projected amp
m = mean(projAmp');
%sd is the sd of the projected amps
sd = std(projAmp');
num = size(z,2);

disp([int2str(num(1)),' pixels in ROI']);


