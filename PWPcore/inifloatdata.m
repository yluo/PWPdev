
%function [float yrstart yrstop] = inifloatdata(floatfile)

load([float_path '/' floatfile]);
float_tracers = {'O2','NO3'};

activetr = intersect(float_tracers,tracer_name);
nactive = length(activetr);

[~,float.lon] = findprofile(data,z,find(strcmp('lon',data_header)));
float.lon_mean = mean(float.lon(5,:));
[~,float.lat] = findprofile(data,z,find(strcmp('lat',data_header)));
float.lat_mean = mean(float.lat(5,:));
[~,float.T] = findprofile(data,z,find(strcmp('T',data_header)));
float.T(1:4,:) = repmat(float.T(5,:),4,1);
[~,float.S] = findprofile(data,z,find(strcmp('S',data_header)));
float.S(1:4,:) = repmat(float.S(5,:),4,1);
[~,float.t] = findprofile(data,z,find(strcmp('yrdate',data_header)));
float.t(1:4,:) = repmat(float.t(5,:),4,1);

ndives = size(float.T,2);
float.tr = zeros(nz,ndives,ntracers);
for ii = 1:nactive
    tr = float_tracers{ii};
    [~,float.tr(:,:,tr2ind(tr))] = findprofile(data,z,find(strcmp(tr,data_header)));
    % no float data from top 4 meters -- replace with 5 m data
    float.tr(1:4,:,tr2ind(tr)) = repmat(float.tr(5,:,tr2ind(tr)),4,1);
end

% Multiply by correction factor....
tr(:,:,tr2ind('O2')) = O2fact.*tr(:,:,tr2ind('O2'));

yrstart = float.t(1,1);
% decimal date of end of float data (pad one day)
yrstop = float.t(1,end)+1/365;





