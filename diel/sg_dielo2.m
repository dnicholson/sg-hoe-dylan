
function [S] = sg_dielo2(gliderid,O2col,zrng)

sgpath = '/Users/Roo/Documents/CMORE/HOE-DYLAN';

%gliderid = 'sg148';
oldir = cd;
cd(sgpath);
load([gliderid, '.mat']);
load('O2corr.mat');
O2corr = eval(['O2corr_' gliderid(3:5)]);
% load('sg146_300m.mat');
% D146 = DWN;
% U146 = UP;
% load('sg146_300m.mat');
% D512 = DWN;
% U512 = UP;
% clear('DWN','UP');
cd(oldir);

zcol = 5;
tcol = 6;
%O2col = 27;
Scol = 11;
Tcol = 12;

iso2anom = O2col == 27;

if O2col >= 26
    O2eqU = O2sol(UP(:,11),UP(:,12));
    O2eqD = O2sol(DWN(:,11),DWN(:,12));
    DWN(:,26) = 100.*((DWN(:,14)+O2corr(1))./O2eqD-1);
    UP(:,26) = 100.*((UP(:,14)+O2corr(1))./O2eqU-1);
    DWN(:,27) = DWN(:,14)+O2corr(1)-O2eqD;
    UP(:,27) = UP(:,14)+O2corr(1)-O2eqU;
end
%zlevs = [5:2:20];
%zrng = [2 35];

%zlevs = 25;
%nlevs = length(zlevs);
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

dvs = unique(DWN(:,7));
% for each dive, average O2 is calculated over specified zrng
% a single time point is assigned to each dive (mean for avged data)
for ii = 1:length(dvs);
    dz = (abs(DWN(:,5) - mean(zrng)) < abs(diff(zrng)./2) & DWN(:,7) == dvs(ii));
    %o2sat(ii) = mean(DWN(dz,26));
    S.Do2(ii) = nanmean(DWN(dz,O2col));
    S.Dtyr(ii) = nanmean(DWN(dz,6));
    if iso2anom
        S.Do2eq(ii) = nanmean(O2eqD(dz));
    end
end

dvs = unique(UP(:,7));
for ii = 1:length(dvs);
    dz = (abs(UP(:,5) - mean(zrng)) < abs(diff(zrng)./2) & UP(:,7) == dvs(ii));
    %o2sat(ii) = mean(UP(dz,26));
    S.Uo2(ii) = nanmean(UP(dz,O2col));
    S.Utyr(ii) = nanmean(UP(dz,6));
    if iso2anom
        S.Uo2eq(ii) = nanmean(O2eqU(dz));
    end
end

if iso2anom
    [~,S.Do2] = dailysatanom( S.Dtyr,S.Do2,S.Do2eq );
    [~,S.Uo2] = dailysatanom( S.Utyr,S.Uo2,S.Uo2eq );
end
if O2col == 14 || O2col == 27 || O2col == 26 
[ S.daysd,S.ampd,S.peakd, S.offsd, S.varid, S.errvald,S.pvald] = dielPRfit( S.Dtyr,S.Do2 );
[ S.daysu,S.ampu,S.peaku, S.offsu, S.variu, S.errvalu,S.pvalu] = dielPRfit( S.Utyr,S.Uo2 );
else
[ S.daysd,S.ampd,S.peakd, S.offsd , S.varid,S.errvald,S.pvald] = dielsinefit(S.Dtyr,S.Do2,1);
[ S.daysu,S.ampu,S.peaku, S.offsu , S.variu,S.errvalu,S.pvalu] = dielsinefit(S.Utyr,S.Uo2,1);
end


%[ S.daysus,S.ampus,S.peakus, S.offsus , S.varius,S.errvalus,S.pvalus] = dielsinefit(S.Utyr,S.Uo2,23.9345788179./24);



