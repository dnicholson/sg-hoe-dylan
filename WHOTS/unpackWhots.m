function [ dn,z,S,T ] = unpackWhots( whotsid )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


%% UNFINISHED -- time vectors are slightly different due to numerical rounding...
depths = [15;25;35;40;45;50;55;65;75;85;105;135;155];
nz = length(depths);

fname = ['OS_WHOTS_', whotsid, '_D_MICROCAT-', num2str(depths(1),'%03d'), 'm' '.nc'];
t1 = ncread(fname,'TIME');
S = NaN(length(t1),nz);
T = NaN(length(t1),nz);
z = NaN(nz,1);
for ii = 1:nz
    fname = ['OS_WHOTS_', whotsid, '_D_MICROCAT-', num2str(depths(ii),'%03d'), 'm' '.nc'];
    t = ncread(fname,'TIME');
    [~,it] = intersect(t1,t);
    sz = ncread(fname,'PSAL');
    S(it,ii) = sz;
    %slen(ii) = length(S);
    tz = ncread(fname,'TEMP');
    T(it,ii) = tz;
    %tlen(ii) = length(T);
    z(ii) = ncread(fname,'DEPTH');
end
%t = ncread(fname,'TIME');
dn = datenum(2012,1,1)+t1;


