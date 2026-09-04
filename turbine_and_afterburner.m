function [T_06, p_06, wt, T_05, p_05, f_ab_max] = turbine_and_afterburner(T_04, p_04, b, wc, f, f_ab)


    % CONSTANTS AND PROPERTIES ---------------------------
    gamma = 1.33;         % CPG assumption, provided for turbine
    MW = 28.8;            % g/mol = 28.8 kg/kmol
    Tmax_0 = 1300;        % K, base max allowable temperature
    b_max = 0.12;         % dimensionless
    C_b1 = 700;           % K
    eta_sh = 0.99;        % shaft efficiency
    eta_poly = 0.92; % polytropic efficiency
    b = 0.1;
 
       
    % BLEED SYSTEM CHECK --------------------
    T_max = Tmax_0 + C_b1 * sqrt(b / b_max);    % maximum temperature limit

    if T_04 < T_max
        disp('Temperature is fine, appropriate bleed system');
    else
        disp('Temperature is too high, bleed system failure');
    end

 
    % MORE PROPERTIES --------------------------
    R  = 8314 / MW;                 % J/kg-K
    cp = gamma * R / (gamma - 1);   % J/kg-K

    
    % TEMPERATURE CALCULATIONS -------------------------
    wt  = wc / eta_sh;                               % kJ/kg, work shaft must produce
    T_05 = T_04 - (wt * 1000) / (cp * eta_poly);     % K, temperature out of turbine
    T_ratio = T_05 / T_04;                           % temperature ratio of turbine


    % PRESSURE CALCULATIONS -----------------------------
    eta_is = (T_ratio - 1) / (T_ratio^(1/eta_poly) - 1);    % isentropic efficiency
    PR = T_ratio^(gamma / ((gamma - 1) * eta_is));          % pressure ratio
    p_05 = PR * p_04;                                       % exit pressure of turbine


    % AFTERBURNER ---------------------------
    n_ab = 0.96;      % afterburner efficiency
    Qf   = 45e6;      % J/kg fuel
    cp_ab = cp;       % assume same cp
    
    % Max allowable AB temperature
    T_ab_max = 2200;   % K
    
    T_06 = T_05 + (f_ab * n_ab * Qf) / ((1 + f + f_ab) * cp);
    
    % Maximum fuel ratio allowed
    f_ab_max = ( (T_ab_max - T_05) * cp_ab ) / ( n_ab*Qf - cp_ab*(T_ab_max - T_05) );
    
    % Compute total fuel to air ratio
    f_total = f + f_ab;
    
    % AB Temperature rise
    T_06 = T_05 + (f_ab * n_ab * Qf) / ((1 + f_total) * cp_ab);
    
    % Exit pressure (negligible losses)
    p_06 = p_05;

end     