load Kaneohe_Tides

 %tfit = datenum(2012,1,1):(1/100):datenum(2012,12,31);
% change time to GMT from hawaii time
npts = 101;
coef = ut_solv ( KBtides.daten+10/24, KBtides.h, [], 22.75,'auto') ;
k1ind = find(strcmpi(coef.name,'K1'));
m2ind = find(strcmpi(coef.name,'M2'));
t0_GMT = coef.aux.reftime+coef.g(k1ind)./360;
fk1 = 24.*coef.aux.frq(1);
%tfit = linspace(t_hitide_GMT-fk1./4,t_hitide_GMT+3.*fk1./4,npts);
tfit = linspace(t0_GMT,t0_GMT+fk1,npts);
tk1 = linspace(0,1,npts);

%tfit = (trefGMT-coef.g./360):0.01:(trefGMT-coef.g./360)+1;
k1 = ut_reconstr(tfit,coef,'Cnstit',coef.name{1});
m2 = ut_reconstr(tfit,coef,'Cnstit',coef.name{2});
o1 = ut_reconstr(tfit,coef,'Cnstit',coef.name{3});


