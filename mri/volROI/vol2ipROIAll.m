function vol2ipROIAll(homedr)
%vol2ipROIAll([homedr])
%
%Projects all volume ROI's found in the subject's volume ROI
%directory to directory <homedr>  Default <homedr> is the
%current directory.

%11/23/97 gmb  Wrote it.

if ~exist('homedr')
  homedr = pwd;
end

%Get the subject's name from AlignParams
if check4File('AlignParams')
  load AlignParams
else
  disp(['file ',pwd,'/AlignParams not found.']);
  return
end

%Get a list of the subject's volume ROIs
homedr = pwd;
volROIdr = ['/usr/local/mri/anatomy/',subject,'/volROIs/'];
chdir(volROIdr);
[a,fileList] = unix(['ls *.mat']);
if isempty(fileList)
  disp(['no volume ROIs found in ',pwd]);
  chdir(homedr);
  return
end
endid = findstr(fileList,'.mat')-1;
startid = [1,endid(1:(length(endid)-1))+6];
chdir(homedr);

qt = '''';
disp(['projecting ',subject,qt,'s ',num2str(length(startid)),' volume ROIs to ',pwd])

%Loop and project all volume ROIs
for i=1:length(startid)
  fileName = fileList([startid(i):endid(i)]);
  vol2ipROI(fileName,fileName);
end
disp('done.');

