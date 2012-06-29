% ------------------------------------------------------------------------
% temperature dependent Schmidt number for inert gases
%
% USAGE:
% ------------------------------------------------------------------------
%
% [ScO2 DO2] = schmidt(35,20,'O2')
%
% >ScO2 = 467.5239
% >DO2 = 2.2398e-09
%
% DESCRIPTION:
% ------------------------------------------------------------------------ 
% 
% % A and Ea are from table 9.1 in Emerson and Hodges 2008 and are
% parameters for the Eyring Equation: D = A*exp(-Ea/RT). (T in Kelvin)
% units of AEa below: A (m2/s) Ea (J/mol)
% INPUT:
% ------------------------------------------------------------------------
% t:    temperature         (deg C)
% s:    salinity
% gas:  name of the gas     (see below)
%
% Neon:         'Ne'
% Argon:        'Ar'
% Krypton:      'Kr'
% Xenon:        'Xe'
% Nitrogen:     'N2'
% Oxygen:       'O2'
%
% OUTPUT:
% ------------------------------------------------------------------------
% Sc:       Schmidt number
%
% calculations are from a fit to data from table VIII in 
% Emerson and Hedges (2008)
%
% D:        Diffusivity     (m2/s)
%
% From Eyring Equation
%
% written by David Nicholson 8/1/08
% ------------------------------------------------------------------------

function [Sc D] = schmidt(s,t,gas)


% Gas constant
R = 8.314510;


if strcmpi(gas, 'He')
    [AEa] = [0.8180e-6 11700];
elseif strcmpi(gas, 'Ne')
    [AEa] = [1.6080e-6 14840];
elseif strcmpi(gas, 'O2')
    [AEa] = [4.200e-6 18370];
elseif strcmpi(gas, 'Ar')
    [AEa] = [10.60e-6 20630];
elseif strcmpi(gas, 'Ar36')
    [AEa] = [10.60e06 20630];
elseif strcmpi(gas, 'Kr')
    [AEa] = [6.3930e-6 20200];
elseif strcmpi(gas, 'Xe')
    [AEa] = [9.0070e-6 21610];
elseif strcmpi(gas, 'N2')
    [AEa] = [7.9000e-6 19620];
elseif strcmpi(gas, 'CO2')
    % co2 schmidt# formula from Wanninkopf (1992)
    Sc = 2073.1 - 125.62.*t + 3.6276.*t.^2 - 0.043219.*t.^3;
    D = sw_visc(35.*ones(size(t)),t,0)./Sc;
    return
else
    error('Gas name must be Ne, O2, Ar, Kr, Xe, CO2 or N2');
end

D = AEa(1).*exp(-AEa(2)./(R.*(t+273.16)));
Sc = sw_visc(s,t,0)./D;
if strcmpi(gas, 'Ar36')
    alphaD = 0.995;
    D = D./alphaD^2;
    Sc = Sc.*alphaD^2;
end



