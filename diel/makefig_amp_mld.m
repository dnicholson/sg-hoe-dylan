
figpos = [1 1 12 20];
fontsz = 14;
lnw = 2;
mkz = 5;
nplots_x = 1;
nplots_y = 2;
lmarg = 0.2;
rmarg = 0.05;
bmarg = .1;
tmarg = .05;
xgutter = .06;
ygutter = .04;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;



%zrng = [2 10];
zrng = [2 20];
xtickvals = datenum([2012,5,1;2012,6,1;2012,7,1;2012,8,1;2012,9,1;2012,10,1;2012,11,1;2012,12,1]);

stageSgMld;
%%
period  = 23.9345788179./24;
tz = -10;
load t0_GMT;
dn_hi = t0_GMT+(tz-6)./24;
pcut = 0.05;

dnt = dmld1;
mldz = dmld1(:,2);
d = ~isnan(mldz);
[ days1,amp1,peak1, offs, vari, errval,pval1] = dielsinefit( dnt(d),-mldz(d),period );
gd1 = pval1 < pcut;

dnt = dmld2;
mldz = dmld2(:,2);
d = ~isnan(mldz);
[ days2,amp2,peak2, offs, vari, errval,pval2] = dielsinefit( dnt(d),-mldz(d),period );
gd2 = pval2 < pcut;

dnt = datenum(dmld3(:,1),1,1);
mldz = dmld3(:,2);
d = ~isnan(mldz);
[ days3,amp3,peak3, offs, vari, errval,pval3] = dielsinefit( dnt(d),-mldz(d),period );
gd3 = pval3 < pcut;

% up mld
dnt = umld1;
mldz = umld1(:,2);
d = ~isnan(mldz);
[ udays1,uamp1,upeak1, uoffs, uvari, uerrval,upval1] = dielsinefit( dnt(d),-mldz(d),period );
gu1 = upval1 < pcut;


daysAll = [days1 days2 days3]';
uniqueDays = unique(daysAll);
ampAll = [amp1; amp2; amp3];
peakAll = [peak1; peak2; peak3];

ndays = length(uniqueDays);
ampmean = nan(ndays,3);
ampmedian = nan(ndays,4);
peakmean = ampmean;
aveWindow = 3;
for ii = 1:ndays
    win = abs(daysAll-uniqueDays(ii)) < aveWindow;
    ampmean(ii,1) = nanmean(ampAll(win));
    ampmean(ii,2) = nanstd(ampAll(win));
    ampmean(ii,3) = sum(win);
    ampmedian(ii,1) = nanmedian(ampAll(win));
    ampmedian(ii,2:3) = quantile(ampAll(win),[0.1 0.9]);
    ampmedian(ii,4) = sum(win);
    winP =  abs(daysAll-uniqueDays(ii)) < aveWindow;
    peakmean(ii,1) = nanmean(peakAll(winP));
    peakmean(ii,2) = nanstd(peakAll(winP));
    peakmean(ii,3) = sum(winP);
end
    


%% create figure
figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);
ax1 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],'FontSize',fontsz,'LineWidth',lnw);

hold all;
colors = get(ax1,'ColorOrder');
c1 = colors(1,:);
c2 = colors(2,:);
c3 = colors(3,:);

p2 = plot(ax1,days1(gd1),amp1(gd1),'o','MarkerFaceColor',c1,'MarkerEdgeColor','none');
p3 = plot(ax1,days2(gd2),amp2(gd2),'o','MarkerFaceColor',c2,'MarkerEdgeColor','none');
p4 = plot(ax1,days3(gd3),amp3(gd3),'o','MarkerFaceColor',c3,'MarkerEdgeColor','none');
%p4 = 
% p4 = plot(ax1,S6.daysds(dS6),S6.ampds(dS6),'v','MarkerFaceColor',c2,'MarkerEdgeColor','none');
% p5 = plot(ax1,S6.daysus(uS6),S6.ampus(uS6),'^','MarkerFaceColor',c2,'MarkerEdgeColor','none');
ylab = 'Diurnal amplitude (m)';
yrng = [0 50];
    


%%
v = ~isnan(ampmean(:,1));
p1 = plot(uniqueDays(v),ampmedian(v,1),'Color','k','LineWidth',2);
%patch([uniqueDays(v);flip(uniqueDays(v))],[ampmean(v,1)-ampmean(v,2);flip(ampmean(v,1)+ampmean(v,2))],'k','FaceAlpha',0.25,'EdgeAlpha',0);
patch([uniqueDays(v);flip(uniqueDays(v))],[ampmedian(v,2);flip(ampmedian(v,3))],'k','FaceAlpha',0.25,'EdgeAlpha',0);


set(ax1,'FontSize',14);
ylabel(ylab);
xlim([uniqueDays(1)-10 uniqueDays(end)+10]);
ylim(ax1,yrng);
box on;
set(ax1,'layer','top','Xtick',xtickvals);
datetick('x','keepticks');

%%
% Phase plot
%
ax2 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'XTickLabel',[]);
hold all;

% speed of K1 tide (15.04 deg/hr) k1 tidal period = 23.934... hrs)
period  = 23.9345788179./24;
load t0_GMT;
dn_hi = t0_GMT+(tz-6)./24;
%spd = 15.0410686./15;
dys = datenum(2012,5,1):datenum(2012,12,1);
tspd = mod((dys-dn_hi).*period,1);
tspd_lo = rem((dys-dn_hi-0.5).*period,1);

%tspd = rem(tspd+0.85-tspd(1),1);
plot(dys,24.*tspd,'LineWidth',lnw+1,'Color',[0.5 0.5 0.5]);
plot(dys,24.*(tspd-0.5),'LineWidth',lnw+1,'Color',[0.5 0.5 0.5],'LineStyle','--');

p1 = plot(days1(gd1),24.*peak1(gd1),'o','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
p2 = plot(days2(gd2),24.*peak2(gd2),'o','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
p3 = plot(days3(gd3),24.*peak3(gd3),'o','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');
 %plot(udays1(gu1),24.*upeak1(gu1),'^','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
% p3 = plot(S6.daysds(dS6),24.*S6.peakds(dS6),'v','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
% p4 = plot(S6.daysus(dS6),24.*S6.peakus(dS6),'^','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');


l1 = legend([p1,p2,p3],{'sg148','sg146','sg512'},'Location','NorthEast','Orientation','vertical');

legend('boxoff');

ylabel('Phase of diurnal peak');

xlim([uniqueDays(1)-10 uniqueDays(end)+10]);
ylim([0 24]);
box on;
set(ax2,'layer','top','Xtick',xtickvals);
datetick('x','keepticks');
set(ax2,'XTickLabel',[]);
