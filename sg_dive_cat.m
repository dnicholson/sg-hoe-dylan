% SG_DIVE_GRID
% -------------------------------------------------------------------------
% Outputs depth-gridded results concatenated across a range of seaglider
% dives.  All fields are linearly interpolated to z_grid and require at
% least 10 datapoints to process
%
% INPUTS
% -------------------------------------------------------------------------
% dive_rng:     vector of dives to output
% z_grid:       depth grid to interpolate to
% header:       str array of variable names to output (optional)
%
% OUTPUTS
% -------------------------------------------------------------------------
% UP:           output for ascending data
% DWN:          output for descending data
% out_header:   column headers
%
% USAGE
% -------------------------------------------------------------------------
% [UP DWN header] = sg_dive_grid(1:100,1:2:200)
% gets dives 1:100 gridded at 2m resolution
%
% [UP DWN header] = sg_dive_grid(1:5:100,1:200,{'tempc','salin','fluor'})
% gets data from every fifth dive for upper 100 m only for variables listed
%
% -------------------------------------------------------------------------
% Author David Nicholson -- dnicholson@whoi.edu -- Version 01 NOV 2012
% -------------------------------------------------------------------------


function [UP DWN all_header] = sg_dive_cat(dive_rng,path,varargin)

oldpath = cd;
cd(path);
addpath(oldpath);


if length(dive_rng) == 2
    dive_rng = dive_rng(1):dive_rng(2);
end


% This loop concatenates data from the dives specified by FIRST and LAST
% into two large matrices:  DWN contains all data from descents and UP
% contains all data from ascents
divenum = dive_rng(1);
divesum;
% variables to output - must match variable names from divesum.m

if nargin > 3
    data_header = varargin{1};
else
    data_header = {'vmtime','press','sigmath0','salin','tempc','oxygen',...
        'optode_dphase_oxygenc','fluor','red_ref','red_scttr','blue_ref',...
        'blue_scttr','wl600_ref','wl600_sig','chl_ref','chl_sig',...
        'cdom_ref','cdom_sig'};
end


% position/dimension columns (always included)
core_header = {'lon','lat','xpos','ypos','z','daten','divenum'};
nCoreFields = length(core_header);
all_header = cat(2,core_header,data_header);
nDataFields = length(data_header);

UP = [];%zeros(length(dive_rng).*length(z_grid),npos+ndata);
DWN = UP;

for ii = dive_rng+1
    try
        disp(num2str(divenum));
        % start_ser_date is a serial date in the form of days since 1-jan-0000
        % which represents the start time of the dive
        
        daten = datenum(loginfo.year,loginfo.month,loginfo.date,loginfo.hour,loginfo.minute,loginfo.second+vmtime);
        %dv = datevec(ser_date);
        % decimal time (e.g. 2010.1234)
        %dectime = dec_year(ser_date);
        
        [~,botind] = min(zpos);
        idwn = 1:botind;
        iup = botind:length(vmtime);
        
        % remove bad (NaN) values...
        %iup(find(isnan(sigmath0))-botind + 1) = [];
        dwn = NaN(length(idwn),nDataFields+nCoreFields);
        up = NaN(length(iup),nDataFields+nCoreFields);
        % utm x coordinate at start of dive
        % GPS2 is fix immediately before diving
        startlon = loginfo.GPS2_lon;
        startlat = loginfo.GPS2_lat;
        divefract = vmtime./vmtime(end);
        
        zd = vmdepth;
        %epsz = rand(length(zd),1).*1e-7;
        
        %     % intitialize dive data arrays
        %     dwn = zeros(length(z_grid),npos+nfields);
        %     up = dwn;
        %     dwn(:,5) = z_grid;
        %     dwn(:,7) = divenum;
        %     up(:,5) = z_grid;
        %     up(:,7) = divenum;
        %
        %linearly interpolate data columns to z_grid (must have at least 10
        %data points for descent and ascent
        %         for jj = 1:nDataFields
        %             datacol = eval(data_header{jj});
        %             if length(datacol) == length(vmdepth)
        %                 dwn(:,jj+nCoreFields) = datacol(idwn);
        %                 up(:,jj+nCoreFields) = datacol(iup);
        %             else
        %                 dwn(:,jj+nCoreFields) = NaN;
        %                 up(:,jj+nCoreFields) = NaN;
        %                 disp(['divenum ' num2str(divenum) 'field ' data_header{jj} ' failed']);
        %             end
        %         end
        for jj = 1:nDataFields
            datacol = eval(data_header{jj});
            dwn(:,jj+nCoreFields) = datacol(idwn);
            up(:,jj+nCoreFields) = datacol(iup);
        end
        
        up(:,7) = divenum;
        dwn(:,7) = divenum;
        %
        % In order to calculate position during previous dive, the gps from the
        % next dive surface must be accessed
        %
        
        divenum = ii;
        try
            divesum;
        catch
            continue
        end
        %The end gps fix comes from the next dive file
        % GPS1 is fix immediately after surfacing
        endlon = loginfo.GPS1_lon;
        endlat = loginfo.GPS1_lat;
        
        lonpos = startlon + (endlon - startlon).*divefract;
        latpos = startlat + (endlat - startlat).*divefract;
        [xpos, ypos] = utm_hot(lonpos,latpos);
        
        
        dwn(:,1) = lonpos(idwn);
        dwn(:,2) = latpos(idwn);
        dwn(:,3) = xpos(idwn);
        dwn(:,4) = ypos(idwn);
        dwn(:,5) = zd(idwn);
        dwn(:,6) = daten(idwn);
        
        up(:,1) = lonpos(iup);
        up(:,2) = latpos(iup);
        up(:,3) = xpos(iup);
        up(:,4) = ypos(iup);
        up(:,5) = zd(iup);
        up(:,6) = daten(iup);
        
        UP = cat(1,UP,up);
        DWN = cat(1,DWN,dwn);
    catch err
        warning('error on dive %d. Dive not processed',divenum);
        % rethrow(err);
        divenum = ii;
        try
            divesum;
        catch
            continue
        end
        continue
    end
    fclose('all');
end


cd(oldpath);
end
