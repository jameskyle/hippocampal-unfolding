function bitimage = zerobitimage(sz,nimages);	
%
%AUTHOR:  G. Boynton
%DATE:   02.20.95
%PURPOSE
%    Initialize a matrix to hold a sequence of 8 bit images
%	used in the mri stimuli
%
%  bitimage=zerobitimage(size,nimages) 
%
%    where 
%       sz: a vector whose two entries are the spatial dimensions
%		of each image
%       nimages: the number of images
%
%  bitimage will have size [(m*n+7)/8,nimages]

bitimage=zeros((prod(sz)+7)/8,nimages);

end
