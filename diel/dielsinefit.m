function [ days,amp,peak, offs, vari, errval,pval] = dielsinefit( tloc,ydata,varargin )


%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
days = unique(floor(tloc))';
days = days(2:end-1);
nd = length(days);
ydata = ydata - nanmean(ydata);
overlaphrs = 1;

guess = [0.2, -0.6, 0];

amp = nan(nd,1);
peak = nan(nd,1);
offs = nan(nd,1);
vari = nan(nd,1);
errval = nan(nd,1);
pval = nan(nd,1);
fixedphase = 0;

if nargin > 2
    period = varargin{1};
else
    period = 1;
end

for ii = 1:nd
    d = (floor(tloc) == days(ii)-overlaphrs | floor(tloc) == days(ii)+overlaphrs);
    vari(ii) = var(ydata(d));
    if sum(d) < 4
        amp(ii) = NaN;
        peak(ii) = NaN;
        offs(ii) = NaN;
    elseif fixedphase == 1
        df = mod(tloc(d),1);
        fun = @(x) sum((ydata(d) - (x(1).*cos(2.*pi.*(df - 0.65))+x(2))).^2);
        [xv] = fminsearch(fun, [0.2 0], optimset('TolX',1e-4));
        amp(ii) = xv(1);
        peak(ii) = xv(2);
        offs(ii) = 0.4;
    else
        df = mod(tloc(d),1);
        fun = @(x) sum((ydata(d) - (x(1).*cos(period.*2.*pi.*(df - x(2)))+x(3))).^2);
        [xv,fv] = fminsearch(fun, guess, optimset('TolX',1e-4));
        amp(ii) = xv(1);
        peak(ii) = xv(2);
        offs(ii) = xv(3);
        [r,p] = corrcoef(ydata(d),xv(1).*cos(2.*pi.*(df-xv(2)))+xv(3));
        errval(ii) = r(1,2).^2;
        pval(ii) = p(1,2);
    end
end
peak = mod(peak,1);
% if amp is negative, then need to shift 1/2 wavelength
peak(amp < 0) = peak(amp < 0)+1/2;
% ensure that all values are 0 < peak < 1
peak(peak > 1) = peak(peak > 1) - 1;
peak(peak < 0) = peak(peak < 0) + 1;
% make all amplitides positive
amp = abs(amp);


