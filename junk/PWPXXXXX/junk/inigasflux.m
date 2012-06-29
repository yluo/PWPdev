% inigasflux.m

% calculates terms needed to calculate gas fluxes associated with lateral
% heat transport

% rough calculation of gas solubility temperature dependence (dC/dt)

T_gas = 0.5:30.5;
dCdT = zeros(length(T_gas)-1,ngas);
for igas=1:ngas
    dCdT(:,igas)=diff(gasmoleq(35+0.*T_gas,T_gas,ind2gas(igas)));
end
T_gas = (T_gas(2:end)+T_gas(1:end-1))./2;

% latheat turned off here????
%latheat=-latheatflux*htfact/ndepvhec*ones(size(t)); % set up vector with the lateral heat flux imbalance changed into appropriate units
vhecgas=repmat(vhec,1,ngas); % get matrices to be right shape for multiplication
%dcdt=repmat(dCdT,500,1); % get matrices to be right shape for multiplication