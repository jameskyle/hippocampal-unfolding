function [subject] = mrGetSubject(voldr)
%function [subject] = mrGetSubject(voldr)
%
% PURPOSE: Get the name of a subject on whom we have volume data.
% AUTHOR:  Poirson 
% DATE:    07.16.97

qt=''''; %single quote character

subject = 'NotAPerson';

S = sprintf('test -d %s/%s',voldr,subject);
while (~unix(S)==0)

	fprintf(1,'Current list of subjects:\n');
	estr=(['unix(',qt,'ls ',voldr,qt,');']);
	eval(estr);
	subject=input('Subject name: ','s');
	S = sprintf('test -d %s/%s',voldr,subject);
	fprintf(1,'\n');

end

return

% Less fancy -- ABP
fprintf(1,'Current list of subjects:\n');
estr=(['unix(',qt,'ls ',voldr,qt,');']);
eval(estr);
subject=input('Subject name: ','s');
fprintf(1,'\n');

end



