function labErr = regresLab(lTransform,xyz1,xyz2,white)
% function labErr = regresLab(lTransform,xyz1,xyz2,white)
%
%  This is a function intended to be called by fmins()
%  in order to compute the cielab error between two data sets.
%  The fmins() call should be structured as follows:
%   
%	fmins('regresLab',lTransform,options,[],xyz1,xyz2,white)
%	
%  lTransform is a 9,1 vector containing the initial guess about
%	 the linear transformation, usually derived from 
%              lTransform = xyz2/xyz1;
%  xyz1 and xyz2 are 3 x N data sets
%  white is the 3 vector describing the white point for the cielab calculation
%

  if( length(lTransform) ~= 9)
    error('The linear trasnsformation must be a vector with 9 entries')
  elseif size(xyz1,2) ~= size(xyz2,2)
    error('The data sets must have the same number of columns')
  elseif size(xyz1,1) ~= 3 | size(xyz2,1) ~= 3
    error('The data sets must have three rows')
  end

  lTransform = reshape(lTransform,3,3);
  est = lTransform*xyz1;

%
%	Various possibilities for minimization include
%
  labErr = mean(deltaEab(xyz2,est,white));

%
%	But the mean seems ok for now.
%
% labErr = max(deltaEab(xyz2,est,white));
% labErr = mean(deltaEab(xyz2,est,white)) + max(deltaEab(xyz2,est,white));
%
