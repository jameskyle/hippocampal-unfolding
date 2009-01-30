function [map,cmap] = mrMakeInplaneMap(curSer,viewPlane)
% PURPOSE: Creates map of inplane values on the flattened cortex.
% AUTHOR: gmb wrote it.
% DATE: 12/12/96   
% HISTORY:  02.18.97 ABP -- changed color map values

% If the file 'VolParams.mat' doesn't exist, have user create it.
if ~check4File('VolParams')	% VolParams.mat doesn't exist
  voldr='/usr/local/mri/anatomy';
  disp (['VolParams.mat not found.  Please enter experimental values.']);
  mrGetVolParams(voldr);
end 

% 7/07/97 Lea updated to 5.0
if ~check4File(['Fanat_',viewPlane])
  disp('Flattened anatomy not available.');
  map = [];
  cmap = [];
  return
end

%Load in inplane parameters
load anat
load ExpParams

%Load in flattened anatomy which includes variables:
%anat anatmap fSize curCrop gray2inplane gray2flat
eval(['load Fanat_',viewPlane]);

% Figure out gray matter locations in 3d in the functional volume
% gLocsFunc is a nGray x 3 array.  The data points are rounded to
% fall on functional voxels.
% 
gLocsFunc = mrVcoord(gray2inplane,curSize);

% These are the row and col locations of the gray-matter in the
% flattened representation
% 
tmp = mrVcoord(gray2flat,fSize);
colF = tmp(:,1); rowF = tmp(:,2);

% Allocate or re-initialize tSeriesF and its counter
% 
mapF = zeros(1,prod(fSize));
tSeriesC = zeros(1,size(mapF,2));

% Find the index into the functional volume for 
% the current plane

% 7/10/97 Lea updated to 5.0
for thisAnat = numofanats:-1:1
  xLocsFp = find(gLocsFunc(:,3) == thisAnat);  
  if ~isempty(xLocsFp)
    xFlatImage= ...
	mrVcoord([colF(xLocsFp) rowF(xLocsFp) ...
	    ones(length(xLocsFp),1)],fSize);   
    
    tSeriesC(xFlatImage) = tSeriesC(xFlatImage) + 1;
    mapF(xFlatImage) = mapF(xFlatImage)+ thisAnat*ones(size(mapF(xFlatImage)));
  end
end

list = find(tSeriesC > 1);
denom = tSeriesC(list);

mapF(list) = mapF(list) ./ denom;
map = zeros(numofexps/numofanats,prod(fSize));
map(curSer,:)=mapF;

id = find(map==mmin(map(map>0)));
map(id(1))=mmin(map(map>0))-0.5;
id = find(map==mmax(map));
map(id(1))=mmax(map)+0.5;
map = map;

cmap = gray(128);
maxmap = mmax(map)-mmin(map(map>0));
%create ugly, but effective color map
%for i=1:maxmap
%  idlist = (floor((i-1)*128/maxmap+129)):floor(i*128/maxmap+128);
%  spoo = (((-1).^i)+1)/2;
%  cmap(idlist,:)=ones(length(idlist),1) * [spoo,1-spoo,i/maxmap];
%end

% Create more pronounced colormap -- ABP
% Good for 18 inplanes
cmapValues = [1,0,0;
  	  1.0,1.0,1.0;...
	  0.75,0.25,0.5;...
	  1,1,0;...
	  1,0,1;...
          0,1,0;...
	  0,0,1;...
	  0,1,1;...
	  0.5,0.0,1.0;...
	  1.0,0.5,0.0;...
	  0.0,1.0,0.5;...
	  1.0,0.0,0.5;...
	  0.5,0.5,1.0;...
	  0.5,1.0,0.5;...
	  0.5,1.0,0.0;...
	  0.0,0.5,1.0;...
	  1.0,0.5,0.5];
nValues = size(cmapValues,1);
for i=1:maxmap
  idlist = (floor((i-1)*128/maxmap+129)):floor(i*128/maxmap+128);
  if (i > nValues)
    spoo = (((-1).^i)+1)/2;
    cmap(idlist,:)=ones(length(idlist),1) * [spoo,1-spoo,i/maxmap];
  else
    cmap(idlist,:)=ones(length(idlist),1) * cmapValues(i,:);
  end
end
cmap = cmap;
