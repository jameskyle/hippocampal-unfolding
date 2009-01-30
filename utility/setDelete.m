% setDelete.m
%
%  AUTHOR:  Heidi Baseler
%    DATE:  2/6/97
% PURPOSE:  Run this script to set up the ability to delete with
%           the Backspace key in your matlab environment
%           (Often a problem on some HP machines such as khaki)

unix('xmodmap -e "keysym BackSpace = Delete"');


