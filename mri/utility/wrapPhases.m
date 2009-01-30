function data = wrapPhases(data)
% 
% 

l = find(data >= 90);
data(l) = data(l) - 360;

return;
