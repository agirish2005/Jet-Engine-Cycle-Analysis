% =========================================================================
%  main.m  —  Air-breathing engine cycle analysis (AE4451 term project)
%
%  Driver script: loops over the two design flight conditions, sets the
%  engine design parameters, and marches the flow through each component
%  (diffuser -> compressor -> combustor -> turbine/afterburner -> nozzle),
%  printing the station temperatures, pressures, work terms and overall
%  performance (specific thrust, TSFC).
%
%  The component physics live in ./components/*.m. Make sure that folder
%  is on the MATLAB path, e.g. from this directory:
%       addpath(genpath('components'))
%
%  This is a plain-text mirror of JetProTermProject.mlx, kept so the code
%  is diff-able and viewable directly on GitHub.
% =========================================================================

% -------------------- GIVEN CONDITIONS (per flight case) -----------------
% GROUND ROLL
Ta_groundroll = 285;                    % K
Pa_groundroll = 100;                    % kPa
M_groundroll = 0;                       % dimensionless
SpecificThrust_groundroll = 2.8;        % kN-s/kg

% HIGH ALTITUDE SUBSONIC CRUISE
Ta_hasc = 220;                          % K
Pa_hasc = 29;                           % kPa
M_hasc = 0.86;                          % dimensionless
SpecificThrust_hasc = 0.86;             % kN-s/kg

Ta_inputs = [Ta_groundroll Ta_hasc];
Pa_inputs = [Pa_groundroll Pa_hasc];
M_inputs  = [M_groundroll  M_hasc];
ST        = [SpecificThrust_groundroll SpecificThrust_hasc];

for i = 1:length(Ta_inputs)
    Ta = Ta_inputs(i);
    pa = Pa_inputs(i);
    M  = M_inputs(i);

    % ---------------------- DESIGN / ENGINE INPUTS -----------------------
    % Test-case values (from the handout) left here for verification:
    %   Ta = 220; pa = 10.0; M = 1.50;
    %   Prc = 30; Prf = 1.2; bypass = 2.0; b = 0.1; f = 0.05;

    Prc    = 25;          % compressor stagnation pressure ratio
    Prf    = 0;           % fan stagnation pressure ratio
    bypass = 0;           % bypass ratio (b)
    b      = 0.05;        % bleed fraction (b)

    % fuel-air ratio main burner / afterburner (throttle setting per case)
    if i == 1             % ground roll
        f    = 0.03;
        f_ab = 0.03;
    else                  % high altitude cruise
        f    = 0.015;
        f_ab = 0.02;
    end

    % ------------------------- INLET / COMPRESSOR ------------------------
    [P02,T02] = diffuser(Ta, pa, M);
    fprintf('Diffuser exit temperature, T_02     = %.2f K\n', T02);
    fprintf('Diffuser exit pressure, p_02        = %.2f kPa\n', P02);

    [P03,T03,w3,Cpc] = compressor(P02,T02,Prc);
    fprintf('Compressor exit temperature, T_03   = %.2f K\n', T03);
    fprintf('Compressor exit pressure, p_03      = %.2f kPa\n', P03);

    p03 = P03;
    wc  = w3/1000;

    % ------------------------------ COMBUSTOR ----------------------------
    [T04, p04, fmax, R, Cp4] = combustor(f, T03, p03, Cpc);
    fprintf('Combustor exit temperature, T_04   = %.2f K\n', T04);
    fprintf('Combustor exit pressure, p_04      = %.2f kPa\n', p04);
    fprintf('fmax                               = %.2f \n', fmax);

    T_04 = T04;
    p_04 = p04;

    % ----------------------- TURBINE AND AFTERBURNER ---------------------
    [T_06, p_06, wt, T_05, p_05] = turbine_and_afterburner(T_04, p_04, b, wc, f, f_ab);

    fprintf('Turbine exit temperature, T_05   = %.2f K\n', T_05);
    fprintf('Turbine exit pressure, p_05      = %.2f kPa\n', p_05);
    fprintf('Turbine shaft work, wt           = %.2f kJ/kg\n', wt);
    fprintf('AB exit temperature, T_06        = %.2f K\n', T_06);
    fprintf('AB exit pressure, p_06           = %.2f kPa\n', p_06);

    % ------------------------------- NOZZLE ------------------------------
    [u_e, T_e, p_e, thrust_specific, TSFC] = core_nozzle(T_06, p_06, p_a, T_a, M, f, f_ab);

    TSFC_final            = TSFC*1000;
    thrust_specific_final = thrust_specific / 1000;

    fprintf('Nozzle exit velocity, u_e       = %.2f m/s\n', u_e);
    fprintf('Nozzle exit temperature, T_e    = %.2f K\n', T_e);
    fprintf('Nozzle exit pressure, p_e       = %.2f kPa\n', p_e);
    fprintf('Specific thrust                 = %.2f kN*s/kg\n', thrust_specific_final);
    fprintf('TSFC                            = %.6f kg/(kN*s)\n', TSFC_final);

end   % end flight-condition loop  (added to close the for-loop)
