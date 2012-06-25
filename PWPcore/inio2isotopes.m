% -------------------------------------------------------------------------
% Load BATS 14C PP
% -------------------------------------------------------------------------

load c14_bats_new.mat


 P14C = interp1(c14z, c14, z);
 P14C = interp1(c14t, P14C',t)';
 
% set production to zero below 140 m
P14C(71:end,:) = 0;
%
% convert p(14C) to GPP  (Marra, J 2002 --> 2.7)
% 
% conversion factors 12011 mg C/mol C, 1e6./1024 (umol/kg-->mol/m3) 60*60*24 s/d

% Uncomment for variable GPP_NPP
% -------------------------------

% GPP units are mol m-3 s-1
GPP = c14_2_GPP.*P14C./(tday.*12011);

% -------------------------------------------------------------------------
% Initialize O2 isotope constants
% -------------------------------------------------------------------------

%  from Angert et al. (2003)
%  0.518 value used instead of 0.516 (Luz and Barkan 2005) 8/12/09
lambda = 0.518;
o17max = 249;

% fractionation factors
%a18r = 0.978;%;0.982;  % fraction during respiration is -18 per mil (Kiddon et al. 1993) for bacteria
%a17r = a18r.^lambda; % mass dependent

a18r = 0.980;
a17r = lambda.*(a18r-1)+1;

% set standard to be air
r18a = 1;
r17a = 1;
% set water 
r18w = .97704;
%r17w = .988331;
theta = log(1+lambda*(a18r-1))./log(a18r);
r17w = (r18w./r18a)^theta.*(exp(249./1e6));

% photosythesis
a18p = 1.000;
a17p = a18p.^lambda; % mass dependent
% gas exchange kinetic fractionation 
%a18gek = 1/0.9972; % (18k/16k) kinetic fractionation during gas exchange from Knox et al. (1992)
a18gek = 0.9972; 
%a17gek = a18gek.^lambda; % mass dependent
a17gek = lambda.*(a18gek-1)+1;

% gas exchange equilibrium fractionation
a18ge = 1.00062; % Benson and Krause (1980) equilibrium 18/16 @25 C
%a17ge set in o2isotopes.m based on temperature and
%cap17O_eq at each time step






