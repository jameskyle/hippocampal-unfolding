function y = CirConv(func, kernel)
%  
%  Y = CirConv(func, kernel)
%  	Performs 1D circular convolution of func by the kernel.
%       The origin of the func and kernel is assumed to be at 
%       location 1,1.  The length of the result is equal to the
%	length of func.
%
%  Reminder: circular convolution, like linear convolution, performs
%	     time reversal on the kernel.
%
%  Rick Anthony
%  6/29/93

disp('CirConv warning: this routine takes the kernel origin to be 1')

func = func(:);
kernel = kernel(:);

fl = length(func);

y = conv([func; func], kernel);
y = y(fl+1:2*fl)';

