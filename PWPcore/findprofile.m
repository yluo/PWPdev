% function to break Argo data into discrete profiles

function [divev,dataout] = findprofile(data,zgrid,varcol)

zcol = 8;

bind = 1;
tind = [];
divev = NaN*zeros(size(data,1),1);
diven = 1;


nz = length(zgrid);

%dataout = NaN*zeros(diven*nz,size(data,2));

while 1
    tind = find(isnan(data(bind:end,zcol)),1,'first')+bind-2;
    divev(bind:tind) = diven;
    
    %interpret dive to dataout
    %zprof = data(bind:tind,7);
    %dive = data(bind:tind,:);
    
    %dvout = interp1(zprof,dive,zgrid);
    %dataout((diven-1)*nz+1:diven*nz,:) = dvout;
    dvout = interp1(data(bind:tind,zcol),data(bind:tind,varcol),zgrid);
    dataout(:,diven) = dvout;
    
    % find start of next prof
    bind = tind+2;
    if bind > length(divev)
        break
    end
    diven = diven + 1;
end



    