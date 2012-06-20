
load(floatfile);
float_tracers = {'O2','NO3'};

activetr = intersect(float_tracers,tracer_name);
nactive = length(activetr);

[divev,lon] = findprofile(data,z,find(strcmp('lon',data_header)));
loFLT = mean(lon(5,:));
[divev,lat] = findprofile(data,z,find(strcmp('lat',data_header)));
laFLT = mean(lat(5,:));
[divev,T_float] = findprofile(data,z,find(strcmp('T',data_header)));
T_float(1:4,:) = repmat(T_float(5,:),4,1);
[divev,S_float] = findprofile(data,z,find(strcmp('S',data_header)));
S_float(1:4,:) = repmat(S_float(5,:),4,1);
[divev,t_float] = findprofile(data,z,find(strcmp('yrdate',data_header)));
t_float(1:4,:) = repmat(t_float(5,:),4,1);

ndives = size(T_float,2);
tr_float = zeros(nz,ndives,ntracers);
for ii = 1:nactive
    tr = float_tracers{ii};
    [divev,tr_float(:,:,tr2ind(tr))] = findprofile(data,z,find(strcmp(tr,data_header)));
    % no float data from top 4 meters -- replace with 5 m data
    tr_float(1:4,:,tr2ind(tr)) = repmat(tr_float(5,:,tr2ind(tr)),4,1);
end

% Multiply by correction factor....
tr_float(:,:,tr2ind('O2')) = O2fact.*tr_float(:,:,tr2ind('O2'));

yrstart = t_float(1,1);
yrstop = t_float(1,end)+1/365;





