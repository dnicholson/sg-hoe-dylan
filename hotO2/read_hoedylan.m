function [] = read_hoedylan(crn)

%
load stationMap;
hoedylan = importdata(['hoedylan' num2str(crn) '.gof'],' ',4);
%load hoedylan_header.mat;
hoe_data = hoedylan.data;
hoe_data(hoe_data(:) == -9) = NaN;

[cast2time, headtype] = loadcruise(crn);
load([headtype,'header.mat']);

istn = strcmpi('STNNBR',header(1,:));
icast = strcmpi('CASTNO',header(1,:));
ibot = strcmpi('ROSETTE',header(1,:));
ilat = strcmpi('LAT',header(1,:));
ilon = strcmpi('LON',header(1,:));
ipress = strcmpi('CTDPRS',header(1,:));
iT = strcmpi('CTDTMP',header(1,:));
iS = strcmpi('CTDSAL',header(1,:));
iO2 = strcmpi('OXYGEN',header(1,:));


hoe.crn = crn;
hoe.station = hoe_data(:,istn);
hoe.cast = str2double(cellstr([num2str(hoe_data(:,istn),'%02d') num2str(hoe_data(:,icast),'%03d')]));
hoe.bot = str2double(cellstr([num2str(hoe_data(:,istn),'%02d') num2str(hoe_data(:,icast),'%03d') num2str(hoe_data(:,ibot),'%02d')]));
%hoe.lat = station2lat(hoe.station);
%hoe.lon = station2lon(hoe.station);
hoe.z = sw_dpth(hoe_data(:,ipress),22.75);
hoe.S  = hoe_data(:,iS);
hoe.T  = hoe_data(:,iT);
hoe.lon = hoe_data(:,ilon);
hoe.O2 = hoe_data(:,iO2);
hoe.O2eq = O2sol(hoe.S,hoe.T);

% why doesn't vector work here?
for ii = 1:length(hoe.cast);
    hoe.t(ii,1) = cast2time(hoe.cast(ii));
    hoe.lat(ii,1) = station2lat(hoe.station(ii));
    hoe.lon(ii,1) = station2lon(hoe.station(ii));
end

save(['hoedylan' num2str(crn)],'hoe');

function [cast2time, crtype] = loadcruise(crn)
%%%% in progress ***
hoedylan = importdata(['hoedylan' num2str(crn) '.gof'],' ',4);
fileID = fopen(['hoedylan' num2str(crn) '.sum'],'r');
startRow = 5;
switch crn
    case {2,4,6,8,10}
        crtype = 'hot';
        stacol = 3;
        castcol = 4;
        datecol = 6;
        tcol = 7;
        formatSpec = '%9s%6s%5s%4s%6s%7s%5s%4s%4s%6s%2s%5s%6s%2s%5s%6s%5s%5s%7s%13s%8s%3s%2s%s%[^\n\r]';
        
        dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
        dstring=strcat((dataArray{:,datecol}), (dataArray{:,tcol}));
        sum_time = dec_year(datenum(dstring,'mmddyyHHMM'));
        sum_cast = 1000.*str2double(dataArray{:,stacol})+str2double(dataArray{:,castcol});
        
    case {1,5,7,9,11}
        crtype = 'hoe';
        stacol = 1;
        castcol = 2;
        mocol = 3;
        dycol = 4;
        yrcol = 5;
        tcol = 6;
        formatSpec = '%3f%4f%6s%3f%5f%9s%4f%7f%2s%5f%7f%2s%9f%f%[^\n\r]';
        dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
        dstring = strcat(num2str(dataArray{:,dycol}),dataArray{:,mocol},num2str(dataArray{:,yrcol}),dataArray{:,tcol});
        sum_time = dec_year(datenum(dstring,'ddmmmyyyyHH:MM:SS'));
        sum_cast = 1000.*dataArray{:,stacol}+dataArray{:,castcol};
    otherwise
        error('unknown cruise number');
end
        
cast2time = containers.Map(sum_cast',sum_time');