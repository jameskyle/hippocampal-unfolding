%CreateDC.m
%
%Creates dc matrix from tSeries.  
%Each pixel holds the mean value of the pixel's time-course.
%saves it with CorAnal.mat
%

% 11/24/96  gmb  Wrote the silly short script.
% 8/6/97    djh  Modified to save it in CorAnal.mat

clear dc
load CorAnal
if exist('dc')
  disp('dc already exists in CorAnal.mat');
elseif check4File('DC')
  disp('DC.mat exists.  Using that...');
  load DC
  dc=map;
else
  load ExpParams
  load anat
  dc=zeros(numofexps,prod(curSize));
  for i=1:numofexps
    tSeries = mrLoadTSeries(i);
    dc(i,:)=mean(tSeries((junkimages+1):size(tSeries,1),:));
  end
end

disp(['Saving Correlation Matrices']);
str=['save CorAnal co ph amp dc'];
eval(str);



