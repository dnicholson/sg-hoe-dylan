

function [vb,vh,vl] = whots_bandpass(dt,v,cut_lo,cut_hi)

% time is in days
% cut_lo = 0.5;
% cut_hi = 2;
% Nyquist Freq
fN = 1/(2.*dt);
forder = 3;
% creat butterworth bandpass filter
[b,a] = butter(forder,[cut_lo cut_hi]./fN,'bandpass');
[bh,ah] = butter(forder,cut_hi./fN,'high');
[bl,al] = butter(forder,cut_lo./fN,'low');
vb = filtfilt(b,a,v);
vh = filtfilt(bh,ah,v);
vl = filtfilt(bl,al,v);


% 