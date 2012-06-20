%%%
%
% -------------------------------------------------------------------------
% INPUTS
% -------------------------------------------------------------------------
% ncep path:    root directory for ncep files (e.g.
%               /Users/Roo/Documents/MATLAB/Datasets/ncep.reanalysis
% lat, lon:     vectors of observed profile lat/lon (must be same length)
% t:            vector of matlab datenum dates for corresponding profiles
%               lat/lon/t can also be just max/min values, e.g. lat = [20
%               24]; lon = [200 205]; t = [datenum(2012,1,1)
%               datenum(2012,3,1)];
%  
%
%%%%%
function [F] = get_forcing(ncep_path,lat,lon,t)

% define study domain
yvec = datevec(datenum(t,1,1));
yr_rng = [yvec(1,1) yvec(end,1)];
% make all longitudes positive
lon(lon < 0) = lon(lon < 0) + 360;

% initialize final output struct
F.u10m = [];
F.v10m = [];
F.nSWRS = [];
F.nLWRS = [];
F.nSHTFL = [];
F.nLHTFL = [];
F.PRATE = [];
F.PRES = [];
F.RHUM = [];
F.AIRT = [];
F.uStress = [];
F.vStress = [];
F.CURL = [];
F.DateTime = [];

% get forcing for each year and concatenate
for yr = yr_rng(1):yr_rng(2)
    
    latyr = lat(yvec(:,1) == yr);
    lonyr = lon(yvec(:,1) == yr);
    dn_tyr = datenum(t(yvec(:,1) == yr),1,1);
    % data domain for yr
    dn_trng = [min(dn_tyr) max(dn_tyr)];
    lat_rng = [min(latyr) max(latyr)];
    lon_rng = [min(lonyr) max(lonyr)];
    
    % 10 meter zonal (u) wind (m/s)
    
    flxpath = [ncep_path '/surface_gauss/'];
    srfpath = [ncep_path '/surface/'];
    
    % get time vector, ncep lat and lon grids
    time = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'],'time');
    
    % ncep time --> matlab datenumber
    % for some reason need to add a 48 hour offset....
    dntime = datenum(1,1,1,time-48,0,0);
    
    % only select forcing up to last observation for final year..
    if yr  == yr_rng(2)
        dntime = dntime(dntime <= dn_trng(2));
    end
    
    
    nt = length(dntime);
    
    latvec = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'],'lat');
    lonvec = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'],'lon');
    
    
    % Find ncep indices that bound model domain (padded by 1 degree)
    % note: max and min are 'switched' here because ncep lat decreases
    % monotonically
    
    [~, min_ind(1)] = min(abs(lon_rng(1)-1-lonvec));
    [~, max_ind(1)] = min(abs(lon_rng(2)+1-lonvec));
    
    [~, max_ind(2)] = min(abs(lat_rng(1)-1-latvec));
    [~, min_ind(2)] = min(abs(lat_rng(2)+1-latvec));
    
    % initialize output vectors here
    dv = datevec(dntime);
    [~, yearfrac] = date2doy(dntime);
    DateTime = dv(:,1)+yearfrac;
    
    u10m = zeros(nt,1);
    v10m = zeros(nt,1);
    nSWRS = zeros(nt,1);
    nLWRS = zeros(nt,1);
    nSHTFL = zeros(nt,1);
    nLHTFL = zeros(nt,1);
    PRATE = zeros(nt,1);
    PRES = zeros(nt,1);
    RHUM = zeros(nt,1);
    AIRT = zeros(nt,1);
    uStress = zeros(nt,1);
    vStress = zeros(nt,1);
    CURL = zeros(nt,1);
    
    % time dimension here
    min_ind(3) = 1;
    max_ind(3) = Inf;
    
    
    % get indices for hyperslab
    lonslab = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'], 'lon',min_ind(1),1+max_ind(1)-min_ind(1),1);
    latslab = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'], 'lat',min_ind(2),1+max_ind(2)-min_ind(2),1);
    n_ind = max_ind-min_ind+1;
    % load surface_flux ncep variables
    y_u10m = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'], 'uwnd',min_ind,n_ind,[1 1 1]);
    y_v10m = ncread([flxpath 'vwnd.10m.gauss' '.' num2str(yr) '.nc'], 'vwnd',min_ind,n_ind,[1 1 1]);
    y_nswrs = ncread([flxpath 'nswrs.sfc.gauss' '.' num2str(yr) '.nc'], 'nswrs',min_ind,n_ind,[1 1 1]);
    y_nlwrs = ncread([flxpath 'nlwrs.sfc.gauss' '.' num2str(yr) '.nc'], 'nlwrs',min_ind,n_ind,[1 1 1]);
    y_shtfl = ncread([flxpath 'shtfl.sfc.gauss' '.' num2str(yr) '.nc'], 'shtfl',min_ind,n_ind,[1 1 1]);
    y_lhtfl = ncread([flxpath 'lhtfl.sfc.gauss' '.' num2str(yr) '.nc'], 'lhtfl',min_ind,n_ind,[1 1 1]);
    y_prate = ncread([flxpath 'prate.sfc.gauss' '.' num2str(yr) '.nc'], 'prate',min_ind,n_ind,[1 1 1]);
    y_uflx = ncread([flxpath 'uflx.sfc.gauss' '.' num2str(yr) '.nc'], 'uflx',min_ind,n_ind,[1 1 1]);
    y_vflx = ncread([flxpath 'vflx.sfc.gauss' '.' num2str(yr) '.nc'], 'vflx',min_ind,n_ind,[1 1 1]);
    % load surface ncep variables
    y_rhum = ncread([srfpath 'rhum.sig995' '.' num2str(yr) '.nc'], 'rhum',min_ind,n_ind,[1 1 1]);
    y_air = ncread([srfpath 'air.sig995' '.' num2str(yr) '.nc'], 'air',min_ind,n_ind,[1 1 1]);
    y_slp = ncread([srfpath 'slp' '.' num2str(yr) '.nc'], 'slp',min_ind,n_ind,[1 1 1]);
    
    %
    % calculate curl
    %
    % Coordinate transform from deg to km
    reflon = mean(lonslab);
    reflat = mean(latslab);
    % calculate distance between longitudes @ reflat
    x_scale = distance(reflat,lonslab(1),reflat,lonslab(end))./(lonslab(end)-lonslab(1));
    %x_dist and y_dist in meters
    x_dist = 1000*deg2km(lonslab-reflon).*x_scale;
    y_dist = 1000*deg2km(latslab-reflat);
    [X,Y] = meshgrid(y_dist,x_dist);
    
    % linearly interpolate latitude and longitude to ncep time variable
    % for ncep time out of range of observations, reference lat and lon are
    % used
    latint = interp1(dn_tyr,latyr,dntime,'linear',reflat);
    lonint = interp1(dn_tyr,lonyr,dntime,'linear',reflon);
    for jj = 1:nt
        [~, ila] = min(abs(latslab-latint(jj)));
        [~, ilo] = min(abs(lonslab-lonint(jj)));
        
        u10m(jj) = y_u10m(ilo,ila,jj);
        v10m(jj) = y_v10m(ilo,ila,jj);
        nSWRS(jj) = y_nswrs(ilo,ila,jj);
        nLWRS(jj) = y_nlwrs(ilo,ila,jj);
        nSHTFL(jj) = y_shtfl(ilo,ila,jj);
        nLHTFL(jj) = y_lhtfl(ilo,ila,jj);
        PRATE(jj) = y_prate(ilo,ila,jj);
        PRES(jj) = y_slp(ilo,ila,jj);
        RHUM(jj) = y_rhum(ilo,ila,jj);
        AIRT(jj) = y_air(ilo,ila,jj);
        uStress(jj) = y_uflx(ilo,ila,jj);
        vStress(jj) = y_vflx(ilo,ila,jj);
        jjcurl = curl(X,Y,y_uflx(:,:,jj),y_vflx(:,:,jj));
        CURL(jj) = jjcurl(ilo,ila);
    end
    
    F.u10m = [F.u10m;u10m];
    F.v10m = [F.v10m;v10m];
    F.nSWRS = [F.nSWRS;nSWRS];
    F.nLWRS = [F.nLWRS;nLWRS];
    F.nSHTFL = [F.nSHTFL;nSHTFL];
    F.nLHTFL = [F.nLHTFL;nLHTFL];
    F.PRATE = [F.PRATE;PRATE];
    F.PRES = [F.PRES;PRES];
    F.RHUM = [F.RHUM;RHUM];
    F.AIRT = [F.AIRT;AIRT];
    F.uStress = [F.uStress;uStress];
    F.vStress = [F.vStress;vStress];
    F.CURL = [F.CURL;CURL];
    F.DateTime = [F.DateTime;DateTime];
end
                        


