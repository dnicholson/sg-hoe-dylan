function [] = read_hot_mrkoxy(crn)


hotoxy = importdata(['hot' num2str(crn) '.oxy'],' ',3);
hotmrk = importdata(['hot' num2str(crn) '.mrk']);
oxy = hotoxy.data;


hot.z = oxy(:,5);
hot.O2 = oxy(:,6);

for ii = 1:length(oxy)
    % find matching day/cast/bottle
    d = find(oxy(ii,2) == hotmrk(:,1) & oxy(ii,3) == hotmrk(:,2) & oxy(ii,4) == hotmrk(:,3));
    %append salinity and temperature from mrk file
    oxy(ii,8) = hotmrk(d,9);
    oxy(ii,9) = hotmrk(d,7);
    oxy(ii,10:11) = hotmrk(d,4:5);
end

hotdn = datenum([num2str(oxy(:,10),'%06d') num2str(oxy(:,11),'%06d')],'mmddyyHHMMSS');

hot.crn = crn;
hot.cast = str2double(cellstr([num2str(oxy(:,2),'%02d') num2str(oxy(:,3),'%03d')]));
hot.bot = str2double(cellstr([num2str(oxy(:,2),'%02d') num2str(oxy(:,3),'%03d') num2str(oxy(:,4),'%02d')]));
hot.t = dec_year(hotdn);
hot.S = oxy(:,8);
hot.T = oxy(:,9);
hot.O2eq = O2sol(oxy(:,8),oxy(:,9));
save(['hot' num2str(crn)],'hot');