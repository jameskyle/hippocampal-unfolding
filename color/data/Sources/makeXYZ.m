cd /home/brian/matlab/cap/Sources

load -ascii xyz.dat

l1 = find(xyz(:,1) == 370);
l2 = find(xyz(:,1) == 730);

X = xyz(l1:l2,2);
Y = xyz(l1:l2,3);
Z = xyz(l1:l2,4);

XYZ = [X Y Z];
size(XYZ)
save XYZ XYZ
