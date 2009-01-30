function mrSlicoControlRet (curSer, co, ph, amp, anat, curSize, curDisplayName,selpts,anatmap,pWindow,slideName)
% mrSlicoControlRet (curSer, co, ph, amp, anat, curSize, curDisplayName,selpts,anatmap,pWindow,[slideName])

% Determines what to do when the slico slider is touched.
% Basically, if we're working on corellation thresholds it should make the
% change, print the new value of slico, and redraw the image.
% Otherwise, it should simply print the new value of slico.

% 6/11/96	gmb	Added ROI as member of curDisplayName
% 6/11/96	gmb	Added 10th input argument as flag that the slico bar was moved.
% 9/6/96        gmb     Added amp as input for amplitude map by 'mrThreshAmpRet';
% 9/6/96        gmb     Incorporated mrColorBar
% 9/6/96        gmb     Text of cothresh now appears under slico slider.

% Variable Declarations
thresh = -1;		% If the slico is brought all the way to the right
			% the user is prompted for a threshold
			% value.
		
global slico;

%Prompt the user for cothresh if the slider is pegged at 1.0

if (get (slico, 'value')) == 1
   while ((thresh < 0 ) | (thresh > 1)),
       thresh = input ('Please enter correlation threshold: ');
       if ((thresh < 0) | (thresh > 1))
	   disp ('Correlation threshold must be between 0 and 1');		
       end
   end
   set (slico, 'value', thresh);
end

if (nargin>8)
  %slico bar moved!
  thresh = get (slico, 'value');
  %Insert text below the bar
  
  %Setup graph (label) below slico bar
  slico_pos = get(slico,'Position');
  main = get(gcf,'CurrentAxes');
  co_label_pos = slico_pos - [0,0.025,0,0];
  
  %delete old graph (label)  first
  %Find the handle of the colorbar (if it exists);
  a=get(gcf,'Children');
  for i=1:length(a)
    type = get(a(i),'Type');
    if (strcmp(type,'axes'))
      pos = get(a(i),'Position');
      if pos == co_label_pos
	delete(a(i));
      end
    end
  end
  
  main =get(gcf,'CurrentAxes');
  %Create a new graph and place the text inside
  co_label = axes('position',co_label_pos,'Visible','off');
  %axis off;
  %text(slico_pos(1),slico_pos(2)-.1,sprintf(' 	%2.2f',thresh),'FontSize',10);
  text(thresh*0.9-0.25,0,sprintf(' 	%2.2f',thresh),'FontSize',10);
  set(gcf,'CurrentAxes',main);
end

  





