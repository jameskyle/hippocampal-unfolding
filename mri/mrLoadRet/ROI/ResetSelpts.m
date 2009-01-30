%ResetSelpts.m

%resets selpts_left, selpts_right and/or selpts_inplane to '[]'.

if strcmp(viewPlane,'inplane')
  selpts_right = [];
  selpts_left = [];
elseif (strcmp(viewPlane,'left') | strcmp(viewPlane,'right'))
  selpts_inplane = [];
end
