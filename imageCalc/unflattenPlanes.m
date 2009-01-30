function result = unflattenPlanes(data, rows, cols)


if(nargin < 2)
    error('Two input arguments required');
end

data = data';
data = data(:);
planes = length(data)/(rows*cols);

if(planes ~= ceil(planes))
    error('Incorrect number of rows or columns specified');
end

result = reshape(data,rows,planes*cols);
