function im=makeRandomDots(dims,density)
%
% im=makeRandomDots(dims,density)
%
% Makes a random dot image
%   dims=[n m] is the size
%   density is the dot density
% see stereotutorial for an example
%
% DJH, 6/96

tmp=rand(dims);
im=tmp<density;
