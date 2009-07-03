function [ decimated_x, mean_y, var_y ] = running_avg( y, x, Nbins )
% function [ decimated_x, mean_y, var_y ] = running_avg( y, x, Nbins )
%
% Returns the running average of y over x (which will be sorted and decimated
% by 100), the running variance of y, and the sorted decimated version of x.
%
% INPUT:
%	y : data values as a function of x
%	x : vector of independent data values
%   Nbins : number of bins in x over which the mean and variance are to be
%           calculated
%
% OUTPUT:
% 	decimated_x : vector of independent data values decimated by Nbins
%                     and sorted in ascending order
%            mean_y : mean of y values in each bin
%             var_y : variance of y values in each bin
%

% Written by Suelika Chial
% 10.21.97

y = y(:);				% Concatenate inpus in case they
x = x(:);				%   are not vectors

x_incr = max(x) / Nbins;		% Size of each bin

for i = 1:Nbins
  samps = find( x < i*x_incr );		% Find all y in bin i
  mean_y(i) = mean( y(samps) );		% Find mean and variance over them
  var_y(i) = var( y(samps) );
end;

decimated_x = x_incr * [1:Nbins];
