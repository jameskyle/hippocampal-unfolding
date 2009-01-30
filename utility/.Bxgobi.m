function xgobi(data,color,mark)
%
%  xgobi(data,color,mark)
%
%  Calls unix xgobi program with the data points in data.
%  data  - Every row in data is a point in xgobi.
%  color - You may specify a color vector (having the same 
%       number of rows as data). Every entry in color is a character
%       from the set allowed in plot ('w' 'b' 'g' 'r' 'c' 'm' 'y' 'k')
%  mark  - You may specify a mark vector (having the same 
%       number of rows as data). Every entry in mark is a character
%       from the set allowed in plot ('.' 'o' 'x' '+' '*')
%
% Hagit (gigi) Hel-Or
% Last Modified: 5/7/96
%

% xgobi reads the coordinate data from the file xxx.dat
% xgobi reads the color data from the file xxx.colors
% xgobi reads the mark data from the file xxx.glyphs
% There is a problem in that xgobi gives warning comments if
%   the colors are not loaded as brush colors. So, create a 
%   resources file called xxx.resources that have the brushcolors.
% For more info read     man xgobi
% Comment aboutthe marks: There are various sizes to choose from 
%   I chose the mark sizes to be readable and distinguishable.
%   If they are inadequate they can be easily be changed. read man pages.


if (nargin >1)
   if (size(color,1) ~= size(data,1))
       error('Number of rows in data and color must be the same');
   end;
   disp('Loading color data - will take time!!!');

   % default color is 'w'
   colorlabel = ones(size(color,1),1) * abs('white  ');
   indx = find(color=='b');
   colorlabel(indx,:) = ones(size(indx,1),1) * 'blue   ';
   indx = find(color=='g');
   colorlabel(indx,:) = ones(size(indx,1),1) * 'green  ';
   indx = find(color=='r');
   colorlabel(indx,:) = ones(size(indx,1),1) * 'red    ';
   indx = find(color=='c');
   colorlabel(indx,:) = ones(size(indx,1),1) * 'cyan   ';
   indx = find(color=='m');
   colorlabel(indx,:) = ones(size(indx,1),1) * 'magenta';
   indx = find(color=='y');
   colorlabel(indx,:) = ones(size(indx,1),1) * 'yellow ';
   indx = find(color=='k');
   colorlabel(indx,:) = ones(size(indx,1),1) * 'black  ';

   fid = fopen('xgobi.colors','w');
   for(i=1:size(color,1))
      fprintf(fid,'%s\n',colorlabel(i,:));
   end;
   fclose(fid);

   % create the following resource file just so that xgobi wont yell....
   fid = fopen('xgobi.resources','w');
   fprintf(fid,'*brushColor0: white\n');
   fprintf(fid,'*brushColor1: blue\n');
   fprintf(fid,'*brushColor2: green\n');
   fprintf(fid,'*brushColor3: red\n');
   fprintf(fid,'*brushColor4: cyan\n');
   fprintf(fid,'*brushColor5: magenta\n');
   fprintf(fid,'*brushColor6: yellow\n');
   fprintf(fid,'*brushColor7: black\n');
   fprintf(fid,'*XGobi*PlotWindow.background: light grey\n');
   fclose(fid); 
end; 
 
if (nargin > 2)
   if (size(mark,1) ~= size(data,1))
       error('Number of rows in data and mark must be the same');
   end;
   disp('Loading mark data - will take time!!!');

   % default mark is '.'
   marklabel = 31 .* ones(size(mark,1),1);
   indx = find(mark=='o');
   marklabel(indx) = ones(size(indx,1),1) * 22;
   indx = find(mark=='x');
   marklabel(indx) = ones(size(indx,1),1) * 8;
   indx = find(mark=='+');
   marklabel(indx) = ones(size(indx,1),1) * 3;
   indx = find(mark=='*');
   marklabel(indx) = ones(size(indx,1),1) * 27; 

   fid = fopen('xgobi.glyphs','w');
   for(i=1:size(mark,1))
      fprintf(fid,'%d\n',marklabel(i,:));
   end;
   fclose(fid);
end;


save -ascii xgobi.dat data
unix('xgobi xgobi');
unix('rm xgobi.*');
