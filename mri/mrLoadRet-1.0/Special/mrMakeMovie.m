function mrMakeMovie(tSeries,anat,curSize,ncycles,junkimages)
%mrMakeMovie(tSeries,anat,curSize,ncycles,junkimages)
%
%	Creates and Plays a movie of the current functional image sequence
%	overlayed on the current anatomy plane using MATLAB's 'movie' tool.
%
%	Each frame is the current anatomy plus a scale factor times the 
%	Smoothed functional without the DC component.

%	June 15,1996	gmb	Wrote it.

%Some general parameters
magnify=4;	%  Amplification factor for functional component.
y=2;		%  #of pixels (from top) for time-course indicator bar.

%Check if tSeries is loaded in.
% 7/07/97 Lea updated to 5.0
if isempty(tSeries)
	disp('no tSeries information available.');
	return
end

mrColorBar(0,'off');

% 7/10/97 Lea updated to 5.0
%smooth the time series and subtract the DC component
disp('Smoothing time series...');
filter=[1,4,6,4,1] ./ 16;
tSeries=tSeries-ones(size(tSeries,1),1)*mean(tSeries);
for (i=1:size(tSeries,2));
	tSeries(:,i)=convolvecirc(tSeries(:,i),filter);
end

%Create the movie matrix M
nimages=size(tSeries,1)-junkimages;
myShowImage(anat,curSize);
M=moviein(nimages);
disp(['Creating movie...']);
for (i=1:nimages)
	img=magnify*tSeries(i+junkimages,:)+anat;
	img(find(img<0))=zeros(size(find(img<0)));

	myShowImage(img,curSize);
	
	%draw time-course bar
	line([0,curSize(2)],[y,y]);
	%tick marks
	for j=1:ncycles+1
		x=(j-1)*curSize(2)/ncycles;
		patch([x-1,x+1,x+1,x-1],[y-1,y-1,y+1,y+1],'y');
	end
	x=i*curSize(2)/(nimages);
	patch([x-2,x+2,x+2,x-2],[y-2,y-2,y+2,y+2],'r');
	
	M(:,i)=getframe;
end


do_again='y';
while(do_again(1)=='y')
	disp(['Playing movie...']);
	movie(M,10)	
	do_again=input('Play it again (y/n)? ','s');
end

%seq=ceil(linspace(1,nimages-1,nimages*4));
%disp(['Playing movie more slowly...']);
%movie(M,[5,seq])

