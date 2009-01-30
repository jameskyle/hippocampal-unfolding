function result = flattenPlanes(data, planes)


if(nargin < 2)
    error('Two input arguments required');
end

data = data(:);
rows = planes;
cols = length(data)/planes;

if(cols ~= ceil(cols))
    error('Incorrect number of planes specified');
end

result = reshape(data,cols,rows)';



