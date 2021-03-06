% -------------------------------------------------------------------------
%
%  Set all optional model paramters here
%
% -------------------------------------------------------------------------

% Path for core functions here
addpath('/Users/Roo/Documents/PWPdev/PWPcore',0);

% -------------------------------------------------------------------------
% list of tracers to be run
% -------------------------------------------------------------------------

floatfile = 'Bermuda.mat';
% specify which tracers to include here
%tracer_name = {'Ar','O2','O18','O17'};
tracer_name = {'O2'};
ntracers = length(tracer_name);
tracer_ind = num2cell(1:ntracers);

% map tracer name to index and vice versa
% now can call for example: ind2tr('Ar') to get 1 or tr2ind(1) to get 'Ar'
ind2tr = containers.Map(tracer_ind,tracer_name);
tr2ind = containers.Map(tracer_name,tracer_ind);

% -------------------------------------------------------------------------
%  biology parameters
% -------------------------------------------------------------------------
pfract = 0;
bioON_OFF = 1;  % biology on/off switch for o2 isotopes.  1 = biology on, 0 = biology off  

oxyamp =  10;%5;  % amplitude of NCP (mol O2 m-2 y-1)
oxycons= 18; % magnitude of biological consumption -- integrated
c14_2_GPP = 2.7;  % set fixed GOP:NPP(14C) here


% -------------------------------------------------------------------------
%  wind/gas exchange paramters
% -------------------------------------------------------------------------

% power of piston velocity
pvpower = 2; 
LowPassFactor = 1E-5;

% Air sea exchange magnitude factors
gasexfact = 0.9332;         % relative to Wanninkof 1992
% Bubble flux parameters (see Stanley et al. 2009)
Ac = 9.1E-11./4;            
Ap = 2.3E-3./4;
diffexp=2/3; betaexp=1; % exponents used in air injection equation for diffusivity and for solubilitiy, see gasexcha
zbscale=0.5; % scaling factor for depth of bubble penetration -- see inigasa for details

% -------------------------------------------------------------------------
%  physical parameters
% -------------------------------------------------------------------------

% Ekman heat transport (W/m2)
EkmHeatConv = -28;
%EkmHeatConv = 0;
% Depth range of lateral heat flux (in 100's of meters)
VHEC= 0.5;
% Ekman salt convergence due to fresh water downward pumping
EkmSaltConv = 1.75E-6;  

% Vertical diffusivity (m2/s)
Kz = 11*1e-5;
TracerDiffFactor = 1;
Kt = TracerDiffFactor*Kz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% -------------------------------------------------------------------------
% output storage arrays
% -------------------------------------------------------------------------

outt = [];
outS = [];
outT = [];
outdS = [];
outdT = [];
outTra = [];
outD_Tra = [];
outPV = [];

% -------------------------------------------------------------------------
% run model
% -------------------------------------------------------------------------

 pwp;
 %modelout;




