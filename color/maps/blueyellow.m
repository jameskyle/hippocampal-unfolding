function y = redgreen(m)

if nargin < 1, m = size(get(gcf,'colormap'),1); end
y = blue(m) + flipud(red(m) + green(m)); 

