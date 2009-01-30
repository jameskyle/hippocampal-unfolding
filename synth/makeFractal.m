function res = makeFractal(dims, fract_dim)
% MAKEFRACTAL: Makes pink noise
%
% res = makeFractal([ydim xdim], fract_dim)
% spectrum of pink noise has 1/f^(1+FRACT_DIM).
% fract_dim is fractal dimension (default value is 0).
%
% EPS, 6/96.

%% ***Should make this more efficient!

if (exist('fract_dim') ~= 1)
  fract_dim = 0;
end

res = randn(dims);

fres = fft2(res);

sz = size(res);
ctr=floor((sz+1)/2);

shape = makeR(sz, -(fract_dim+1), ctr);
shape(ctr(1),ctr(2)) = 1;
shape = [shape(ctr(1):sz(1),ctr(2):sz(2)) , shape(ctr(1):sz(1),1:ctr(2)-1); ...
         shape(1:ctr(1)-1,ctr(2):sz(2)) , shape(1:ctr(1)-1,1:ctr(2)-1) ];
fres = shape .* fres;

fres = ifft2(fres);

if (max(max(imag(fres))) > 1e-10)
  error('Symmetry error in creating fractal');
else
  res = real(fres);
end  
