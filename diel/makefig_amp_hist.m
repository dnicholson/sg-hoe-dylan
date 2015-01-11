
figpos = [1 1 12 30];
fontsz = 14;
lnw = 2;
mkz = 5;
nplots_x = 1;
nplots_y = 3;
lmarg = 0.2;
rmarg = 0.05;
bmarg = .05;
tmarg = .03;
xgutter = .06;
ygutter = .02;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;



varname1 = 'o2anom';
%varname1 = 'optode_dphase_oxygenc';
varname2 = 'tempc';
varname3 = 'chl_bbfl2';

tcol = 12;
%zrng = [2 10];

zrng = [5 40];
yrngO = [0 10];
yrngT = [0 0.2];
yrngchl = [0 0.08];
xtickvals = datenum([2012,5,1;2012,6,1;2012,7,1;2012,8,1;2012,9,1;2012,10,1;2012,11,1;2012,12,1]);

%% Fit diel cycles
% p-value cutoff for significance
pcut = 0.05;
[S] = sg_dielo2_name('sg148',varname1,zrng,'timezone',-10);
dS = S.pvald < pcut & ((S.peakd < 0.15) | (S.peakd > 0.85));
uS = S.pvalu < pcut & ((S.peaku < 0.15) | (S.peaku > 0.85));
[S6] = sg_dielo2_name('sg146',varname1,zrng,'timezone',-10);
dS6 = S6.pvald < pcut & ((S6.peakd < 0.15) | (S6.peakd > 0.85));
uS6 = S6.pvalu < pcut & ((S6.peaku < 0.15) | (S6.peaku > 0.85));
% [S5] = sg_dielo2_name('sg512',varname1,zrng,'timezone',-10);
% dS5 = S5.pvald < pcut;
% uS5 = S5.pvalu < pcut;
% if strcmpi(varname1,'optode_dphase_oxygenc') || strcmpi(varname1,'o2anom')
%     dS5 = [];
%     uS5 = [];
% end

[C] = sg_dielo2_name('sg148',varname3,zrng,'timezone',-10);
dC = C.pvald < pcut;
uC = C.pvalu < pcut;
[C6] = sg_dielo2_name('sg146',varname3,zrng,'timezone',-10);
dC6 = C6.pvald < pcut;
uC6 = C6.pvalu < pcut;
[C5] = sg_dielo2_name('sg512',varname3,zrng,'timezone',-10);
dC5 = C5.pvald < pcut;
uC5 = C5.pvalu < pcut;
if strcmpi(varname3,'optode_dphase_oxygenc') || strcmpi(varname3,'o2anom')
    dC5 = [];
    uC5 = [];
end

[T] = sg_dielo2_name('sg148',varname2,zrng,'timezone',-10);
dT = T.pvald < pcut;
uT = T.pvalu < pcut;
[T6] = sg_dielo2_name('sg146',varname2,zrng,'timezone',-10);
dT6 = T6.pvald < pcut;
uT6 = T6.pvalu < pcut;
[T5] = sg_dielo2_name('sg512',varname2,zrng,'timezone',-10);
dT5 = T5.pvald < pcut;
uT5 = T5.pvalu < pcut;

xrng = [T.daysd(1)-5 T5.daysd(end)-5];
%% smooth averages

allDaysAmpO = [S.daysd(dS),S.ampd(dS);S.daysu(uS),S.ampu(uS);...
    S6.daysd(dS6),S6.ampd(dS6);S6.daysu(uS6),S6.ampu(uS6);...
    S5.daysd(dS5),S5.ampd(dS5);S5.daysu(uS5),S5.ampu(uS5)];
    
allDaysPeakO = [S.daysd(dS),S.peakd(dS);S.daysu(uS),S.peaku(uS);...
    S6.daysd(dS6),S6.peakd(dS6);S6.daysu(uS6),S6.peaku(uS6);...
    S5.daysd(dS5),S5.peakd(dS5);S5.daysu(uS5),S5.peaku(uS5)];
    
allDaysAmpC = [C.daysd(dC),C.ampd(dC);C.daysu(uC),C.ampu(uC);...
    C6.daysd(dC6),C6.ampd(dC6);C6.daysu(uC6),C6.ampu(uC6);...
    C5.daysd(dC5),C5.ampd(dC5);C5.daysu(uC5),C5.ampu(uC5)];
    
allDaysPeakC = [C.daysd(dC),C.peakd(dC);C.daysu(uC),C.peaku(uC);...
    C6.daysd(dC6),C6.peakd(dC6);C6.daysu(uC6),C6.peaku(uC6);...
    C5.daysd(dC5),C5.peakd(dC5);C5.daysu(uC5),C5.peaku(uC5)];   

allDaysAmpT = [T.daysd(dT),T.ampd(dT);T.daysu(uT),T.ampu(uT);...
    T6.daysd(dT6),T6.ampd(dT6);T6.daysu(uT6),T6.ampu(uT6);...
    T5.daysd(dT5),T5.ampd(dT5);T5.daysu(uT5),T5.ampu(uT5)];

allDaysPeakT = [T.daysd(dT),T.peakd(dT);T.daysu(uT),T.peaku(uT);...
    T6.daysd(dT6),T6.peakd(dT6);T6.daysu(uT6),T6.peaku(uT6);...
    T5.daysd(dT5),T5.peakd(dT5);T5.daysu(uT5),T5.peaku(uT5)];

aveWindow = 5;
[ uniqueDaysO,ampmeanO,ampmedianO ] = windowAve( allDaysAmpO(:,1),allDaysAmpO(:,2),aveWindow );
[ uniqueDaysC,ampmeanC,ampmedianC ] = windowAve( allDaysAmpC(:,1),allDaysAmpC(:,2),aveWindow );
[ uniqueDaysT,ampmeanT,ampmedianT ] = windowAve( allDaysAmpT(:,1),allDaysAmpT(:,2),aveWindow );
    


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
if ~(strcmpi(varname1,'optode_dphase_oxygenc') || strcmpi(varname1,'o2anom'))
    p6 = plot(ax1,S5.daysd(dS5),S5.ampd(dS5),'v','MarkerFaceColor',c3,'MarkerEdgeColor','none');
    p7 = plot(ax1,S5.daysu(uS5),S5.ampu(uS5),'^','MarkerFaceColor',c3,'MarkerEdgeColor','none');
end
ylab = 'GPP (mmol m^{-3} d^{-1})';


v = ~isnan(ampmeanO(:,1));
p1 = plot(uniqueDaysO(v),ampmedianO(v,1),'Color','k','LineWidth',3);
%patch([uniqueDays(v);flip(uniqueDays(v))],[ampmean(v,1)-ampmean(v,2);flip(ampmean(v,1)+ampmean(v,2))],'k','FaceAlpha',0.25,'EdgeAlpha',0);
patch([uniqueDaysO(v);flip(uniqueDaysO(v))],[ampmedianO(v,2);flip(ampmedianO(v,3))],'k','FaceAlpha',0.25,'EdgeAlpha',0);


set(ax1,'FontSize',14);
ylabel(ylab);
ylim(yrngO);
box on;
set(ax1,'layer','top','Xtick',xtickvals);
datetick('x','keepticks');
xlim(xrng);

%%
% Phase plot
%
ax2 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'XTickLabel',[]);
hold all;


p2 = plot(ax2,C.daysd(dC),C.ampd(dC),'v','MarkerFaceColor',c1,'MarkerEdgeColor','none');
p3 = plot(ax2,C.daysu(uC),C.ampu(uC),'^','MarkerFaceColor',c1,'MarkerEdgeColor','none');
p4 = plot(ax2,C6.daysd(dC6),C6.ampd(dC6),'v','MarkerFaceColor',c2,'MarkerEdgeColor','none');
p5 = plot(ax2,C6.daysu(uC6),C6.ampu(uC6),'^','MarkerFaceColor',c2,'MarkerEdgeColor','none');
p6 = plot(ax2,C5.daysd(dC5),C5.ampd(dC5),'v','MarkerFaceColor',c3,'MarkerEdgeColor','none');
p7 = plot(ax2,C5.daysu(uC5),C5.ampu(uC5),'^','MarkerFaceColor',c3,'MarkerEdgeColor','none');

v = ~isnan(ampmeanC(:,1));
p1 = plot(uniqueDaysC(v),ampmedianC(v,1),'Color','k','LineWidth',3);
%patch([uniqueDays(v);flip(uniqueDays(v))],[ampmean(v,1)-ampmean(v,2);flip(ampmean(v,1)+ampmean(v,2))],'k','FaceAlpha',0.25,'EdgeAlpha',0);
patch([uniqueDaysC(v);flip(uniqueDaysC(v))],[ampmedianC(v,2);flip(ampmedianC(v,3))],'k','FaceAlpha',0.25,'EdgeAlpha',0);

ylabel('Amplitude of diel chl (\mug L^{-1})');


ylim(yrngchl);
box on;
set(ax2,'layer','top','Xtick',xtickvals);
datetick('x','keepticks');
xlim(xrng);
set(ax2,'XTickLabel',[]);


ax3 = axes('Parent',figure1,'Position',[lmarg bmarg+2.*(aheight+ygutter) awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'XTickLabel',[]);
hold all;


p2 = plot(ax3,T.daysd(dT),T.ampd(dT),'v','MarkerFaceColor',c1,'MarkerEdgeColor','none');
p3 = plot(ax3,T.daysu(uT),T.ampu(uT),'^','MarkerFaceColor',c1,'MarkerEdgeColor','none');
p4 = plot(ax3,T6.daysd(dT6),T6.ampd(dT6),'v','MarkerFaceColor',c2,'MarkerEdgeColor','none');
p5 = plot(ax3,T6.daysu(uT6),T6.ampu(uT6),'^','MarkerFaceColor',c2,'MarkerEdgeColor','none');
p6 = plot(ax3,T5.daysd(dT5),T5.ampd(dT5),'v','MarkerFaceColor',c3,'MarkerEdgeColor','none');
p7 = plot(ax3,T5.daysu(uT5),T5.ampu(uT5),'^','MarkerFaceColor',c3,'MarkerEdgeColor','none');

v = ~isnan(ampmeanT(:,1));
p1 = plot(uniqueDaysT(v),ampmedianT(v,1),'Color','k','LineWidth',3);
%patch([uniqueDays(v);flip(uniqueDays(v))],[ampmean(v,1)-ampmean(v,2);flip(ampmean(v,1)+ampmean(v,2))],'k','FaceAlpha',0.25,'EdgeAlpha',0);
patch([uniqueDaysT(v);flip(uniqueDaysT(v))],[ampmedianT(v,2);flip(ampmedianT(v,3))],'k','FaceAlpha',0.25,'EdgeAlpha',0);

l1 = legend(ax3,[p2,p4,p6],{'sg148','sg146','sg512'},'Location','NorthEast','Orientation','vertical');

legend('boxoff');

ylabel('Amplitude of diel T (\circC)');


ylim(yrngT);
box on;
set(ax3,'layer','top','Xtick',xtickvals);
datetick('x','keepticks');
xlim(xrng);
set(ax3,'XTickLabel',[]);



%%
% Phase plot
%
figure2 = figure;
set(figure2,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);
xrng = [0 24];
xtick = 0:3:24;
yrng3 = [0 25];
yrng4 = [0 90];

ax4 = axes('Parent',figure2,'Position',[lmarg bmarg awidth aheight],'FontSize',fontsz,'LineWidth',lnw);
hold all;

dbin = 1;
bins = [0-dbin/2:dbin:24+dbin];
rs = suncycle(22.75,-158,allDaysPeakO(:,1));
sunset_loc = mod(rs(:,2)+tz,24);
peakoff = (mod(24.*allDaysPeakO(:,2)+sunset_loc,24));
h1 = histogram(peakoff,bins);
box on;
set(ax4,'XTick',xtick);
xlim(xrng);
ylim(yrng3);

ax5 = axes('Parent',figure2,'Position',[lmarg bmarg+aheight+ygutter awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'XTickLabel',[]);
hold all;

rs = suncycle(22.75,-158,allDaysPeakC(:,1));
peakoff = rem(24.*(allDaysPeakC(:,2)+0.5),24);
%bins = [-12.5:1:12.5];
h2 = histogram(peakoff,bins);
set(ax5,'XTick',xtick);
box on;
xlim(xrng);
ylim(yrng4);

ax6 = axes('Parent',figure2,'Position',[lmarg bmarg+2.*(aheight+ygutter) awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'XTickLabel',[]);
hold all;

rs = suncycle(22.75,-158,allDaysPeakT(:,1));
sunset_loc = mod(rs(:,2)+tz,24);
%peakoff = rem(24.*allDaysPeakT(:,2) - sunset_loc,24);
peakoff = rem(24.*allDaysPeakT(:,2),24);
%bins = [-12.5:1:12.5];
h2 = histogram(peakoff,bins);
set(ax6,'XTick',xtick);
box on;
xlim(xrng);
ylim(yrng4);


