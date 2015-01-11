function [f1, a1] = makefig_dielcycles(tyr,o2,xrng,yrng)

figpos = [1 1 14 5];
fontsz = 10;
nplots_x = 1;
nplots_y = 1;
lmarg = 0.2;
rmarg = 0.05;
bmarg = .25;
tmarg = .05;
xgutter = .06;
ygutter = .08;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;

%yrng = [-0.5 0.5];

tyr = reshape(tyr,[length(tyr) 1]);
o2 =reshape(o2,[length(o2) 1]);

mk_sz = 14;
lnw = 1;
font_sz = 12;

dd = tyr >= xrng(1) & tyr < xrng(2) & ~isnan(tyr);
firstday = floor(min(tyr(dd)));

% Create figure
figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);
axes1 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],'FontSize',fontsz,'LineWidth',lnw);
[hh,RS] = plotdiel(firstday,tyr(dd),yrng,22.75,202,-10,'FaceColor','y','LineStyle','none','FaceAlpha',0.4);
hold all;
p1 = plot(tyr(dd),o2(dd),'.-k','LineWidth', lnw);
set(p1,'MarkerSize',mk_sz);
set(axes1,'Color',[0.8 0.8 0.8],'TickDir','out');

box on;
set(axes1,'XTick',xrng(1):xrng(2));
datetick('x','mm/dd','keeplimits','keepticks');
xlim(xrng);
ylim(yrng);
ylabel('[O_2]_{anom} (mmol m^{-3})');