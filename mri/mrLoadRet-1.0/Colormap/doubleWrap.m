% Script to change the phase colormap in mrLoadRet 
% so that 180 deg from one hemifield maps onto a full
% hsv colormap (instead of just half of it)
% HAB, 2/26/97
%
cmap = colormap;
cmap2 = cmap;
cmap2(129:129+63,:) = hsv(64);
cmap2(129+64:256,:) = hsv(64);
figure(1)
colormap(cmap2)
