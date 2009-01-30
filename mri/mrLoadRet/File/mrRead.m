function [y,count] = mrRead(filename,imageSize,header)
%
%  [y, cnt] = mrRead(filename,imageSize,header)
%AUTHOR:  Wandell
%PURPOSE: Read the MRI data file into a vector.
%
%	filename:  A string containing the file name
%	imageSize: A 2x2 vector of row and col sizes
%	header:  An optional switch to indicate whether the file
%	   has a header and what size.
%
%
%	y:  The prod(imageSize) vector containing the image data
%	count:  The number of length of the vector
%
%	Lately, the images are 256 x 256
%  	The header size used to be 7900 bytes, but Gary decided
%	to zero it on 121092, so we stripped all over here.
%	We have backups on exabyte tapes with headers from 120792 back.
%

%   121/4/96 gmb  Added check to uncompress and recompress files
%
if nargin < 3,  header = -1; end
if nargin < 2,  error('mrRead:  Two arguments required'), end

%Uncompress file if <filename>.gz is found
if check4File([filename,'.gz'])
  unfoldFlag = 1;
  disp (['Uncompressing ',filename,' ...']);
  unix(['gunzip ',filename]);
else
  unfoldFlag = 0;
end

fid = fopen(filename,'r');
if fid == -1
  s = sprintf('Could not open file %s',filename);
  error(s)
end

if header == 1  	%There is a header
  fseek(fid,7900,'bof');%Move start 7900 bytes from start of file
end

if header >1  % Header size given
   fseek(fid,header,'bof');%Move start [header] bytes from start of file
end

[y,count] = fread(fid,'ushort');

y = reshape(y,imageSize(1),imageSize(2))';
y = reshape(y,1,imageSize(1)*imageSize(2));
fclose(fid);

%Re-compress the file
if unfoldFlag ==1
  disp (['Compressing   ',filename,' ...']);
  unix(['gzip ',filename]);
end

