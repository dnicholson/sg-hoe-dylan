function [zmld, iml] = calcmld(dens,z,dens_off)

% density offset threshold (kg/m3)
%dens_off = 0.125;

t = size(dens,2);
zmld = zeros(t,1);
iml = zeros(t,1);
for i = 1:t
    surfz = z <= 5 & z >= 3;
    dens0 = nanmean(dens(surfz,i));
    ml = find(dens(5:end,i) -dens0 > dens_off,1,'first')+4;
    try
        zmld(i) = z(ml);
        iml(i) = ml;
    catch
        zmld(i) = z(end);
        iml(i) = length(z);
    end
end
    