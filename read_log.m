%********************************************************************
% A structure-based Seaglider log reader.
% Returns the structure 'loginfo' with elements names identical to
% the tags in the log file with the following modifications:
% - The leading '$' has been removed.
% - Tags beginning with characters not in [a-zA-Z] 
%   (e.g. '_' and numbers) have a leading character appended.
% Thus, if pad_char = 'a': $DIVE -> loginfo.DIVE, 
% $24V_AH -> loginfo.a24_AH and $_SM_ANGLEo -> loginfo.a_SM_ANGLEo
% Most structure elements will be single values or vectors.
% The exceptions are those listed in 'multi_tags'. These are tags that
% have multple instances in the log file ($GC is the orginal example).
% The elements associated with these tags will be cell arrays. Thus,
% loginfo.GC{i} = <vector of GC values for the ith occurance of the 
% $GC tag in the logfile.
% Some sample output...
% loginfo.KALMAN_Y: [1.0386e+004 796.6000 -625.3000 -1.7215e+004 999.6000]
% loginfo.MHEAD_RNG_PITCHd_Wd: [179 186617 -13.6000 -9.9800]
% loginfo.D_GRID: 2031
% loginfo.T_DIVE2: 167
% loginfo.GC: {1x40 cell}
% loginfo.GC{2}: [54.0000 -1.0600 -146.1000 ... 0.1840 0.1050]
% loginfo.HUMID: 1834
% loginfo.a24V_AH: [23.7000 5.4850]
%
% cml 14 April 2004

function loginfo = read_log (log_file)

% Character for padding troublesome tag names.

pad_char = 'a';

% A cell array of tag names that can occur more than once in a log file.

multi_tags = {'GC', 'RAFOS'};
exception_tags = {'TGT_NAME', 'GCHEAD', 'DEVICES', 'SENSORS'};
exception_fmts = {'%s', '%s', '%s', '%s'};

%*** Need to work in parsing for lat/lon locations.

%---------------------------------------------------------------
% Bookeeping for multi-lne tags. 
% 'mc_count' will be used to index instances.

n_mc = length(multi_tags);
mc_count = zeros(n_mc,1);

% Open the log file.

fp = fopen(log_file, 'r');
if fp == -1
   loginfo = struct([]);
   return
end

line = fgetl(fp);
if strncmp(line, 'version:', 8) == 1
   fclose(fp);
   [hdr, fp] = read_header(log_file);	% read_header opens the file and returns the gently used file pointer
   if isfield(hdr, 'start')
      loginfo.month = hdr.start(1);
      loginfo.date = hdr.start(2);
      loginfo.year = hdr.start(3);
      loginfo.hour = hdr.start(4);
      loginfo.minute = hdr.start(5);
      loginfo.second = hdr.start(6);
   end
else
   tmp = sscanf(line, '%2d %2d %3d %2d %2d %2d');

   if length(tmp) == 6 & tmp(1) > 0 & tmp(1) <= 12 & tmp(2) > 0 & tmp(2) <= 31
        loginfo.month = tmp(1);
        loginfo.date = tmp(2);
        loginfo.year = 1900 + tmp(3);
        loginfo.hour = tmp(4);
        loginfo.minute = tmp(5);
        loginfo.second = tmp(6);
   end
end

% Assumes that log files begin with a 6-integer time stamp of the
% form: mm dd yyy (+1900) hh mm ss (UTC). 
% Read and assign the time stamp.

tag = 0;
while (tag ~= -1)
  
  
  line = fgetl(fp);
   
  if line == -1
     break;
  end

  % if no leading $ then this is probably the date line

  if line(1) ~= '$'

     continue;
  end

  % Strip the leading '$'.

  [tag, remainder] = strtok(strtok(line, '$'), ',');
  
  % Read the values associated with the tag. 
  
  ii = 0;
  values = [];
  while (~isempty(remainder))
    [tmp, remainder] = strtok(remainder, ',');
    ii = ii + 1;
    jj = strmatch(tag, exception_tags, 'exact');
    if isempty(jj)
       scan = sscanf(tmp, '%f');
       if ~isempty(scan)
          values(ii) = scan;
       end
    else
       values{ii} = sscanf(tmp, char(exception_fmts{jj}));
    end

  end
  if (tag ~= -1)
    
    % If the tag begins with something other than a letter, pad
    % the name with 'pad_char' before defining the structure element.
    % MATLAB variables must begin with [a-zA-Z].
    
    if isempty(regexp(tag(1), '[a-zA-Z]'))
      tag = [pad_char tag];
    end

    % Is the tag on the multi-line tag list?
    
    jj = strmatch(tag, multi_tags, 'exact');
    if isempty(jj)
      eval (['loginfo.' tag ' = values;']);
    else
      % Special case where there may be multiple lines of the same
      % tag (e.g. $GC)...     
      mc_count(jj) = mc_count(jj) + 1;
%      eval (['loginfo.' tag '{' num2str(mc_count(jj)) '} = values;']);
      if mc_count(jj) == 1
         eval (['loginfo.' tag '(' num2str(mc_count(jj)) ',:) = values;']);
      else
         base_cols = length( eval (['loginfo.' tag '(1,:);']) );
         cols = length(values);
         if cols == base_cols
            eval (['loginfo.' tag '(' num2str(mc_count(jj)) ',:) = values;']);
         end
      end
    end
    
  end
end

fclose(fp);

%**********************************************************************
% some useful derived quantities here -- make sure to protect with isfield

if isfield(loginfo, 'GPS1')
   degrees = fix(loginfo.GPS1(2)/100);
   minutes = rem(loginfo.GPS1(2), 100);
   loginfo.GPS1_lat = degrees + minutes / 60.0;

   degrees = fix(loginfo.GPS1(3)/100);
   minutes = rem(loginfo.GPS1(3), 100);
   loginfo.GPS1_lon = degrees + minutes / 60.0;
end

if isfield(loginfo, 'GPS2')
   degrees = fix(loginfo.GPS2(2)/100);
   minutes = rem(loginfo.GPS2(2), 100);
   loginfo.GPS2_lat = degrees + minutes / 60.0;

   degrees = fix(loginfo.GPS2(3)/100);
   minutes = rem(loginfo.GPS2(3), 100);
   loginfo.GPS2_lon = degrees + minutes / 60.0;
end

if isfield(loginfo, 'GPS')
   degrees = fix(loginfo.GPS(3)/100);
   minutes = rem(loginfo.GPS(3), 100);
   loginfo.GPS_lat = degrees + minutes / 60.0;

   degrees = fix(loginfo.GPS(4)/100);
   minutes = rem(loginfo.GPS(4), 100);
   loginfo.GPS_lon = degrees + minutes / 60.0;
end
