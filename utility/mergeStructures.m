function outStruct = mergeStruct(firstStruct,secondStruct)
%outStruct = mergeStruct(firstStruct,secondStruct)
%
%returns a structure with fields from both input structures.
%If both input structures have the same fields, the secondStruct
%fields overwrite the firstStruct fields.

outStruct = firstStruct;

if ~isempty(secondStruct)
  fieldNames = fieldnames(secondStruct);
  for i = 1:length(fieldNames)
    outStruct = setfield(outStruct,char(fieldNames(i)),...
	getfield(secondStruct,char(fieldNames(i))));
  end
end


