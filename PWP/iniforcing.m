%%% Loads NCEP forcing


%%% if Forcing.mat exists, then loads from file, else extract forcing from
%%% ncep archive
%%% note: currently only 2000-mid2011 available...

try
    load Forcing.mat;
catch
    GetForcing.m;
end
latitude = laFLT;