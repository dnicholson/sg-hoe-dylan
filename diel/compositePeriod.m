function [ median4bin,mean4bin,std4bin,count4bin,bins] = compositePeriod(dn,vv,nbins,period,tref)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
binctr = (1/(2.*nbins)):(1/nbins):1;
periodfrac = mod(dn-tref,period);

count4bin = NaN(1,nbins);
median4bin = NaN(1,nbins);
mean4bin = NaN(1,nbins);
std4bin = NaN(1,nbins);
for jj = 1:nbins
    ind = periodfrac < jj./nbins & periodfrac > (jj-1)./nbins;
    count4bin(jj) = sum(ind);
    median4bin(jj) = nanmedian(vv(ind));
    mean4bin(jj) = nanmean(vv(ind));
    std4bin(jj) = nanstd(vv(ind));
end

count4bin = dimwrap(count4bin,2);
median4bin = dimwrap(median4bin,2);
mean4bin = dimwrap(mean4bin,2);
std4bin = dimwrap(std4bin,2);
bins = dimwrap(binctr,2);
bins(end) = bins(end)+1;
bins(1) = bins(1)-1;
end

function wrapped = dimwrap(M,dim)
    if dim == 1
        wrapped = [M(end,:);M;M(1,:)];
    elseif dim == 2
        wrapped = [M(:,end),M,M(:,1)];
    else
        error('only supports dim = 1 or dim = 2');
    end
end



