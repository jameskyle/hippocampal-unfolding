function mrFCorRet (nExp, imagesperexp, ncycles,junkimages,ltrend,side)

% [co,ph,amp]=mrFCorRet (nExp, imagesperexp, ncycles, junkimages,[ltrend]);
%
%	Reads the flattened functional data, experiment by experiment.
% The data are correlated with the appropriate sinusoids
% (mrAdCorRet).  The results of the anaylsis are placed in three
% matrices, co, ph, and amp.  These matrices are returned by the
% function in the aforementioned order.
% In each matrix, each row corresponds to an  experiment and each
% column is a pixel. If ltrend(1)=='y' the linear trend is
% subtracted, if ltrend is not given, a prompt asks for it.
% co,ph and amp are saved in files: FCorAnal_left.mat and FCorAnal_right.mat

%9/2/96  gmb Wrote it.

if (~exist('ltrend'))
	ltrend=input('Subtract linear trend? ','s');
end

if (~exist('side'))
  side = input('Flatten (l)eft, (r)ight, or (b)oth? ','s'); 
end
if side == 'b', side = ['l','r']; end

for brainSide = side
  if brainSide == 'l' 
    hemisphere = 'left';
  else 
    hemisphere = 'right';
  end
  clear co ph amp
  % Variable declarations
  qt=''''; 				% single quote character.
  i = 1; 				% a counter
  tSeries = []; 			% a matrix in which each column is a pixel and each row is
  % a sample in time.
  estr = ''; 				% Hack to avoid MatLab's stupid convention of not eval'ing variable names
  
  global dr;
  
  for i=1:nExp
    disp(['experiment ',num2str(i)]);
    eval(['load FtSeries',num2str(i),'_',hemisphere]);
    [co(i,:),ph(i,:),amp(i,:)]= ...
	mrFTCorSeries(tSeries(junkimages+1:imagesperexp,:),ncycles,ltrend);
  end
  estr = ['save FCorAnal_',hemisphere,' co ph amp'];
  disp(estr)
  eval(estr);

end %brainSide

