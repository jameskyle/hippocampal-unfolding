function y = redgreen(m)

if nargin < 1, m = size(get(gcf,'colormap'),1); end
y = red(m) + flipud(green(m)) + [zeros(m,1) zeros(m,1) 0.5*ones(m,1)]; 

