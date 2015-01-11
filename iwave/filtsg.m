function [t, v_hp, v_lp] = filtsg(dn,surf)

% z_ind = 5;
% t_ind = 6;
% freq cutoff (in y-1)
f_cutoff = 365./2;
f_cutoff = 1./2;

d = ~isnan(surf);
t = dn;
v = surf(d)-mean(surf(d));
dt = median(diff(t));
% Nyquist frequency
fN = 1/(2.*dt);
Wn = f_cutoff./fN;
[b,a] = butter(9,Wn,'high');
v_hp = filtfilt(b,a,v);
v_lp = v - v_hp;
