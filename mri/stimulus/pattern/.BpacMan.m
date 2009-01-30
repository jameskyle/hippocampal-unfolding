
cd /home/brian/data/mri/stimuli

radius = 64;

x = [-radius:radius];
y = [-radius:radius];

[X Y] = meshgrid(x,y);

inCircle = find (X.^2 + Y.^2 < radius^2);
size(inCircle)
