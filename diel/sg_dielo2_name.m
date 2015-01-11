
function [S] = sg_dielo2_name(gliderid,varname,zrng, varargin)

%%
% Parse input
%*

p = inputParser;

defaultPath = '/Users/Roo/Documents/CMORE/HOE-DYLAN';
defaultTimezone = -10;
defaultI = 100;
defaultIk = 150;
defaultIb = 200e10;
defaultLat = 22.75;
defaultLon = 202;

addRequired(p,'gliderid',@ischar);
addRequired(p,'varname',@ischar);
addRequired(p,'zrng',@(x) length(x) == 2 & isnumeric(x));

addParameter(p,'sgpath',defaultPath,@ischar);
addParameter(p,'timezone',defaultTimezone,@isnumeric);
addParameter(p,'I',defaultI,@isnumeric);
addParameter(p,'Ik',defaultIk,@isnumeric);
addParameter(p,'Ib',defaultIb,@isnumeric);
addParameter(p,'lat',defaultLat,@isnumeric);
addParameter(p,'lon',defaultLon,@isnumeric);

parse(p,gliderid,varname,zrng, varargin{:});

gliderid = p.Results.gliderid;
varname = p.Results.varname;
zrng = p.Results.zrng;
sgpath = p.Results.sgpath;
timezone = p.Results.timezone;
I = p.Results.I;
Ik = p.Results.Ik;
Ib = p.Results.Ib;
lon = p.Results.lon;
lat = p.Results.lat;

% 
% Load data
%
oldir = cd;
cd(sgpath);
load([gliderid, '.mat']);
load('O2corr.mat');
O2corr = eval(['O2corr_' gliderid(3:5)]);
header = eval(['header' gliderid(3:5)]);

D = array2table(DWN,'VariableNames',header);
U = array2table(UP,'VariableNames',header);
clear('DWN','UP');


%%
% Convert to local time here
%%
D.ser_date_loc = D.ser_date + timezone./24;
U.ser_date_loc = U.ser_date + timezone./24;

cd(oldir);

iso2anom = strcmpi(varname,'o2anom');

if iso2anom
    D.o2eq = O2sol(D.salin,D.tempc);
    U.o2eq = O2sol(U.salin,U.tempc);
    % converted to mmol m-3 here
    D.o2anom = (1+D.sigmath0./1000).*(D.optode_dphase_oxygenc+O2corr(1)-D.o2eq);
    U.o2anom = (1+U.sigmath0./1000).*(U.optode_dphase_oxygenc+O2corr(1)-U.o2eq);
end

% Dvar = D.(varname);
% Uvar = U.(varname);

ampd = [];
ampu = [];
peakd = [];
peaku = [];
rsqd = [];
rsqu = [];
offsd = [];
offsu = [];
pd = [];
pu = [];

dvs = unique(D.divenum);
% for each dive, average O2 is calculated over specified zrng
% a single time point is assigned to each dive (mean for avged data)
for ii = 1:length(dvs);
    dz = (abs(D.z - mean(zrng)) < abs(diff(zrng)./2) & D.divenum == dvs(ii));
    %o2sat(ii) = mean(DWN(dz,26));
    S.Do2(ii) = nanmean(D.(varname)(dz));
    S.Dtyr(ii) = nanmean(D.ser_date_loc(dz));
    if iso2anom
        S.Do2eq(ii) = nanmean(D.o2eq(dz));
    end
end

dvs = unique(U.divenum);
% for each dive, average O2 is calculated over specified zrng
% a single time point is assigned to each dive (mean for avged data)
for ii = 1:length(dvs);
    dz = (abs(U.z - mean(zrng)) < abs(diff(zrng)./2) & U.divenum == dvs(ii));
    %o2sat(ii) = mean(DWN(dz,26));
    S.Uo2(ii) = nanmean(U.(varname)(dz));
    S.Utyr(ii) = nanmean(U.ser_date_loc(dz));
    if iso2anom
        S.Uo2eq(ii) = nanmean(U.o2eq(dz));
    end
end

if iso2anom
    [~,S.Do2] = dailysatanom( S.Dtyr,S.Do2+S.Do2eq,S.Do2eq );
    [~,S.Uo2] = dailysatanom( S.Utyr,S.Uo2+S.Uo2eq,S.Uo2eq );
end
if strcmpi(varname,'optode_dphase_oxygenc') || strcmpi(varname,'o2anom')
    [ S.daysd,S.ampd,S.peakd, S.offsd, S.varid, S.errvald,S.pvald] = dielPRfit( S.Dtyr,S.Do2,lat,lon,timezone,I,Ik,Ib );
    [ S.daysu,S.ampu,S.peaku, S.offsu, S.variu, S.errvalu,S.pvalu] = dielPRfit( S.Utyr,S.Uo2,lat,lon,timezone,I,Ik,Ib );
else
    [ S.daysd,S.ampd,S.peakd, S.offsd , S.varid,S.errvald,S.pvald] = dielsinefit(S.Dtyr,S.Do2,1);
    [ S.daysu,S.ampu,S.peaku, S.offsu , S.variu,S.errvalu,S.pvalu] = dielsinefit(S.Utyr,S.Uo2,1);
end





