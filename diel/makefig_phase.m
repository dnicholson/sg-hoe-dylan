
figpos = [1 1 12 10];
fontsz = 14;
lnw = 2;
mkz = 5;
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


o2col = 23;
tcol = 12;
zrng = [13 18];

%% fit diel
[S] = sg_dielo2('sg148',o2col,zrng);
dS = S.pvalds < 0.05;
[S6] = sg_dielo2('sg146',o2col,zrng);
dS6 = S6.pvalds < 0.05;
[S5] = sg_dielo2('sg512',o2col,zrng);
dS5 = S5.pvalds < 0.05;
%%
% [T] = sg_dielo2('sg148',tcol,zrng);
% dT = T.pvalds < 0.05;
% [T6] = sg_dielo2('sg146',tcol,zrng);
% dT6 = T6.pvalds < 0.05;
% [T5] = sg_dielo2('sg512',tcol,zrng);
% dT5 = T5.pvalds < 0.05;

% speed of K1 tide (15.04 deg/hr
spd = 15.0410686./15;
dys = datenum(2012,5,1):datenum(2012,12,1);
tspd = rem(dys./spd,1);
tspd = rem(tspd+0.85-tspd(1),1);


figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);
axes1 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],'FontSize',fontsz,'LineWidth',lnw);
hold all;
plot(dys,24.*tspd,'LineWidth',lnw+1,'Color',[0.5 0.5 0.5]);

colors = get(axes1,'ColorOrder');
c1 = colors(1,:);
c2 = colors(2,:);
c3 = colors(3,:);


p1 = plot(S.daysds(dS),24.*S.peakds(dS),'v','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
p2 = plot(S6.daysds(dS6),24.*S6.peakds(dS6),'v','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
p3 = plot(S5.daysds(dS5),24.*S5.peakds(dS5),'v','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');

plot(S.daysus(dS),24.*S.peakus(dS),'^','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
plot(S6.daysus(dS6),24.*S6.peakus(dS6),'^','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
plot(S5.daysus(dS5),24.*S5.peakus(dS5),'v','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');
l1 = legend([p1,p2,p3],{'sg148','sg146','sg512'},'Location','NorthOutside','Orientation','horiz');

% elseif strcmpi(plotvar,'T');
% p1 = plot(T.daysds(dT),24.*T.peakds(dT),'v','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
% p2 = plot(T6.daysds(dT6),24.*T6.peakds(dT6),'v','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
% p3 = plot(T5.daysds(dT5),24.*T5.peakds(dT5),'v','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');
% 
% plot(T.daysus(dT),24.*T.peakus(dT),'^','MarkerSize',mkz,'MarkerFaceColor',c1,'MarkerEdgeColor','none');
% plot(T6.daysus(dT6),24.*T6.peakus(dT6),'^','MarkerSize',mkz,'MarkerFaceColor',c2,'MarkerEdgeColor','none');
% plot(T5.daysus(dT5),24.*T5.peakus(dT5),'^','MarkerSize',mkz,'MarkerFaceColor',c3,'MarkerEdgeColor','none');
% 
% l1 = legend([p1,p2,p3],{'sg148','sg146','sg512'},'Location','NorthOutside','Orientation','horiz');
% end
legend('boxoff');
ylim(axes1,[0 24]);

set(gca,'FontSize',14);
ylabel('Hour');
datetick;
xlim([dys(1) dys(end)]);
box on;
set(axes1,'layer','top');