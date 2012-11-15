function makefig_hoe_z(prop,trange,Prange,zopt,diveopt)

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

switch zopt
    case {'depth','z'}
        yrange = [0 200];
        z_ind = 5;
        mldplot = 1;
    case { 'sigma','sig','density'}
        yrange = [23 25.5];
        z_ind = 10;
        mldplot = 0;
end


switch diveopt
    case {'dwn','down','dives','dive'}
        pdwn = 1;
        pup = 0;
    case { 'up','ascent'}
        pdwn = 0;
        pup = 1;
    case {'both','all'}
        pdwn = 1;
        pup = 1;
end
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
S_ind = 11;
T_ind = 12;
%z_ind = 5;

O2off_146 = 14.53;
O2off_148 = 4.36;
O2off_512 = 11.50;

load sg146.mat
td = DWN(:,t_ind) > trange(1) & DWN(:,t_ind) < trange(2);
tu = UP(:,t_ind) > trange(1) & UP(:,t_ind) < trange(2);
D146 = DWN(td,:);
U146 = UP(tu,:);
mld((mld(:,1) == 0),:) = NaN;
mld146 = mld;

load sg148.mat
td = DWN(:,t_ind) > trange(1) & DWN(:,t_ind) < trange(2);
tu = UP(:,t_ind) > trange(1) & UP(:,t_ind) < trange(2);
D148 = DWN(td,:);
U148 = UP(tu,:);
mld((mld(:,1) == 0),:) = NaN;
mld148 = mld;

load sg512.mat
td = DWN(:,t_ind) > trange(1) & DWN(:,t_ind) < trange(2);
tu = UP(:,t_ind) > trange(1) & UP(:,t_ind) < trange(2);
D512 = DWN(td,:);
U512 = UP(tu,:);
mld((mld(:,1) == 0),:) = NaN;
mld512 = mld;

% Tind_146 = find(strcmpi(header146, 'tempc'));
% Tind_148 = find(strcmpi(header148, 'tempc'));
% Tind_512 = find(strcmpi(header512, 'tempc'));
% 
% Sind_146 = find(strcmpi(header146, 'salin'));
% Sind_148 = find(strcmpi(header148, 'salin'));
% Sind_512 = find(strcmpi(header512, 'salin'));

%  Correct for O2 offset

O2ind_146 = find(strcmpi(header146, 'optode_dphase_oxygenc'));
O2ind_148 = find(strcmpi(header148, 'optode_dphase_oxygenc'));
O2ind_512 = find(strcmpi(header512, 'optode_dphase_oxygenc'));

D146(:,O2ind_146) = D146(:,O2ind_146) + O2off_146; 
U146(:,O2ind_146) = U146(:,O2ind_146) + O2off_146; 

D148(:,O2ind_148) = D148(:,O2ind_148) + O2off_148; 
U148(:,O2ind_148) = U148(:,O2ind_148) + O2off_148;

D512(:,O2ind_512) = D512(:,O2ind_512) + O2off_512; 
U512(:,O2ind_512) = U512(:,O2ind_512) + O2off_512;


Pind_146 = find(strcmpi(header146, prop));
Pind_148 = find(strcmpi(header148, prop));
Pind_512 = find(strcmpi(header512, prop));

% calculate O2_sat
if strcmpi(prop,'O2sat')
    Pind_146 = O2ind_146;
    Pind_148 = O2ind_148;
    Pind_512 = O2ind_512;
    D146(:,O2ind_146) = 100.*(D146(:,O2ind_146)./O2sol(D146(:,S_ind),D146(:,T_ind))-1);
    U146(:,O2ind_146) = 100.*(U146(:,O2ind_146)./O2sol(U146(:,S_ind),U146(:,T_ind))-1);
    D148(:,O2ind_148) = 100.*(D148(:,O2ind_148)./O2sol(D148(:,S_ind),D148(:,T_ind))-1);
    U148(:,O2ind_148) = 100.*(U148(:,O2ind_148)./O2sol(U148(:,S_ind),U148(:,T_ind))-1);
    D512(:,O2ind_512) = 100.*(D512(:,O2ind_512)./O2sol(D512(:,S_ind),D512(:,T_ind))-1);
    U512(:,O2ind_512) = 100.*(U512(:,O2ind_512)./O2sol(U512(:,S_ind),U512(:,T_ind))-1);
end
    
% Property sg146,sg512
axes1 = axes('Parent',figure1,'Position',[lmarg bmarg+aheight+ygutter ...
    awidth aheight],'Ydir','Reverse','TickDir','out','FontSize',fontsz,...
    'LineWidth',1,'XTickLabel',[]);

hold all;
box on;

if pup == 1
    s = scatter(U146(:,t_ind),U146(:,z_ind),10,U146(:,Pind_146),'filled','Marker','s');
    s = scatter(U512(:,t_ind),U512(:,z_ind),10,U512(:,Pind_512),'filled','Marker','s');
end

if pdwn == 1
    s = scatter(D146(:,t_ind),D146(:,z_ind),10,D146(:,Pind_146),'filled','Marker','s');
    s = scatter(D512(:,t_ind),D512(:,z_ind),10,D512(:,Pind_512),'filled','Marker','s');
end

if mldplot
    plot(mld146(:,1),mld146(:,2),'k','LineWidth',lnw);
    plot(mld512(:,1),mld512(:,2),'k','LineWidth',lnw);
end

box on;
xlim(trange);
ylim(yrange);
caxis(Prange);
colorbar;

% Property sg148
axes2 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],...
    'Ydir','Reverse','TickDir','out','FontSize',fontsz,'LineWidth',1);

hold all;

if pup == 1
    s = scatter(U148(:,t_ind),U148(:,z_ind),10,U148(:,Pind_148),'filled','Marker','s');
end
if pdwn == 1
    s = scatter(D148(:,t_ind),D148(:,z_ind),10,D148(:,Pind_148),'filled','Marker','s');
end

if mldplot
    plot(mld148(:,1),mld148(:,2),'k','LineWidth',lnw);
end

box on;
xlim(trange);
ylim(yrange);
caxis(Prange);
colorbar;

cd(oldpath);
