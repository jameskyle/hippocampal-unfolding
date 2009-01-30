clear;
m=128;
n=128;

cd '/wusr3/boynton/matlab/stimuli'

bitimage=ExpandingRings(m,n);

nimages=size(bitimage,2);

cd '/wusr3/boynton/mac/Matlab'
save ringdat bitimage m n nimages

