% inidic;

% sets up variables needed to keep track of dic in pwpa model


DIC = 0;
abunddic=360E-6 * 1E3/1.024*1.86E-8/R; % used in gas exchange calculation. similar to "abund" calculated for the other gases. see inigasoxyng
ALK_0=2358.7; % start with reasonable value of Alk -- CHECK THIS!
P=0;
pCO2atm=360;
DICa=DIC; % set up matrix that will store DIC values
O2toC=-117/170; % use revised redfield ratios of anderson and sarmiento (1994) to convert O2 to C


% initialize variables that will save gas exchange fluxes
% acfluxdic=0; % diagnostic: air injection complete trapping flux -- used in each timepoint
% apfluxdic=0; % diagnostic: air injection partial trapping flux -- used in each timepoint
% gefluxdic=0; % diagnostic: gas exchange flux -- used in each time point
% Acfluxdic=acfluxdic; % used to store Ac fluxes for reporting purposes
% Apfluxdic=apfluxdic; % used to store Ap fluxes for reporting purposes 
% Gefluxdic=gefluxdic; % used to store GE fluxes for reporting purposes
% acfluxcumdic=0; % diagnostic: cumulative air injection complete trapping flux -- used to accumulate fluxes since last recording
% apfluxcumdic=0; % diagnostic: cumulative air injection partial trapping flux -- used to accumulate fluxes since last recording
% gefluxcumdic=0; % diagnostic: cumulative gas exchange flux -- used to accumulate fluxes since last recording


DIC_0=DIC(1);
[pCO2,CO2,HCO3,CO3,CO2eq,h]=pco2_dicalk(T(1),S(1),P,DIC_0,ALK_0,pCO2atm);
pco2_0 = pCO2; 