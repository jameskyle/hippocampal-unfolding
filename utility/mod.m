function m = mod(a,n)
%
%  Modulus operator.  
%  Works on matrics, vectors or scalars.

%disp('This function is different from the internal MATLAB mod function.')
%disp('Send mail to peter@kaos.stanford.edu if you plan to use this function in the future')
%disp('Do you still wanna continue? Press any key')
%pause

m = a - n .* fix(a./n);
return;

