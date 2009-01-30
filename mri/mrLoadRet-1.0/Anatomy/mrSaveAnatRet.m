function mrSaveAnatRet(anat, anatmap, oSize, curSize, curCrop,fname)

if ~exist('fname')
  fname = 'anat';
end

str = ['save ',fname,' anat anatmap curSize curCrop'];
eval(str);

