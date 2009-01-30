function class = writeClassFile(class,filename);
% 
% AUTHOR:  Wandell
% DATE: 10.17.97
% PURPOSE: 
%   Write out the information in a class structure so that it can
% be read by mrGray.  Matlab 5.0 code.
% 
% ARGUMENTS:
% 
%    class:  The classification data structure 
% filename:  The output filename
% 
% 

% DEBUG:
% Read in a class file, write it back out, and check thend read
% it back in again.
% 
% class = readClassFile('rightCalc.class');
% filename = 'test.class'
% writeClassFile(class,filename);
% tclass = readClassFile(filename);
% 
% Check class.header by hand.
% max(abs(tclass.data(:) - class.data(:)))
% class.header.params - tclass.header.params
% class.header.voi - tclass.header.voi
% class.header.vSize - tclass.header.vSize

% Open the file
% 
fprintf('Writing class file:  %s\n',filename);
fp = fopen(filename,'w');

% Write header information
% 
fprintf(fp, 'version= %d\n',class.header.version);
fprintf(fp, 'minor= %d\n',class.header.minor);

fprintf(fp, 'voi_xmin=%d\n',class.header.voi(1));
fprintf(fp, 'voi_xmax=%g\n',class.header.voi(2));
fprintf(fp, 'voi_ymin=%d\n',class.header.voi(3));
fprintf(fp, 'voi_ymax=%d\n',class.header.voi(4));
fprintf(fp, 'voi_zmin=%d\n',class.header.voi(5));
fprintf(fp, 'voi_zmax=%d\n',class.header.voi(6));

fprintf(fp, 'xsize=%d\n',class.header.xsize);
fprintf(fp, 'ysize=%d\n',class.header.ysize);
fprintf(fp, 'zsize=%d\n',class.header.zsize);

csf_mean   = class.header.params(1);
gray_mean  = class.header.params(2);
white_mean = class.header.params(3);
stdev      = class.header.params(4);
confidence = class.header.params(5);
smoothness = class.header.params(6);

% 
% 
fprintf(fp, 'csf_mean=%g\n',csf_mean );
fprintf(fp, 'gray_mean=%g\n',gray_mean);
fprintf(fp, 'white_mean=%g\n',white_mean);
fprintf(fp, 'stdev=%g\n',stdev);
fprintf(fp, 'confidence=%g\n',confidence);
fprintf(fp, 'smoothness=%d\n',smoothness);

% Reshape the volume
% 
% class.data = ...
%     reshape(im,[class.header.xsize,class.header.ysize,class.header.zsize]);

im = class.type.unknown* ...
    ones(class.header.xsize, class.header.ysize,class.header.zsize);
im( ...
    (class.header.voi(1):class.header.voi(2))+1, ...
    (class.header.voi(3):class.header.voi(4))+1, ...
    (class.header.voi(5):class.header.voi(6))+1 ...
    ) = class.data;

% Write the raw data
% 
cnt = fwrite(fp,im,'uchar');
fclose(fp);

return;

% 
% End of writeClassFile

