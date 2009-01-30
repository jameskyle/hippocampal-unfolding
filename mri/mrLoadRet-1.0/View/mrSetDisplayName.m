function curDisplayName = mrSetDisplayName(curDisplayNum)
%curDisplayName = mrSetDisplayName(curDisplayNum)
%
% HISTORY:
% 07.01.98 SJC	Converted curDisplayList into an array of cells to
%		eliminate need to remove extra blank spaces.

% Old code
%curDisplayList = ['anatomy '; ... %1
%                  'cor     '; ... %2
%		  'amp     '; ... %3
%		  'phase   '; ... %4
%		  'concor  '; ... %5
%		  'medcor  '; ... %6
%		  'conphase'; ... %7
%		  'medphase'; ... %8
%		  'map     '; ... %9
%		  'wphase  ']; ... %10
%curDisplayName=curDisplayList(curDisplayNum,:);
%
%Remove extra blank spaces
%while curDisplayName(length(curDisplayName)) == ' '
%  curDisplayName=curDisplayName(1:length(curDisplayName)-1);
%end

% 07.01.98 SJC
curDisplayList = [{'anatomy'};	...	%1
                  {'cor'};	...	%2
		  {'amp'};	...	%3
		  {'phase'};	...	%4
		  {'concor'};	...	%5
		  {'medcor'};	...	%6
		  {'conphase'};	...	%7
		  {'medphase'};	...	%8
		  {'map'};	...	%9
		  {'wphase'}];	...	%10

curDisplayName=char(curDisplayList(curDisplayNum,:));




	      
	  
