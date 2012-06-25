% -------------------------------------------------------------------------
% Initialize productivity and respiration profiles
% -------------------------------------------------------------------------
%		
%      productivity profile is proportional to sin(pi * z/76) for 0<=z<=76
%(choose a 76 meter compensation depth -- later may make this a variable)
%           and area of this curve will be 152/pi
% also we will set consumption curve to have profile found by our aour
% study. it will have separate amplitude since production and consumption
% not necessarily balanced on instantaneous time scales. we calculate area
% by integrating the spline (since it is per m this is easy to do)a nd
% scale accordingly 
%
%
% conversion factors:> area sine, y-> sec, mol/m3-> umol/kg
%				
%
z_scale = 76; % default is 76 meters
%z_scale = 120;

% oxyamp in mol m-2 yr-1
oxyfac=oxyamp*(pi/(2*z_scale))*dt/dz/tyr;


Prod=zeros(nz,1); nmld=z_scale/dz; 
Prod(1:nmld)=oxyfac*sin(pi*z(1:nmld)/z_scale);


% -------------------------------------------------------------------------
% set respiration based on average aou profile at BATS
% -------------------------------------------------------------------------

% now work on consumption
load aourprof.txt; % load in aour profile
%areaaour=sum(aourprof(:,2)); % calculate area so that can scale units
aour = interp1(aourprof(:,1), aourprof(:,2), z(nmld+1:nz));
aour(aour < 0) = 0;
areaaour=dz*sum(aour); % calculate area so that can scale units
oxyconsfac=oxycons/areaaour*dt/dz/tyr; % unit conversion
Prod(nmld+1:nz)=-oxyconsfac*aour;

% -------------------------------------------------------------------------
% Seasonality
% -------------------------------------------------------------------------

% maximum Prod in June (.2)
PofT=(1+sin((t-2005.2)*pi*2));


