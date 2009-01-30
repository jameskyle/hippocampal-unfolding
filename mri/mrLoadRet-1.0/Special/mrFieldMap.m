function [co,ph,amp,map] = mrFieldMap(co,ph,amp,map,curSer,curSize,viewPlane)

%[co,ph,amp,map] = mrFieldMap(co,ph,amp,map,curSer)
%Calculates a "visual field sign map" from retinotopy data.
%The user is prompted for experiment number(s) that correspond to
%expanding ring and rotating wedge stimuli.  If more than one
%experiment number is given, data is averaged across experiments.
%
%The resulting field map is saved in the parameter map matrix
%'map' under the current series.
%
%This algorithm is based on Sereno et al. (1994)'s Cerebral
%cortex publication.  Phase gradients are calculated in the
%complex domain using a trick described in Fleet and Jepson's
%(1990) Journal of Computer Vision publication.  The visual field
%sign map is the z-vector of the cross product between the
%phase gradients of the expanding ring and rotating wedge
%experiments. Positive and negative values indicate
%'mirror-image' and 'non-mirror-image' areas respectively.
%Rather than creating a binary map like Sereno, this
%algorithm returns the log of the z-vector (while preserving the
%sign).  When viewed with mrLoadRet, the degree of saturation of
%the parameter map is an indication of the confidence of the algorithm.

%10/1/96 gmb  Wrote it.

%Load in correlation matrices, if necessary.
% 7/07/97 Lea updated to 5.0
if isempty(co)
  [co, ph, amp]=mrLoadCorAnal(viewPlane);
end

%Prompt user for experiment numbers and filter size
expWedge = input('Wedge experiment number(s): ');
expRing  = input('Ring  experiment number(s): ');


%Default filter size of [31,15] works well.
sGradFilter = [31,15];
sGradFilter = mrEditSFilter(sGradFilter);

disp(['Results will appear as a parameter map for experiment ',num2str(curSer),'.']);

%save amp,co,and ph for the two experiments in new matrices.
%Average across experiments if necessary.
  
%Rotating Wedges:
if prod(size(expWedge))>1
  zWedge = mean(amp(expWedge,:) .* exp(sqrt(-1)*ph(expWedge,:)));
  coWedge = mean(co(expWedge,:));
  ampWedge = abs(zWedge);
  phWedge = angle(zWedge);
  phWedge(phWedge<0)=phWedge(phWedge<0)+pi*2;
else
  coWedge = co(expWedge,:);
  ampWedge = amp(expWedge,:);
  phWedge = ph(expWedge,:);
end
  
%Expanding Rings:
if prod(size(expRing))>1
  zRing = mean(amp(expRing,:).*exp(sqrt(-1)*ph(expRing,:)));
  coRing = mean(co(expRing,:));
  ampRing = abs(zRing);
  phRing = angle(zRing);
  phRing(phRing<0)=phRing(phRing<0)+pi*2;
else
  coRing = co(expRing,:);
  ampRing = amp(expRing,:);
  phRing = ph(expRing,:);
end


%Blur the correlation, phas and amplitude maps for both experiments.
disp('Blurring maps...');
[coWedge,phWedge,ampWedge] =  mrBlurExp(coWedge,phWedge,ampWedge,[],1,curSize,sGradFilter);
[coRing,phRing,ampRing] =  mrBlurExp(coRing,phRing,ampRing,[],1,curSize,sGradFilter);

%Calculate phase gradients for both experiments
disp('Calculating gradients...');
[coWedge,phWedge,ampWedge] = mrGradExp(coWedge,phWedge,ampWedge,1,curSize);
[coRing,phRing,ampRing] = mrGradExp(coRing,phRing,ampRing,1,curSize);

%Calculate the field sign.  First make 3d vector with z values = 0

gradRing = [zeros(size(ampRing));ampRing.* sin(phRing); ampRing.* cos(phRing)];
gradWedge =[zeros(size(ampRing));ampWedge.*sin(phWedge);ampWedge.*cos(phWedge)];

%Calculate the cross product.
crossMap = cross(gradRing,gradWedge);

%log of z value is the visual field sign map.
lambda = sign(crossMap(1,:)).*log10(abs(crossMap(1,:)));
lambda(isnan(crossMap(1,:)))=zeros(size(find(isnan(crossMap(1,:)))));

% 7/10/97 Lea updated to 5.0
if isempty(map)
  map = zeros(size(co));
end

%Save the map in the parameter map for the current series.
map(curSer,:)=lambda;

%set the colormap
colormap(mrRedGreenCmap);









