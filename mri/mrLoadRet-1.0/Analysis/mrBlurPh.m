function [co,ph,amp,map] =  mrBlurPh(co,ph,amp,map,curSer,curSize,sFilter,anat,slico)
% [co,ph,amp,map] =  mrBlurPh(co,ph,amp,curSer,curSize,sFilter,[anat],[slico])
%
% Blurs phases AFTER thresholding the correlations.  All phases
% for pixels exceeding the correlation threshold are weighted
% equally.

%3/18/97    gmb  Wrote it from mrBlurExp

%12/12/96   gmb  If anat is in input, blurring does not bleed
%                beyond regions where anatomy is present.


if ~exist('slico')
  cothresh = 0;
else
  cothresh=get(slico,'Value');
end

if ~exist('sFilter')
  sFilter = [3,0.5];  %sFilter = [support, half-width];
end

kernel = mkGaussian([sFilter(1),sFilter(1)],sFilter(2));

%This will make a circular filter:
%kernel(kernel<.0001)=zeros(size(find(kernel<.0001)));

kernel=kernel/sum(sum(kernel));
PhImg = reshape(ph(curSer,:),curSize(1),curSize(2));
CoImg = reshape(co(curSer,:),curSize(1),curSize(2));
validpts = (CoImg)>cothresh;

filtSinPh = gaussInterp(sin(PhImg),validpts,kernel);
filtCosPh = gaussInterp(cos(PhImg),validpts,kernel);
filtCo = gaussInterp(CoImg,validpts,kernel);

filtPh = atan2(filtSinPh,filtCosPh);
filtPh(isnan(filtPh))=zeros(size(find(isnan(filtPh))));
filtPh(filtPh<=0)=filtPh(filtPh<=0)+pi*2;

ph(curSer,:) = filtPh(:)';
co(curSer,:) = filtCo(:)';

if (~isempty(map))
  mapImg = reshape(map(curSer,:),curSize(1),curSize(2));
  filtMap = gaussInterp(CoImg,validpts,kernel);
  map(curSer,:)=filtMap(:)';
end

if nargin>7
  co(:,anat==0)=zeros(size(co,1),length(find(anat==0)));
  amp(:,anat==0)=zeros(size(amp,1),length(find(anat==0)));
  ph(:,anat==0)=zeros(size(ph,1),length(find(anat==0)));
  if (~isempty(map))
    map(:,anat==0)=zeros(size(map,1),length(find(anat==0)));
  end
end
%RefreshScreen should be called after this function is executed








