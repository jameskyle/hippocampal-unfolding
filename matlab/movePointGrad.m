% movePointGrad.m
% ---------------
%
% function g = movePointGrad(x,neighborLocs,mDist,flatWeight,P)
%
%
%  AUTHOR: Brian Wandell
%    DATE: October, 1995
% PURPOSE:
%         The gradient function for movePointErr, used in the 3-D
%         flattening part of the code.
%         It returns a matrix where each column corresponds to the gradient 
%         of the each of the error elements in vector totalErr (calculated 
%         in movePointErr) with respect to the current solution x.
%
%         You can use Maple calls to verify the gradient functions:
%
%             fi = '(xi - u)^2 + (yi - v)^2 + (zi - w)^2 - mDisti'
%             dfidu = diff(fi,'u')
%             dfidv = diff(fi,'v')
%             dfidw = diff(fi,'w')
%             flatErr = 'n * flatweight * ( p(1)*u + p(2)*v + p(3)*w)^2'
%             dfFdu = diff(flatErr,'u')
%             dfFdu = diff(flatErr,'v')
%             dfFdw = diff(flatErr,'w')
%
% ARGUMENTS:
%              x : The current point location.
%   neighborLocs : The 3D coordinates of selected sample point neighbors.
%           iDist: Manifold distances between this point and its selected 
%                  neighbors. (Note that this is not being used)
%      flatWeight: Weight bias for pushing towards the flattening plane.
%               P: Perpendicular to the plane.
%
%

function g = movePointGrad(x,neighborLocs,mDist,flatWeight,P)


%% Get the number of neighbors.
%
 n = size(neighborLocs,1);

%% Calculate the error gradient with respect with each one of the 
%% coordinates of x.
%
 dfidu = -2*neighborLocs(:,1) + 2*x(1);
 dfidv = -2*neighborLocs(:,2) + 2*x(2);
 dfidw = -2*neighborLocs(:,3) + 2*x(3);


%% Calculate the error gradient with respect to x of the squared 
%% perpenticular distance of x from the plane.
%
 dfFdu = 2*n*flatWeight*P*(P*x');


%% Store in g the error gradients in column form.
% 
 g = [dfidu , dfidv , dfidw]';
 g = [g , dfFdu'];


%%%%



