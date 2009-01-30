% mrShiftImage(oldIm,imSize,sh)
%
%	Shifts image

function newIm = mrShiftImage(oldIm,imSize,sh)

% Variable Declarations
indx = 0;	%
i = 0;		% counter

newIm = reshape(oldIm,imSize(1),imSize(2));
if(abs(sh(1)) > 0)
   indx = [(abs(sh(1))+1):imSize(2),1:(abs(sh(1)))];
   for i = 1:imSize(1)
      if(sh(1) < 0)
        newIm(i,1:(imSize(2))) = newIm(i,indx);
      else
        newIm(i,indx) = newIm(i,1:(imSize(2)));
      end
   end
end
if(abs(sh(2)) > 0)
   for i = 1:imSize(2)
      indx = [(abs(sh(2))+1):imSize(1),1:(abs(sh(2)))];
      if(sh(2) < 0)
         newIm(1:(imSize(1)),i) = newIm(indx,i);
      else
         newIm(indx,i) = newIm(1:(imSize(1)),i);
      end
   end
end
newIm = reshape(newIm,1,prod(imSize));


