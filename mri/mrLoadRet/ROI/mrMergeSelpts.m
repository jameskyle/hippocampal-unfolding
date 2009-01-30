function selpts=mrMergeSelpts(selpts1,selpts2, ...
    selpts3,selpts4,selpts5,selpts6,selpts7,selpts8,selpts9)
%selpts=mrMergeSelpts(selpts1,[selpts2],[selpts3],...)
%
%Merges a list selpts matrices (ROI's) into one
%by calculating the union of the ROI's and removing duplicates.

%1/25/97 gmb Wrote it.

%merge the selpts
selpts = [];
for selptsnum=1:nargin
  str = ['selpts = [selpts,selpts',int2str(selptsnum),'];'];
  eval(str);
end



%unwrap each selpts matrix into a long vector:

%strip off selpts that have negative inplane values.
if ~isempty(selpts)
  selpts = selpts(:,selpts(2,:)>0);
end

%if we still have an ROI...
if ~isempty(selpts)
  maxImgSize=max([selpts(1,:)]);
  unwrapSelpts=selpts(1,:)+(selpts(2,:)-1)*maxImgSize;

  %zero out a matrix to hold locations of ROI's
  id = zeros(1,max(unwrapSelpts));
  %increment the index matrix
  id(unwrapSelpts)=id(unwrapSelpts)+1;

  %pull out indices (union of two ROI's)
  unwrapSelpts = find(id);

  %transform back into standard selpts format
  selpts=zeros(2,length(unwrapSelpts));
  selpts(1,:)=mod((unwrapSelpts(1,:)-1),maxImgSize)+1;
  selpts(2,:)=floor((unwrapSelpts(1,:)-1)/maxImgSize)+1;
end
%done.

