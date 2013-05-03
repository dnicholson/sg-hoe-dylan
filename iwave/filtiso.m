function [t z_hp z_lp] = filtiso(DWN,t_ind,z_ind,surf)

% z_ind = 5;
% t_ind = 6;
% freq cutoff (in y-1)
f_cutoff = 365./2;


d = find(abs(DWN(:,10)-surf) < 0.01);
t = DWN(d,t_ind);
z = DWN(d,z_ind)-mean(DWN(d,z_ind));
dt = median(diff(t));
% Nyquist frequency
fN = 1/(2.*dt);
Wn = f_cutoff./fN;
[b,a] = butter(9,Wn,'high');
z_hp = filtfilt(b,a,z);
z_lp = z - z_hp;
