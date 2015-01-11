

figpos = [1 1 14 10];
nplots_x = 1;
nplots_y = 2;
lmarg = 0.15;
rmarg = 0.15;
bmarg = .1;
tmarg = .05;
xgutter = .02;
ygutter = .2;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;

fontsz = 12;
lnw = 2;
cbw = 0.02; % colorbar width


lat = 22.75;
lon = 202;
tz = -10;

yrng1 = [2 50];
yrng2 = [-10 10];
xrng = [0 2];
clim1 = [-0.7 0.7];

clim2 = [-.1 0.1];
tlevs = linspace(-0.2,0.2,40);
olevs = linspace(-2,2,40);
%% fit diurnal cycles
o2col = 14;
tcol = 12;
% zrng = [2 20];
% zrng = [20 40];
dnrange = [datenum(2012,7,1) datenum(2012,8,1)];
nbins = 12;
%pK1 = 23.9345788179./24;
pK1 = 1;
tz = -10;


stageSgMld;

DWN = [D146;D148;D512];
%DWN = [D146;D512];
dwin = DWN(:,6) > dnrange(1) & DWN(:,6) < dnrange(2);
DWN = DWN(dwin,:);

DWNO = [D146;D148];
%DWNO = [D146];
dwino = DWNO(:,6) > dnrange(1) & DWNO(:,6) < dnrange(2);
DWNO = DWNO(dwino,:);

%DWN = D512;
%% calculate tidal constituents
ut_kbtidalcomp;
k1 = k1-mean(k1);
%% composite of period
zbin = 1:50;
median_O = nan(length(zbin),nbins+2);
median_T = median_O;
median_Od = median_O;
%tref = t0_GMT+tz/24;
tref = datenum(2012,2,1)+tz/24;
for ii = 1:length(zbin)
    izo = DWNO(:,5) == zbin(ii);
    iz = DWN(:,5) == zbin(ii);
    [ median_O(ii,:)] = dielcomp(DWNO(izo,6),DWNO(izo,o2col),nbins,pK1,tref);
    [ median_Od(ii,:)] = dielcomp(DWN(izo,6),DWN(iz,o2col),nbins,1,tref);
    [ median_T(ii,:),meanT(ii,:),std4bin,count4bin,bins] = dielcomp(DWN(iz,6),DWN(iz,tcol),nbins,pK1,tref);
    %[ median_Td(ii,:),meanTd(ii,:),std4bin,count4bin,bins] = dielcomp(datenum(DWN(iz,6),1,1),DWN(iz,tcol),nbins,1,datenum(2012,1,1));
end
 %[ median_mld] = dielcomp(dmld(:,1),dmld(:,2), nbins,pK1,t0_GMT+tz/24);
 [median_mld] = compositePeriod(dmld(:,1),dmld(:,2), nbins,pK1,tref);
 [median_mldth] = compositePeriod(mld(:,1),mld(:,2), nbins,pK1,tref);



%% Create figure
figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);

% Upper plot

ax1 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'YDir','Reverse');
hold all;
c1 = ax1.ColorOrder(1,:);
c2 = ax1.ColorOrder(2,:);
c3 = ax1.ColorOrder(3,:);
c4 = ax1.ColorOrder(4,:);


ylim(ax1,yrng1);
%area(ax1,tk1,k1,ax1.YLim(1),'FaceColor',[0.7 0.7 0.7],'LineStyle','none');
[C, h] = contourf(ax1,[bins,bins(3:end)+1],zbin,[median_O, median_O(:,3:end)],olevs);
caxis(ax1,clim1);
colorbar;
set(h,'LineStyle','none');
hold on;
plot(ax1,[bins,bins(3:end)+1],[median_mld,median_mld(3:end)],'k','LineWidth',2);
%plot(ax1,bins,10.*median_T,'LineWidth',lnw+1);
%plot(ax2,bins,-median_mld,'LineWidth',lnw+1,'Color',c4);


box on;
set(ax1,'XTick',xrng(1):(0.25):xrng(2));
xlim(ax1,xrng);
set(ax1,'Layer','top');

cb1 = colorbar(ax1);
set(cb1,'Position',[ax1.Position(1)+ax1.Position(3)+xgutter ax1.Position(2) cbw ax1.Position(4)]);
%xlim(ax2,xrng);
%ylim(ax1,yrng1);
%ylabel(ax1,'P+R (mmol m^{-3} d^{-1})');

ax2 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter awidth aheight],'FontSize',fontsz,'LineWidth',lnw);
hold all;
set(ax2,'Color','none','XtickLabel',[],'YDir','Reverse');
[C, h] = contourf(ax2,[bins,bins(3:end)+1],zbin,[median_T, median_T(:,3:end)],tlevs);
caxis(ax2,clim2);
cb2 = colorbar(ax2);
set(cb2,'Position',[lmarg+awidth+xgutter ax2.Position(2) cbw aheight]);

set(h,'LineStyle','none');
plot(ax2,[bins,bins(3:end)+1],[median_mld,median_mld(3:end)],'k','LineWidth',2);
set(ax2,'XTick',xrng(1):(0.25):xrng(2));
xlim(ax2,xrng);
box on;
set(ax2,'Layer','top');

ax3 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+.01 awidth ygutter-0.02],'FontSize',fontsz,'LineWidth',lnw,'Visible','off');
hold all;
area(ax3,[tk1 tk1+1],[k1 k1+(k1(end)-k1(1))],ax3.YLim(1),'FaceColor',[0.7 0.7 0.7],'LineStyle','none');


xlim(ax2,xrng);
