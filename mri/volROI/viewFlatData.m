%viewFlatData.m
%
%Uses viewUnfold to view flattened data

mrLoadAlignParams;

voldir = '/usr/local/mri/anatomy';
unfoldSubDir = '';
unfdir =  ...
    [voldir,'/',subject,'/',hemisphere,'/', unfoldSubDir,'/'];

str = ['load ',unfdir,'gLocs2dTmp'];
eval(str);


sFactor = 1;
kernel = mkGaussKernel([5 5],[2 2]); 	%original default
mp = [hsv(63);[0,0,0]];
mpScale = 's';

[imUnfold rowF colF fSize] = viewUnfold(gLocs2d,sFactor,kernel,...
 	mp,volPh,mpScale);

figure
image(imUnfold)
colormap(mp);

