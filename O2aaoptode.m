function [ O2, O2sat ] = O2aaoptode(optodeModel,calStruc, optode_phase,tempc,salin,depth)

% O2AAOPTODE:  Calculates oxygen concentration in umol/kg from raw phase
% and temperature data.  Optional salinity and pressure corrections are
% also included.
% Multipoint calibration Stern Volmer based method also is supported
% 
% INPUTS:
% optodeModel:  Identifier for optode model e.g. 4330 or 3830
% calStruc:     Struct of calibration coefficients
% optode_phase: vector of optode phase measurements (calphase or dphase)
% tempc:        temperature in deg C
% salin:        Salinity (Optional) default = 0
% depth:        Depth in meters for pressure correction (Optional) def = 0
%
% OUTPUT:
% O2:           Oxygen concentration in micromol/kg
% O2sat:        Oxygen percent saturation (%) (100 = saturated)
%
% USAGE EXAMPLES:
% ---------- 4330 sensor using the default polynomial calibration
% [O2, O2sat] = O2aaoptode(4330,calcoeff,calphase,T,S,z)
%       where   calcoeff.optode_FoilCoefA = 14 x 1
%               calcoeff.optode_FoilCoefB = 14 x 1
%               calcoeff.FoilPolyDegO = 28 x 1
%               calcoeff.FoilPolyDegT = 28 x 1
%
% ---------- 4330 sensor using the 'Stern Volmer Uchida' Formula
% [O2, O2sat] = O2aaoptode(4330,calcoeff,calphase,T,S,z)
%       where calcoeff.SVUFormula = 1 and calcoeff.C = 7x1 vector of c_0-c_6
%
% ---------- 3930 sensor using defaults (salin = 0), (depth = 0)
% [O2, O2sat] = O2aaoptode(3930,calcoeff,dphase,T)
%       where calcoeff.CM = 5 x 4 matrix:
%        [ C00     C01     C02     C03 ]
%        [ C10     C11     C12     C13 ]
%        [ C20     C21     C22     C23 ]
%        [ C30     C31     C32     C33 ]
%        [ C40     C41     C42     C43 ]
%
% -------------------------------------------------------------------------
% David Nicholson // dnicholson@whoi.edu // April 2014 // v1.0
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Parse and shape input arguments
% -------------------------------------------------------------------------

% orient data so it is 1 x nobs
nobs = length(optode_phase);
optode_phase = reshape(optode_phase,nobs,1);
if length(tempc) == 1
    tempc = repmat(tempc,nobs,1);
else
    tempc = reshape(tempc,nobs,1);
end
% if saliniity is specified
if nargin > 4
    if length(salin) == 1
        salin = repmat(salin,nobs,1);
    else
        salin = reshape(salin,nobs,1);
    end
else
    salin = zeros([nobs,1]);
end
% if depth is specified
if nargin > 5
    if length(depth) == 1
        depth = repmat(depth,nobs,1);
    else
        depth = reshape(depth,nobs,1);
    end
else
    depth = zeros([nobs,1]);
end

% scaled temperature
temps = log((298.15-tempc)./(273.15+tempc));
% convert optodeModel to integer

if ~isnumeric(optodeModel)
    optodeModel = str2double(optodeModel);
end
optodeModel = int16(optodeModel);

%
if length(optode_phase) ~= length(tempc)
    error('optode_dphase and tempc must have the same length');
end

%
% Salinity correction coefficients
% these should be the same for all optodes
if ~isfield(calStruc,'SB')
    calStruc.SB = [-6.24097E-3;
        -6.93498E-3;
        -6.90358E-3;
        -4.29155E-3];
end
if ~isfield(calStruc,'SC')
    calStruc.SC = -3.11680E-7;
end

if optodeModel < 4000 || optodeModel == 5013
    % ---------------------------------------------------------------------
    % Oxygen calculation for 3XXX series optodes
    % ---------------------------------------------------------------------
    % check calibration input
    % CM is the matrix of optode coefficients
    % size is 5 x 4
    % [ C00     C01     C02     C03 ]
    % [ C10     C11     C12     C13 ]
    % [ C20     C21     C22     C23 ]
    % [ C30     C31     C32     C33 ]
    % [ C40     C41     C42     C43 ]
    if ~isfield(calStruc,'CM')
        error([num2str(optodeModel), 'requires a calibration matrix calStruc.CM']);
    end
    
    if isfield(calStruc,'RawPhaseMode')
        if calStruc.RawPhaseMode == 1
            nPhaseCoef = length(calStruc.PhaseCoef);
            polyDegPhaseCoeff = 0:(nPhaseCoef-1);
            phase_M =repmat(optode_phase,1,nPhaseCoef).^repmat(polyDegPhaseCoeff,nobs,1);
            optode_phase = phase_M*reshape(calStruc.PhaseCoef,nPhaseCoef,1);
        end
    end
    
        
    % Depth comensation coefficient for 3XXX sensors
    D = 0.032;
    
    % size 4 x 1 and 5 x 1
    %polyDegT = [0;1;2;3];
    polyDegT = 0:3;
    polyDegPh = 0:4;
    %[0;1;2;3;4];
    % matrix size: nobs x 4 
    polyDegT_M = repmat(polyDegT,nobs,1);
    % matrix size: nobs x 5
    polyDegPh_M = repmat(polyDegPh,nobs,1);
    % temperature matrix size nobs x 4 
    temp_M = repmat(tempc,1,length(polyDegT)).^polyDegT_M;
    % phase matrix size nobs x 5
    phase_M = repmat(optode_phase,1,length(polyDegPh)).^polyDegPh_M;
    % 5x4  * 4xnobs = 5 x nobs
    % initial O2 concentration calc in uM
    % nobs x 4 * 4 x 5 = nobs * 5
    optode_uM = sum((temp_M*calStruc.CM').*phase_M,2);
    optode_umolkg = 1000.*optode_uM./sw_dens0(salin,tempc);
    
    % ---------------------------------------------------------------------
    % Oxygen calculation for 4XXX series optodes
    % ---------------------------------------------------------------------
    
elseif optodeModel == 4831 || optodeModel == 4330
    % Pressure compensation coefficient should be 0.032 for all 4XXX
    % sensors
    D = 0.032;
    % Uchida et al. 2008 Stern-Volmer based calbration mode
    if isfield(calStruc,'SVUFormula')
        % -----------------------------------------------------------------
        % Check for appropriate calibration fields
        % -----------------------------------------------------------------
        if ~isfield(calStruc,'C')
            error([num2str(optodeModel), 'requires calibration vector calStruc.C']);
        end
        C = calStruc.C;
        Ksv = C(1) + C(2).*tempc+C(3).*tempc.^2;
        P0 = C(4) + C(5).*tempc;
        PC = C(6) + C(7).*optode_phase;
        optode_umolkg = ((P0./PC)-1)./Ksv;
        % default mode
    else
        % -----------------------------------------------------------------
        % Check for appropriate calibration fields
        % -----------------------------------------------------------------
        if ~isfield(calStruc,'optode_FoilCoefA')
            error([num2str(optodeModel), 'requires calibration vector calStruc.optode_FoilCoefA']);
        elseif ~isfield(calStruc,'optode_FoilCoefB')
            error([num2str(optodeModel), 'requires calibration vector calStruc.optode_FoilCoefB']);
        elseif ~isfield(calStruc,'FoilPolyDegT')
            error([num2str(optodeModel), 'requires calibration vector calStruc.FoilPolyDegT']);
        elseif ~isfield(calStruc,'FoilPolyDegO')
            error([num2str(optodeModel), 'requires calibration vector calStruc.FoilPolyDegO']);
        end
        % optode_FoilCoefA and optode_FoilCoefB are 14 x 1 vectors
        % FoilPolyT_M and FoilPolyO_M are each 28 x 1 vectors
        FoilCoef = [squeeze(calStruc.optode_FoilCoefA);...
            squeeze(calStruc.optode_FoilCoefB)];
        
        calphase_M = repmat(optode_phase,1,length(FoilCoef));
        tempc_M = repmat(tempc,1,length(FoilCoef));
        
        FoilPolyDegT_M = repmat(calStruc.FoilPolyDegT,1,length(tempc))';
        FoilPolyDegO_M = repmat(calStruc.FoilPolyDegO,1,length(tempc))';
        
        optode_pO2 = (tempc_M.^FoilPolyDegT_M).*(calphase_M.^FoilPolyDegO_M)*FoilCoef;
        % 1013.25 hPa = 1 atm minus saturated water vapour pressure f(t)
        % 0.20946 is the mole fraction O2 in dry air (Glueckauf 1951)
        % Expression for h2o vapor pressure is from aanderaa manual
        p_atm_tot = 1013.25 - exp(52.57-6690.9./(tempc+273.15)-4.681.*log(tempc+273.15));
        optode_umolkg = O2sol(salin,tempc).*(optode_pO2./(p_atm_tot.*0.20946));
    end
else
    error('unidentified optode model "optodemod"');
end

% -------------------------------------------------------------------------
% Do Salinity and Pressure corrections here:
% -------------------------------------------------------------------------
tempS_M = [ones(nobs,1),temps,temps.^2,temps.^3];


SB = squeeze(calStruc.SB);
SC = squeeze(calStruc.SC);
O2 = optode_umolkg.*exp(salin.*(tempS_M*SB)+SC.*salin.^2).*(1+depth.*D./1000);
O2sat = 100.*O2./O2sol(salin,tempc);

