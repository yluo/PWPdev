

% -------------------------------------------------------------------------
% Load wind forcing - QScat winds
% -------------------------------------------------------------------------


%load HybridForcingQ.mat;  %% Qscat where available, otherwise NCEP


% % -------------------------------------------------------------------------
% % physical constants
% % -------------------------------------------------------------------------
% 
% atm_Pa = 101325.0;      % atmospheric pressure in Pa
% hcapy=1.e-6;			% heat capacity in deg/cal/m3
% j2cal=0.23905;			% joules -> calories
% tday = 60*60*24;        % seconds in a day
% tyr = tday*365.25;      % seconds in a year
% g = 9.807;              % grav. const. (m/s2)
% rho_m = 1023;           % approx density
% R = 8.314;              % gas constant

% % -------------------------------------------------------------------------
% % Model parameters
% % -------------------------------------------------------------------------
% 
% dz = 2;
% zmax = 1000;
% BRiFac=g*dz/rho_m;		% factor for bulk Ri No Calculation
% GRiFac=g*dz/rho_m;		% factor for Grad Ri No Calculation
% BRiCrit=.65; GRiCrit=.25;	% critical values for overturning
% TSOint_z = 600;         % z for depth integrated values

ta = yrstart; mlt=zeros(5,5); mls=zeros(5,5); wct=zeros(5,5); wcs=zeros(5,5);
EkpMaxDep = 550;

%
%		load the NCEP forcing (above) for the duration of the experiment
%		at 6 hourly intervals, with the following variables input
% 		from forcing.mat
%			 DateTime       time 					years
%			 LHTFL          latent heat flux 	watts/m^2
%			 PRATE          precipitation			kg/m^2
%			 PRES           sea level pressure	Pa
%			 SHTFL          sensible heat flux	watts/m^2
%			 nLWRS          net longwave radn	watts/m^2
%			 nSWRS          net shortwave radn	watts/m^2
%			 uStress        zonal stress			N/m^2
%			 uWind          zonal wind				m/s
%			 vStress        meridional stress	N/m^2
%			 vWind          meridional wind		m/s
%            CURL           wind stress curl   N/m^3
%


% calculated model parameters
nyrs = yrstop - yrstart;
dt=min([0.4*dz*dz/max(Kz) 0.4*dz*dz/max(Kt) 2.e4]);	% time step must resolve diurnal scales (dt < 6 hours)
z=[dz/2:dz:zmax-dz/2]'; nz=length(z); zp=[0:dz:zmax];	% useful depth vectors
tmax=nyrs*tyr; nt=nyrs*tyr/dt;                  % time constants
treport = tyr;  nreport = treport/dt;           % report once a year
t=[1:nt]*dt/tyr + yrstart; tpf=2*pi*t/tyr;		% time vector, etc.

%
%		the following for easy sigmaT calculation
%		using a linearized equation of state
%
%
%
omega=2*pi/tday; f=2*omega*cosd(latitude);

% ------------------------------------------------------------------------
%       the wind stress curl data is very noisy as it is calculated
%       directly from wind stress data on 6-hourly basis, and we need
%       to filter out variations ocurring on times comparable to or less 
%       than a few inertial periods
% ------------------------------------------------------------------------
% 

oldcurl = F.CURL;


[b,a]=butter(12,.2/2);  % create low pass filter with 5 day period (if use 20 then get all zeros)
%               note that the nyquist limit is 2 per day
curl=filtfilt(b,a,F.CURL);    % and use a phase correcting implementation
ekp=curl/rho_m/f;			% compute vert vel. (pos. down) from curl
wv=interp1(F.DateTime,ekp,t,'linear');     % actual curl calculated
nwmax=EkpMaxDep/dz;wvf=dt*[[nwmax:-1:1]/nwmax zeros(1,nz-nwmax)]'/dz;

% -------------------------------------------------------------------------
%		vertical attenuation of w, going to zero at base of seasonal layer
%				For the stress: divide by rho and multiply by
%					dt/dz to get acceleration
%				and compute wind speed from components
%  -----------------------------------------------------------------------

taux=dt*F.uStress/rho_m/dz;  tauy=dt*F.vStress/rho_m/dz;

%if Qwinds    
    wspeed = (F.u10m.^2 + F.v10m.^2).^0.5;
%else   
%    wspeed = (uWind.^2 + vWind.^2).^0.5;
%end
%				and reiDateTime,curl,'r'nterpolate wind stress and speeds onto time vector
taux=interp1(F.DateTime,taux,t,'linear'); tauy=interp1(F.DateTime,tauy,t,'linear');
wspeed=interp1(F.DateTime,wspeed,t,'linear');

%  ------------------------------------------------------------------------ 
%		next compute heat flux, wind speed and radiant heat for run
%		and normalize for temperature change
%		NB: have to adjust offset in THF for closure
% -------------------------------------------------------------------------

htfact=hcapy*dt*j2cal/dz;	% converts to temperature change in cell
TotHeat = F.nLHTFL + F.nSHTFL + F.nLWRS + F.nSWRS;
ResidualHeat = csaps(F.DateTime,TotHeat,LowPassFactor,F.DateTime);  % use lowpassed heat offset
%ResidualHeat = csaps(DateTime,TotHeat,0.00,DateTime);  % use lowpassed heat offset
%NetHeatOffset = EkmHeatConv - ResidualHeat;


%%%%% CHANGED HERE


NetHeatOffset = EkmHeatConv- 0.*ResidualHeat;

% actual net heat flux offset to make it sum to 0 over some time interval
% the above is to compensate for the net heat imbalance in the NCEP
% data for this locale partly compensated for ekman heat convergence
% (associated with downwelling of warm surface water)
rhf=-F.nSWRS*htfact; rhf=interp1(F.DateTime,rhf,t,'linear');
thf=-(F.nLWRS + F.nLHTFL + F.nSHTFL)*htfact; thf=interp1(F.DateTime,thf,t,'linear');
hhc=-interp1(F.DateTime,NetHeatOffset*htfact,t,'linear');
slp=interp1(F.DateTime,F.PRES/atm_Pa,t,'linear');     % compute/interpolate sea level pressure pascals -> atmospheres
% relative humidity in mm Hg?
ph2o=F.RHUM/100.*Humidity(F.AIRT-273)/760; % compute partial pressure of water in atm
ph2o=interp1(F.DateTime,ph2o,t,'linear'); 
patmdry=slp-ph2o; % pressure of dry air in atm -- used in gasexhak
vhec=zeros(zmax/dz,1);
if VHEC ~= 0 
    ndepvhec=100*VHEC/dz;
    vhec(1:ndepvhec)=1;
    hhc=hhc/ndepvhec;
else
    vhec(1)=1;
end
%  ------------------------------------------------------------------------
%  
%		differential irradiance curve, and the
%		surface irradiance history (minus sign for direction
%		of difference)
% -------------------------------------------------------------------------
  
dRdz=-diff(0.62*exp(-1.67*zp)+0.38*exp(-0.05*zp))';
  
  % param version from Hamme et a. (2006) light a bit deeper...use for HOT
  %dRdz=-diff(0.49*exp(-0.04*zp)+0.51*exp(-zp))';

% -------------------------------------------------------------------------
%		now compute fresh water flux effects
% -------------------------------------------------------------------------

FWfact=dt/dz;			% converts fw flux to salinity change
hfactor=540 * 1000 / j2cal;	% converts watts to kg/s


% -------------------------------------------------------------------------
%		net water flux = PRATE - LHTFL/factor
%		where PRATE is in kg/m^2/s
%		where factor = 0.23905 J/cal * 540 cal/g * 1000 g/kg
%		and LHTFL is in watts/m^2 = J / s/m^2
%		Also: net E - P is about 65 cm/y, so an offset is applied to balance the FWF
%		over the period, assuming that this is achieved by lateral FWF divergence
% -------------------------------------------------------------------------

NetEminusPOffset=csaps(F.DateTime,F.PRATE-F.nLHTFL/hfactor,LowPassFactor,F.DateTime);		% balance salt
FWFlux=FWfact * (F.PRATE - F.nLHTFL/hfactor - NetEminusPOffset - EkmSaltConv); 
FWFlux=1-FWFlux/1000;			% convert to salinity multiplier (1 - kg/m^3)
FWFlux=interp1(F.DateTime,FWFlux,t,'linear');		% recast onto time vector

% -------------------------------------------------------------------------
%		compute the weight factors for FUDM advection
%		but cannot include vertical advection because it
%		changes with time, so the minus and "0" factors
%		are provisional and will be adjusted for wv in advdif.m
%		(this is not done on a "wim")
% -------------------------------------------------------------------------
 
wim=Kz*dt/dz/dz*ones(nz,1); wp=wim; wim(1)=0; wi0=1-wp-wim; wi0(1)=1-wp(1);
wimt=Kt*dt/dz/dz*ones(nz,1); wpt=wimt; wimt(1)=0; wi0t=1-wpt-wimt; wi0t(1)=1-wpt(1);

% -------------------------------------------------------------------------
%	Various factors/vectors of convenience
% -------------------------------------------------------------------------

% recording interval in # per day
tintv = 1;%tday./dt;
% convert to number of time steps
tintv=round(tday./(dt.*tintv));	NumPerYear = 48;	% sampling interval = #/month

% index of float profile times
tprofind = round(interp1(t,1:length(t),t_float(1,:)));

% -------------------------------------------------------------------------
%		rotation matrix for velocity/momemtum
%		"f" factor is rotation effect due to coriolis
% -------------------------------------------------------------------------

angle=f*dt*.5;		% half angle of coriolis rotation during dt
cosang=cos(angle);
sinang=sin(angle);
rotn=[cosang -sinang; sinang cosang];	% velocity rotation matrix

% -------------------------------------------------------------------------
%		counters for tracking profile adjustment activity
% -------------------------------------------------------------------------

nbri=0;ngri=0;nstin=0;			% counters
nnbri=0;nngri=0;nnstin=0;		% accumulated counters
oldnow=0;                       % start with clean slate
noften=tintv/dt;                % how many iterations in a report cycle
nclock=0;                       % for telling time every so often
nlineret=0;


% -------------------------------------------------------------------------
%		observed temperature for restoring interpolated
% -------------------------------------------------------------------------





    
    
