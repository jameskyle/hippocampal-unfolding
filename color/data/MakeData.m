cd /home/brian/matlab/capData
name = 'smithPokorny.10';
smithPokorny10 = readcap(name,'CapBasis');
save smithPokorny10  smithPokorny10 

name = 'smithPokorny.1';
smithPokorny = readcap(name,'CapBasis');
save smithPokorny  smithPokorny

name = 'ncones.10';
ncones10 = readcap(name,'CapBasis');
save ncones10  ncones10 

name = 'ncones.1';
ncones = readcap(name,'CapBasis');
save ncones  ncones

name = 'Y.10';
Y10 = readcap(name,'CapBasis');
Vlambda10 = Y10;
save Y10 Y10
save Vlambda10 Vlambda10

name = 'xyz.10';
XYZ10 = readcap(name,'CapBasis');
save XYZ10 XYZ10

name = 'xyz.1';
XYZ = readcap(name,'CapBasis');
save XYZ XYZ

name = 'rods.1';
V0lambda = readcap(name,'CapBasis');
save V0lambda V0lambda

name = 'bar487.10';
bar48710 = readcap(name,'CapBasis');
save bar48710  bar48710 

name = 'bar487.1';
bar487 = readcap(name,'CapBasis');
save bar487  bar487

name = 'hit489.1';
hit489 = readcap(name,'CapBasis');
save hit489 hit489

name = 'hit489.10';
hit48910 = readcap(name,'CapBasis');
save hit48910 hit48910

name = 'bar469.1';
bar469 = readcap(name,'CapBasis');
save bar469 bar469

name = 'p31.10';
p3110 = readcap(name,'CapBasis');
save p3110 p3110

name = 'p31.1';
p31 = readcap(name,'CapBasis');
save p31 p31

name = 'cieabc.1';
cieabc = readcap(name,'CapBasis');
save cieabc cieabc

name = 'daycie.1';
daycie = readcap(name,'CapBasis');
save daycie daycie

name = 'D65.1';
D65 = readcap(name,'CapBasis');
save D65 D65

name = 'cwf.1';
CWF = readcap(name,'CapBasis');
save CWF CWF

%%%%%%%%%%%%%%%
load -ascii stockmanLog.raw
stockWave = stockmanLog(:,1);
%
%	I am not sure which one to use.
%	I used the one based on the 1964 data because
%	they looked smoother for the red.
%
stockLMSA = stockmanLog(:,[2,3,4]);
stockLMSB = stockmanLog(:,[5,6,7]);

stockman = 10 .^ stockLMSB;
z = zeros(4,3);
stockman = [z ; stockman];
stockWave = 370:5:730;
wave = 370:730;
stockman = interp1(stockWave,stockman,wave);
plot(wave,stockman)
save /home/brian/matlab/capData/stockman stockman
