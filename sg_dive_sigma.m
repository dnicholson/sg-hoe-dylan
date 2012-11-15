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


function [UP DWN out_header] = sg_dive_sigma(dive_rng, sig_grid,path,varargin)

oldpath = cd;
cd(path);
addpath(oldpath);

sig_grid = squeeze(sig_grid);

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

ndata = length(data_header);

% position/dimension columns (always included)
pos_header = {'lon','lat','xpos','ypos','z','dectime','divenum'};
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
    
    sd = sigmath0;
    %vt = vmtime;
    vz = vmdepth;
    epsz = rand(length(sd),1).*1e-7;
    
    % intitialize dive data arrays
    dwn = zeros(length(sig_grid),npos+ndata);
    up = dwn;
    %dwn(:,5) = sig_grid;
    dwn(:,7) = divenum;
    %up(:,5) = sig_grid;
    up(:,7) = divenum;
    
    %linearly interpolate data columns to z_grid (must have at least 10
    %data points for descent and ascent
    for jj = 1:ndata
        datacol = eval(data_header{jj});
        if length(find(~isnan(datacol(idwn)))) > 10
            dwn(:,jj+npos) = naninterp1(sd(idwn)+epsz(idwn), datacol(idwn), sig_grid);
        else
            dwn(:,jj+npos) = NaN.*sig_grid;
        end
        if length(find(~isnan(datacol(iup)))) > 10
            up(:,jj+npos) = naninterp1(sd(iup)+epsz(iup), datacol(iup), sig_grid);
        else
            up(:,jj+npos) = NaN.*sig_grid;
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
    dectime = dec_year(ser_date);
    
    if length(find(~isnan(lonpos(idwn)))) > 10
        dwn(:,1) = naninterp1(sd(idwn)+epsz(idwn),lonpos(idwn),sig_grid);
        dwn(:,2) = naninterp1(sd(idwn)+epsz(idwn),latpos(idwn),sig_grid);
        dwn(:,3) = naninterp1(sd(idwn)+epsz(idwn),xpos(idwn),sig_grid);
        dwn(:,4) = naninterp1(sd(idwn)+epsz(idwn),ypos(idwn),sig_grid);
        dwn(:,5) = naninterp1(sd(idwn)+epsz(idwn),vz(idwn),sig_grid);
        dwn(:,6) = naninterp1(sd(idwn)+epsz(idwn),dectime(idwn),sig_grid);
    else
        dwn(:,1:4) = NaN;
    end
    
    if length(find(~isnan(lonpos(iup)))) > 10
        up(:,1) = naninterp1(sd(iup)+epsz(iup),lonpos(iup),sig_grid);
        up(:,2) = naninterp1(sd(iup)+epsz(iup),latpos(iup),sig_grid);
        up(:,3) = naninterp1(sd(iup)+epsz(iup),xpos(iup),sig_grid);
        up(:,4) = naninterp1(sd(iup)+epsz(iup),ypos(iup),sig_grid);
        up(:,5) = naninterp1(sd(iup)+epsz(iup),vz(iup),sig_grid);
        up(:,6) = naninterp1(sd(iup)+epsz(iup),dectime(iup),sig_grid);
    else
        up(:,1:6) = NaN;
    end
        

    
    UP = cat(1,UP,up);
    DWN = cat(1,DWN,dwn);

    catch err
       warning('error on dive %d. Dive not processed',divenum);
       %rethrow(err);
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