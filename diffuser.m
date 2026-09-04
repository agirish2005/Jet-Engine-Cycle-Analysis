function[P02,T02] = diffuser(Ta, pa, M)
gamma2 = 1.4;
T02 = Ta*(1+(((gamma2-1)/2)*(M^2)));
if M < 1
    rd = 1;
else 
    rd = 1 - .075*(M-1)^1.35;
end
nd = .92;
P02 = rd * pa * (1 + nd * (gamma2 - 1)/2 * M^2)^(gamma2/(gamma2 - 1));
end
  

% function[P03,T03] =compressor(P02,T02)
% P03 = P02*Prc;
% nc = .92;
% gamma3 = 1.4;
% T03 = T02*(1+(1/nc)*(Prc^((gamma3-1)/gamma3)-1));
% end

 
% function[P03,T03] =inlet(Ta, pa)
%     [P02,T02] = diffuser(Ta, pa)
%     [P03,T03] =compressor(P02,T02)
%     end