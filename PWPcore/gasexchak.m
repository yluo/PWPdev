%
%		gasexch.m	exchanges gases from mixed layer to
%				atmosphere
%
%		first flux the gas, sharing over the whole
%		mixed layer
%
%			This uses the latest Wanninkhof cubic formulation
%						Wanninkhof & McGillis (1999) GRL 26(13) 1889-1892
%
% additionally, scales W&M formulation by gasexfact set in pwpg


% -------------------------------------------------------------------------
% Need to modify pvpower options:  only pvpower 2 is correct...
% -------------------------------------------------------------------------

if pvpower==2		% pv (cm/h) = 0.31 * ws^2 * (Sc/660)^-1/2
    pv = gasexfact.*k_W92(wspeed(it),660,0);
end

wfact=(wspeed(it)-2.27)^3;          % this is the air injection factor as function of wind speed

%wfact=(wspeed(it)-2.27)^2; % TRY QUADRATIC AIR INJECTION
if wfact<0      % which is zero below the 2.27 m/s threshold
    wfact = 0;
end

% -------------------------------------------------------------------------
% Oxygen isotope fractionation factors
% -------------------------------------------------------------------------

% cap17O2_eq:  Equilibrium cap17O as a function of temperature from Luz
% (2009 (in press))
%
cap17eq = T(1).*0.6+1.8;

% set equilibrium fractionation to equal cap17eq
a18ge = 1+(-0.730 + 427./(T(1)+273.15))./1000;  % from Benson and Kraus (1980)
a17ge = a18ge.^lambda.* (cap17eq./1e6+1);
a36ge = a18ge.^2;
a35ge = a18ge*a17ge;


% includes contribution of windspeed, patm, and T
ai=wfact.*patmdry(it)*atm_Pa/(R*(273.15+T(1)));

for igas=1:ngas     % do all the gases
   
    % correct rates for equilibrium and kinetic fractionation factors
    gas = gases{igas};
    if strcmp(gas,'O17')
        [Sc, D] = schmidt(S(1),T(1),'O2');
        Geq = a17ge.*gasmoleq(S(1),T(1),'O2');
        Sc = Sc.*a17gek.^(-1/2);
        D =  D.*a17gek.^(1/2);
    elseif strcmp(gas,'O18')
        [Sc, D] = schmidt(S(1),T(1),'O2');
        Geq = a18ge.*gasmoleq(S(1),T(1),'O2');
        Sc = Sc.*a18gek.^(-1/2);
        D =  D.*a18gek.^(1/2);
    elseif strcmp(gas,'O36')
        [Sc, D] = schmidt(S(1),T(1),'O2');
        Geq = a36ge.*gasmoleq(S(1),T(1),'O2');
        Sc = Sc.*a36gek.^(-1/2);
        D =  D.*a36gek.^(1/2);
    elseif strcmp(gas,'O35')
        [Sc, D] = schmidt(S(1),T(1),'O2');
        Geq = a35ge.*gasmoleq(S(1),T(1),'O2');
        Sc = Sc.*a35gek.^(-1/2);
        D =  D.*a35gek.^(1/2);
    else   
        [Sc, D] = schmidt(S(1),T(1),gas);
        Geq = gasmoleq(S(1),T(1),gas);
        
    end
    % correct gas transfer for schmidt number
    gpv=pv./sqrt(Sc./660);     
    
    if igas == o2ind
        gpvo = gpv;
    end
        
    % Fluxes are in mol m-3 s-1
    
    acflux(igas)=ai.*xG(igas)*Ac; %calculate flux due to complete trapping, now add Ac
    %         need to include p of dry air (correct total P for ph2o) and use temperature in kelvin

    % need to use asco ^ 4/3 because asco is Sc^-(1/2) and i thoguht it would be easier to use existing code...)
    apflux(igas)=ai.*Ap.*(D.^diffexp).*((22.4.*Geq./(xG(igas).*Sig(1))).^betaexp)...
        .*(phydro(it)./patmdry(it)-Tracer(1,tr2ind(gas))./Geq+1); % multiply by scaling factor Ap, beta raised to some power betaexp and diffusivity raised to some power diffexp
    % multiply by (phydro/P-f)=(phydro/P-Cl/Cg+1) see keeling for explanation
    
    geflux(igas)=-gpv*(Tracer(1,tr2ind(gas))-slp(it)*Geq); % calculates the GE flux as diagnostic
    Tracer(1:mld,tr2ind(gas))=Tracer(1:mld,tr2ind(gas)) + (geflux(igas)+acflux(igas)+apflux(igas))*dt/(dz*mld); %change in conc = old conc + change due to gas exchanve, complete trapping, partial trapping
    %the dt/dz/mld are to convert flux to a concentration change.

    % now accumulate the gas fluxes
    apfluxcum(igas)=apfluxcum(igas)+apflux(igas);
    acfluxcum(igas)=acfluxcum(igas)+acflux(igas);
    gefluxcum(igas)=gefluxcum(igas)+geflux(igas);
end


fluxcumnum=fluxcumnum+1; % number of fluxes accumulated so know how to average the numbers

% NOTE: HAVE NOT CHANGED NEXT FEW LINES TO ACCOUNT FOR NEW AI EQUATION FOR
% 3HE OR TRITIUM
%[Sc, D] = schmidt(T(1),'He');
%gpv=1.0724*pv./sqrt(660./Sc);     % piston velocity corrected for isotope diffusivity^0.5
 
% not correct for He !!!! need to fix
gpv = pv;
%n3flux=n3flux+1; he3flux=he3flux+dz*gpv*sum(He3(1:mld))/dt;     % accumulate 3He flux from surface TU/m2/s
% He3(1:mld)=He3(1:mld)-gpv*He3(1:mld);       % lose some 3He
% Trit(1:mld)=SurfTrit(it)*ones(mld,1);       % update surface tritium to DRDJ function
