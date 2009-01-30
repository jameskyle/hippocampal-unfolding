function [co,ph,amp,map] =  ...
    mrBlurExp(co,ph,amp,map,curSer,curSize,sFilter,anat,slico)
% 
% [co,ph,amp,map] = ...
%    mrBlurExp(co,ph,amp,map,curSer,curSize,sFilter,[anat],[slico])
% 
% AUTHOR:  Boynton
% PURPOSE:
%   Spatial blurring of the correlation and phase values
% 
% 12/12/96   gmb  If anat is in input, blurring does not bleed
%                beyond regions where anatomy is present.
% 07/07/97   Lea updated to 5.0
% 051498    BW, added comment and looked at line below where
%           divide by zero occurs often.  See comment.

%%%%%%%%%%%%%%%%%%%%%%%
% Debugging - HAB, 05.18.98
%dataDir = '/usr/local/mri/GY/092697a';
%chdir(dataDir)
%load Fanat_left
%load FCorAnal_left
%
%chdir('/home/brian/slides/mri/Patients/gy/PhasePlots/data/Blur');
%load testcoph
%chdir(dataDir)
%
%curSer = 1;
%curSize = fSize;
%map = [];
%sFilter = [5 1];
%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(map)
  img_map = reshape(map(curSer,:),curSize(1),curSize(2));
end

if ~exist('slico')
  cothresh = 0;
%  cothresh = 0.2;
else
  cothresh=get(slico,'Value');
end

img_co = reshape(co(curSer,:),curSize(1),curSize(2));
fprintf('Cor thresh:  %.3f\n',cothresh);

zerovals = img_co <= cothresh;
fprintf('Number of points below or equal to threshold: %.0f\n',sum(sum(zerovals)));

img_z = amp(curSer,:).*exp(sqrt(-1)*ph(curSer,:));
img_z(zerovals)=zeros(size(find(zerovals)));
img_z = reshape(img_z,curSize(1),curSize(2));

if ~exist('sFilter')
  sFilter = [3,0.5];  %sFilter = [support, half-width];
end

kernel = mkGaussian([sFilter(1),sFilter(1)],sFilter(2));

filt_z_img    = conv2(img_z,kernel,'same');
filt_z_weight = conv2(img_z~=0,kernel,'same');

filt_co_img    = conv2(img_co,kernel,'same');
filt_co_weight = conv2(img_co~=0,kernel,'same');

if ~isempty(map) 
  filt_map_img = conv2(img_map,kernel,'same');
  filt_map_weight = conv2(img_map~=0,kernel,'same');
end

%isweight = filt_co_weight>0;

%%%%%%%%%%%%%
% Debug - HAB, 05.18.98
%boo=find(isweight);
%size(boo)
%isZweight = filt_z_weight>0;
%boo2=find(isZweight);
%size(boo2)
%isZimg = filt_z_img~=0;
%boo3=find(isZimg);
%size(boo3)
%boo4 = intersect(boo,boo3);
%size(boo4)
%
%%%%%%%%%%%%%%%%%%
% What we really want is the nonzero values of filt_z_img,
% because they are a subset of the nonzero values of 
% filt_co_weight - HAB, 05.18.98

isweight = filt_z_img ~= 0;

% The following line produced a lot of zeros in the denominator and error
% messages. Presumably, filt_z_weight can have zeros in it.  I
% think we should protect those cases. - BW, 05.14.98
% 
filt_z_img(isweight)= filt_z_img(isweight) ./ filt_z_weight(isweight);

filt_co_img(isweight)=filt_co_img(isweight)./filt_co_weight(isweight);

if ~isempty(map)
  filt_map_img(isweight)=filt_map_img(isweight)./filt_map_weight(isweight);
end

filt_ph_img=angle(filt_z_img);
filt_ph_img(filt_ph_img<=0)=filt_ph_img(filt_ph_img<=0)+pi*2;

filt_amp_img= abs(filt_z_img);

%%%%%%%%%%%%%%%%
%Debug - HAB, 05.18.98
% Check to make sure that no NaN's were produced (should only be
% produced by "divide by zero" error).
%boo=find(isnan(filt_ph_img));
%boo2 = find(isnan(filt_amp_img));
%nonan_ph=filt_ph_img;
%nonan_ph(boo)=8*ones(size(boo));
%nonanrnd = round(nonan_ph);
%figure; hist(nonanrnd)
%nonanmap = jet(8);
%figure; image(nonanrnd); colormap(nonanmap); axis image
%colorbar
%
%nonan_amp=filt_amp_img;
%bigval = (max(max(filt_amp_img))+50);
%nonan_amp(boo2)=bigval*ones(size(boo2));
%nonanrndamp = round(nonan_amp);
%hist(nonanrndamp)
%nonanmap = jet(bigval);
%image(nonanrndamp); colormap(nonanmap); axis image
%colorbar
%
%sameornot = boo2-boo;
%%%%%%%%%%%%%%%%

ph(curSer,:)=filt_ph_img(:)';
co(curSer,:)=filt_co_img(:)';
amp(curSer,:)=filt_amp_img(:)';

if ~isempty(map)
  map(curSer,:)=filt_map_img(:)';
end

if nargin>7
  co(:,anat==0)=zeros(size(co,1),length(find(anat==0)));
  amp(:,anat==0)=zeros(size(amp,1),length(find(anat==0)));
  ph(:,anat==0)=zeros(size(ph,1),length(find(anat==0)));
  if ~isempty(map)
    map(:,anat==0)=zeros(size(map,1),length(find(anat==0)));
  end
end

%RefreshScreen should be called after this function is executed








