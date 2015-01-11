

figpos = [1 1 12 10];
fontsz = 12;
mk_sz = 14;
lnw = 1;
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

oldir = cd;
whots_path = '/Users/Roo/github/sg-hoe-dylan/WHOTS';

% -------------------------------------------------------------------------
% Spectral analysis of sg data
% -------------------------------------------------------------------------
gliderid = 'sg148';
CHUNK = 2^7;
OVERLAP = CHUNK./2;
O2col = 27;
Tcol = 12;
zrng = [2 30];
[S] = sg_dielo2(gliderid,O2col,zrng);
[T] = sg_dielo2(gliderid,Tcol,zrng);
dt = median(diff(S.Dtyr));
%o2norm = (S.Do2-mean(S.Do2))./var(S.Do2);
o2norm = detrend(S.Do2)./var(detrend(S.Do2));
sgTnorm = detrend(T.Do2)./var(detrend(T.Do2));
[pxxo,fo,pxxco] = pwelch(o2norm,CHUNK,OVERLAP,CHUNK,1./dt,'ConfidenceLevel',0.95);
[pxxsgT,fsgT,pxxcsgT] = pwelch(sgTnorm,CHUNK,OVERLAP,CHUNK,1./dt,'ConfidenceLevel',0.95);

% -------------------------------------------------------------------------
% Spectral Analysis of WHOTS surface (15m) temperature
% -------------------------------------------------------------------------
cd(whots_path);

step = 10;
CHUNK = 2^15;
OVERLAP = CHUNK./2;
whots_fname = 'OS_WHOTS_201206_D_MICROCAT-015m.nc';
T = ncread(whots_fname,'TEMP');
t = ncread(whots_fname,'TIME');
dt = step.*(t(2)-t(1));
%Tnorm = (T-mean(T))./var(T);
Tnorm = detrend(T(1:step:end))./var(detrend(T(1:step:end)));
%[Tbp,Th,Tl] = whots_bandpass(dt,T,2,0.5);
[pxxw,fw,pxxcw] = pwelch(Tnorm,CHUNK,OVERLAP,CHUNK,1./dt,'ConfidenceLevel',0.95);

xrng = [1e-1 1e1];
yrng = [1e-5 1e3];
% -------------------------------------------------------------------------
% Spectral Analysis of WHOTS surface (10m) currents
% -------------------------------------------------------------------------
step = 20;
CHUNK = 2^13;
OVERLAP = CHUNK./2;
u = ncread('OS_WHOTS_201206_D_NGVM-010m.nc','UCUR');
v = ncread('OS_WHOTS_201206_D_NGVM-010m.nc','VCUR');
t = ncread('OS_WHOTS_201206_D_NGVM-010m.nc','TIME');
%unorm = (u-mean(u))./var(u);
unorm = detrend(u(1:step:end))./var(detrend(u(1:step:end)));
%vnorm = (v-mean(v))./var(v);
vnorm = detrend(v(1:step:end))./var(detrend(v(1:step:end)));

dt = step.*(t(2)-t(1));
[pxxU,fU,pxxcU] = pwelch(unorm,CHUNK,OVERLAP,CHUNK,1./dt,'ConfidenceLevel',0.95);
[pxxV,fV,pxxcV] = pwelch(vnorm,CHUNK,OVERLAP,CHUNK,1./dt,'ConfidenceLevel',0.95);

cd(oldir);
% Create figure
figure1 = figure;
set(figure1,'Units','centimeters','PaperPositionMode', 'auto','Position',figpos);
axes1 = axes('Parent',figure1,'Position',[lmarg bmarg awidth aheight],'XScale','log','YScale','log');
hold all;
box on;
set(axes1,'MinorGridLineStyle','-','MinorGridAlpha',0.125,'GridAlpha',0.4,'FontSize',fontsz,'LineWidth',lnw);

p2 = plot(fw,pxxw,'LineWidth',1.5.*lnw);
p1 = plot(fU,pxxU,'LineWidth',1.5.*lnw);
p3 = plot(fV,pxxV,'LineWidth',1.5.*lnw);
p4 = plot(fo,pxxo, 'LineWidth',1.5.*lnw);
p5 = plot(fsgT,pxxsgT, 'LineWidth',1.5.*lnw);
grid on;

xlim(xrng);
ylim(yrng);
ylabel('Power spectral density');
xlabel('cycles per day');
legend([p1,p3,p2,p4,p5],{'10m U-vel','10m V-vel','15m Tem', 'glider O_2', 'glider Tem'},'Location','Northeast');
legend('boxoff');