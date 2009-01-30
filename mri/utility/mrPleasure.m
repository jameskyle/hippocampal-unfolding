function mrPleasure(giveReportFlag, Ndays)
%function mrPleasure([giveReportFlag], [Ndays])
%
% Add an entry to the database of who helped who,
% or print out a report of pleasure-unit statistics.
%
% mrPleasure(0) prompts user for new entry.
%    (The database file mrPleasureDB is re-read and updated
%    just before termination, to minimize update conflicts.)
% mrPleasure(1) prints net helper-helpee stats.
% mrPleasure(2) prints entire database for last 30 days.
%    mrPleasure(2, Ndays) does the same for the last Ndays days.
% mrPleasure(3) prints total scanning sessions (as helper or helpee) plus
%    total psychophysics sessions (as helper only) during the last 30 days.
%    mrPleasure(3, Ndays) does the same for the last Ndays days.
%
% mrPleasure without an argument gives a menu of options.
%
% Typing "q" at any prompt quits mrPleasure without changing the database.
%
% By convention, it is the HELPER who adds an entry to mrPleasure's database.
% Should we change this to the helpee?  Maybe that's better, since the helpee
% typically does all the other bookkeeping for a given scan session.
% 
% To delete the last entry (e.g. if erroneous):
%   cd /usr/local/matlab/toolbox/mri/utility
%   load mrPleasureDB
%   pdb.records(size(pdb.records, 1), :) = [];
%   save mrPleasureDB pdb 
% (If you need to do this more than once, tell Ben and I'll make mrPleasure(-1)).
%
% Y2K compliant through the year 2095. 2/4/95 is in 2095, but 2/4/96 is in 1996.
% Dates can be entered as 4/30/99 or 4/30/1999, and as 4/30/00 or 4/30/2000.
%
% 3/2/99, 3/11/99 Ben Backus

% mrPleasureDB holds the structure pdb, with fields:
%  .names      cell array of lowercase names
%  .records  Nx5 array, one line per record, with columns:
%     1 helpee   (index into pdb.names)
%     2 helper   (index into pdb.names)
%     3 date     (matlab numeric format)
%     4 helpType (See helpStrings below for numeric codes, also disp statements)
%     5 date of record entry (matlab numeric format)

% Find mrPleasureDB.mat's pathname on current computer
switch computer
case 'HP700'
   dbFileName = '/usr/local/matlab/toolbox/mri/utility/mrPleasureDB';
case 'LNX86'
   dbFileName = '/usr/local/matlab/toolbox/mri/utility/mrPleasureDB';
case 'PCWIN'
   dbFileName = 'Y:/mri/utility/mrPleasureDB';
otherwise
   error([computer ' is not known computer type']);
end

% Load database
load(dbFileName);      

% Here are the types of help coded in 4th column of helpType
helpStrings = {'scan subject'; 'operator'; 'psychophysics subject'; 'other'};
PSYCHOPHYSICS = 3;  % macro

% mrPleasure without arguments is the same as mrPleasure(0)
if ~exist('giveReportFlag', 'var')
   s = '';
   while isempty(s)
      disp(' ');
      disp('mrPleasure options (see also ''help mrPleasure''):');
      disp(' ');
      disp('  0  Add a helping event');
      disp('  1  Print out net helper-helpee stats');
      disp('  2  Print out entire database (last 30 days)');
      disp('  3  Recent helper/helpee activity (last 30 days)');
      disp('  q  Quit');
      disp(' ');
      s = input('Your choice? ', 's');
      if s
         if lower(s(1)) == 'q'
            return
         end
      end
      sNum = round(str2num(s(1)));
      if ~isempty(sNum)       % s contained a number
         if sNum >= 0 & sNum <= 3
            giveReportFlag = sNum;
         else
            s = '';
         end
      else
         s = '';
      end
   end
end
disp(' ');
   
switch giveReportFlag
   
case 0,    %%%%%%%%%%%%% Add an entry to the database  %%%%%%%%%%%%%%%%%%%%
   % Get helper's name
   okHelper = 0;
   while ~okHelper
      helper = '';
      while isempty(helper)
         helper = input('Who had the pleasure of GIVING help? ', 's');
      end
      helper = lower(helper);
      if helper(1) == 'q'
         return
      end
      nameCheck = strcmp(helper, pdb.names);
      if any(nameCheck)
         okHelper = 1;
         newHelperFlag = 0;
      else
         disp('Names in the datebase are:');
         disp(pdb.names);
         s = input([helper ' is not in the database.  Add ' helper ' (y/n)? '], 's');
         if lower(s(1)) == 'y'
            newHelperFlag = 1;
            okHelper = 1;
         elseif lower(s(1)) == 'n'
            disp('OK.');
         elseif lower(s(1)) == 'q'
            return
         end
      end
   end
   
   % Get helpee's name
   okHelpee = 0;
   while ~okHelpee
      helpee = '';
      while isempty(helpee)
         helpee = input('Who had the pleasure of RECEIVING help? ', 's');
      end
      helpee = lower(helpee);
      if helpee(1) == 'q'
         return
      end
      if strcmp(helper, helpee)
         disp('God helps those that help themselves.');
         return
      end
      nameCheck = strcmp(helpee, pdb.names);
      if any(nameCheck)
         okHelpee = 1;
         newHelpeeFlag = 0;
      else
         disp('Names in the datebase are:');
         disp(pdb.names);
         s = input([helpee ' is not in the database.  Add ' helpee ' (y/n)? '], 's');
         if lower(s(1)) == 'y'
            newHelpeeFlag = 1;
            okHelpee = 1;
         elseif lower(s(1)) == 'n'
            disp('OK.');
         elseif lower(s(1)) == 'q'
            return
         end
      end
   end
   
   % Get date of help
   okDate = 0;
   while ~okDate
      dateStr = '';
      while isempty(dateStr)
         dateStr = input('On what day did this help occur (e.g. 4/30/99)? ', 's');
         if lower(dateStr(1)) == 'q'
            return
         end
         dateVec = sscanf(dateStr, '%d/%d/%d');
         if size(dateVec,1) ~= 3
            disp('Please note form of date, mm/dd/yy.  Y2K: Year 00 is 2000.');
            dateStr = '';
         end
      end
      month = dateVec(1);
      day = dateVec(2);
      year = dateVec(3);
      dateVecToday = datevec(now);
      if year < 100  % Date was given as 2-digit date
         if year > 95                % Y2K compliant...but will fail in 2096.
            year = year + 1900;
            if dateVecToday(1) > 2095  % You never know...
               error('This code turns years greater than 95 into 1900''s, not 2000''s.');
            end
         else
            year = year + 2000;
         end
      end
      dateNum = datenum(year, month, day);
      
      % Check that dateNum is reasonable
      dateNumToday = datenum(dateVecToday(1), dateVecToday(2), dateVecToday(3));
      if (dateNum > dateNumToday) | (dateNum < dateNumToday - 60)
         s = input(['Is ' datestr(dateNum,1) ' really correct (y/n)? '], 's');
         if lower(s(1)) == 'y'
            okDate = 1;
         elseif lower(s(1)) == 'n'
            disp('OK.');
         elseif lower(s(1)) == 'q'
            return
         end
      else
         okDate = 1;
      end
   end
         
   % Get description of help
   okHelpType = 0;
   while ~okHelpType
      disp('Kinds of help are:');               % Remember to modify helpStrings too, if changed
      disp('  1 being scanned as a subject');
      disp('  2 operating scanner');
      disp('  3 collecting psychophysical data');
      disp('  4 other');
      s = '';
      while isempty(s)
         s = input('What kind of help did the helper give? ', 's');
      end
      if lower(s(1)) == 'q'
         return
      end      
      helpType = str2num(s);
      helpType = round(helpType);
      if helpType >= 1 & helpType <= 4
         okHelpType = 1;
      else
         disp('You''ll have to modify mrPleasure.m if you want that kind of help.');
      end
   end
   
   % Load, modify, and resave database in one fell swoop
   load(dbFileName);
   nName = size(pdb.names,1);
   if newHelperFlag
      pdb.names{nName + 1} = helper;   % Add temporarily in case used again
      nName = nName+1;
   end
   if newHelpeeFlag
     pdb.names{nName + 1} = helpee;   % Add temporarily in case used again
   end
   nRecord = size(pdb.records,1);
   helperNum = find(strcmp(helper, pdb.names));
   helpeeNum = find(strcmp(helpee, pdb.names));
   pdb.records(nRecord + 1,:) = [helperNum helpeeNum dateNum helpType dateNumToday];
   
   save(dbFileName, 'pdb');
   
   disp('New record has been added:');
   disp([pdb.names{helperNum} ' helped ' pdb.names{helpeeNum} ' on ' ...
         datestr(dateNum,2) ' as a(n) ' helpStrings{helpType} '.']);
   disp(' ');
   disp('Thank you, it''s been a pleasure.');
   
case 1,  %%%%%%%%%%%%%%%% Print out summary stats %%%%%%%%%%%%%%%%%%%%%
   disp('Net pleasure units:');
   disp(' ');
   nName = size(pdb.names,1);
   [sortNames, sortIndex] = sortrows(pdb.names);  % alphabetize
%   pleasureInfo.names = cell(nName, 1);
%   pleasureInfo.netHelp = zeros(nName, 1);
%   iCount = 0;
   for iName = sortIndex' % do loop in alphabetical order
      nHelper = sum(pdb.records(:,1) == iName);
      nHelpee = sum(pdb.records(:,2) == iName);
      netHelp = nHelper - nHelpee;
      disp([sprintf('%12s', pdb.names{iName}) ': ' sprintf('%4d', netHelp)]);  
%      iCount = iCount+1;
%      pleasureInfo.names{iCount} = pdb.names{iName};    % use if output is desired
%      pleasureInfo.netHelp(iCount) = netHelp;
   end
   
case 2,  %%%%%%%%%%%%%%%%% Print out entire database  %%%%%%%%%%%%%%
   dateVecToday = datevec(now);
   dateNumToday = datenum(dateVecToday(1), dateVecToday(2), dateVecToday(3));
   if ~exist('Ndays', 'var')
      Ndays = 30;
   end
   recentRecords = pdb.records(pdb.records(:,3) >= dateNumToday-Ndays & ...
                               pdb.records(:,3) <= dateNumToday, :);
   [junk, sortDateIndex] = sort(recentRecords(:,3));
   disp([sprintf('%12s', 'HELPER') ...
         sprintf('%12s', 'HELPED') ...
         '     DATE    '  ...
         '    HOW']);
   for iRec = sortDateIndex'
      record = recentRecords(iRec,:);
      disp([sprintf('%10s', pdb.names{record(1)}) ...
            sprintf('%12s    ', pdb.names{record(2)}) ...
            datestr(record(3),2) '    ' ...
            helpStrings{record(4)}]);
   end
%   pleasureInfo = pdb;  % Use if output is desired

case 3, %%%%%%%%%%%%%%% Print out recent activity (last 30 days) %%%%%%%%%%%%%%%%%
   dateVecToday = datevec(now);
   dateNumToday = datenum(dateVecToday(1), dateVecToday(2), dateVecToday(3));
   if ~exist('Ndays', 'var')
      Ndays = 30;
   end
   recentRecords = pdb.records(pdb.records(:,3) >= dateNumToday-Ndays & ...
                               pdb.records(:,3) <= dateNumToday, :);
   nName = size(pdb.names,1);
   [sortNames, sortIndex] = sortrows(pdb.names);  % alphabetize
   
   disp('Total scanning events + psychophysics helping events');
   disp(['in the last ' num2str(Ndays) ' days:']);
   disp(' ');
   for iName = sortIndex' % do loop in alphabetical order
      nHelper = sum(recentRecords(:,1) == iName);
      nHelpee = sum(recentRecords(:,2) == iName);
      nHelpeePsychoPhys = sum(recentRecords(:,2) == iName & ...
                              recentRecords(:,4) == PSYCHOPHYSICS);
      total = nHelper + nHelpee - nHelpeePsychoPhys;
      disp([sprintf('%12s', pdb.names{iName}) ': ' sprintf('%4d', total)]);  
   end
otherwise,
   error(['I don''t know what to do with your argument of ' num2str(giveReportFlag)]);
end
