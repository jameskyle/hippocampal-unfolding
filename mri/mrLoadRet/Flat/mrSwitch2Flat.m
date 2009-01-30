%script  %mrSwitch2Flat.m

%Switches mrLoadRet's configuration to show functional data
%on a flattened cortical representation.  This written as
%a script rather than a function because it requires no
%local variables.  The only 'input' is the variable viewPlane
%Switch2Plane == 1 -> left hemisphere
%Switch2Plane == 2 -> right hemisphere
%
%The script is designed to 'fool; mrLoadRet into thinking 
%that flattened data is just the first (and only) slice
%from the inplane anatomies:

%9/1/96 gmb   Wrote it.

%Determine which hemispheres exist
side = mrExistSides; 			

%save name of original viewPlane
oldviewPlane=viewPlane;

%Color of configuration buttons
oncolor = [.8,.2,.2];
offcolor  = [0.701961 0.701961 0.701961];

%Set button colors appropriately
if Switch2Plane== 1 & findstr('l',side)
  viewPlane = 'left';
  set(leftButton,'BackgroundColor',oncolor);
  set(rightButton,'BackgroundColor',offcolor);
  set(inplaneButton,'BackgroundColor',offcolor);
end
if Switch2Plane== 2 & findstr('r',side)
  viewPlane = 'right';
  set(rightButton,'BackgroundColor',oncolor);
  set(leftButton,'BackgroundColor',offcolor);
  set(inplaneButton,'BackgroundColor',offcolor);
end

%Exit if we're not changing viewplanes
if strcmp(viewPlane,oldviewPlane)
  clear Switch2Plane oncolor offcolor oldviewPlane side
  if strcmp(viewPlane,'inplane')
    disp('Error: data on this hemisphere not available');
  end
  return
end

% OK to here
% We want selpts_left,selpts_right,selpts_inplane,
%  selpts_gray and selpts
%
% We compute selpts_gray from the current selection, and this
% contains the indices into the gray matter in the volume.
%
% Whenever we change the ROI in _left, _right, or  _inplane 
% the other selpts_ all get cleared.
%
% Whenever we change any ROI, we update the selpts_gray.
%
%
% selpts refers to the representation on the screen.
%

%load in orignal (3D) configuration
%
load ExpParams
load anat

%
% Deal with selected points
%
% First, save the current selpts ( i.e. selpts_inplane = selpts)
%

% 7/08/97 Lea updated to 5.0
estr = ['selpts_',oldviewPlane,' = selpts;'];
eval(estr);

% Are there selpts saved for the new view? 
% If not, create the from selpts_gray
%

% 7/08/97 Lea updated to 5.0
if (eval(['isempty(selpts_',viewPlane,')']) & strcmp(oldviewPlane,'inplane'))
 [selpts_left selpts_right] = mrProjectROI2Flat(selpts_inplane,curSize);
end
eval(['selpts = selpts_',viewPlane,';']);

%
% Next, hide the antomy selection buttons
%
for i=1:numofanats
  set(anatBtnList(i),'Visible','off');
  if i==1
    set(anatBtnList(1),'Value',1);
  else
    set(anatBtnList(i),'Value',0);
  end
end

%Reset numofexps
numofexps = numofexps/numofanats;
numofanats=1;

%Reset current series
if strcmp(oldviewPlane,'inplane')
  inplane_curSer = curSer;
end
curSer=mod(curSer-1,numofexps)+1;

% Get the flattened anatomy data for viewing
%
eval(['load Fanat_',viewPlane]);
curSize = fSize;

%Load in flattened correlation, phase and amplitude matrices
%(only if there is one in memory already)

% 7/09/97 Lea updated to 5.0
if ~isempty(co)
  [co, ph, amp, dc] = mrLoadCorAnal(viewPlane);
end

if ~isempty(map)
  map = [];
end


tSeries=[];

%Reset the current image
RefreshScreen

%clear unused variables
clear oncolor offcolor Switch2Plane oldviewPlane side
