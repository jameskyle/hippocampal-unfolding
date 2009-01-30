function checkForShift(dr)
%
%function checkForShift(dr)
%AUTHOR: Poirson
%DATE: 4/29/97
%
%PURPOSE:
% Check for shift between structural (inplane) and functional
% images.  (Assumes 256x256 images).
%ARGUMENTS:
%  dr: the place where mrLoadRet believes the data sit.
%HISTORY: 
% Motivated by a script written by Heidi Baseler on 04.29.97

qt = '''';

curdr = pwd;

pfdr = sprintf('%s/%s',dr,'anatomy/Pfiles');
str = sprintf('\nDirectory of Pfile images is: %s',pfdr);
disp(str);
inputdr = input ('Press <return> to accept, or enter a new directory: ','s');
if ~(inputdr)
  pfdr = inputdr;
end

ipdr = sprintf('%s/%s',dr,'anatomy/inplane');
str = sprintf('\nDirectory of inplane images is: %s',ipdr);
disp(str);
inputdr = input ('Press <return> to accept, or enter a new directory: ','s');
if ~isempty(inputdr)
  ipdr = inputdr;
end

chdir(pfdr);

str= ['[foo,Pname]=unix(',qt,'ls P?????.??1',qt,');'];
eval(str);
nPfiles=length(Pname)/11;
if nPfiles<1
  disp(['No Pfiles found in directory ',pfdr,'!']);
  return
end	
Pname=reshape(Pname,11,nPfiles)';
Pname=Pname(:,1:10);
%Let the user decide which P file on the list to check
disp(' ');
disp('Which Pfiles do you want to check?');
for i=1:nPfiles
  disp(['(',int2str(i),') ',Pname(i,:)]);
end
Plist=input('Enter a vector (i.e. [1,2,5]), or press <return> for all: ');
%default is to check all Pfiles
if isempty(Plist)
   Plist=1:nPfiles;
end

% Read in first anatomical image
chdir(ipdr)
[struc,count] = mrRead('I.001',[256 256],7904);
% clip out the high values for better viewing pleasure
m = max(struc);
l = find(struc>(0.4*m));
z = zeros(1,length(l));
struc(l) = z;
ims = reshape(struc,256,256);

chdir(pfdr);
for curPfile=Plist
	pf = [qt,Pname(curPfile,:),qt];
	str=sprintf('Checking %s ',pf);
	disp(str);

	readstr = ['[func,count] = mrRead(',pf, ',[256 256],0);'];
	eval(readstr);

	% Reshape image
	imf = reshape(func,256,256);

	% Plot images
	figure;
	hold off; clf;
	axis image
	colormap(gray(max2([func; struc])));
	subplot(2,1,1),mrShowImage(struc,[256 256],'s');
	set(gca,'xtick',[100:10:180]);
	set(gca,'ytick',[100:10:200]);
	grid on;
	title(sprintf('%s/I.001',ipdr));
	
	subplot(2,1,2),mrShowImage(func,[256 256],'s');
	set(gca,'xtick',[100:10:180]);
	set(gca,'ytick',[100:10:200]);
	grid on;
	title(sprintf('%s/%s',pfdr,pf));

end

chdir(curdr);

sprintf('\n');
return


% Plot one line from each image
figure
hold off; clf;
plot(1:256,ims(128,:),'r',1:256,imf(128,:),'y')

