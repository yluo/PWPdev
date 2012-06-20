% dogasheatcorr
% ------------
% gas is added to correct for lateral heat flux addition so that gas
% saturation state and isotopic ratio is preserved for each gas

Told=T-hhc(it)*vhec;

% correct gases to new temperature
for igas=1:ngas 
    gas = gases{igas};
    gassat = Tracer(:,tr2ind(gas))./gasmoleq(S,Told,gas);
    Tracer(:,tr2ind(gas)) = gassat.*gasmoleq(S,T,gas);
end
