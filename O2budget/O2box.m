
z_ind = 5;
t_ind = 6;
S_ind = 11;
T_ind = 10;
O2_ind = 14;
z_surf = 5;

load F.mat;
wspd = sqrt(F.u10m.^2+F.v10m.^2);
slp = F.PRES;

ml = find(DWN(:,z_ind) == z_surf);
t_ml = DWN(ml,t_ind);
S_ml = DWN(ml,S_ind);
T_ml = DWN(ml,T_ind);
O2_ml = sw_dens0(S_ml,T_ml).*DWN(ml,O2_ind)./1e6;
O2_solml = gasmoleq(DWN(ml,S_ind),DWN(ml,T_ind),'O2');

ml_wspd = interp1(F.DateTime,wspd,t_ml);
ml_slp = interp1(F.DateTime,slp,t_ml)./101325;



Sc = schmidt(S_ml,T_ml,'O2');
kg = kgas(ml_wspd,Sc,'Sw07');

Fge = -kg.*(O2_ml-ml_slp.*O2_solml);
[Finj Fex] = Fbub_N11(ml_wspd,S_ml,T_ml,ml_slp,'O2');

dives = unique(DWN(:,7));
for ii = 1:length(dives)
    d = find(DWN(:,5) < 100 & DWN(:,7) == dives(ii));
    O2m(ii) = 1023.*nanmean(DWN(d,14))./1e6;
end

s2d = 60*60*24;
% time in days
td = t_ml(1):1/365:t_ml(end);
dFge = interp1(t_ml,Fge,td);
dFinj = interp1(t_ml,Finj,td);
dFex = interp1(t_ml,Fex,td);
dFbub = dFinj+dFex;
dO2m = interp1(t_ml,O2m,td);
dO2m = dO2m-dO2m(1);

dJbio = dO2m.*100 - s2d.*cumsum(dFbub - dFge);




