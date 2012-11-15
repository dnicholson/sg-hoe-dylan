function [] = read_hoedylan(crn)


hoedylan = importdata(['hoedylan' num2str(crn) '.gof'],' ',4);
hoesum = importdata(['hoedylan' num2str(crn) '.sum'],' ',4);
load hoedylan_header.mat;

hoe_data = hoedylan.data;
hsum = hoesum.textdata(5:end,:);
hoe_dstr = strcat(hsum(:,4),hsum(:,3),hsum(:,5),hsum(:,6));

sum_time = dec_year(datenum(hoe_dstr,'ddmmmyyyyHH:MM:SS'));
sum_cast = 1000.*str2double(hsum(:,1))+str2double(hsum(:,2));

cast2time = containers.Map(sum_cast',sum_time');

istn = strcmpi('STNNBR',hoedylan_header(1,:));
icast = strcmpi('CASTNO',hoedylan_header(1,:));
ibot = strcmpi('ROSETTE',hoedylan_header(1,:));
ilat = strcmpi('LAT',hoedylan_header(1,:));
ilon = strcmpi('LON',hoedylan_header(1,:));
ipress = strcmpi('CTDPRS',hoedylan_header(1,:));
iT = strcmpi('CTDTMP',hoedylan_header(1,:));
iS = strcmpi('CTDSAL',hoedylan_header(1,:));
iO2 = strcmpi('OXYGEN',hoedylan_header(1,:));


hoe.crn = crn;
hoe.cast = str2double(cellstr([num2str(hoe_data(:,istn),'%02d') num2str(hoe_data(:,icast),'%03d')]));
hoe.bot = str2double(cellstr([num2str(hoe_data(:,istn),'%02d') num2str(hoe_data(:,icast),'%03d') num2str(hoe_data(:,ibot),'%02d')]));
hoe.lat = hoe_data(:,ilat);
hoe.lon = hoe_data(:,ilon);
hoe.z = sw_dpth(hoe_data(:,ipress),hoe.lat);
hoe.S  = hoe_data(:,iS);
hoe.T  = hoe_data(:,iT);
hoe.lon = hoe_data(:,ilon);
hoe.O2 = hoe_data(:,iO2);
hoe.O2eq = O2sol(hoe.S,hoe.T);

% why doesn't vector work here?
for ii = 1:length(hoe.cast);
    hoe.t(ii,1) = cast2time(hoe.cast(ii));
end


save(['hoedylan' num2str(crn)],'hoe');