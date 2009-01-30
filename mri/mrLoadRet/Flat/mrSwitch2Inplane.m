script  %mrSwitch2Inplane

%Switches mrLoadRet's configuration to show functional data
%on the inplanes.  This is the 'normal' operating mode.

side = mrExistSides;  %Determine which hemispheres exist

%save original viewPlane
oldviewPlane = viewPlane;

viewPlane = 'inplane';

%Color of configuration buttons
oncolor = [.8,.2,.2];
offcolor  = [0.701961 0.701961 0.701961];

%Set button colors appropriately
set(leftButton,'BackgroundColor',offcolor);
set(rightButton,'BackgroundColor',offcolor);
set(inplaneButton,'BackgroundColor',oncolor);

tSeries=[];

%load in orignal (3D) configuration

load ExpParams
load anat

% In this case, we load 

if prod(size(co))>0
  load CorAnal
end

% 7/09/97 Lea updated to 5.0
if ~isempty(map)
  map = [];
end

%reset the current series to the value saved by
%mrSwitch2flat

curSer = inplane_curSer;

%unhide the anatomy selection buttons
for i=1:numofanats
  set(anatBtnList(i),'Visible','on');
  if anatmap(curSer) == i
    set(anatBtnList(i),'Value',1);
  else
    set(anatBtnList(i),'Value',0);
  end
end


%Project the ROI from flattened representation to inplanes:

%save original selpts ( i.e. selpts_left = selpts)
estr = ['selpts_',oldviewPlane,' = selpts;'];
eval(estr);

% 7/09/97 Lea updated to 5.0
if isempty(selpts_inplane)
 selpts_inplane = mrProjectROI2Inp(selpts_left,selpts_right);
end
selpts = selpts_inplane;

%Reset the current image
RefreshScreen

%clear  unused variables
clear oncolor offcolor







