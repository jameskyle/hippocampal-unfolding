function mrProjectCorAnal
%mrProjectCorAnal

%Creates FCorAnal directly from CorAnal
%by projecting co,ph and amp directly to the
%flattened representation.

%Note that this projection is exact only for 
%ph and amp.  Co is exact only for pixels in
%the flattened representation that correspond
%to only one inplane voxel.  Otherwise, the mean
%of the correlations from more than one inplane
%pixel is taken, which is not exact, since the
%information about the non-harmonic frequencies
%is lost.

%11/24/96   gmb wrote it.
%12/9/97    gmb converted to matlab 5 and added dc projection
%07/07/98   sjc added user query for unfold subdirectory in cases
%	        when FCorAnal_HEMISPHERE does not exist and needs
%		to be created.

% If the file 'VolParams.mat' doesn't exist, have user create it.
% if ~check4File('VolParams')	% VolParams.mat doesn't exist
%   voldr='/usr/local/mri/anatomy';
%   disp (['VolParams.mat not found.  Please enter experimental values.']);
%   mrGetVolParams(voldr);
% end 

% If the file 'AlignParams.mat' doesn't exist, have user create it.
if ~check4File('AlignParams')	
   voldr='/usr/local/mri/anatomy';
   disp (['AlignParams.mat not found.  Please enter experimental values.']);
   mrGetAlignParams(voldr);
else
   disp('Loading AlignParams')
   load AlignParams
end

side = input('Project (l)eft, (r)ight, or (b)oth? ','s'); 
side = side(1);
if strcmp(side,'b')
  side = ['lr']; 
end

%Load in inplane parameters
load anat
load ExpParams
load CorAnal

%Save variables (variable names co,ph and amp will be reused)
inplaneco =  co;
inplaneamp = amp;
inplaneph =  ph;
if exist('dc')
  inplanedc =  dc;
end

for brainSide = side
  if strcmp(brainSide,'l')
    hemisphere = 'left';
  else 
    hemisphere = 'right';
  end

  % If the flattened anatomy file does not exist, create it
  if ~check4File(['Fanat_',hemisphere]);

    % Get unfold subdirectory
    curdir = cd;
    unfDir = ['usr/local/mri/anatomy/' subject '/' hemisphere '/unfold'];
    chdir(unfDir)
    
    % Find unfold subdirectories and list them.
    %
    fprintf('Available unfold subdirectories: ');
    FindDirectories
    
    UnfoldSubDir = input('Which unfold subdirectory?  ','s');
    
    % Check to see if the subdirectory exists
    d = sprintf('%s/%s',unfDir,UnfoldSubDir);
    if ~ (exist(d,'dir'))
      fprintf('No directory %s.\nSetting sub directory to null.\n',d);
      UnfoldSubDir = '';
    end
    chdir(curDir)
    
    cmd = ['mrCreateFlatAnat(side,' hemisphere 'UnfoldSubDir);'];
    eval(cmd);
  end
  
  %Load in flattened anatomy which includes variables:
  %anat anatmap fSize curCrop gray2inplane gray2flat
  eval(['load Fanat_',hemisphere]);

  %load inplane correlations, amplitudes and phases
 
  % Figure out gray matter locations in 3d in the functional volume
  % gLocsFunc is a nGray x 3 array.  The data points are rounded to
  % fall on functional voxels.
  % 
  gLocsFunc = mrVcoord(gray2inplane,curSize);
  % This is the number of voxels in the functional volume
  % 
  volumeLength = prod(curSize)*numofanats;
  % These are the row and col locations of the gray-matter in the
  % flattened representation
  % 
  
  tmp = mrVcoord(gray2flat,fSize);
  colF = tmp(:,1); rowF = tmp(:,2);
  
  % Allocate or re-initialize tSeriesF and its counter
  % 
  coF = zeros(numofexps/numofanats,prod(fSize));
  ampF = zeros(numofexps/numofanats,prod(fSize));
  phF = zeros(numofexps/numofanats,prod(fSize));
  if exist('dc')
    dcF = zeros(numofexps/numofanats,prod(fSize));
  end
  tSeriesC = zeros(1,size(coF,2));
  
  % Find the index into the functional volume for 
  % the current plane
  % size(xLocsFp), max(xLocsFp)
  for thisAnat = 1:numofanats
    xLocsFp = find(gLocsFunc(:,3) == thisAnat);  
    if ~isempty(xLocsFp)
      % Make the index into this plane, so we can address the proper
      % columns of tSeries
      xFlatImage= ...
	  mrVcoord([colF(xLocsFp) rowF(xLocsFp) ...
	      ones(length(xLocsFp),1)],fSize);   
      
      % Make the index into the original tSeries data.  The variable
      % curSize is the (row,col) size of the implicit tSeries image.   
      % mrShowImage(tSeries(1,:),curSize)
      % gLocsFunc is structured as (x,y,z), which is (col,row,nplane).
      % 
      xTseries =  ...
	  mrVcoord([gLocsFunc(xLocsFp,[1 2]) ...
	      ones(length(xLocsFp),1)],curSize); 
      
      %There will be duplicates: some of the gray matter maps to the
      %same voxel. So, we need to sort and merge these values
      tSeriesC(xFlatImage) = tSeriesC(xFlatImage) + 1;
      
      for curExp = 1:numofexps/numofanats
	curSer = (thisAnat-1)*numofexps/numofanats+curExp;
	ampF(curExp,xFlatImage) = ampF(curExp,xFlatImage)+ inplaneamp(curSer,xTseries).*exp(sqrt(-1)*inplaneph(curSer,xTseries));
	
	coF(curExp,xFlatImage) = coF(curExp,xFlatImage)+ (inplaneco(curSer,xTseries).^2).*exp(sqrt(-1)*inplaneph(curSer,xTseries));
	if exist('dc')
	  dcF(curExp,xFlatImage) = dcF(curExp,xFlatImage)+ inplanedc(curSer,xTseries).*exp(sqrt(-1)*inplaneph(curSer,xTseries));
	end
	% Mark each grid point in the flattened image where we added a
	% a tSeries
      end
    end
  end
  
  list = ones(numofexps/numofanats,1)*(tSeriesC > 1);
  denom = ones(numofexps/numofanats,1)*tSeriesC(find(list(1,:)));

  
  if ~isempty(denom)
    ampF(find(list)) = ampF(find(list)) ./ denom(:);
    coF(find(list)) = coF(find(list)) ./ denom(:);
    if exist('dc')
      dcF(find(list)) = dcF(find(list)) ./ denom(:);
      dc = abs(dcF);
    end
  end
  amp = abs(ampF);
  ph = angle(ampF);
  ph(ph<0)=ph(ph<0)+pi*2;
  co = abs(sqrt(coF));

  if ~exist('dc')
      str = ['save FCorAnal_',hemisphere,' amp co ph'];
  else
    str = ['save FCorAnal_',hemisphere,' amp co ph dc'];
  end
  disp(str);
  eval(str);
end %side














