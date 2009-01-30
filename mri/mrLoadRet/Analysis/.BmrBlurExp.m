function [co,ph,amp,map] =  ...
    mrBlurExp(co,ph,amp,map,curSer,curSize,sFilter,anat,slico)
% 
% [co,ph,amp,map] =  mrBlurExp(co,ph,amp,map,curSer,curSize,sFilter,[anat],[slico])
% 
% 

%12/12/96   gmb  If anat is in input, blurring does not bleed
%                beyond regions where anatomy is present.
%07/07/97   Lea updated to 5.0

if ~isempty(map)
  img_map = reshape(map(curSer,:),curSize(1),curSize(2));
end

if ~exist('slico')
  cothresh = 0;
else
  cothresh=get(slico,'Value');
end

img_co = reshape(co(curSer,:),curSize(1),curSize(2));
cothresh
zerovals=img_co<=cothresh;
sum(sum(zerovals))
img_z = amp(curSer,:).*exp(sqrt(-1)*ph(curSer,:));
img_z(zerovals)=zeros(size(find(zerovals)));
img_z = reshape(img_z,curSize(1),curSize(2));

if ~exist('sFilter')
  sFilter = [3,0.5];  %sFilter = [support, half-width];
end

kernel = mkGaussian([sFilter(1),sFilter(1)],sFilter(2));

filt_z_img = conv2(img_z,kernel,'same');
filt_z_weight = conv2(img_z~=0,kernel,'same');

filt_co_img = conv2(img_co,kernel,'same');
filt_co_weight = conv2(img_co~=0,kernel,'same');

if ~isempty(map) 
  filt_map_img = conv2(img_map,kernel,'same');
  filt_map_weight = conv2(img_map~=0,kernel,'same');
end

isweight = filt_co_weight>0;

filt_z_img(isweight)=filt_z_img(isweight)./filt_z_weight(isweight);
filt_co_img(isweight)=filt_co_img(isweight)./filt_co_weight(isweight);

if ~isempty(map)
  filt_map_img(isweight)=filt_map_img(isweight)./filt_map_weight(isweight);
end

filt_ph_img=angle(filt_z_img);
filt_ph_img(filt_ph_img<=0)=filt_ph_img(filt_ph_img<=0)+pi*2;

filt_amp_img= abs(filt_z_img);

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








