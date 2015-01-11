u = ncread('../WHOTS/OS_WHOTS_201206_D_NGVM-010m.nc','UCUR');
v = ncread('../WHOTS/OS_WHOTS_201206_D_NGVM-010m.nc','VCUR');
tw = ncread('../WHOTS/OS_WHOTS_201206_D_NGVM-010m.nc','TIME')';
datenGMT = tw + datenum(1950,1,1)+10/24;
d = datenGMT < datenum(2012,9,1);
 %tfit = datenum(2012,1,1):(1/100):datenum(2012,12,31);
% change time to GMT from hawaii time
npts = 101;
if exist('WHOTS_utcoef.mat','file')
    load('WHOTS_utcoef.mat');
else
    coef = ut_solv ( datenGMT(d), u(d), v(d), 22.75,'auto') ;
    save('WHOTS_utcoef','coef');
end
k1ind = find(strcmpi(coef.name,'K1'));
m2ind = find(strcmpi(coef.name,'M2'));
t0_GMT = coef.aux.reftime+coef.g(k1ind)./360;
fk1 = 24.*coef.aux.frq(k1ind);

tfit = linspace(t0_GMT,t0_GMT+fk1,npts);
tk1 = linspace(0,1,npts);

k1 = ut_reconstr(tfit,coef,'Cnstit','K1');
m2 = ut_reconstr(tfit,coef,'Cnstit','M2');
%o1 = ut_reconstr(tfit,coef,'Cnstit',coef.name{3});


