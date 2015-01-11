

figpos = [1 1 14 16];
fontsz = 18;
nplots_x = 1;
nplots_y = 2;
lmarg = 0.18;
rmarg = 0.1;
bmarg = .1;
tmarg = .05;
xgutter = .08;
ygutter = .03;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;



lat = 22.75;
lon = 202;
tz = -10;
I = 100;
Ik = 150;
Ib = 200e10;
%beta = 3e-3;
I_Ib = 0.7;
day = datenum(2012,7,15);
yrng1 = [-2 2];
yrng2 = [-0.3 0.3];
xrng = [day day+1];

%yrng = [-0.5 0.5];
[dfPR,P,R] = diel_PR2( lat, lon,day,tz,I./Ik,I./Ib );
scalePR = 1;

mk_sz = 14;
lnw = 4;
font_sz = 12;
cmaplines = brewermap(12,'paired');

% Create figure
figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);

% Upper plot

ax1 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'TickDir','out');
[hh,RS] = plotdiel(day,day+dfPR,yrng1,lat,lon,tz,'FaceColor','y','LineStyle','none','FaceAlpha',1);
hold all;

p1 = plot(ax1,day+dfPR,scalePR.*(P+R),'Color',cmaplines(2,:),'LineWidth', lnw+1);
p2 = plot(ax1,xrng,[0,0],'-','Color',[0.6, 0.6, 0.6],'LineWidth',lnw);
p3 = area(ax1,day+dfPR,scalePR.*(P+R),'LineStyle', 'none','FaceColor',[0.5, 0.5, 0.5]);
p1 = plot(ax1,day+dfPR,scalePR.*(P+R),'Color','k','LineWidth', lnw);

box on;
set(ax1,'XTick',xrng(1):(1/8):xrng(2));
set(ax1,'XTickLabel',[],'Layer','top');
xlim(ax1,xrng);
ylim(ax1,yrng1);
ylabel(ax1,'P+R (mmol m^{-3} d^{-1})');


% Lower plot
ax2 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'TickDir','out');
hold(ax2,'on');

[hh,RS] = plotdiel(day,day+dfPR,yrng1,lat,lon,tz,'FaceColor','y','LineStyle','none','FaceAlpha',1);
p3 = plot(ax2,day+dfPR,cumtrapz(dfPR,scalePR.*(P+R)),'Color',cmaplines(2,:),'LineWidth', lnw+1);
p4 = plot(ax2,day+dfPR,cumtrapz(dfPR,scalePR.*(P+1.1.*R)),'Color',cmaplines(1,:),'LineWidth', lnw/2);
p5 = plot(ax2,day+dfPR,cumtrapz(dfPR,scalePR.*(P+0.9.*R)),'Color',cmaplines(1,:),'LineWidth', lnw/2);
%p4 = plot(ax2,day+dfPR,cumtrapz(dfPR,scalePR.*(1.1.*P+R)),'Color',cmaplines(1,:),'LineWidth', lnw/2);
%p5 = plot(ax2,day+dfPR,cumtrapz(dfPR,scalePR.*(0.9.*P+R)),'Color',cmaplines(1,:),'LineWidth', lnw/2);

box on;
set(ax2,'XTick',xrng(1):(1/8):xrng(2));
set(ax2,'Layer','top');
datetick(ax2,'x','HH:MM','keeplimits','keepticks');
xlim(ax2,xrng);
ylim(ax2,yrng2);
ylabel(ax2,'O2 (mmol m^{-3})');