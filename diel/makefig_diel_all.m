zrng = [2 30];
trng = [datenum(2012,6,15) datenum(2012,9,25)];
tz = -10;
[S] = sg_dielo2_name('sg148','o2anom',zrng);
%[T] = sg_dielo2('sg148',12,zrng);

makefig_dielcycles(S.Dtyr+tz/24,S.Do2,trng,[1 4]);

ax1 = gca;
props = {'Parent','Position','FontSize','LineWidth'};
axprops = get(ax1,props);

% ax2 = axes(props,axprops);
% set(ax2,'Color','none','YAxisLocation','Right','XTick',[]);
% hold all;
% plot(T.Dtyr+tz/24,T.Do2,'.-');
% xlim(ax1.XLim);
