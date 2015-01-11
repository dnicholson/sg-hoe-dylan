
Kz = 1e-4;
iz = 5;
it = 6;
idivenum = 7;
ith = 10;
iS = 11;
iT = 12;
iD = 10;
iO2 = 14;
iO2sat = 26;
zmax = 100;
thmax = 24.3;
mlzrng = [2 20];


load Forcing.mat;
oldir = cd;
cd('/Users/Roo/Documents/CMORE/HOE-DYLAN/');
load('O2corr.mat');
load('sg148.mat','DWN');
DWN(:,26) = 100.*((DWN(:,14)+O2corr_148(1))./O2sol(DWN(:,11),DWN(:,12))-1);
tstart = datenum(2012,6,28);
tend = datenum(2012,9,8);

% load('sg146.mat','DWN');
% DWN(:,26) = 100.*((DWN(:,14)+O2corr_146(1))./O2sol(DWN(:,11),DWN(:,12))-1);
% tstart = datenum(2012,5,27);
% tend = datenum(2012,8,8);


cd(oldir);


v = F.daten >= tstart & F.daten <= tend;
wspd = F.WSPD(v);
slp = F.PRES(v)./1013.25;  % slp in atm
t = F.daten(v);



% iml = (DWN(:,iz) >= mlzrng(1) & DWN(:,iz) <= mlzrng(2));
% t_ml = DWN(iml,it);
% S_ml = DWN(iml,iS);
% T_ml = DWN(iml,iT);
% O2_ml = sw_dens0(S_ml,T_ml).*DWN(ml,iO2)./1e6;
% O2_solml = gasmoleq(DWN(ml,iS),DWN(ml,iT),'O2');
% 
% ml_wspd = interp1(F.DateTime,wspd,t_ml);
% ml_slp = interp1(F.DateTime,slp,t_ml)./101325;

% preallocate variables
dives = unique(DWN(:,7));
ndvs = length(dives);
td = zeros(ndvs,1);
Td = zeros(ndvs,1);
Sd = zeros(ndvs,1);
O2d = zeros(ndvs,1);
O2sat = zeros(ndvs,1);
O2zm = zeros(ndvs,1);
O2satth = zeros(ndvs,1);
O2thm = zeros(ndvs,1);
dOdz = zeros(ndvs,1);

for ii = 1:length(dives)
    iml = (DWN(:,iz) >= mlzrng(1) & DWN(:,iz) <= mlzrng(2) & DWN(:,idivenum) == dives(ii));
    ithetam = DWN(:,ith) < thmax & DWN(:,idivenum) == dives(ii);
    izm = (DWN(:,iz) >= 2 & DWN(:,iz) <= zmax & DWN(:,idivenum) == dives(ii));
    izmax = (abs(DWN(:,iz) - zmax) < 10 & DWN(:,idivenum) == dives(ii) & ~isnan(DWN(:,iz)));
    
    td(ii) = nanmean(DWN(iml,it));
    Td(ii) = nanmean(DWN(iml,iT));
    Sd(ii) = nanmean(DWN(iml,iS));
    O2d(ii) = nanmean((DWN(iml,iD)+1000).*DWN(iml,iO2))./1e6;
    O2sat(ii) = nanmean(DWN(iml,iO2sat));
    O2zm(ii) = nanmean((DWN(izm,iD)+1000).*DWN(izm,iO2))./1e6;
    O2satth(ii) = nanmean(DWN(ithetam,iO2sat));
    O2thm(ii) = nanmean((DWN(ithetam,iD)+1000).*DWN(ithetam,iO2))./1e6;
    p = polyfit(DWN(izmax,iz),(DWN(izmax,iD)+1000).*DWN(izmax,iO2)./1e6,1);
    dOdz(ii) = p(1);
end
% Delta O2 (mol m-3)
%mixed l
%DO2zm = (O2satth./100).*gasmoleq(Sd,Td,'O2');
DO2zm = (O2sat./100).*gasmoleq(Sd,Td,'O2');
%DO2zm = O2thm;

O2satf = interp1(td,O2sat,t);
O2zmf = interp1(td,O2zm,t);
DO2zmf = interp1(td,DO2zm,t);
O2eqf = interp1(td,gasmoleq(Sd,Td,'O2'),t);
dOdzf = interp1(td,dOdz,t);
Sf = interp1(td,Sd,t);
Tf = interp1(td,Td,t);


% wspd_d = interp1(F.daten,F.WSPD,td);
% slp_d = interp1(F.daten,F.PRES./1013.25,'O2');



[ Fs, Fp, Fc, Deq] = fbub_L13((O2satf./100+1).*O2eqf,wspd,Sf,Tf,slp,'O2');
[ Fs, Fp, Fc, Deq] = fas_N11((O2satf./100+1).*O2eqf,wspd,Sf,Tf,slp,'O2');

% [ FsN, FpN, FcN, DeqN] = fbub_L13(1.01.*gasmoleq(Sf,Tf,'N2'),18,Sf,Tf,slp,'N2');
% [ FsA, FpA, FcA, DeqA] = fbub_L13(1.01.*gasmoleq(Sf,Tf,'Ar'),18,Sf,Tf,slp,'Ar');
Ftot = Fs+Fp+Fc;
s2d = 60*60*24;
% time in days
% td = t_ml(1):1/365:t_ml(end);
% dFge = interp1(t_ml,Fge,td);
% dFinj = interp1(t_ml,Finj,td);
% dFex = interp1(t_ml,Fex,td);
% dFbub = dFinj+dFex;
% dO2m = interp1(t_ml,O2m,td);
% dO2m = dO2m-dO2m(1);

% change in O2 inventory
dO2zm = zmax.*(DO2zmf-DO2zmf(1));

%cumulative air-sea flux
Fcum = s2d.*cumtrapz(t,Ftot);
Fpcum = s2d.*cumtrapz(t,Fp);
Fccum = s2d.*cumtrapz(t,Fc);
Fscum = s2d.*cumtrapz(t,Fs);

% cumulative mixing flux
Fkz = s2d.*Kz.*cumtrapz(t,dOdzf);

cumJbio = dO2zm - Fcum;
cumJbio = -Fcum;
Jbio = ctr1stdiffderiv(cumJbio,t);
dys = unique(floor(t));

for ii = 1:length(dys)
    id = floor(t) == dys(ii);
    cumJbiod(ii) = nanmean(cumJbio(id));
end
%cumJbiod = interp1(t,cumJbio,dys);
Jbiod = ctr1stdiffderiv(cumJbiod,dys');

for ii = 1:length(dys)
    iw = abs(dys-dys(ii)) <= 3;
    ave7day(ii) = nanmean(Jbiod(iw));
end

%%
addpath([cd '/../diel']);
[tt,mld,td,dmld] = sgmld(DWN,DWN,0.03);
zmt = interp1(td(~isnan(dmld)),dmld(~isnan(dmld)),t);
dOdt = Ftot.*s2d./zmt;
Od = 0.*dOdt;
for ii = 1:length(dys);
    d = floor(t) == dys(ii);
    if sum(d) > 1
        Od(d) = detrend(cumtrapz(t(d),dOdt(d)));
    end
end


