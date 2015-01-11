function [ days,amp,peak, offs, vari, errval,pval] = dielPRfit( tloc,ydata,lat,lon, tz,I,Ik,Ib )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% tz = -10;
% t = tgmt + tz./24;
days = unique(floor(tloc(~isnan(tloc))))';
%days = days(2:end-1);
nd = length(days);
ydata = ydata - nanmean(ydata);
overlaphrs = 0;

guess = [1, 0.1, 0];

amp = nan(nd,1);
peak = nan(nd,1);
offs = nan(nd,1);
vari = nan(nd,1);
errval = nan(nd,1);
pval = nan(nd,1);
fixedphase = 0;

% this is the shape of P+R curve
[dfPR,P,R] = diel_PR2(lat,lon,datenum(2012,8,15),tz,I./Ik,I./Ib );
D = cumtrapz(dfPR,P+R) - mean(cumtrapz(dfPR,P+R));

for ii = 1:nd
    [dfPR,P,R] = diel_PR2( lat,lon,days(nd),tz,I./Ik,I./Ib );
    D = cumtrapz(dfPR,P+R) - mean(cumtrapz(dfPR,P+R));
    d = (floor(tloc) == days(ii)-overlaphrs | floor(tloc) == days(ii)+overlaphrs);
    vari(ii) = var(ydata(d));
    if sum(d) < 4
        amp(ii) = NaN;
        peak(ii) = NaN;
        offs(ii) = NaN;
        r(1,2) = NaN;
        p(1,2) = NaN;
    elseif fixedphase == 1
        df = mod(tloc(d),1);
        fun = @(x) sum((interp1(dfPR,x(1).*(D),df)-ydata(d)+x(2)).^2);
        [xv] = fminsearch(fun, [0.2 0], optimset('TolX',1e-4));
        amp(ii) = xv(1);
        peak(ii) = 0;
        offs(ii) = xv(2);
        [r,p] = corrcoef(ydata(d),interp1(dfPR,xv(1).*(D),mod(tloc(d),1))+xv(2));
    else
        df = mod(tloc(d),1);
        fun = @(x) sum((interp1(dfPR,x(1).*(D),mod(tloc(d) + x(2),1))-ydata(d)+x(3)).^2);
        [xv,fv] = fminsearch(fun, guess, optimset('TolX',1e-4));
        amp(ii) = xv(1);
        peak(ii) = xv(2);
        offs(ii) = xv(3);
        [r,p] = corrcoef(ydata(d),interp1(dfPR,xv(1).*(D),mod(tloc(d) + xv(2),1))+xv(3));
    end
    errval(ii) = r(1,2).^2;
    pval(ii) = p(1,2);
end
peak = mod(peak,1);
% if amp is negative, then need to shift 1/2 wavelength
peak(amp < 0) = peak(amp < 0)+1/2;
% ensure that all values are 0 < peak < 1
peak(peak > 1) = peak(peak > 1) - 1;
peak(peak < 0) = peak(peak < 0) + 1;
% make all amplitides positive
amp = abs(amp);


