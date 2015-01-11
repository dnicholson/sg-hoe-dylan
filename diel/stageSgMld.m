%% calulate diurnal mixed layer depth
oldir = cd;
cd('/Users/Roo/Documents/CMORE/HOE-DYLAN/');
load('O2corr.mat');
load('sg146.mat');
DWN(:,26) = 100.*((DWN(:,14)+O2corr_146(1))./O2sol(DWN(:,11),DWN(:,12))-1);
DWN(:,27) = DWN(:,14)+O2corr_146(1)-O2sol(DWN(:,11),DWN(:,12));
header146 = cat(2,header146,'o2sat','o2anom');
D146 = DWN;
%D146 = UP;
U146 = UP;
load('sg148.mat');
DWN(:,26) = 100.*((DWN(:,14)+O2corr_148(1))./O2sol(DWN(:,11),DWN(:,12))-1);
DWN(:,27) = DWN(:,14)+O2corr_148(1)-O2sol(DWN(:,11),DWN(:,12));
D148 = DWN;
header148 = cat(2,header148,'o2sat','o2anom');
%D148 = UP;
U148 = UP;
load('sg512.mat');%,'DWN','UP');
DWN(:,26) = 100.*((DWN(:,14)+O2corr_512(1))./O2sol(DWN(:,11),DWN(:,12))-1);
DWN(:,27) = DWN(:,14)+O2corr_512(1)+2-O2sol(DWN(:,11),DWN(:,12));
D512 = DWN;
%D512 = UP;
U512 = UP;
header512 = cat(2,header512,'o2sat','o2anom');
cd(oldir);

[~,dmld1] = sgmld(D148,D148,0.03);
[~,dmld2] = sgmld(D146,D146,0.03);
[~,dmld3] = sgmld(D512,D512,0.03);

[~,umld1] = sgmld(U148,U148,0.03);
[~,umld2] = sgmld(U146,U146,0.03);
[~,umld3] = sgmld(U512,U512,0.03);

dmld = [dmld1;dmld2;dmld3];
dmld = sortrows(dmld,1);
dmld(dmld(:,2) == 200,:) = [];
dmld(:,1) = dmld(:,1);

[~,mld1] = sgmld(D148,D148,0.125);
[~,mld2] = sgmld(D146,D146,0.125);
[~,mld3] = sgmld(D512,D512,0.125);

mld = [mld1;mld2;mld3];
mld = sortrows(mld,1);
mld(mld(:,2) == 200,:) = [];
mld(:,1) = mld(:,1);