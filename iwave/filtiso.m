function [t v_hp v_lp] = filtiso(DWN,t_ind,surf_ind,surf,var_ind)

% z_ind = 5;
% t_ind = 6;
% freq cutoff (in y-1)
f_cutoff = 365./2;


d = find(abs(DWN(:,surf_ind)-surf) < 0.01);
t = DWN(d,t_ind);
v = DWN(d,var_ind)-mean(DWN(d,var_ind));
dt = median(diff(t));
% Nyquist frequency
fN = 1/(2.*dt);
Wn = f_cutoff./fN;
[b,a] = butter(9,Wn,'high');
v_hp = filtfilt(b,a,v);
v_lp = v - v_hp;
