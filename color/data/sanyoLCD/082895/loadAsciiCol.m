function cols = loadAsciiCol(prefs,basename,suf)

for i = 1:3
	nam = [prefs(i,:) basename];
	eval(['load ',nam,'.',suf]);
	eval(['cols(:,i) = ',nam,'(:,2);']);
end 
