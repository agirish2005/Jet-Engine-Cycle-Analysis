function [u_e, T_e, p_e, thrust_specific, TSFC] = core_nozzle(T_06, p_06, p_a, T_a, M, f, f_ab)
% Core nozzle calculations
% Inputs from TURBINE: T_05 [K], p_05 [kPa]
% Input from flight condition: p_a [kPa]

    R = 287;
    gamma_n = 1.35;
    eta_n = 0.95;
    
    c_p = (gamma_n * R) / (gamma_n - 1);
    T_e_ideal = T_06 * (p_a / p_06)^((gamma_n - 1)/gamma_n);
    T_e = T_06 - eta_n * (T_06 - T_e_ideal);
    u_e = sqrt(2 * c_p * (T_06 - T_e));
    p_e = p_a;
   
    % Thrust and TSFC calculations (OVERALL ENGINE)
    gamma_air = 1.4;    % for ambient air
    u = M * sqrt(gamma_air * R * T_a);  % flight velocity
    
    % Specific thrust (simplified since p_e = p_a)
    f_total = f + f_ab;
    thrust_specific = (1 + f_total) * u_e - u;
    TSFC = f_total / thrust_specific;
    
end

% % From teammates and flight condition:
% T_05 = 1081;    % from turbine
% p_05 = 163.2;   % from turbine  
% p_a = 10.0;     % ambient pressure
% T_a = 220;      % ambient temperature
% M = 1.5;        % flight Mach number
% f = 0.018;      % fuel-air ratio from combustor
% 
% [u_e, T_e, p_e, thrust, TSFC] = core_nozzle(T_05, p_05, p_a, T_a, M, f);

