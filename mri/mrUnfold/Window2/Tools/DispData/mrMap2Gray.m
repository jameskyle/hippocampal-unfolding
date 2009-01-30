function displayData = mrMap2Gray(xyzc,grayNodes)
% function displayData = mrMap2gray(xyzc,grayNodes)
%
% 07.10.98  SJC
%
% PURPOSE:	Maps the xyz locations in the input into the list
%		of gray matter locations and returns the input data
%		sorted and with the mapping index.
%
% ARGUMENTS:	xyzc	[x y z cMapIdx]
%			Nx4 matrix where the first three entrires of
%			each row are the x,y,z locations of the data
%			point and the fourth entry is an index into
%			the data colormap
%		grayNodes	List of the x,y,z, layer, and other
%				data about the gray matter nodes
%
% RETURNS:	displayData	[x y z cMapIdx map2graymatter]
%				Nx5 matrix where the first four entries
%				of each row are the same as in the
%				input parameter xyzc, the fifth is the
%				index that maps the data point into the
%				gray matter list, and the entire matrix
%				is sorted so that the gray matter map
%				indices are in increasing order
%


% First find the intersection of the locations
%
[dummy grayIdx dataIdx] = intersect(grayNodes(1:3,:)',xyzc(:,1:3),'rows');

% Create the mapping into the gray matter
% Each xyzc(dataIdx,:) corresponds to grayNodes(grayIdx,:)
%
dataMap2Gray(dataIdx) = grayIdx;

% Sort the mapping indeces
%
[dummy sortIdx] = sort(dataMap2Gray);

% Create and sort output data
%
displayData = [xyzc dataMap2Gray'];

displayData = displayData(sortIdx,:);

return