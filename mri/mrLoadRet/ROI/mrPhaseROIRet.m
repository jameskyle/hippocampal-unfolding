% mrPhaseROIRet(curSer, curAnat, ph, seph, selpts);
%
%	Draws a phase plot for the points on the image given by
% selpts.  The number of th anatomy image under scrutiny is given by curAnat.
% 

% MMZ 6/10/03 Fixed isempty bug

function mrPhaseROIRet(curSer,curAnat,ph,seph,selpts);

% Variable Declarations
stimChange = [];	% I don't rightly know
xTickValue = 0;		% ditto
myph = [];
myse = [];


selpts = mrExtractROIRet (curAnat,selpts);
if ~any(selpts)
   return;
end

mrColorBar(0,'off');


ph = ph(curSer,selpts(1,:));
% MMZ if (seph == [])
if isempty(seph)
	seph = zeros(1,length(selpts(1,:)));
else
	seph =seph(curSer,selpts(1,:));
end

ph = -ph;
ph = unwrap(ph);
ph = ph-min(ph);
plot(1:length(ph),ph, 'wo');
hold on
errorbar(1:length(ph),ph,seph,seph,'w-');
hold off
%stimChange = ones(1,floor(length(ph)/6.4))*6.4;
stimChange = ones(1,floor(length(ph)/5.34))*5.34;
xTickValue = cumsum(stimChange);
set(gca,'XTick',xTickValue,'Xlim',[0,length(ph)+1],'XTickLabels',[]);
set(gca,'YTick',[(0:6)*pi],'Ylim',[-.2, 6*pi],'YTickLabels',[0:6]);
grid on
end
