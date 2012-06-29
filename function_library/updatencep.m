%
%  This will download an entire year of ncep data (will take a long time 
%  if internet connection is slow...
%
%  'outdir' specifies where the path where files will be saved.
%

function [] = updatencep(yr,outdir)

% open connection to noaa server
ft = ftp('ftp.cdc.noaa.gov','anonymous','XXXXX@whoi.edu');

datapath = '/Datasets/ncep.reanalysis';

% specify variables to be downloaded here.  paths are relative to 
froots = {'/surface_gauss/uwnd.10m.gauss','/surface_gauss/vwnd.10m.gauss',...
    '/surface_gauss/nswrs.sfc.gauss','/surface_gauss/nlwrs.sfc.gauss',...
    '/surface_gauss/shtfl.sfc.gauss','/surface_gauss/lhtfl.sfc.gauss',...
    '/surface_gauss/prate.sfc.gauss','/surface/slp','/surface/rhum.sig995',...
    '/surface/air.sig995','/surface_gauss/uflx.sfc.gauss',...
    '/surface_gauss/vflx.sfc.gauss','/surface/slp'};


nfls = length(froots);

% ftp each file
for ii = 1:nfls
    fname = strcat(datapath, froots{ii}, '.', num2str(yr), '.nc');
    mget(ft,fname,outdir);
end