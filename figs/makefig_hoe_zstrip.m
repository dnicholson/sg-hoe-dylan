function makefig_hoe_zstrip(prop,Prange)

figpos = [1 1 24 12];
fontsz = 10;
nplots_x = 1;
nplots_y = 4;
lmarg = 0.05;
rmarg = 0.05;
bmarg = .10;
tmarg = .05;
xgutter = .06;
ygutter = .04;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;

yrange = [0 200];
%xrange = [2012.35 2012.85];
xrange = [datenum(2012,5,1) datenum(2012,11,7)];
Trange = [15 30];
Srange = [34.4 35.6];
mk_sz = 14;
lnw = 0.5;

% Create figure
figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);

sgpath = '/Users/Roo/Documents/CMORE/HOE-DYLAN';
oldpath = cd;
cd(sgpath);

% load data
load O2corr.mat;

load sg146.mat
DWN(:,26) = 100.*((DWN(:,14)+O2corr_148(1))./O2sol(DWN(:,11),DWN(:,12))-1);
D146 = DWN;
U146 = UP;
mld((mld(:,1) == 0),:) = NaN;
mld146 = mld;

load sg148.mat
D148 = DWN;
U148 = UP;
mld((mld(:,1) == 0),:) = NaN;
mld148 = mld;
load sg512.mat
D512 = DWN;
U512 = UP;
mld((mld(:,1) == 0),:) = NaN;
mld512 = mld;

t_ind = 6;
z_ind = 5;
Tind_146 = find(strcmpi(header146, 'tempc'));
Tind_148 = find(strcmpi(header148, 'tempc'));
Tind_512 = find(strcmpi(header512, 'tempc'));

Sind_146 = find(strcmpi(header146, 'salin'));
Sind_148 = find(strcmpi(header148, 'salin'));
Sind_512 = find(strcmpi(header512, 'salin'));

Pind_146 = find(strcmpi(header146, prop));
Pind_148 = find(strcmpi(header148, prop));
Pind_512 = find(strcmpi(header512, prop));


% Temperature

axes1 = axes('Parent',figure1,'Position',[lmarg bmarg + 3.*aheight + ...
    3.*ygutter awidth aheight],'Ydir','Reverse','TickDir','out',...
    'FontSize',fontsz,'LineWidth',1,'XTickLabel',[]);

    hold all;

s = scatter(U146(:,t_ind),U146(:,z_ind),10,U146(:,Tind_146),'filled','Marker','s');
s = scatter(D146(:,t_ind),D146(:,z_ind),10,D146(:,Tind_146),'filled','Marker','s');

s = scatter(U148(:,t_ind),U148(:,z_ind),10,U148(:,Tind_148),'filled','Marker','s');
s = scatter(D148(:,t_ind),D148(:,z_ind),10,D148(:,Tind_148),'filled','Marker','s');

s = scatter(U512(:,t_ind),U512(:,z_ind),10,U512(:,Tind_512),'filled','Marker','s');
s = scatter(D512(:,t_ind),D512(:,z_ind),10,D512(:,Tind_512),'filled','Marker','s');

plot(mld146(:,1),mld146(:,2),'k','LineWidth',lnw);
plot(mld148(:,1),mld148(:,2),'k','LineWidth',lnw);
plot(mld512(:,1),mld512(:,2),'k','LineWidth',lnw);

box on;
xlim(xrange);
ylim(yrange);
caxis(Trange);
colorbar;

% Salinity
axes2 = axes('Parent',figure1,'Position',[lmarg bmarg + 2.*aheight + ...
    2.*ygutter awidth aheight],'Ydir','Reverse','TickDir','out',...
    'FontSize',fontsz,'LineWidth',1,'XTickLabel',[]);

hold all;

% s = scatter(U146(:,t_ind),U146(:,z_ind),10,U146(:,Sind_146),'filled','Marker','s');
% s = scatter(D146(:,t_ind),D146(:,z_ind),10,D146(:,Sind_146),'filled','Marker','s');
% 
% s = scatter(U148(:,t_ind),U148(:,z_ind),10,U148(:,Sind_148),'filled','Marker','s');
% s = scatter(D148(:,t_ind),D148(:,z_ind),10,D148(:,Sind_148),'filled','Marker','s');
% 
% s = scatter(U512(:,t_ind),U512(:,z_ind),10,U512(:,Sind_512),'filled','Marker','s');
% s = scatter(D512(:,t_ind),D512(:,z_ind),10,D512(:,Sind_512),'filled','Marker','s');

s = scatter(U146(:,t_ind),U146(:,z_ind),10,U146(:,Pind_146),'filled','Marker','s');
s = scatter(D146(:,t_ind),D146(:,z_ind),10,D146(:,Pind_146),'filled','Marker','s');

s = scatter(U148(:,t_ind),U148(:,z_ind),10,U148(:,Pind_148),'filled','Marker','s');
s = scatter(D148(:,t_ind),D148(:,z_ind),10,D148(:,Pind_148),'filled','Marker','s');

s = scatter(U512(:,t_ind),U512(:,z_ind),10,U512(:,Pind_512),'filled','Marker','s');
s = scatter(D512(:,t_ind),D512(:,z_ind),10,D512(:,Pind_512),'filled','Marker','s');

plot(mld146(:,1),mld146(:,2),'k','LineWidth',lnw);
plot(mld148(:,1),mld148(:,2),'k','LineWidth',lnw);
plot(mld512(:,1),mld512(:,2),'k','LineWidth',lnw);

box on;
xlim(xrange);
ylim(yrange);
caxis(Srange);
colorbar;


% Property sg146,sg148
axes3 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter ...
    awidth aheight],'Ydir','Reverse','TickDir','out','FontSize',fontsz,...
    'LineWidth',1,'XTickLabel',[]);

hold all;
box on;

s = scatter(U146(:,t_ind),U146(:,z_ind),10,U146(:,Pind_146),'filled','Marker','s');
s = scatter(D146(:,t_ind),D146(:,z_ind),10,D146(:,Pind_146),'filled','Marker','s');

s = scatter(U512(:,t_ind),U512(:,z_ind),10,U512(:,Pind_512),'filled','Marker','s');
s = scatter(D512(:,t_ind),D512(:,z_ind),10,D512(:,Pind_512),'filled','Marker','s');


plot(mld146(:,1),mld146(:,2),'k','LineWidth',lnw);
plot(mld512(:,1),mld512(:,2),'k','LineWidth',lnw);

box on;
xlim(xrange);
ylim(yrange);
caxis(Prange);
colorbar;

% Property sg512
axes4 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],...
    'Ydir','Reverse','TickDir','out','FontSize',fontsz,'LineWidth',1);

hold all;

s = scatter(U148(:,t_ind),U148(:,z_ind),10,U148(:,Pind_148),'filled','Marker','s');
s = scatter(D148(:,t_ind),D148(:,z_ind),10,D148(:,Pind_148),'filled','Marker','s');

plot(mld148(:,1),mld148(:,2),'k','LineWidth',lnw);

box on;
xlim(xrange);
ylim(yrange);
caxis(Prange);
colorbar;

cd(oldpath);
