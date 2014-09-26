% movePointPlansGrad.m
% --------------------
%
% function g = movePointGrad(x,neighborLocs,iDist)
%
%
%  AUTHOR: Brian Wandell
%    DATE: October, 1995.
% PURPOSE:
%         The gradient function for movePointPlaneErr,  used in the 2-D
%         interpolation part of the code.
%         It returns a matrix where each column corresponds to the gradient 
%         of the each of the error elements in vector totalErr (calculated 
%         in movePointPlaneErr) with respect to the current solution x.
%
% ARGUMENTS:
%              x : The current point location.
%   neighborLocs : The 2D coordinates of selected sample point neighbors.
%           iDist: Manifold distances between this point and its selected 
%                  neighbors. (Note that this is not being used)
% 
%

function g = movePointGrad(x,neighborLocs,nDist)


%% Calculate the error gradient with respect with each of the 
%% coordinates of x.
%
 dfidu = -2*neighborLocs(:,1) + 2*x(1);
 dfidv = -2*neighborLocs(:,2) + 2*x(2);


%% Store in g the error gradients in column form.
% 
 g = [dfidu , dfidv]';


%%%%