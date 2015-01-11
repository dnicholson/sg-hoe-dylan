function [ O2eq_day,dO2 ] = dailysatanom( dn,o2,o2eq )

O2eq_day = NaN.*o2eq;
days = unique(floor(dn));
nd = length(days);
for ii = 1:nd
    d = floor(dn) == days(ii);
    O2eq_day(d) = nanmean(o2eq(d));
end
dO2 = o2-O2eq_day;

