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


function [UP, DWN, out_header] = sg_dive_grid(dive_rng, z_grid,path,varargin)

oldpath = cd;
cd(path);
addpath(oldpath);

z_grid = squeeze(z_grid);

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
        'optode_dphase_oxygenc','chl_bb2fl','bb700','bb470','bb600',...
        'chl_bbfl2','cdom'};
end

ndata = length(data_header);

% position/dimension columns (always included)
pos_header = {'lon','lat','xpos','ypos','z','ser_date','divenum'};
npos = length(pos_header);

out_header = [pos_header data_header];

UP = [];%zeros(length(dive_rng).*length(z_grid),npos+ndata);
DWN = UP;


for ii = dive_rng+1
    
    try
    % start_ser_date is a serial date in the form of days since 1-jan-0000
    % which represents the start time of the dive
    ser_date = datenum(loginfo.year,loginfo.month,loginfo.date,loginfo.hour,loginfo.minute,loginfo.second+vmtime); 
    dv = datevec(ser_date);
    % decimal time (e.g. 2010.1234)
    %dectime = dec_year(ser_date);
    
    [~,botind] = min(zpos);
    idwn = 1:botind;
	iup = botind:length(vmtime);
    
    % remove bad (NaN) values...
    iup(find(isnan(sigmath0))-botind + 1) = [];
    
    % utm x coordinate at start of dive
    % GPS2 is fix immediately before diving 
    startlon = loginfo.GPS2_lon;
    startlat = loginfo.GPS2_lat;
    divefract = vmtime./vmtime(end);
    
    zd = vmdepth;
    epsz = rand(length(zd),1).*1e-7;
    
    % intitialize dive data arrays
    dwn = zeros(length(z_grid),npos+ndata);
    up = dwn;
    dwn(:,5) = z_grid;
    dwn(:,7) = divenum;
    up(:,5) = z_grid;
    up(:,7) = divenum;
    
    %linearly interpolate data columns to z_grid (must have at least 10
    %data points for descent and ascent
    for jj = 1:ndata
        datacol = eval(data_header{jj});
        if length(find(~isnan(datacol(idwn)))) > 10
            dwn(:,jj+npos) = naninterp1(zd(idwn)+epsz(idwn), datacol(idwn), z_grid);
        else
            dwn(:,jj+npos) = NaN.*z_grid;
        end
        if length(find(~isnan(datacol(iup)))) > 10
            up(:,jj+npos) = naninterp1(zd(iup)+epsz(iup), datacol(iup), z_grid);
        else
            up(:,jj+npos) = NaN.*z_grid;
        end
    end

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
    
    if length(find(~isnan(lonpos(idwn)))) > 10
        dwn(:,1) = naninterp1(zd(idwn)+epsz(idwn),lonpos(idwn),z_grid);
        dwn(:,2) = naninterp1(zd(idwn)+epsz(idwn),latpos(idwn),z_grid);
        dwn(:,3) = naninterp1(zd(idwn)+epsz(idwn),xpos(idwn),z_grid);
        dwn(:,4) = naninterp1(zd(idwn)+epsz(idwn),ypos(idwn),z_grid);
        dwn(:,6) = naninterp1(zd(idwn)+epsz(idwn),ser_date(idwn),z_grid);
    else
        dwn(:,1:4) = NaN;
    end
    
    if length(find(~isnan(lonpos(iup)))) > 10
        up(:,1) = naninterp1(zd(iup)+epsz(iup),lonpos(iup),z_grid);
        up(:,2) = naninterp1(zd(iup)+epsz(iup),latpos(iup),z_grid);
        up(:,3) = naninterp1(zd(iup)+epsz(iup),xpos(iup),z_grid);
        up(:,4) = naninterp1(zd(iup)+epsz(iup),ypos(iup),z_grid);
        up(:,6) = naninterp1(zd(iup)+epsz(iup),ser_date(iup),z_grid);
    else
        up(:,1:6) = NaN;
    end
        

    
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
end

cd(oldpath);
end

function [out] = naninterp1(x, y, xi)
    out = interp1(x(~isnan(y)),y(~isnan(y)),xi);
end