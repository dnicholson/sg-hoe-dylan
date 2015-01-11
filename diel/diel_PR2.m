function [tt,Pout,Rout] = diel_PR2( lat, lon,daten,tz,E0_Ek,E0_Eb)
% Creates diel Gross photosynthesis and constant respiration based on a
% photosynthesis vs. irradiance curve of shape:
% P = (1-exp(-E./Ek)).*exp(-E.*beta);
%
% Daily integral of P is 1 and R is -1 (e.g. GPP = 1 mmol O2 m-3 d-1)

nt = 240;


[rs,t,~,z] = suncycle(lat,lon,daten,nt);
rs = rs + tz;
% be sure in range [0 1] when 
rs = mod(rs,1);

t = t + tz./24;
S = [rem(t,1)',z'];
S = sortrows(S,1);

df = S(:,1);

S(S(:,2) < 0,2) = 0;
%E = E0.*sind(S(:,2));


P = (1-exp(-E0_Ek.*sind(S(:,2)))).*exp(-E0_Eb.*sind(S(:,2))); 

tt = linspace(0,1,nt+1)';
Pout = interp1(df,P,tt,'linear','extrap');
Pout = Pout./trapz(tt,Pout);
Rout = -ones(nt+1,1);


% Pint = -(exp(E.*(-(1./Ek)+beta)).*(Ek.*beta.*exp(E./Ek-1)+exp(E./Ek)))./...
%     (beta.*(Ek.*beta+1));
% P1 = P./Pint;

end

