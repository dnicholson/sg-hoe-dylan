function [ median4bin,mean4bin,std4bin,count4bin,bins] = dielcomp( dn, v, nbins,period,varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin > 4
    tref = varargin{1};
else
    tref = 0;
end
%period = 1; %diel period
%period = 23.9345788179./24; % k1 period
%binctr = (1:nbins)./(nbins+1)+1/(2+nbins);
%binctr = (1/(2.*nbins)):(1/nbins):1;
prds = unique(floor((dn-tref)./period));
prds(isnan(prds)) = [];
nprds = length(prds);
vv = NaN*v;
for ii = 1:nprds
    iday = floor((dn-tref)./period) == prds(ii);
    % require at least four values per day
    
    vv(iday) = v(iday)-nanmean(v(iday));
end

[ median4bin,mean4bin,std4bin,count4bin,bins] = compositePeriod(dn,vv,nbins,period,tref);
% periodfrac = rem(dn-tref,period);
% for jj = 1:nbins
%     ind = periodfrac < jj./nbins & periodfrac > (jj-1)./nbins;
%     count4bin(jj) = sum(ind);
%     median4bin(jj) = nanmedian(vv(ind));
%     mean4bin(jj) = nanmean(vv(ind));
%     std4bin(jj) = nanstd(vv(ind));
% end
% 
% count4bin = dimwrap(count4bin,2);
% median4bin = dimwrap(median4bin,2);
% mean4bin = dimwrap(mean4bin,2);
% std4bin = dimwrap(std4bin,2);
% bins = dimwrap(binctr,2);
% bins(end) = bins(end)+1;
% bins(1) = bins(1)-1;
% end
% function wrapped = dimwrap(M,dim)
%     if dim == 1
%         wrapped = [M(end,:);M;M(1,:)];
%     elseif dim == 2
%         wrapped = [M(:,end),M,M(:,1)];
%     else
%         error('only supports dim = 1 or dim = 2');
%     end
% end
% end
