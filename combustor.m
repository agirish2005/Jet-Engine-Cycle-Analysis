function [T04, p04, fmax,R,Cp4] = combustor(f, T03, p03,Cpc)

%Givens
gamma4= 1.33;                                       %Dimensionless
Qf=45e6;                                         %J/g
Mw=28.8;                                            %g/mol
Pr4= 0.98;                                          %Dimensionless
n4=0.99;                                            %Dimensionless
 
Tmax_0 = 1300;    % K
b_max = 0.12;     % dimensionless
C_b1 = 700;       % K
b = 0.1;          % dimensionless (burner output, given condition)

T_max = Tmax_0 + C_b1 * (b/b_max)^(1/2);

Ru= 8.314;                                          %J/mol*k
%R= (Ru/Mw)*1000;                                           %J/g*k
R= 287;
Cp4=R* (gamma4/(gamma4-1));                          %J/kg*k

%Maximum Stagnation Temp Ratiov 
MaxRatio= T_max/T03;     %                           Dimensionless

%Max Fuel Ratio
%fmax= (1-(1/MaxRatio))/((n4*Qf/(Cp4*T03*MaxRatio)-1)); %Dimensionlesss
% Correct fmax derived from Enthalpy Balance:
% (Cpc * T03) + (f * Qf * n4) = (1 + f) * Cp4 * T_max

numerator = (Cpc * T_max) - (Cpc * T03);
denominator = (n4 * Qf) - ((Cpc) * T_max);

fmax = numerator / denominator;
%Burner Stagnation Pressure
p04=Pr4*p03;                                         %kPa
%QR = Qf/.99;


ratio= ((1) + (f * n4*Qf/((Cp4)*T03))) / (1+f);  
%T04 = (((Cpc/Cp4)*T03)+(f*n4*(Qf/Cp4)))/(1+f);
T04= ratio*T03;                                      %K

end