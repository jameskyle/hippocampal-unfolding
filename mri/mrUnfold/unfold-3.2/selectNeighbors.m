% selectNeighbors.m
% -----------------
%
% function nList = selectNeighbors(vDist,rSamp,rule,rSeed)
%
%
%  AUTHOR: Brian Wandell
%    DATE: 09.08.95
% PURPOSE:
%          Selects rSamp indices that correspond to the neighbors of
%          a point.
%
% ARGUMENTS:
%          vDist : A vector of distances from the current point to all
%	           the other points in the list.
%          rSamp : The number of indexes required.
%           rule : A character that chooses the selection rule. For the 
%                  time being this can only be 'r' for a random selection
%                  or it can be ignored.
%	   rSeed : The seed for the random number generator
%
% RETURNS:
%          nList : A list of indices corresponding to the neighbors
%	           chosen according to the rule.
%
% TODO:  Allow people to change the random number seed
%
% MODIFICATIONS:
% 06.26.98 SJC	added the random number seed as an optional input parameter
%

function nList = selectNeighbors(vDist,rSamp,rule,rSeed)

%% If no random number seed was passed, make it zero
%
if (nargin < 4)
  rSeed = 0;
end

%% If rule was not passed then just make it random.
%
if nargin < 3
  rule = 'r';
end

% If the number of indexes to be chosen, rSamp, was not passed then,
% set rSamp equal to the minimum between length(vDist) and 20.
%
n = length(vDist);
if nargin < 3
  error('selectNeighbors: Wrong number of arguments.\n')
end

if (n <= rSamp)
  error('selectNeighbors:  rSamp too large for this many data points\n');
end

% If rule='r' then do a random sampling of indexes to make up
% the randomly chosen neighbors.
rand('seed',rSeed);

% Check that there are enough sample points so that we can get to
% rSamp in a reasonable enough time.

if rule == 'r'
  nList = zeros(1,rSamp);
  i=1;
  while(i <= rSamp)

    % Find a ranom index value
    temp = ceil(n*rand);

    % If the index isn't already in the list, add it
    if (~length(find(nList==temp)))
      nList(i) = temp;
      i=i+1;
    end

  end
end

return;

%%%%



