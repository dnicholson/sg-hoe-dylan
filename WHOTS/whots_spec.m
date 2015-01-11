Tw = ncread('OS_WHOTS_201206_D_MICROCAT-015m.nc','TEMP');
tw = ncread('OS_WHOTS_201206_D_MICROCAT-015m.nc','TIME');

dt = tw(2)-tw(1);
% time is in days

cut_lo = 0.5;
cut_hi = 2;
% creat butterworth filter
fN = 1/(2.*dt);
%Wn_hi = cut_hi./fN;
[b,a] = butter(3,[cut_lo cut_hi]./fN,'bandpass');

d = tw < 450;
Tbp = filtfilt(b,a,Tw(d));

figure;
plot(tw(d),Tbp);


% 