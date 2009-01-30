function result = makeSyntheticImage(dims,funname,Yrange,Xrange,var1,var2,var3,var4,var5)
% makeSyntheticImage: makes a synthetic image from a function
%
%	im = makeSyntheticImage([ydim xdim],'funname',[Y1 YM],[X1 XN],var1,var2.,,,)
%	[ydim xdim] is image size
%	[Y1 YM] is y-range
%	[X1 XM] is x-range
%	funname must be a function that takes image ramps y and x
%       var1,... are additional variables sent to funname
%       funname should be of the form result=funname(y,x,var1,var2,...)
%	(see Rsqrd.m or Gaussian.m for examples)
%
% Examples:
%
% im1 = makeSyntheticImage([65 65],'rsqrd');
% im2 = makeSyntheticImage([65 65],'gaussian',[-4 4],[-4 4],2);
%
% DJH '96

if ~exist('Yrange')
  Yrange = [-1 1];
end
if ~exist('Xrange')
  Xrange = [-1 1];
end

[x,y] = meshgrid(linspace(Xrange(1),Xrange(2),dims(2)), ...
    linspace(Yrange(1),Yrange(2),dims(1)));

fcall = [funname,'(y,x'];
for i=1:nargin-4
  fcall=[fcall,',var',num2str(i)];
end
fcall=[fcall,')'];
result = eval(fcall);

