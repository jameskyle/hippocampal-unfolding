function cmap = mrRedGreenCmap()
% jmz 6/5/95

cmap = gray(128);
for i=(129:256)
  cmap(i,:) = [((i-128)/128)^.5, (1-(i-128)/128)^.5, 0];
end
