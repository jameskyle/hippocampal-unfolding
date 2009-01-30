%Q(x)  Q-function: it evaluates the following integral
%                  1/sqrt(2*pi) int_x inf exp^(-t^2/2) dt
function [q] = Q2(x)
q=0.5*erfc(x/sqrt(2));
%end;
