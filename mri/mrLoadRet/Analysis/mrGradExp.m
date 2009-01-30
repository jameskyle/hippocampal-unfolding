function [co,ph,amp] =  mrGradExp(co,ph,amp,curSer,curSize)
%[co,ph,amp] =  mrGradExp(co,ph,amp,curSer,curSize)
img_co = reshape(co(curSer,:),curSize(1),curSize(2));
zerovals=img_co==0;

img_z = co(curSer,:).*exp(sqrt(-1)*ph(curSer,:));
img_z(zerovals)=zeros(size(find(zerovals)));
img_z = reshape(img_z,curSize(1),curSize(2));

%[x,y]=meshgrid(linspace(-1,1,size(img_z,2)),linspace(-1,1,size(img_z,1)));
%img_z=exp(sqrt(-1)*sin(2*pi*(x+y));

%d5
%s = [3.342604e-2 0.241125 0.450898 0.241125 3.342604e-2];
%sd = [9.186104e-2 0.307610 0.00000 -0.307610 -9.186104e-2];

%d7
s = [ 0.0050    0.0682    0.2449    0.3636    0.2449    0.0682    0.0050];
sd = [ 0.0186    0.1237    0.1969         0   -0.1969   -0.1237   -0.0186];
gradx = conv2(conv2(img_z,sd,'same'),s,'same');
grady = conv2(conv2(img_z,sd','same'),s','same');
abs_squared = abs(img_z).^2;
rx =  imag(conj(img_z).*gradx)./abs_squared;
ry =  imag(conj(img_z).*grady)./abs_squared;

filt_ph_img = atan2(ry,rx);
filt_ph_img(filt_ph_img<=0)=filt_ph_img(filt_ph_img<=0)+pi*2;

filt_co_img = sqrt(rx.^2+ry.^2);
nanlist = isnan(filt_co_img);
filt_co_img(nanlist)=zeros(size(find(nanlist)));
co(curSer,:)=filt_co_img(:)';
ph(curSer,:)=filt_ph_img(:)';

%RefreshScreen should be called after this function is executed







