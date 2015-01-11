function [tt,mld,td,dmld,tu,umld] = sgmld(DWN,UP,doff)

% doff = 0.125;
% doff = 0.03;

divecol = 7;
denscol = 10;
zcol = 5;
tcol = 6;


dvs = unique(DWN(:,divecol));

for ii = dvs';
    d = find(DWN(:,divecol) == ii);
    td(ii) = nanmean(DWN(d,tcol));
    dmld(ii) = calcmld(DWN(d,denscol),DWN(d,zcol),doff);
    u = find(UP(:,divecol) == ii);
    tu(ii) = nanmean(UP(u,tcol));
    umld(ii) = calcmld(UP(u,denscol),UP(u,zcol),doff);
end

tt = [td tu];
mld(:,1) = [td';tu'];
mld(:,2) = [dmld';umld'];
mld = sortrows(mld,1);
mld(mld(:,1) == 0,:) = NaN;
dmld(dmld == 0) = NaN;
umld(umld == 0) = NaN;