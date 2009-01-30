function y = threshold(img, kernel,levels)
% threshold(img, kernel, levels)
%	Thresholds an image against a given kernel.  Specifying levels
%	allows multi-level dithering.  For example,
%
% 		levels = [0 .5 1], will dither the image with the
%		given kernel to three levels.  
%
%	Levels defaults  to [0 1] if unspecified.  Levels may also be
%	a single number.  For example
%
%		levels = 3, with be translated to levels = [0 .5 1].  
%
%  Note: If the level values are not in ascending order then negative
%	 image values may result.
%
%  Rick Anthony
%  6/21/93

% assign default levels.
if nargin < 3,
    levels = [0 1];
else 
    if length(levels) == 1,
        n = levels-1;
        levels = (0:n)/n;
    end
end


% The levels should be in ascending order.
if sort(levels) ~= levels,
   disp('Levels should be in ascending order!');
   disp('Resulting image may contain negative values.');
end

[m n] = size(img);
l = length(levels);
d = ceil(size(img)./size(kernel));

% tesselate kernel to match img size
kernel = kron(ones(d(1),d(2)),kernel);
kernel = kernel(1:m,1:n);

% pass over the image l-1 times.
y = zeros(m,n);
for i=2:l
    m = levels(i)-levels(i-1);
    b = levels(i-1);
    y = y + m*(img >= m*kernel+b);
end





