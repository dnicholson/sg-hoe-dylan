function makefig_hoe_z_dives(prop,trange,Prange)

figpos = [1 1 24 6];
fontsz = 10;
nplots_x = 1;
nplots_y = 2;
lmarg = 0.05;
rmarg = 0.05;
bmarg = .10;
tmarg = .05;
xgutter = .06;
ygutter = .08;
awidth = (1-lmarg-rmarg-(nplots_x-1)*xgutter)./nplots_x;
aheight = (1-tmarg-bmarg-(nplots_y-1)*ygutter)./nplots_y;

yrange = [0 200];
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
t_ind = 6;
z_ind = 5;

load sg146.mat
td = DWN(:,t_ind) > trange(1) & DWN(:,t_ind) < trange(2);
%tu = UP(:,t_ind) > trange(1) & UP(:,t_ind) < trange(2);
D146 = DWN(td,:);
%U146 = UP(tu,:);
mld((mld(:,1) == 0),:) = NaN;
mld146 = mld;

load sg148.mat
td = DWN(:,t_ind) > trange(1) & DWN(:,t_ind) < trange(2);
%tu = UP(:,t_ind) > trange(1) & UP(:,t_ind) < trange(2);
D148 = DWN(td,:);
%U148 = UP(tu,:);
mld((mld(:,1) == 0),:) = NaN;
mld148 = mld;

load sg512.mat
td = DWN(:,t_ind) > trange(1) & DWN(:,t_ind) < trange(2);
%tu = UP(:,t_ind) > trange(1) & UP(:,t_ind) < trange(2);
D512 = DWN(td,:);
%U512 = UP(tu,:);
mld((mld(:,1) == 0),:) = NaN;
mld512 = mld;

% Tind_146 = find(strcmpi(header146, 'tempc'));
% Tind_148 = find(strcmpi(header148, 'tempc'));
% Tind_512 = find(strcmpi(header512, 'tempc'));
% 
% Sind_146 = find(strcmpi(header146, 'salin'));
% Sind_148 = find(strcmpi(header148, 'salin'));
% Sind_512 = find(strcmpi(header512, 'salin'));

Pind_146 = find(strcmpi(header146, prop));
Pind_148 = find(strcmpi(header148, prop));
Pind_512 = find(strcmpi(header512, prop));


% Property sg146,sg512
axes1 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter ...
    awidth aheight],'Ydir','Reverse','TickDir','out','FontSize',fontsz,...
    'LineWidth',1,'XTickLabel',[]);

hold all;
box on;

%s = scatter(U146(:,t_ind),U146(:,z_ind),10,U146(:,Pind_146),'filled','Marker','s');
s = scatter(D146(:,t_ind),D146(:,z_ind),10,D146(:,Pind_146),'filled','Marker','s');

%s = scatter(U512(:,t_ind),U512(:,z_ind),10,U512(:,Pind_512),'filled','Marker','s');
s = scatter(D512(:,t_ind),D512(:,z_ind),10,D512(:,Pind_512),'filled','Marker','s');


plot(mld146(:,1),mld146(:,2),'k','LineWidth',lnw);
plot(mld512(:,1),mld512(:,2),'k','LineWidth',lnw);

box on;
xlim(trange);
ylim(yrange);
caxis(Prange);
colorbar;

% Property sg148
axes2 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],...
    'Ydir','Reverse','TickDir','out','FontSize',fontsz,'LineWidth',1);

hold all;

%s = scatter(U148(:,t_ind),U148(:,z_ind),10,U148(:,Pind_148),'filled','Marker','s');
s = scatter(D148(:,t_ind),D148(:,z_ind),10,D148(:,Pind_148),'filled','Marker','s');

plot(mld148(:,1),mld148(:,2),'k','LineWidth',lnw);

box on;
xlim(trange);
ylim(yrange);
caxis(Prange);
colorbar;

cd(oldpath);
