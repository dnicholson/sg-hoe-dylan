function [t,z,Ri,N2g,sh2g,t300,dnadcp,zshear,shearsqr,tout,zout,N2 ] = alohaRi( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
addpath('..');
addpath('../WHOTS');

% hawaii timezone
tz = -10;
trng = [datenum(2012,6,15), datenum(2013,6,10)];
zrng = 1:120;

stageSgMld;

DWN = D148;
%%
[ Tg,~,~ ] = sg_gridvar( DWN,12,zrng);
[ Sg,~,~ ] = sg_gridvar( DWN,11,zrng);
[ pg,tg,zg ] = sg_gridvar( DWN,9,zrng);

% calculate brunt-vaisala
[N2, ~] = gsw_Nsquared(Sg,Tg,pg);
zout = (zg(2:end)+zg(1:end-1))./2;
tout = datenum(tg,1,1);
ito = ~isnan(tout);


%% load and grid ADCP data
uc300 = ncread('OS_WHOTS_201206_D_ADCP-125m.nc','UCUR');
vc300 = ncread('OS_WHOTS_201206_D_ADCP-125m.nc','VCUR');
t300 = ncread('OS_WHOTS_201206_D_ADCP-125m.nc','TIME');
z300 = ncread('OS_WHOTS_201206_D_ADCP-125m.nc','DEPTH');

dn300 = datenum(1950,1,1) + t300 + tz;
dz300 = z300(2)-z300(1);

it3 = dn300 > trng(1) & dn300 < trng(2);
dnadcp = dn300(it3);
[~,ushear300] = gradient(uc300(:,it3),dn300(2)-dn300(1),dz300);
[~,vshear300] = gradient(vc300(:,it3),dn300(2)-dn300(1),dz300);
shearsqr_300 = ushear300.^2 + vshear300.^2; 

%
uc600 = ncread('OS_WHOTS_201206_D_ADCP-048m.nc','UCUR');
vc600 = ncread('OS_WHOTS_201206_D_ADCP-048m.nc','VCUR');
t600 = ncread('OS_WHOTS_201206_D_ADCP-048m.nc','TIME');
z600 = ncread('OS_WHOTS_201206_D_ADCP-048m.nc','DEPTH');

dn600 = datenum(1950,1,1) + t600 + tz;
dz600 = z600(2)-z600(1);

[~,ushear600] = gradient(uc600(:,it3),dn600(2)-dn600(1),dz600);
[~,vshear600] = gradient(vc600(:,it3),dn600(2)-dn600(1),dz600);
shearsqr_600 = ushear600.^2 + vshear600.^2; 

shearsqr = [shearsqr_300(1:20,:);shearsqr_600(3:21,:)];
zshear   = [z300(1:20);z600(3:21)];

% grid shearsqr in z direction
sh2g = interp1(zshear,shearsqr,zout,'nearest');
% grid N2 in t direction
N2g = interp1(tout(ito),N2(:,ito)',dnadcp)';
Ri = N2g./sh2g;
t = dnadcp;
z = zout;

end

