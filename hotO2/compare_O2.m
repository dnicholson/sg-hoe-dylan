function [O2dat, O2sg mlind t] = compare_O2(DWN,iO2,cruises,tradius,dist,method)

% sg data column
iz = 5;
idiven = 7;
idens = 10;


% calcmld is here
addpath('/Users/Roo/Documents/CMORE/HOE-DYLAN');



if ismember(method,{'dens','sigma','density','d','s','hybrid','h'})
    densplot = 1;
    yrng = [15 27];
    yax = 'Normal';
else
    densplot = 0;
    yrng = [0 200];
    yax = 'Reverse';
end

    densplot = 1;
    yrng = [15 27];
    yax = 'Normal';

figure;
hold on;
a1 = gca;
set(a1,'YDir',yax);
ylim(yrng);
t = [];
O2dat = [];
O2sg = [];
mlind = [];
mlind = logical(mlind);


for ii = 1:length(cruises)
    switch cruises(ii)
        case 3
            load hot242;
        case 4
            load hot243;
        case 5
            load hoedylan5;
        case 6
            load hot244;
        case 7
            load hoedylan7;
        case 8
            load hot245;
        case 9
            load hoedylan9;
    end
    
    if ismember(cruises(ii),[3,4,6,8])
        dat = eval('hot');
    elseif ismember(cruises(ii),[5,7,9])
        dat = eval('hoe');
    else
        error('cruise number not found');
    end
    
    % identify surface value for each dive
    d = find(DWN(:,iz) == 2);
    alldives = DWN(d,idiven);
    t_sg = DWN(d,6);
    x_sg = DWN(d,3);
    y_sg  = DWN(d,4);
    dist_sg = sqrt(x_sg.^2 + y_sg.^2);
    
    casts = unique(dat.cast);
    for jj = 1:length(casts)
        icast = dat.cast == casts(jj) & dat.O2 ~= -9;
        t_cast = mean(dat.t(icast));
        neardives = find(abs(t_sg-t_cast) < tradius & dist_sg < dist);
         %figure;
         %title(['HOE DYLAN' num2str(cruises(ii)) 'cast' num2str(casts(jj))]);
         %set(gca,'YDir','Reverse');
         
         hold on;
        for kk = 1:length(neardives)
            idive = DWN(:,idiven) == alldives(neardives(kk)) & isfinite(DWN(:,idens));
            if ~isfinite(dat.O2(icast))
                warning(['no data for dive' num2str(neardives(kk))]);
            else
                [O2_out ml] = match_prof(dat.z(icast),sw_dens0(dat.S(icast),...
                dat.T(icast)),dat.O2(icast),DWN(idive,iz), ...
                DWN(idive,idens),DWN(idive,iO2),method);
                %plot(dat.O2(icast),dat.T(icast),'.b');
                %hold on;
                %plot(O2_out,dat.T(icast),'.r');
                if densplot 
                    plot(a1,dat.O2(icast)-O2_out,dat.T(icast),'.k');
                else
                    plot(a1,dat.O2(icast)-O2_out,dat.z(icast),'.k');
                end
                t = [t; dat.t(icast)];
                mlind = [mlind; ml];
                O2dat = [O2dat; dat.O2(icast)];
                O2sg = [O2sg; O2_out];
                
            end
            
        end
    end
end
end

function [O2_out iml] = match_prof(c_z,c_dens,c_O2,sg_z,sg_dens,sg_O2,method)

d_off = 0.125;
O2_out = zeros(length(c_O2),1);
mld = calcmld(sg_dens,sg_z,d_off);
iml = c_z <= mld;
switch method
    case {'dens','sigma','density','d','s'}
        O2_out = interp1(sg_dens,sg_O2,c_dens-1000);
    case {'depth','z'}
        O2_out = interp1(sg_z,sg_O2,c_z);
    case {'hybrid','h'}
        O2_out(iml) = interp1(sg_z,sg_O2,c_z(iml));
        O2_out(~iml) = interp1(sg_dens,sg_O2,c_dens(~iml)-1000);
end
end

