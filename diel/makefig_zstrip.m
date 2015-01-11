figpos = [1 1 18 8];
fontsz = 16;
lnw = 2;
mkz = 5;
scatsz = 20;
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

zcol = 5;
tcol = 6;
o2col = 27;
o2range = [-15 15];

%  o2col = 11;
%  o2range = [35 35.6];
%%
stageSgMld;

% oldir = cd;
% cd('/Users/Roo/Documents/CMORE/HOE-DYLAN/');
% load('O2corr.mat');
% load('sg146.mat','DWN');
% DWN(:,26) = 100.*((DWN(:,14)+O2corr_146(1))./O2sol(DWN(:,11),DWN(:,12))-1);
% DWN(:,27) = DWN(:,14)+O2corr_146(1)-O2sol(DWN(:,11),DWN(:,12));
% D146 = DWN;
% load('sg148.mat','DWN','UP');
% DWN(:,26) = 100.*((DWN(:,14)+O2corr_148(1))./O2sol(DWN(:,11),DWN(:,12))-1);
% DWN(:,27) = DWN(:,14)+O2corr_148(1)-O2sol(DWN(:,11),DWN(:,12));
% % UP(:,26) = 100.*((UP(:,14)+O2corr_148(1))./O2sol(UP(:,11),UP(:,12))-1);
% % UP(:,27) = UP(:,14)+O2corr_148(1)-O2sol(UP(:,11),UP(:,12));
% D148 = DWN;
% U148 = UP;
% load('sg512.mat','DWN');
% DWN(:,26) = 100.*((DWN(:,14)+O2corr_512(1))./O2sol(DWN(:,11),DWN(:,12))-1);
% DWN(:,27) = DWN(:,14)+O2corr_512(1)+2-O2sol(DWN(:,11),DWN(:,12));
% D512 = DWN;
% cd(oldir);
% 
% 
figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);
axes1 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],'FontSize',fontsz,'LineWidth',lnw,'Ydir','Reverse');
hold on;
hold all;

scatter(D146(:,tcol),D146(:,zcol),scatsz,D146(:,o2col),'filled');
scatter(D512(:,tcol),D512(:,zcol),scatsz,D512(:,o2col),'filled');
scatter(D148(:,tcol),D148(:,zcol),scatsz,D148(:,o2col),'filled');
%scatter(datenum(U148(:,tcol),1,1),U148(:,zcol),scatsz,U148(:,o2col),'filled');
% [~,mld1] = sgmld(D148,D148,0.125);
% [~,mld2] = sgmld(D146,D146,0.125);
% [~,mld3] = sgmld(D512,D512,0.125);
% [~,dmld1] = sgmld(D148,D148,0.03);
% [~,dmld2] = sgmld(D146,D146,0.03);
% [~,dmld3] = sgmld(D512,D512,0.03);
% mld = [mld1;mld2;mld3];
% mld = sortrows(mld,1);
% mld(mld(:,2) == 200,:) = [];
% 
% dmld = [dmld1;dmld2;dmld3];
% dmld = sortrows(dmld,1);
% dmld(dmld(:,2) == 200,:) = [];

%%
plot(mld(:,1),mld(:,2),'-k','LineWidth',1.5);
%plot(dmld(:,1),dmld(:,2),'-w','LineWidth',1.5);
%datetick;
hold all;
caxis(o2range);
box on;
%xlim([datenum(2012,5,15) datenum(2012,11,20)]);
%xlim([datenum(2012,5,20) datenum(2012,11,11)]);
%xlim([datenum(2012,7,1) datenum(2012,9,7)]);
ylim([0 150]);
datetick(gca,'x','mmm','keepticks');
xlim([datenum(2012,5,15) datenum(2012,11,20)]);
set(gca,'layer','top');
cm = flip(brewermap(256,'PiYG'));
colormap(cm);
colorbar;


