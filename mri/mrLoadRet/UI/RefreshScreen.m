script 					%RefreshScreen
% 
% script to refresh the screen, usually called
% This is a key script.  It is used to put up all the different
% types of images under the View menu.
% 

mrSlicoControlRet(curSer, co, ph, amp, ....
    anat(anatmap(curSer),:), curSize,  ...
    curDisplayName,selpts,anatmap,pWindow);

%Load the correlation data if needed
%Load the anatomy images if needed

if ~exist('oldDisplayName');
  oldDisplayName = '';
end

if ~strcmp(curDisplayName,oldDisplayName) & ...
      ~(strcmp(curDisplayName,'FullAnat') | ...
        strcmp(curDisplayName,'SS'))
    disp('Loading anatomy images...');
    [anat, anatmap,curImage, curSize, curCrop] = ...
    mrReLoadAnatRet(anatmap(curSer),viewPlane);
    if isempty(~strcmp(curDisplayName,'anatomy') & co)
      [co, ph, amp]=mrLoadCorAnal(viewPlane);
    end
end

if (strcmp(curDisplayName, 'cor'))

  curImage = ...
      mrThreshCorRet(curSer, co, ph, anat, anatmap, ...
      pWindow, fixedCorCmapRange);

elseif (strcmp(curDisplayName, 'amp'))

  [curImage]=mrThreshAmpRet(curSer, co, ph, amp,anat, anatmap, pWindow);

elseif (strcmp(curDisplayName, 'phase'))

  [curImage] =mrThreshPhRet(curSer, co, ph, anat, anatmap,phase_cmap, pWindow);

elseif (strcmp(curDisplayName, 'wphase'))

  sliders.co = slico; sliders.max = slimax; sliders.min = slimin;
  [mergedIm mergedMap] = ...
      wPhMap(anat(anatmap(curSer),:),co(curSer,:),ph(curSer,:),...
      curSize,pWindow,phase_cmap,sliders,[],[],[]);

elseif (strcmp(curDisplayName, 'map'))

  [curImage] =mrThreshMapRet(curSer, co, ph, map,anat, anatmap, pWindow);

elseif (strcmp(curDisplayName, 'concor')) 

  [curImage]=mrConCor (curSer, co, ph, anat, anatmap, curSize,pWindow);

elseif (strcmp(curDisplayName, 'medcor'))

  [curImage]=mrMedCor(curSer, co, ph, anat, anatmap,curSize, pWindow);

elseif (strcmp(curDisplayName, 'conphase'))

  [curImage]=mrConPhase(curSer, co, ph, anat,anatmap,...
      curSize,phase_cmap,pWindow);

elseif (strcmp(curDisplayName, 'medphase'))

  [curImage]=mrMedPhase(curSer, co, ph, anat,anatmap,curSize,...
      phase_cmap,pWindow);

elseif (strcmp(curDisplayName, 'anatomy') | ...
        strcmp(curDisplayName, 'FullAnat'))

    [curImage]=mrAnatomy(curSer,selpts,anat,anatmap,ROI_menu);

end

if(strcmp(curDisplayName,'wphase'))
  image(mergedIm),colormap(mergedMap),axis image;
  mrColorBar([],'off'); 
else
  imHandle = myShowImage(curImage,curSize);
end

if strcmp(get(ROI_menu,'Label'),'Hide ROI')
  mrViewROIRet(curSize,selpts,anatmap(curSer));
end

oldDisplayName = curDisplayName;



