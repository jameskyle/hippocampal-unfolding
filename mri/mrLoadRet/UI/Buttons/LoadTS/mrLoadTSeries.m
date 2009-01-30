function tSeries=mrLoadTSeries(curSer,viewPlane);
%tSeries = mrLoadTSeries(curSer,[viewPlane])
%  loads in tSeries of experiment curSer
%  and displays 'done.' when finished.

% 8/95    gmb  Wrote it.
% 9/2/96  gmb  Added viewPlane input to allow loading
%              flattened tSeries

if nargin==1
  viewPlane='inplane';
end


if strcmp(viewPlane,'inplane')
  filename = (['tSeries',num2str(curSer)]);
else
  filename = (['FtSeries',num2str(curSer),'_',viewPlane]);
end

if check4File(filename)
  disp(['loading ',filename,' ...']);
  eval(['load ',filename]);
  disp('done.');
else
  tSeries = [];
  qt = '''';
  disp(['*** ERROR:  file ',qt,filename,'.mat',qt,' not found ***']);
  disp(['Time series not loaded.']);
end


