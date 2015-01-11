
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


o2col = 27;
tcol = 12;
%zrng = [2 10];
zrng = [2 20];
xtickvals = datenum([2012,5,1;2012,6,1;2012,7,1;2012,8,1;2012,9,1;2012,10,1;2012,11,1;2012,12,1]);

%% Fit diel cycles
% p-value cutoff for significance
pcut = 0.05;
[S] = sg_dielo2('sg148',o2col,zrng);
dS = S.pvald < pcut;
uS = S.pvalu < pcut;
[S6] = sg_dielo2('sg146',o2col,zrng);
dS6 = S6.pvald < pcut;
uS6 = S6.pvalu < pcut;
[S5] = sg_dielo2('sg512',o2col,zrng);
dS5 = S5.pvald < pcut;
uS5 = S5.pvalu < pcut;

% [T] = sg_dielo2('sg148',o2col,zrng);
% dT = T.pvalds < pcut;
% uT = T.pvalus < pcut;
% [T6] = sg_dielo2('sg146',o2col,zrng);
% dT6 = T6.pvalds < pcut;
% uT6 = T6.pvalus < pcut;
% [T5] = sg_dielo2('sg512',o2col,zrng);
% dT5 = T5.pvalds < pcut;
% uT5 = T5.pvalus < pcut;

% speed of K1 tide (15.04 deg/hr
% spd = 15.0410686./15;
% dys = datenum(2012,5,1):datenum(2012,12,1);
% tspd = rem(dys./spd,1);
% tspd = rem(tspd+0.85-tspd(1),1);
%% smooth averages
iso2col = o2col == 14 || o2col == 27  || o2col == 26;
if iso2col
    allDaysAmp = [S.daysd(dS),S.ampd(dS);S.daysu(uS),S.ampu(uS);...
        S6.daysd(dS6),S6.ampd(dS6);S6.daysu(uS6),S6.ampu(uS6)];...
    allDaysPeak = [S.daysd(dS),S.peakd(dS);S.daysu(uS),S.peaku(uS);...
    S6.daysd(dS6),S6.peakd(dS6);S6.daysu(uS6),S6.peaku(uS6)];   
    uniqueDays = sort(unique([S.daysd;S.daysu;S6.daysd;S6.daysu]));
    uniqueDays(isnan(uniqueDays)) = [];
else
    allDaysAmp = [S.daysd(dS),S.ampd(dS);S.daysu(uS),S.ampu(uS);...
    S6.daysd(dS6),S6.ampd(dS6);S6.daysu(uS6),S6.ampu(uS6);...
    S5.daysd(dS5),S5.ampd(dS5);S5.daysu(uS5),S5.ampu(uS5)];
    
    allDaysPeak = [S.daysd(dS),S.peakd(dS);S.daysu(uS),S.peaku(uS);...
    S6.daysd(dS6),S6.peakd(dS6);S6.daysu(uS6),S6.peaku(uS6);...
    S5.daysd(dS5),S5.peakd(dS5);S5.daysu(uS5),S5.peaku(uS5)];
    uniqueDays = sort(unique([S.daysd;S.daysu;S6.daysd;S6.daysu;S5.daysd;S5.daysu]));
end

ndays = length(uniqueDays);
ampmean = nan(ndays,3);
ampmedian = nan(ndays,4);
peakmean = ampmean;
aveWindow = 5;
for ii = 1:ndays
    win = abs(allDaysAmp(:,1)-uniqueDays(ii)) < aveWindow;
    ampmean(ii,1) = nanmean(allDaysAmp(win,2));
    ampmean(ii,2) = nanstd(allDaysAmp(win,2));
    ampmean(ii,3) = sum(win);
    ampmedian(ii,1) = nanmedian(allDaysAmp(win,2));
    ampmedian(ii,2:3) = quantile(allDaysAmp(win,2),[0.1 0.9]);
    ampmedian(ii,4) = sum(win);
    winP =  abs(allDaysPeak(:,1)-uniqueDays(ii)) < aveWindow;
    peakmean(ii,1) = nanmean(allDaysPeak(winP,2));
    peakmean(ii,2) = nanstd(allDaysPeak(winP,2));
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

p2 = plot(S.daysd(dS),S.ampd(dS),'v','MarkerFaceColor',c1,'MarkerEdgeColor','none');
p3 = plot(ax1,S.daysu(uS),S.ampu(uS),'^','MarkerFaceColor',c1,'MarkerEdgeColor','none');
p4 = plot(ax1,S6.daysd(dS6),S6.ampd(dS6),'v','MarkerFaceColor',c2,'MarkerEdgeColor','none');
p5 = plot(ax1,S6.daysu(uS6),S6.ampu(uS6),'^','MarkerFaceColor',c2,'MarkerEdgeColor','none');
ylab = 'Diurnal amplitude (\mumol kg^{-1})';
yrng = [0 8];
if ~iso2col
    p6 = plot(ax1,S5.daysd(dS5),S5.ampd(dS5),'v','MarkerFaceColor',c3,'MarkerEdgeColor','none');
    p7 = plot(ax1,S5.daysu(uS5),S5.ampu(uS5),'^','MarkerFaceColor',c3,'MarkerEdgeColor','none');
    if o2col == 12
        ylab = 'Diurnal amplitude (\circC)';
        yrng = [0 0.25];
    elseif o2col == 23
        ylab = 'Relative fluorescence';
        yrng = [0 4];
    end
    
end

v = ~isnan(ampmean(:,1));
p1 = plot(uniqueDays(v),ampmedian(v,1),'Color','k','LineWidth',2);
%patch([uniqueDays(v);flip(uniqueDays(v))],[ampmean(v,1)-ampmean(v,2);flip(ampmean(v,1)+ampmean(v,2))],'k','FaceAlpha',0.25,'EdgeAlpha',0);
patch([uniqueDays(v);flip(uniqueDays(v))],[ampmedian(v,2);flip(ampmedian(v,3))],'k','FaceAlpha',0.25,'EdgeAlpha',0);

%plot(uniqueDays(v),ampmean(v,1)+ampmean(v,2),'Color','k','LineWidth',1);
%plot(uniqueDays(v),ampmean(v,1)-ampmean(v,2),'Color','k','LineWidth',1);
% 
% l1 = legend([p1,p2,p3],{'sg148','sg146','sg512'},'Location','NorthOutside','Orientation','horiz');
% end
%legend('boxoff');
%ylim(axes1,[0 24]);

set(ax1,'FontSize',14);
ylabel(ylab);
xlim([S.daysd(1)-10 S5.daysd(end)+10]);
ylim(yrng);
box on;
set(ax1,'layer','top','Xtick',xtickvals);
datetick('x','keepticks');

%%
% Phase plot
%
ax2 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'XTickLabel',[]);
hold all;


p1 = plot(S.daysd(dS),24.*S.peakd(dS),'v','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
p2 = plot(S.daysu(uS),24.*S.peaku(uS),'^','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
p3 = plot(S6.daysd(dS6),24.*S6.peakd(dS6),'v','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
p4 = plot(S6.daysu(uS6),24.*S6.peaku(uS6),'^','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');



if ~iso2col
    p5 = plot(S5.daysd(dS5),24.*S5.peakd(dS5),'v','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');
    p6 = plot(S5.daysu(uS5),24.*S5.peaku(uS5),'^','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');
    l1 = legend([p1,p3,p5],{'sg148','sg146','sg512'},'Location','NorthEast','Orientation','vertical');
else
    l1 = legend([p1,p3],{'sg148','sg146'},'Location','NorthEast','Orientation','vertical');
end
legend('boxoff');

ylabel('Phase of diurnal peak');

xlim([S.daysd(1)-10 S5.daysd(end)+10]);
ylim([0 24]);
box on;
set(ax2,'layer','top','Xtick',xtickvals);
datetick('x','keepticks');
set(ax2,'XTickLabel',[]);
% elseif strcmpi(plotvar,'T');
% p1 = plot(T.daysds(dT),24.*T.peakds(dT),'v','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
% p2 = plot(T6.daysds(dT6),24.*T6.peakds(dT6),'v','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
% p3 = plot(T5.daysds(dT5),24.*T5.peakds(dT5),'v','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');
% 
% plot(T.daysus(dT),24.*T.peakus(dT),'^','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
% plot(T6.daysus(dT6),24.*T6.peakus(dT6),'^','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
% plot(T5.daysus(dT5),24.*T5.peakus(dT5),'^','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');