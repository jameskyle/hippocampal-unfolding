function result = isSingular(matrix)
% isSingular.m
%
% Returns 1 if matrix is singular, 0 otherwise.

if ((1/cond(matrix))<1.0e-6)
  result = 1;
else
  result = 0;
end  
  
