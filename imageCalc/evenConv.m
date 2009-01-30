function y = evenConv(func, kernel)
%  
%  evenConv(func, kernel)
%  	Performs 1D circular EVEN convolution of func by the kernel.
%       The origin of the func is at location (1,1).  The kernel's
%	origin is at its mid-point.  If the kernel has an even number
%	of elements then a zero is appended at the end.
%
%  Reminder: circular convolution, like linear convolution, performs
%	     time reversal on the kernel.
%
%  Warning: func must be larger than the kernel!
%
%  BW 07.07.93, from CirConv by Rick.

func = func(:);
kernel = kernel(:);

fl = length(func);
kl = length(kernel);

if kl > fl,
    error('func must be larger than the kernel');
end

% add zeros so that the kernel has an odd number of elements.
if isEven(kl),
    kernel = [kernel; 0];
    kl = length(kernel);
    disp('Kernel with an even number of elements found!');
    disp('A zero was appended to make it odd.');
end

% find the center of the kernel
c = round(kl/2);

%y = [func(fl-c+2:fl); func; func(1:c-1)];
y = [func(c-1:-1:1); func; func(fl:-1:fl-c+2) ];
y = conv(y, kernel);
y = y(2*c-1:2*c-2+fl)';

