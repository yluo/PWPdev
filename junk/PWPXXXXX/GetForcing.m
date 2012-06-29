oldpath = cd;
basepath = '/Users/Roo/Documents';
cd([basepath '/Data/NCEP1']);

%%%%%%%%%%

%  Read data from netCDF files
%  All files should be the same length:  4x daily from 1/1/90 to 1/1/2009

% sets float coordinates here:

%laFLT = 37.97;
%loFLT = 294.8;

% Coords for BATS
%lat_t62 = [33.3328 31.4281];
%lon_t62 =[-63.750 -65.625];

%deltaX = sw_dist([mean(lat_t62) mean(lat_t62)],[lon_t62(1) lon_t62(2)],'km')*1000;
%deltaY = sw_dist([lat_t62(1) lat_t62(2)],[mean(lon_t62) mean(lon_t62)],'km')*1000;


% 10 meter zonal (u) wind (m/s)

u10_id = netcdf.open('uwnd.10m.gauss.2000.nc','nowrite');

% get time vector

timeid = netcdf.inqVarID(u10_id,'time');
time = double(squeeze(netcdf.getVar(u10_id,timeid)));

% get lat and long indices
laid = netcdf.inqVarID(u10_id,'lat');
loid = netcdf.inqVarID(u10_id,'lon');
la = double(squeeze(netcdf.getVar(u10_id,laid)));
lo = double(squeeze(netcdf.getVar(u10_id,loid)));
[x ila] = min(abs(la-laFLT));
[x ilo] = min(abs(lo-loFLT));

[timeall u10m] = nccat(laFLT,loFLT,'uwnd.10m.gauss','uwnd',2000,2011);
[timeall v10m] = nccat(laFLT,loFLT,'vwnd.10m.gauss','vwnd',2000,2011);
[timeall nSWRS] = nccat(laFLT,loFLT,'nswrs.sfc.gauss','nswrs',2000,2011);
[timeall nLWRS] = nccat(laFLT,loFLT,'nlwrs.sfc.gauss','nlwrs',2000,2011);
[timeall SHTFL] = nccat(laFLT,loFLT,'shtfl.sfc.gauss','shtfl',2000,2011);
[timeall LHTFL] = nccat(laFLT,loFLT,'lhtfl.sfc.gauss','lhtfl',2000,2011);
[timeall PRATE] = nccat(laFLT,loFLT,'prate.sfc.gauss','prate',2000,2011);
[timeall PRES] = nccat(laFLT,loFLT,'slp','slp',2000,2011);
[timeall RHUM] = nccat(laFLT,loFLT,'rhum.sig995','rhum',2000,2011);
[timeall AIRT] = nccat(laFLT,loFLT,'air.sig995','air',2000,2011);
[timeall uStress,latY,lonY] = nccat(laFLT,loFLT,'uflx.sfc.gauss','uflx',2000,2011);
[timeall vStress,latX,lonX] = nccat(laFLT,loFLT,'vflx.sfc.gauss','vflx',2000,2011);

deltaX = abs(sw_dist([latX lonX(1)],[latX lonX(3)])./2);
deltaY = abs(sw_dist([latY(1) lonY],[latY(3) lonY])./2);


% calculate curl

%dTauXdY = squeeze(mean(diff(uStress)/deltaY));

dTauXdY = squeeze(mean(diff(uStress))/deltaY);
dTauYdX = squeeze(mean(diff(vStress))/deltaX);
%dTauYdX = squeeze(mean((vStress(:,2,:)-vStress(:,1,:))/deltaX));
CURL = dTauYdX - dTauXdY;

uStress = squeeze(uStress(2,:));
vStress = squeeze(vStress(2,:));
cd(oldpath);

% convert time in hours since 1/1/1 00:00:00 to decimal year
% for some reason, datenum ends up 48 hours off?
serialdate = datenum(1,1,1,timeall-48,0,0);
dv = datevec(serialdate);
[doy yearfrac] = date2doy(serialdate);
DateTime = dv(:,1) + yearfrac;

save('Forcing.mat','CURL','DateTime','uStress','vStress','u10m','v10m','PRATE','nSWRS','nLWRS','SHTFL','LHTFL','PRES','RHUM');
