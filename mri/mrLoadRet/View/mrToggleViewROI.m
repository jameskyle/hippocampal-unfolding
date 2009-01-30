function ROI_menu = mrToggleViewROI(ROI_menu);

label =get(ROI_menu,'Label');

if strcmp(label,'Show ROI');
  set(ROI_menu,'Label','Hide ROI');
else
  set(ROI_menu,'Label','Show ROI');
end
