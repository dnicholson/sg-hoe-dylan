function [uniqueDays, ampmean,ampmedian ] = windowAve( days,amp,aveWindow )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
uniqueDays = sort(unique(days));
ndays = length(uniqueDays);
ampmean = nan(ndays,3);
ampmedian = nan(ndays,4);
%aveWindow = 5;
for ii = 1:ndays
    win = abs(days-uniqueDays(ii)) < aveWindow;
    ampmean(ii,1) = nanmean(amp(win));
    ampmean(ii,2) = nanstd(amp(win));
    ampmean(ii,3) = sum(win);
    ampmedian(ii,1) = nanmedian(amp(win));
    ampmedian(ii,2:3) = quantile(amp(win),[0.1 0.9]);
    ampmedian(ii,4) = sum(win);

end

end

