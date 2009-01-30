function id=mrGetInpWindow(ph,pWindow)
%MRGETINPWINDOW
%
%	id = mrGetInpWindow(ph,pWindow)
%
%	returns index to members of ph that lie in pWindow
%	
%	if pWindow(1)<pWindow(2) returns pWindow(1) < ph < pWindow(2)
%	if pWindow(1)>pWindow(2) returns ph > pWindow(1) or ph < pWindow(2)
%


scfac=180/pi;

if diff(pWindow)>0
	id = (ph>=pWindow(1)/scfac & ph<=pWindow(2)/scfac);
else
	id = (ph>pWindow(1)/scfac | ph<pWindow(2)/scfac);
end


