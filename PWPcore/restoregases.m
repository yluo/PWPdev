% restoregases
% ------------
% gas is added to correct for lateral heat flux addition so that gas
% saturation state and isotopic ratio is preserved for each gas
% should be run immediately after restoretemp.m

Told=T-trfz;
r18old = Gas(:,gas2ind('O18'))./Gas(:,gas2ind('O2'));
r17old = Gas(:,gas2ind('O18'))./Gas(:,gas2ind('O2'));


%debug
% Gas_old = Gas;
% cap17old = 1e6.*(log(o17./Gas(:,6))-theta.*log(o18./Gas(:,6)));

% correct gases to new temperature
for igas=1:ngas
    if strcmp(ind2gas(igas),'O17')
        gassat = Gas(:,igas)./(a17ge.*gasmoleq(S,Told,'O2'));
        Gas(:,igas) = gassat.*a17ge.*gasmoleq(S,T,'O2');
    elseif strcmp(ind2gas(igas),'O18')
        gassat = Gas(:,igas)./(a17ge.*gasmoleq(S,Told,'O2'));
        Gas(:,igas) = gassat.*a17ge.*gasmoleq(S,T,'O2');
    else
        gassat = Gas(:,igas)./gasmoleq(S,Told,ind2gas(igas));
        Gas(:,igas) = gassat.*gasmoleq(S,T,ind2gas(igas));
    end
end



