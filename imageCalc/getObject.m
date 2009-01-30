function object = getObject(buf, label)
% getObject(buf, label)
%	Returns the object associated with the label specified from
%	the object buffer (buf).  If the label doesn't exist then
%	an empty object is returned.  
%	
%	If the label is left unspecified then all labels present in the
%	object buffer are displayed with the sizes of their associated
%	objects.
% 
%	getObject and putObject alleviate the need for pointer in Matlab.
% 
% Rick Anthony
% 4/23/94


bufLength 	= size(buf,2);


if(nargin < 2)
    if(bufLength == 0)
        labelAreaLen = 0;
    else
        labelAreaLen = buf(1);
    end    

    i = 3;
        fprintf('%25s\t%12s\t\t%9s\n\n', ...
                'Name', 'Size', 'String');

    while(i <= labelAreaLen)

        j = i;
        while((buf(j) ~= 0) & (buf(j) ~= 1))
            j = j + 1;
        end

        label = setstr(buf(i:j-1));
        objectRows = buf(j+2);
        objectCols = buf(j+3);
        objectLength = objectRows * objectCols;

        if(buf(j))
            fprintf(1,'%25s\t%8d by %-8d\t%8s\n', ...
                       label, objectRows, objectCols, 'Yes');
        else
            fprintf(1,'%25s\t%8d by %-8d\t%8s\n', ...
                       label, objectRows, objectCols, 'No');
        end

        i = j+5;
    end

    return
end


if(bufLength == 0)
    object = [];
    return;
end


labelLength 	= size(label,2);
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
        objectString 	= labelArea(propIndex);
        objectNumber 	= labelArea(propIndex+1);
        objectRows 	= labelArea(propIndex+2);
        objectCols 	= labelArea(propIndex+3);
        objectLength 	= objectRows * objectCols;
        datumIndex	= indexArea(objectNumber);

        object = datumArea(datumIndex:datumIndex+objectLength-1);
        object = reshape(object, objectRows, objectCols);

        if(objectString)
            object = setstr(object);
        end
    end
end  
