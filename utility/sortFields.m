function sortedStruct = sortFields(struct)
%struct = sortFields(struct)
%
%Returns a structure with the fields in alphabetical order.
%Useful because you can't make an array of structures if
%the fields of the structures are defined in different orders,
%which is very lame.
%
%EXAMPLE:
%foo1.a = 10;
%foo1.b = 20;
%foo2.b = 30;
%foo2.a = 40;
%catFoo = [sortFields(foo1),sortFields(foo2)]
%
%note: [foo1,foo2] doesn't work
fields = fieldnames(struct);
[sortedFields,id] = sort(fields);

sortedStruct = [];
for i=1:length(fields)
  sortedStruct=setfield(sortedStruct,char(fields(id(i))),...
      getfield(struct,char(fields(id(i)))));
end
