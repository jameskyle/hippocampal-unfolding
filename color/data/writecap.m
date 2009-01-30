function count = writecap(filename,data)
%
%  count = writecap(filename,data)
%  Write the data into a Cap Matrix file out to the file filename.
%
if isstr(filename) ~= 1
  disp('First argument must be a string')
  return
end
s = size(data);
fid = fopen(filename,'w');
fprintf(fid,'%d\n',s);
count = fprintf(fid,'%e ',data');
fclose(fid);

