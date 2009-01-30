function selpts = subSelpts(selpts,co,amp,ph,numofanats,anatmap,refexpnum,cothresh,pWindow,slices)

%selpts = subSelpts(selpts,co,amp,ph,numofanats,[refexpnum],[cothresh],[pWindow],[slices])

if ~exist('refexpnum')
  refexpnum=1;
end

if ~exist('cothresh')
  cothresh =0;
end

if ~exist('pWindow')
  pWindow = [0,360];
end

if ~exist('slices')
  slices = 1:numofanats;
end

numscans = size(co,1)/numofanats;

% Set selpts based on specified slices
tmpselpts=[];
for i=1:length(slices)
  tmpselpts=[tmpselpts;selpts(:,selpts(2,:)==slices(i))'];
end
selpts=tmpselpts';

% Set subset of selpts based on correlation and phase window
%  Old way; refexpid = refexpnum:numscans:size(co,1);
%%% Changed 3/7/00 SAE to work with bigGLM

refexpid = zeros(1,numscans);
for i = 1:numofanats
  tmp = find(anatmap==i);
  refexpid(i) = tmp(refexpnum);
end
disp(num2str(refexpid));

refco=co(refexpid,:);
refamp=amp(refexpid,:);
refph= ph(refexpid,:);

% Select subset of selpts based on correlations and phase window
% of the reference scan.
numofanats=size(refco,1);
tmpselpts=[];
if ~isempty(selpts)
  for i=1:numofanats;
    id=selpts(1,find(selpts(2,:)==i));
    sub_id= id(mrGetInpWindow(refph(i,id),pWindow) & (refco(i,id)>cothresh));
    tmpselpts=[tmpselpts,[sub_id;i*ones(1,length(sub_id))]]; 
  end
end
selpts=tmpselpts;




