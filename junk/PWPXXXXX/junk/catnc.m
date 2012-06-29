function [ncout] = catnc(ilat,ilon,froot,var,startyr,endyr)

Varall = [];
timeall = [];
for yr = startyr:endyr
    fname = strcat(froot,'.',yr,'.nc');
    ncid = netcdf.open(fname,'nowrite');
    
    timeid = netcdf.inqVarID(ncid,'time');
    time = netcdf.getVar(ncid,timeid);
    
    varid = netcdf.inqVarID(ncid,var);
    var_raw = netcdf.getVar(ncid,varid,[1,1,1],[ilat,ilon,inf]);
    Varall = cat(3,Varall,var_raw);
    timeall = cat(3,timeall,time);
    netcdf.close(ncid);
end