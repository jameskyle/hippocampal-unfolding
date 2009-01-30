function viewer3d(command,parameter1) 
%  Template for uicontrol form. 
%   
%  If you rename this file: 
%    1. Replace all occurrences of 'viewer3d' with desired 'filename'. 
%    2. Resave this file as that 'filename'. 
%   
%  To edit callbacks : 
%          Fill in the 'elseif command == ...' sections with 
%          code that does something other than what was  
%          defined in GUIMaker 2.0. Be creative! 
%          The code must lie between the CALLBACK_START and  
%          CALLBACK_STOP comments for each objects callback  
%          command section if you want to be able to edit 
%          the GUI with GUIMaker later on and not lose the 
%          callback information. 
%   
%  viewer3d.m 
%   
%  usage:       viewer3d(command,parameter1) 
%   
%           where 
%   
%               'command' is used to perform some defined operation 
%               'parameter1' can be used pass extra information 
%                              to a defined operation 
%   
%           If no arguements are used the GUI is initialized. 
%   
%   
%  Created: 8-May-95 
%  Using  : GUI Maker Ver 2.0 by Patrick Marchand 
%                         (pmarchan@motown.ge.com) 
%  Author :  
%  Mods.  :  
%   

%  Copyright (c)   
%       Permission is granted to modify and re-distribute this 
%       code in any manner as long as this notice is preserved. 
%       All standard disclaimers apply. 


if nargin == 0 
        command = 'new'; 
end 

if isstr(command) 
        if strcmp(lower(command),'initialize') | strcmp(lower(command),'new') 
                command = 0; 
        elseif strcmp(lower(command),lower('h_push_apply')) 
                command = 1; 
        elseif strcmp(lower(command),lower('h_edit_fig')) 
                command = 2; 
        elseif strcmp(lower(command),lower('h_edit_s2val')) 
                command = 3; 
        elseif strcmp(lower(command),lower('h_edit_s1val')) 
                command = 4; 
        elseif strcmp(lower(command),lower('h_edit_s3val')) 
                command = 5; 
        elseif strcmp(lower(command),lower('h_uic_1')) 
                command = 6; 
        elseif strcmp(lower(command),lower('h_uic_3')) 
                command = 7; 
        elseif strcmp(lower(command),lower('h_uic_2')) 
                command = 8; 
        elseif strcmp(lower(command),lower('h_pop_choice')) 
                command = 9; 
        end 
end 

if command ~= 0 
        h_fig_list = findobj(get(0,'children'),'flat',... 
                'tag','viewer3d'); 
                if length(h_fig_list) > 1 
                        h_fig_list = gcf; 
                elseif length(h_fig_list) == 0 
                        error('There are no figures with Tag = viewer3d.'); 
                end 
        handle_list = get(h_fig_list,'userdata'); 
        if length(handle_list) > 0 
                h_uic_6 = handle_list(1); 
                h_push_apply = handle_list(2); 
                h_edit_fig = handle_list(3); 
                h_edit_s2val = handle_list(4); 
                h_edit_s1val = handle_list(5); 
                h_edit_s3val = handle_list(6); 
                h_uic_1 = handle_list(7); 
                h_uic_3 = handle_list(8); 
                h_uic_2 = handle_list(9); 
                h_text_fig = handle_list(10); 
                h_text_s1lab = handle_list(11); 
                h_text_s3lab = handle_list(12); 
                h_text_s2lab = handle_list(13); 
                h_pop_choice = handle_list(14); 
                h_axes_1 = handle_list(15); 
        end 
end 


if command == 0 
        if length(get(0,'children')) > 0
           currentfig = get(0,'currentfigure');
           currentfigstr = num2str(currentfig);
        else
           currentfigstr = '';
        end
        fig = findobj(get(0,'children'),'flat','tag','viewer3d'); 
        if length(fig) > 0 
                set(fig,'visible','on'); 
                figure(fig); 
                return; 
        end 
        fig = figure('position',[ 10 569 393 114 ],... 
                'resize','On','tag','viewer3d',... 
                'menubar','None','name','3-D Viewer',... 
                'numbertitle','Off','visible','off'); 

        %  Uicontrol Object Creation 

        h_uic_6 = uicontrol(... 
                'CallBack','viewer3d(''h_uic_6'');',... 
                'Position',[ 0 0.01 0.73 1 ],... 
                'Enable','off',... 
                'String','AZ EL|Pitch Yaw Roll|X Y Z',... 
                'Style','frame',... 
                'Units','normalized',... 
                'Tag','h_uic_6',... 
                'UserData',''); 
        h_push_apply = uicontrol(... 
                'CallBack','viewer3d(''h_push_apply'');',... 
                'Position',[ 0.35 0.74 0.15 0.23 ],... 
                'String','Apply',... 
                'Style','pushbutton',... 
                'Units','normalized',... 
                'Tag','h_push_apply',... 
                'UserData',''); 
        h_edit_fig = uicontrol(... 
                'CallBack','viewer3d(''h_edit_fig'');',... 
                'Position',[ 0.65 0.75 0.06 0.22 ],... 
                'Style','edit',... 
                'String',currentfigstr,...
                'Units','normalized',... 
                'Tag','h_edit_fig',... 
                'UserData',''); 
        h_edit_s2val = uicontrol(... 
                'CallBack','viewer3d(''h_edit_s2val'');',... 
                'Position',[ 0.55 0.28 0.17 0.22 ],... 
                'String','30',... 
                'Style','edit',... 
                'Units','normalized',... 
                'Tag','h_edit_s2val',... 
                'UserData',''); 
        h_edit_s1val = uicontrol(... 
                'CallBack','viewer3d(''h_edit_s1val'');',... 
                'Position',[ 0.55 0.51 0.17 0.22 ],... 
                'String','-37.5',... 
                'Style','edit',... 
                'Units','normalized',... 
                'Tag','h_edit_s1val',... 
                'UserData',''); 
        h_edit_s3val = uicontrol(... 
                'CallBack','viewer3d(''h_edit_s3val'');',... 
                'Position',[ 0.55 0.05 0.17 0.22 ],... 
                'Style','edit',... 
                'String','0',... 
                'Units','normalized',... 
                'Tag','h_edit_s3val',... 
                'Visible','off',...
                'UserData',''); 
        h_uic_1 = uicontrol(... 
                'CallBack','viewer3d(''h_uic_1'');',... 
                'Position',[ 0.17 0.55 0.37 0.14 ],... 
                'Style','slider',... 
                'Units','normalized',... 
                'Value',[ -37.5 ],... 
                'Min',-90,'Max',90,...
                'Tag','h_uic_1',... 
                'UserData',''); 
        h_uic_3 = uicontrol(... 
                'CallBack','viewer3d(''h_uic_3'');',... 
                'Position',[ 0.17 0.09 0.37 0.14 ],... 
                'Style','slider',... 
                'Units','normalized',... 
                'Value',[ 0 ],... 
                'Min',-90,'Max',90,...
                'Tag','h_uic_3',... 
                'UserData',''); 
        h_uic_2 = uicontrol(... 
                'CallBack','viewer3d(''h_uic_2'');',... 
                'Position',[ 0.17 0.33 0.37 0.14 ],... 
                'Style','slider',... 
                'Units','normalized',... 
                'Value',[ 30 ],... 
                'Min',-90,'Max',90,...
                'Tag','h_uic_2',... 
                'UserData',''); 
        pause(1);
        set(h_uic_1,'vis','on','min',-90,'max',90);
        set(h_uic_2,'vis','on','min',-90,'max',90);
        set(h_uic_3,'vis','off','min',-90,'max',90);
        pause(1);
        h_text_fig = uicontrol(... 
                'CallBack','viewer3d(''h_text_fig'');',... 
                'Position',[ 0.5 0.74 0.14 0.23 ],... 
                'String','Figure:',... 
                'Style','text',... 
                'Units','normalized',... 
                'Tag','h_text_fig',... 
                'UserData',''); 
        h_text_s1lab = uicontrol(... 
                'CallBack','viewer3d(''h_text_s1lab'');',... 
                'Position',[ 0.02 0.5 0.14 0.2 ],... 
                'String','AZ',... 
                'Style','text',... 
                'Units','normalized',... 
                'Tag','h_text_s1lab',... 
                'UserData',''); 
        h_text_s3lab = uicontrol(... 
                'CallBack','viewer3d(''h_text_s3lab'');',... 
                'Position',[ 0.02 0.1 0.14 0.2 ],... 
                'Style','text',... 
                'Units','normalized',... 
                'Tag','h_text_s3lab',... 
                'UserData',''); 
        h_text_s2lab = uicontrol(... 
                'CallBack','viewer3d(''h_text_s2lab'');',... 
                'Position',[ 0.02 0.3 0.14 0.2 ],... 
                'String','EL',... 
                'Style','text',... 
                'Units','normalized',... 
                'Tag','h_text_s2lab',... 
                'UserData',''); 
        h_pop_choice = uicontrol(... 
                'CallBack','viewer3d(''h_pop_choice'');',... 
                'Max',[ 3 ],... 
                'Min',[ 1 ],... 
                'Position',[ 0.02 0.74 0.32 0.22 ],... 
                'String','AZ EL|Pitch Yaw Roll|X Y Z',... 
                'Style','popupmenu',... 
                'Units','normalized',... 
                'Value',[ 1 ],... 
                'Tag','h_pop_choice',... 
                'UserData',''); 


        %  Menu Object Creation 


        %  Axes and Text Object Creation 

        h_axes_1 = axes(... 
                'Box','on', ... 
                'View',[ -37.5 30 ],... 
                'Position',[ 0.77 0.12 0.2 0.71 ],... 
                'Units','normalized', ... 
                'Xgrid','off', ... 
                'Ygrid','off', ... 
                'Xlim',[ 0 1 ],... 
                'Ylim',[ 0 1 ],... 
                'Clipping','on', ... 
                'Tag','h_axes_1', ...
                'XTick',[],...
                'YTick',[],... 
                'ZTick',[],...
                'UserData',''); 
        set(h_axes_1,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');
        l=line([0 0],[0 1],[0 0],'linewidth',3);
        l=line([0 1],[0 0],[0 0],'linewidth',3);
        l=line([0 0],[0 0],[0 1],'linewidth',3);
        text(1,0,0,'x');
        text(0,1,0,'y');
        text(0,0,1,'z');

        handle_list = [ ...  
                 h_uic_6 h_push_apply h_edit_fig ... 
                h_edit_s2val h_edit_s1val h_edit_s3val h_uic_1 ... 
                h_uic_3 h_uic_2 h_text_fig h_text_s1lab ... 
                h_text_s3lab h_text_s2lab h_pop_choice  ... 
                h_axes_1 ... 
                        ]; 

        set(gcf,'userdata',handle_list); 
        drawnow;pause(1); 
        set(gcf,'visible','on'); 


elseif command == 1 
%       disp('h_push_apply selected.') 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_push_apply
        T = get(h_axes_1,'xform');
        fig_app = str2num(get(h_edit_fig,'string'));
        if length(fig_app) > 0
          if any(get(0,'chil') == fig_app)
                set(get(fig_app,'currentaxes'),'xform',T);
          end
        end
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_push_apply 
elseif command == 2 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_edit_fig
        fig_app = str2num(get(h_edit_fig,'string'));
        if length(fig_app) > 0
          if any(get(0,'chil') == fig_app)
                T = get(h_axes_1,'xform');
                set(get(fig_app,'currentaxes'),'xform',T);
          end
        end
         
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_edit_fig 
elseif command == 3 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_edit_s2val 
        choice = get(h_pop_choice,'val');
        if choice == 1
                el = str2num(get(h_edit_s2val,'str'));
                az = get(h_uic_1,'val');
                set(h_axes_1,'view',[az el]);
                set(h_uic_2,'val',el);
        elseif choice == 2 | choice == 3
                x = get(h_uic_1,'val')*pi/180;
                y = str2num(get(h_edit_s2val,'str'))*pi/180;
                z = get(h_uic_3,'val')*pi/180;
                xr = [1 0 0 0; 0 cos(x) -sin(x) 0; 0 sin(x) cos(x) 0; 0 0 0 1];
                yr = [cos(y) 0 sin(y) 0; 0 1 0 0; -sin(y) 0 cos(y) 0; 0 0 0 1];
                zr = [cos(z) -sin(z) 0 0; sin(z) cos(z) 0 0; 0 0 1 0; 0 0 0 1];
            if choice == 2
                T = xr*zr*yr;
            else
                T = xr*yr*zr;
            end
                set(h_uic_2,'val',(round(y*(180/pi)*10)/10));
                set(h_axes_1,'xform',T);
        end 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_edit_s2val 
elseif command == 4 
        disp('h_edit_s1val selected.') 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_edit_s1val 
        choice = get(h_pop_choice,'val');
        if choice == 1
                az = str2num(get(h_edit_s1val,'str'));
                el = get(h_uic_2,'val');
                set(h_axes_1,'view',[az el]);
                set(h_uic_1,'val',az);
        elseif choice == 2 | choice == 3
                x = str2num(get(h_edit_s1val,'str'))*pi/180;
                y = get(h_uic_2,'val')*pi/180;
                z = get(h_uic_3,'val')*pi/180;
                xr = [1 0 0 0; 0 cos(x) -sin(x) 0; 0 sin(x) cos(x) 0; 0 0 0 1];
                yr = [cos(y) 0 sin(y) 0; 0 1 0 0; -sin(y) 0 cos(y) 0; 0 0 0 1];
                zr = [cos(z) -sin(z) 0 0; sin(z) cos(z) 0 0; 0 0 1 0; 0 0 0 1];
            if choice == 2
                T = xr*zr*yr;
            else
                T = xr*yr*zr;
            end
                set(h_uic_1,'val',(round(x*(180/pi)*10)/10));
                set(h_axes_1,'xform',T);
        end 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_edit_s1val 
elseif command == 5 
        disp('h_edit_s3val selected.') 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_edit_s3val 
        choice = get(h_pop_choice,'val');
        if choice == 2 | choice == 3
                x = get(h_uic_1,'val')*pi/180;
                y = get(h_uic_2,'val')*pi/180;
                z = str2num(get(h_edit_s3val,'str'))*pi/180;
                xr = [1 0 0 0; 0 cos(x) -sin(x) 0; 0 sin(x) cos(x) 0; 0 0 0 1];
                yr = [cos(y) 0 sin(y) 0; 0 1 0 0; -sin(y) 0 cos(y) 0; 0 0 0 1];
                zr = [cos(z) -sin(z) 0 0; sin(z) cos(z) 0 0; 0 0 1 0; 0 0 0 1];
            if choice == 2
                T = xr*zr*yr;
            else
                T = xr*yr*zr;
            end
                set(h_uic_3,'val',(round(z*(180/pi)*10)/10));
                set(h_axes_1,'xform',T);
        end 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_edit_s3val 
elseif command == 6 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_uic_1
        choice = get(h_pop_choice,'val');
        if choice == 1
                az = get(h_uic_1,'val');
                el = get(h_uic_2,'val');
                set(h_axes_1,'view',[az el]);
                set(h_edit_s1val,'string',num2str(round(az*10)/10));
        elseif choice == 2 | choice == 3
                x = get(h_uic_1,'val')*pi/180;
                y = get(h_uic_2,'val')*pi/180;
                z = get(h_uic_3,'val')*pi/180;
                xr = [1 0 0 0; 0 cos(x) -sin(x) 0; 0 sin(x) cos(x) 0; 0 0 0 1];
                yr = [cos(y) 0 sin(y) 0; 0 1 0 0; -sin(y) 0 cos(y) 0; 0 0 0 1];
                zr = [cos(z) -sin(z) 0 0; sin(z) cos(z) 0 0; 0 0 1 0; 0 0 0 1];
            if choice == 2
                T = xr*zr*yr;
            else
                T = xr*yr*zr;
            end
                set(h_edit_s1val,'string',num2str(round(x*(180/pi)*10)/10));
                set(h_axes_1,'xform',T);
        end 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_uic_1 
elseif command == 7 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_uic_3 
        choice = get(h_pop_choice,'val');
        if choice == 2 | choice == 3
                x = get(h_uic_1,'val')*pi/180;
                y = get(h_uic_2,'val')*pi/180;
                z = get(h_uic_3,'val')*pi/180;
                xr = [1 0 0 0; 0 cos(x) -sin(x) 0; 0 sin(x) cos(x) 0; 0 0 0 1];
                yr = [cos(y) 0 sin(y) 0; 0 1 0 0; -sin(y) 0 cos(y) 0; 0 0 0 1];
                zr = [cos(z) -sin(z) 0 0; sin(z) cos(z) 0 0; 0 0 1 0; 0 0 0 1];
            if choice == 2
                T = xr*zr*yr;
            else
                T = xr*yr*zr;
            end
                set(h_edit_s3val,'string',num2str(round(z*(180/pi)*10)/10));
                set(h_axes_1,'xform',T);
        end 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_uic_3 
elseif command == 8 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_uic_2 
        choice = get(h_pop_choice,'val');
        if choice == 1
                az = get(h_uic_1,'val');
                el = get(h_uic_2,'val');
                set(h_axes_1,'view',[az el]);
                set(h_edit_s2val,'string',num2str(round(el*10)/10));
        elseif choice == 2 | choice == 3
                x = get(h_uic_1,'val')*pi/180;
                y = get(h_uic_2,'val')*pi/180;
                z = get(h_uic_3,'val')*pi/180;
                xr = [1 0 0 0; 0 cos(x) -sin(x) 0; 0 sin(x) cos(x) 0; 0 0 0 1];
                yr = [cos(y) 0 sin(y) 0; 0 1 0 0; -sin(y) 0 cos(y) 0; 0 0 0 1];
                zr = [cos(z) -sin(z) 0 0; sin(z) cos(z) 0 0; 0 0 1 0; 0 0 0 1];
            if choice == 2
                T = xr*zr*yr;
            else
                T = xr*yr*zr;
            end
                set(h_edit_s2val,'string',num2str(round(y*(180/pi)*10)/10));
                set(h_axes_1,'xform',T);
        end 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_uic_2 
elseif command == 9 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_START h_pop_choice 
        choice = get(h_pop_choice,'val');
        if choice == 1
                set(h_text_s1lab,'string','AZ');
                set(h_text_s2lab,'string','EL');
                set(h_text_s3lab,'string','');
                set([h_uic_3;h_edit_s3val],'visible','off');
        elseif choice == 2
                set(h_text_s1lab,'string','PITCH');
                set(h_text_s2lab,'string','YAW');
                set(h_text_s3lab,'string','ROLL');
                set([h_uic_3;h_edit_s3val],'visible','on');
        else
                set(h_text_s1lab,'string','X');
                set(h_text_s2lab,'string','Y');
                set(h_text_s3lab,'string','Z');
                set([h_uic_3;h_edit_s3val],'visible','on');
        end 
        %%       DO NOT REMOVE/ALTER THIS COMMENT: CALLBACK_STOP h_pop_choice 
else 
        error('Error: viewer3d.m called with incorrect command.') 
end 
