

figpos = [1 1 14 16];
nplots_x = 1;
nplots_y = 3;
lmarg = 0.15;
rmarg = 0.15;
bmarg = .1;
tmarg = .05;
xgutter = .02;
ygutter = .04;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;

fontsz = 16;
lnw = 2;
cbw = 0.02; % colorbar width


lat = 22.75;
lon = 202;
tz = -10;

yrng1 = [2 50];
yrng2 = [-10 10];
xrng = [0 2];
clim1 = [-0.7 0.7];
clim2 = [-0.02 0.02];
clim3 = [-.1 0.1];


tlevs = linspace(-0.2,0.2,40);
clevs = linspace(-.04,.04,40);
olevs = linspace(-1,1,40);
%% fit diurnal cycles
o2col = 14;
tcol = 12;
chlcol = 19;
% zrng = [2 20];
% zrng = [20 40];
%dnrange = [datenum(2012,7,1) datenum(2012,8,1)];
nbins = 12;
%pK1 = 23.9345788179./24;
period = 1;
%tz = -10;

stageSgMld;

%DWN = [D146;D512];
%dwin = DWN(:,6) > dnrange(1) & DWN(:,6) < dnrange(2);






%DWN = D512;

%% composite of period
zbin = 1:50;


yrng1 = [zbin(1) zbin(end)];
median_O148 = nan(length(zbin),nbins+2);
median_T148 = median_O148;
median_O146 = median_O148;
median_T146 = median_O148;
median_T512 = median_O148;
countO148 =  median_O148;
countT148 =  median_O148;
countO146 =  median_O148;
countT146 =  median_O148;
countT512 =  median_O148;

%tref = t0_GMT+tz/24;
tref = datenum(2012,7,1)-tz/24;
for ii = 1:length(zbin)
    iz = D148(:,5) == zbin(ii);
    [ median_O148(ii,:),~,~,countO148(ii,:)] = dielcomp(D148(iz,6),D148(iz,o2col),nbins,period,tref);
    [ median_C148(ii,:),~,~,countC148(ii,:)] = dielcomp(D148(iz,6),D148(iz,chlcol),nbins,period,tref);
    [ median_T148(ii,:),~,~,countT148(ii,:)] = dielcomp(D148(iz,6),D148(iz,tcol),nbins,period,tref);
    iz = D146(:,5) == zbin(ii);
    [ median_O146(ii,:),~,~,countO146(ii,:)] = dielcomp(D146(iz,6),D146(iz,o2col),nbins,period,tref);
    [ median_C146(ii,:),~,~,countC146(ii,:)] = dielcomp(D146(iz,6),D146(iz,chlcol),nbins,period,tref);
    [ median_T146(ii,:),~,~,countT146(ii,:)] = dielcomp(D146(iz,6),D146(iz,tcol),nbins,period,tref);
    iz = D512(:,5) == zbin(ii);
    [ median_T512(ii,:),~,~,countT512(ii,:),bins] = dielcomp(D512(iz,6),D512(iz,tcol),nbins,period,tref);
    [ median_C512(ii,:),~,~,countC512(ii,:),bins] = dielcomp(D512(iz,6),D512(iz,chlcol),nbins,period,tref);
    %[ median_T(ii,:),meanT(ii,:),std4bin,count4bin,bins] = dielcomp(DWN(iz,6),DWN(iz,tcol),nbins,period,tref);
    %[ median_Td(ii,:),meanTd(ii,:),std4bin,count4bin,bins] = dielcomp(datenum(DWN(iz,6),1,1),DWN(iz,tcol),nbins,1,datenum(2012,1,1));
end

median_O = (countO148.*median_O148 + countO146.*median_O146) ./ (countO148 + countO146);
median_T = (countT148.*median_T148 + countT146.*median_T146 + countT512.*median_T512) ./ (countT148 + countT146 + countT512);
median_C = (countC148.*median_C148 + countC146.*median_C146 + countC512.*median_C512) ./ (countC148 + countC146 + countC512);
 %[ median_mld] = dielcomp(dmld(:,1),dmld(:,2), nbins,pK1,t0_GMT+tz/24);
 [median_mld] = compositePeriod(dmld(:,1),dmld(:,2), nbins,period,tref);
 [median_mldth] = compositePeriod(mld(:,1),mld(:,2), nbins,period,tref);



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
datetick('x','HH:MM','keepticks');
xlim(ax1,xrng);
set(ax1,'Layer','top','XTickRotation',45);

cb1 = colorbar(ax1);
set(cb1,'Position',[ax1.Position(1)+ax1.Position(3)+xgutter ax1.Position(2) cbw ax1.Position(4)]);
%xlim(ax2,xrng);
%ylim(ax1,yrng1);
%ylabel(ax1,'P+R (mmol m^{-3} d^{-1})');

ax2 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter awidth aheight],'FontSize',fontsz,'LineWidth',lnw);
hold all;
set(ax2,'Color','none','XtickLabel',[],'YDir','Reverse');
[C, h] = contourf(ax2,[bins,bins(3:end)+1],zbin,[median_C, median_C(:,3:end)],clevs);
caxis(ax2,clim2);
cb2 = colorbar(ax2);
set(cb2,'Position',[lmarg+awidth+xgutter ax2.Position(2) cbw aheight]);

set(h,'LineStyle','none');
plot(ax2,[bins,bins(3:end)+1],[median_mld,median_mld(3:end)],'k','LineWidth',2);
set(ax2,'XTick',xrng(1):(0.25):xrng(2));
xlim(ax2,xrng);
box on;
set(ax2,'Layer','top');


ylim(ax2,yrng1);
xlim(ax2,xrng);

ax3 = axes('Parent',figure1,'Position',[lmarg bmarg+2.*(aheight+ygutter) awidth aheight],'FontSize',fontsz,'LineWidth',lnw);
hold all;
set(ax3,'Color','none','XtickLabel',[],'YDir','Reverse');
[C, h] = contourf(ax3,[bins,bins(3:end)+1],zbin,[median_T, median_T(:,3:end)],tlevs);
caxis(ax3,clim3);
cb2 = colorbar(ax3);
set(cb2,'Position',[lmarg+awidth+xgutter ax3.Position(2) cbw aheight]);

set(h,'LineStyle','none');
plot(ax3,[bins,bins(3:end)+1],[median_mld,median_mld(3:end)],'k','LineWidth',2);
set(ax3,'XTick',xrng(1):(0.25):xrng(2));
xlim(ax3,xrng);
box on;
set(ax3,'Layer','top');


ylim(ax3,yrng1);
xlim(ax3,xrng);

ax4 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+.01 awidth ygutter-0.02],'FontSize',fontsz,'LineWidth',lnw,'Visible','off');
hold all;
patch(tref+1+tz/24+[0 2 2 0],[-1 -1 1 1],[0.5 0.5 0.5],'LineStyle','none');
plotdiel(tref+1,[tref+1, tref+2]',[-1 1],22.75,-158,tz,'LineStyle','none');

ax5 = axes('Parent',figure1,'Position',[lmarg bmarg+2.*aheight+ygutter+.01 awidth ygutter-0.02],'FontSize',fontsz,'LineWidth',lnw,'Visible','off');
hold all;
patch(tref+1+tz/24+[0 2 2 0],[-1 -1 1 1],[0.5 0.5 0.5],'LineStyle','none');
plotdiel(tref+1,[tref+1, tref+2]',[-1 1],22.75,-158,tz,'LineStyle','none');

% area(ax3,[tk1 tk1+1],[k1 k1+(k1(end)-k1(1))],ax3.YLim(1),'FaceColor',[0.7 0.7 0.7],'LineStyle','none');


