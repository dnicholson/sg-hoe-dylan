function [ V,tg,zg ] = sg_gridvar( DWN,vcol,zgrid,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dvcol = 7;
if nargin > 3
    dvs = varargin{1};
else
    dvs = unique(DWN(:,dvcol));
end
zcol = 5;
tcol = 6;
dvcol = 7;
nt = length(dvs);

V = nan(length(zgrid),nt);
tg = nan(1,nt);
zg = zgrid;
for ii = 1:nt
    idv = DWN(:,7) == dvs(ii) & ~isnan(DWN(:,vcol));
    if sum(idv) > 3
        V(:,ii) = interp1(DWN(idv,zcol),DWN(idv,vcol),zgrid);
        tg(ii) = nanmean(DWN(idv,tcol));
    else
        V(:,ii) = NaN;
        tg(ii) = NaN;
    end
end

end

