function [pCO2,CO2,HCO3,CO3,CO2eq,h]=pco2_dicalk(TC,S,P,DIC,ALK,pCO2atm)

% in mol/kg
dic1=DIC/1e6;
alk1=ALK/1e6;

phflag = 0;     % 0: Total scale
                % 1: Free scale

%----- choose K1 and K2: Roy or Mehrbach.

k1k2flag = 0;	% 0: Roy et al. (1993)
		% 1: Mehrbach et al (1973) as 
		%    refit by Lueker et al. (2000) on total scale.

equic;                      
bor = 1.*(416.*(S/35.))* 1.e-6;   % (mol/kg), DOE94

alk = alk1;
dic = dic1;
p5  = -1.;        
p4  = -alk-Kb-K1;
p3  = dic*K1-alk*(Kb+K1)+Kb*bor+Kw-Kb*K1-K1*K2;
tmp = dic*(Kb*K1+2.*K1*K2)-alk*(Kb*K1+K1*K2)+Kb*bor*K1;
p2  = tmp+(Kw*Kb+Kw*K1-Kb*K1*K2);
tmp = 2.*dic*Kb*K1*K2-alk*Kb*K1*K2+Kb*bor*K1*K2;
p1  = tmp+(+Kw*Kb*K1+Kw*K1*K2);
p0  = Kw*Kb*K1*K2;
p   = [p5 p4 p3 p2 p1 p0];
r   = roots(p);
h   = max(real(r));
%   test = p5*h^5+p4*h^4+p3*h^3+p2*h^2+p1*h+p0
h*1.e12;
s = dic / (1.+K1/h+K1*K2/h/h);
%   dic = s*(1.+K1/h+K1*K2/h/h);
hco3 = dic/(1+h/K1+K2/h);
co3 = dic/(1+h/K2+h*h/K1/K2);
%   alk = s*(K1/h+2.*K1*K2/h/h)+Kb*bor/(Kb+h)+Kw/h-h;

CO2eq = pCO2atm*Kh;
pco2 = s/Kh;

% ----------- change units: mumol/kg
%h1 = 10^(-ph1); %
CO2     = s*1.e6;
pCO2    = s*1.e6/Kh;
HCO3    = hco3*1.e6;     
CO3     = co3*1.e6;
DIC     = dic*1.e6;
ALK     = alk*1.e6;
