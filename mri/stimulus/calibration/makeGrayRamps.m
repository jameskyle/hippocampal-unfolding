%
%  Create a set of look tables that are linear gray ramps based on
% the gamma table of the Sanyo LCD.
%

cd /home/brian/exp/mri/stimuli
load sanyoLCDGam	%Load the relevant gamma function
contrasts = [0,.0316,.0750,.1778,.4217,1.0]/2;

linearmap = gray(254);	% To save first and last entries
allmps = zeros(254,18);
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	minc = .5-contrasts(i);
	maxc = .5+contrasts(i);
	allmps(:,mprange) = scale(linearmap,minc,maxc);
end
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/grayRamps cmap
