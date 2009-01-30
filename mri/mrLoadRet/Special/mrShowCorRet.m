% This function displays the corellation data from one of the
% experiments (as dictatated by curSer).

% MMZ 6/10/03 isempty bug fixed

function [curDisplayName] = mrShowCorRet (co, ph, seph, numofexps, size, curSer)

global slimin slimax

% Variable Declarations
oldmin = 0;	% The value of slimin when mrShowCorRet is invoked
oldmax = 1;	% The value of slimax when mrShowCorRet is invoked

% MMZ if (co == []);
if (isempty(co));
   disp ('No correlation data available');
   return;
end

% MMZ if (ph == []);
if (isempty(ph));
   disp ('No phase data available');
   return;
end

oldmin = get(slimin, 'value');		% All of this stuff is
oldmax = get(slimax, 'value');		% making sure that
set (slimin, 'value', 1);		% min = 0 and max = 1
set (slimax, 'value', 0);		% when displaying cor and phase

   subplot (2,1,1);
   myShowImage(ph(curSer,:),size);
   axis([-60, 105, 0, 60]);
   subplot(2,1,2);
   myShowImage(co(curSer,:),size); 
   axis([-60, 105, 0, 60]);
   text(15,-10,'Phase');
   text(10,74,'Correlation');
   text(-80,-11,['Experiment ', num2str(curSer)]);

set (slimin, 'value', oldmin);		% Resetting the slider controls
set (slimax, 'value', oldmax);
curDisplayName = 'corandphase';
