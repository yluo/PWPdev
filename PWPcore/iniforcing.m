%%% Loads NCEP forcing


%%% if Forcing.mat exists, then loads from file, else extract forcing from
%%% ncep archive
%%% note: currently only 2000-mid2011 available...

try
    load forcing.mat;
catch
    F = get_forcing(ncep_path,float.lat(5,:),float.lon(5,:),float.t(5,:));
end
latitude = float.lat_mean;