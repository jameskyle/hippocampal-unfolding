function buf = putObject(buf, label, object)
% putObject(buf, label, object)
% 	Places the object specified in an object buffer (buf).  This
%	object is now associated to the label given.  If an object with
%	the same label already exists in the buffer then it is replaced.
%	Values, vectors, matices or strings (anything) may be placed in
%	the object buffer.
%	
%	Labels are strings that should be at least three characters in 
%	length although any size should work.
%
%	The new object buffer is returned.
%
%	getObject and putObject alleviate the need for pointer in Matlab.
% 
% Rick Anthony
% 4/23/94

if(nargin < 3)
   error('Three input arguments needed');
end

bufLength 		= size(buf,2);
labelLength 		= size(label,2);
[objectRows objectCols] = size(object);
objectLength 		= objectRows * objectCols;
stringObject 		= isstr(object);


if(stringObject)
    object = abs(object);
end


if(isempty(buf))
    buf = [labelLength+5 ...
           0 ...
           abs(upper(label)) ...
           stringObject ...
           1 ...
           objectRows ...
           objectCols ...
           1 ...
           1 ...
           object(:)'];

    return;
end


startLabelArea  = 2;
labelAreaLen 	= buf(startLabelArea-1);
startIndexArea 	= startLabelArea+labelAreaLen+1;
indexAreaLen 	= buf(startIndexArea-1);
startDatumArea 	= startIndexArea+indexAreaLen;
datumAreaLen	= bufLength-startDatumArea+1;
labelArea 	= buf(startLabelArea:labelAreaLen+1);
indexArea 	= buf(startIndexArea:startIndexArea+indexAreaLen-1);
datumArea 	= buf(startDatumArea:bufLength);


indexes = findstr(labelArea, upper(label));

for i=indexes;
 
    if( labelArea(i-1) == 0 )
        propIndex 	= i+labelLength;
        oldString 	= labelArea(propIndex);
        oldNumber 	= labelArea(propIndex+1);
        oldRows 	= labelArea(propIndex+2);
        oldCols 	= labelArea(propIndex+3);
        oldLength 	= oldRows * oldCols;

        if((objectLength == oldLength) & (stringObject == oldString))
            dataIndex = startDatumArea+indexArea(oldNumber)-1;
             
            buf(dataIndex:dataIndex+objectLength-1) = object(:)';
        else
            dataIndex = indexArea(oldNumber);

            labelArea(propIndex) = stringObject;
            labelArea(propIndex+2) = objectRows;
            labelArea(propIndex+3) = objectCols;

            indexPrev = indexArea(1:oldNumber);
            indexNext = indexArea(oldNumber+1:indexAreaLen);
            indexArea = [indexPrev indexNext+(objectLength-oldLength)];

            datumPrev = datumArea(1:dataIndex-1);
            datumNext = datumArea(dataIndex+oldLength:datumAreaLen);
            datumArea = [datumPrev object(:)' datumNext];
 
            buf = [labelAreaLen labelArea indexAreaLen indexArea datumArea];
        end

        return;
    end
end

labelAreaLen = labelAreaLen+labelLength+5;
indexAreaLen = indexAreaLen+1;

buf = [labelAreaLen labelArea ...
       0 abs(upper(label)) stringObject indexAreaLen objectRows objectCols ...
       indexAreaLen indexArea datumAreaLen+1 ...
       datumArea object(:)'];


