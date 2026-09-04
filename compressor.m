function[P03,T03,w3,Cpc] =compressor(P02,T02,Prc)
P03 = P02*Prc;
nc = .92;
gamma3 = 1.4;
T03 = T02*(1+(1/nc)*(Prc^((gamma3-1)/gamma3)-1));
R = 287;
Cpc = (gamma3*R)/(gamma3-1);
w3 = Cpc*(T03-T02);
end
   