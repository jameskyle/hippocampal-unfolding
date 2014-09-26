function writeVolume(fname,vData,vSize)
%
%  writeVolume(fname,vData,vSize)
%
%AUTHOR:  Wandell
%DATE:    08.08.95
%PURPOSE:
%   Interface to method of writing out volume data used by mrUnfold.
%
% 
%
% fname:  Output filename
% vSize:  [row col nplanes]
% vData:  volume data is a matrix of size [nplanes row*col] where each
%	  row is an image.  The data are organized this way because of
%	  the way mrSeries returns a volume data after reading in the
%	  Signa file.
%

rows = vSize(1);
cols = vSize(2);
planes = vSize(3);
endOfHeader = '*';

vFile = fopen(fname,'w');
fprintf(vFile,'rows %f\n',rows);
fprintf(vFile,'cols %f\n',cols);
fprintf(vFile,'planes %f\n',planes);
fprintf(vFile,'%c\n',endOfHeader);

for i=1:planes
 tmp = vData(i,:);
 tmp = reshape(tmp,vSize(1),vSize(2));
 tmp = tmp';
 tmp = tmp(:);
 vData(i,:) = tmp';
end

% The images are to be read in by a C-program that reads down
% the rows, not across the columns. So, we transpose the data before writing.
vData = vData';
fwrite(vFile,vData,'uchar');
fclose(vFile);

