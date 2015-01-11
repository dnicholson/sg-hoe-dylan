function [ dfout,valout,count, stdout, meanout] = dielcompgrad( DWN,valind,zlevs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
zind = 5;
ztol = 0.5;
tind = 6;
nbins = 24;
%dfbin = 1/(2.*nbins):1/nbins:1;
dfout = [0 (1:nbins)./nbins];
% cycle period in days - i.e. 1 = diel period
period = 1;
tz = -10;


nlevs = length(zlevs);
valout = zeros(nlevs,nbins+1);
count = valout;
stdout = valout;
meanout = valout;
dnLocal = DWN(:,tind)+tz/24;  

for ii = 1:nlevs
    dz = (abs(DWN(:,zind) - zlevs(ii)) < ztol);
    val = DWN(dz,valind);
    dnlev = dnLocal(dz);
    dflev = mod(dnlev,1);
    g = gradient(val,dnlev);
%    [ valout(ii,2:end),~,stdout(ii,2:end),count(ii,2:end) ] = dielcomp( dnlev, g, nbins );
    for jj = 1:nbins
        ind = dflev < jj./24 & dflev > (jj-1)./24;
        count(ii,jj+1) = nansum(ind);
        valout(ii,jj+1) = nanmedian(g(ind));
        meanout(ii,jj+1) = nanmean(g(ind));
        stdout(ii,jj+1) = nanstd(g(ind));
    end
end

valout(:,1) = valout(:,end);

