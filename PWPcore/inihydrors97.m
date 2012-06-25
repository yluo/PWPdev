% -------------------------------------------------------------------------
%	IniHydro - sets initial conditions for the hydrography
%
%		Initial conditions : ML Depth = 140 m
%				     Tml = 19.5 C
%				     Sml = 36.60 psu
%		Boundary conditions : (@ zmax)
%				     Tbot = 18.0
%				     Sbot = 36.49
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% Set initial temperature and salinity profiles
% -------------------------------------------------------------------------

T=zeros(nz,1); S=zeros(nz,1); UV=zeros(nz,2); epsUV=1e-8*ones(nz-1,1);



load batsinithydro_97 % initialize profile from 1997.03467
tr=data;
tr(1,5) = 0; % set shallowest depth to 0

T=interp1(tr(:,5),tr(:,7),z,'linear');
S=interp1(tr(:,5),tr(:,8),z,'linear');	% interpolate to model grid

T0=T(1); S0=S(1);
TB=T(end); SB=S(end);
zmld=70; mld=zmld/dz;

%Sig=Sigref+Alpha*(T-Tref)+Beta*(S-Sref);	% compute density
Sig = sw_dens0(S,T);
% initialize storage variables
Ta=T; Sa=S; Siga=Sig; UVa=UV;  tml=T(1); sml=S(1);%ta=yrstart;
TotalHeat = dz*sum(T(z<=TSOint_z))/TSOint_z;
TotalSalt = dz*sum(S(z<=TSOint_z))/TSOint_z;

wct0=mean(T); wss0=mean(S);

