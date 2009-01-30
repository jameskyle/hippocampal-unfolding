function [y,count] = mrRead(filename,imageSize,header,swap)
%mrRead(filename,imageSize,header): Read the MRI data file into a vector.
%
%	filename is a string
%	imageSize is a vector of x and y sizes
%       header is a flag:
%	  if header = 0 then it uses there is no header, just the facts.
%	  if header = 1 then it uses the new header size of 7904
%	  if header = 2 then it uses the older header size of 7900
%
%	Usually, images are 256 x 256
%
%  	The header size used to be 7900 bytes, but Gary decided
%	to zero it on 121092, so we stripped all over here.
%	We have backups on exabyte tapes with headers from 120792 back.
%
%
if nargin < 4,  sawp = 'l'; end
if nargin < 3,  header = -1; end
if nargin < 2,  error('mrRead:  Two arguments required'), end

fid = fopen(filename,'r',swap);		% l to b does byte swapping
if fid == -1
  s = sprintf('Could not open file %s',filename);
  error(s)
end

if header == 1  	%There is a header
  fseek(fid,7904,'bof');%Move start 7904 bytes from start of file
end

if header == 2  	%There is a header
  fseek(fid,7900,'bof');%Move start 7904 bytes from start of file
end

[y,count] = fread(fid,'ushort');
y = reshape(y,imageSize(1),imageSize(2))';
y = reshape(y,1,imageSize(1)*imageSize(2));
fclose(fid);



