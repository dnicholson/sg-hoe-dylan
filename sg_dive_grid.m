function [UP DWN data_header] = sg_dive_grid(dive_rng, z_grid,path)

oldpath = cd;
cd(path);
addpath(oldpath);

z_grid = squeeze(z_grid);

if length(dive_rng) == 2
    dive_rng = dive_rng(1):dive_rng(2);
elseif length(dive_rng) < 2
    error('dive_rng must have length >= 2');
end
% SLOPE = 0.96543;
% BLANK = 2.1026;
% SLOPE = 1.0324;
% BLANK = -0.37298;
 SLOPE = 1;
 BLANK = 0;

UP = [];
DWN = [];
up = [];
dwn = [];

% Keep a record of corrected Soc and Foff coefficients (from drift
% correction)
% date = zeros(last-first,1);
% Soc_recD = zeros(last-first,1);
% Foff_recD = zeros(last-first,1);
% Soc_recU = zeros(last-first,1);
% Foff_recU = zeros(last-first,1);

% This loop concatenates data from the dives specified by FIRST and LAST
% into two large matrices:  DWN contains all data from descents and UP
% contains all data from ascents
divenum = dive_rng(1);
divesum2;

data_header = {'lon','lat','xpos','ypos','z','yrdate','divetime','press','sigmath0',...
    'S','T','SBEO2','O2','red_reff','red_scttr','blue_ref','blue_scttr',...
    'wl600_ref','wl600_sig','chl_ref','chl_sig','cdom_ref','cdom_sig'};

for ii = dive_rng+1
    
    % start_ser_date is a serial date in the form of days since 1-jan-0000
    % which represents the start time of the dive
    ser_date = datenum(loginfo.year,loginfo.month,loginfo.date,loginfo.hour,loginfo.minute,loginfo.second+vmtime); 
    dv = datevec(ser_date);
    [~, decyr] = date2doy(ser_date);
    % decimal time (e.g. 2010.1234)
    dectime = dv(:,1)+decyr;
    
    [~,botind] = min(zpos);
    idwn = 1:botind;
	iup = botind:length(vmtime);
    
    
    % utm x coordinate at start of dive
    % GPS2 is fix immediately before diving 
    startlon = loginfo.GPS2_lon;
    startlat = loginfo.GPS2_lat;
    divefract = vmtime./vmtime(end);
    
    zd = vmdepth;
    epsz = rand(length(zd),1).*1e-7;
    if length(idwn) > 10 && length(iup) > 10

        dwn(:,5) = z_grid;
        dwn(:,6) = naninterp1(zd(idwn)+epsz(idwn), dectime(idwn), z_grid);
        dwn(:,7) = naninterp1(zd(idwn)+epsz(idwn), vmtime(idwn), z_grid);
        dwn(:,8) = naninterp1(zd(idwn)+epsz(idwn), press(idwn), z_grid);
        dwn(:,9) = naninterp1(zd(idwn)+epsz(idwn), sigmath0(idwn), z_grid);
        dwn(:,10) = naninterp1(zd(idwn)+epsz(idwn), salin(idwn), z_grid);
        dwn(:,11) = naninterp1(zd(idwn)+epsz(idwn), tempc(idwn), z_grid);
        dwn(:,12) = naninterp1(zd(idwn)+epsz(idwn), oxygen(idwn), z_grid);
        dwn(:,13) = naninterp1(zd(idwn)+epsz(idwn), optode_dphase_oxygenc(idwn), z_grid);
        dwn(:,14) = naninterp1(zd(idwn)+epsz(idwn), fluor(idwn), z_grid);
        dwn(:,15) = naninterp1(zd(idwn)+epsz(idwn), red_ref(idwn), z_grid);
        dwn(:,16) = naninterp1(zd(idwn)+epsz(idwn), red_scttr(idwn), z_grid);
        dwn(:,17) = naninterp1(zd(idwn)+epsz(idwn), blue_ref(idwn), z_grid);
        dwn(:,18) = naninterp1(zd(idwn)+epsz(idwn), blue_scttr(idwn), z_grid);
        dwn(:,19) = naninterp1(zd(idwn)+epsz(idwn), wl600_ref(idwn), z_grid);
        dwn(:,20) = naninterp1(zd(idwn)+epsz(idwn), wl600_sig(idwn), z_grid);
        dwn(:,21) = naninterp1(zd(idwn)+epsz(idwn), chl_ref(idwn), z_grid);
        dwn(:,22) = naninterp1(zd(idwn)+epsz(idwn), chl_sig(idwn), z_grid);
        dwn(:,23) = naninterp1(zd(idwn)+epsz(idwn), cdom_ref(idwn), z_grid);
        dwn(:,24) = naninterp1(zd(idwn)+epsz(idwn), cdom_sig(idwn), z_grid);
        dwn(:,25) = divenum;
        
        
        up(:,5) = z_grid;
        up(:,6) = naninterp1(zd(iup)+epsz(iup), dectime(iup), z_grid);
        up(:,7) = naninterp1(zd(iup)+epsz(iup), vmtime(iup), z_grid);
        up(:,8) = naninterp1(zd(iup)+epsz(iup), press(iup), z_grid);
        up(:,9) = naninterp1(zd(iup)+epsz(iup), sigmath0(iup), z_grid);
        up(:,10) = naninterp1(zd(iup)+epsz(iup), salin(iup), z_grid);
        up(:,11) = naninterp1(zd(iup)+epsz(iup), tempc(iup), z_grid);
        up(:,12) = naninterp1(zd(iup)+epsz(iup), oxygen(iup), z_grid);
        up(:,13) = naninterp1(zd(iup)+epsz(iup), optode_dphase_oxygenc(iup), z_grid);
        up(:,14) = naninterp1(zd(iup)+epsz(iup), fluor(iup), z_grid);
        up(:,15) = naninterp1(zd(iup)+epsz(iup), red_ref(iup), z_grid);
        up(:,16) = naninterp1(zd(iup)+epsz(iup), red_scttr(iup), z_grid);
        up(:,17) = naninterp1(zd(iup)+epsz(iup), blue_ref(iup), z_grid);
        up(:,18) = naninterp1(zd(iup)+epsz(iup), blue_scttr(iup), z_grid);
        up(:,19) = naninterp1(zd(iup)+epsz(iup), wl600_ref(iup), z_grid);
        up(:,20) = naninterp1(zd(iup)+epsz(iup), wl600_sig(iup), z_grid);
        up(:,21) = naninterp1(zd(iup)+epsz(iup), chl_ref(iup), z_grid);
        up(:,22) = naninterp1(zd(iup)+epsz(iup), chl_sig(iup), z_grid);
        up(:,23) = naninterp1(zd(iup)+epsz(iup), cdom_ref(iup), z_grid);
        up(:,24) = naninterp1(zd(iup)+epsz(iup), cdom_sig(iup), z_grid);
        up(:,25) = divenum;
    else
        dwn = [];
        up = [];
    end
    divenum = ii;
    try
        divesum2;
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
    
    if length(idwn) > 10 && length(iup) > 10
    dwn(:,1) = naninterp1(zd(idwn)+epsz(idwn),lonpos(idwn),z_grid);
    dwn(:,2) = naninterp1(zd(idwn)+epsz(idwn),latpos(idwn),z_grid);
    dwn(:,3) = naninterp1(zd(idwn)+epsz(idwn),xpos(idwn),z_grid);
    dwn(:,4) = naninterp1(zd(idwn)+epsz(idwn),ypos(idwn),z_grid);
    
    up(:,1) = naninterp1(zd(iup)+epsz(iup),lonpos(iup),z_grid);
    up(:,2) = naninterp1(zd(iup)+epsz(iup),latpos(iup),z_grid);
    up(:,3) = naninterp1(zd(iup)+epsz(iup),xpos(iup),z_grid);
    up(:,4) = naninterp1(zd(iup)+epsz(iup),ypos(iup),z_grid);
    
    end
    
    UP = cat(1,UP,up);
    up = [];
    DWN = cat(1,DWN,dwn);
    dwn = [];
end

cd(oldpath);
end

function [out] = naninterp1(x, y, xi)
    out = interp1(x(~isnan(y)),y(~isnan(y)),xi);
end