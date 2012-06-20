%
%		doOutput - every so often, accumulate snapshot of
%			the situation
now=mod(it,tintv);	% time counter (integer)

if now == 0
    %  	if now == 1			% do first time only
    %	    fprintf('Kz = %8.3e, dt = %8.2f hr\n',Kz,dt/3600);
    %  	    fprintf('Month Tsurf Ssurf MLDepth  StIns  BRiN  GRiN\n');
    %  	  end
    Ta=[Ta T]; Sa=[Sa S]; Siga=[Siga Sig]; ta=[ta t(it)]; 
    TotalHeat=[TotalHeat dz*sum(T(z<=TSOint_z))/TSOint_z];
    TotalSalt = [TotalSalt dz*sum(S(z<=TSOint_z))/TSOint_z]; 
    TotalOxy = [TotalOxy dz*sum(Tracer(z<=TSOint_z,tr2ind('O2')))/TSOint_z];
    
    tml = [tml T(1)]; sml = [sml S(1)];
    nbri=nbri/noften; ngri=ngri/noften; nstin=nstin/noften;
    nnbri=[nnbri nbri]; nngri=[nngri ngri]; nnstin=[nnstin nstin];
    zmld=[zmld dz*mld];
    
    
    nclock=nclock + 1;
    if nclock >= NumPerYear				% report once a decade! 
        fprintf('%.2f\r',t(it));
        nclock = 0;
    end
    %
    
    %
    %Anom = cat(3,Anom, anom); 
    Tra=cat(3,Tra, Tracer);GPVO = [GPVO gpvo]; %Hel3=[Hel3 He3]; Tritium=[Tritium Trit]; %R18O = [R18O r18o]; R17O = [R17O r17o]; %O18 = [O18 o18]; O17 = [O17 o17]; 
%    Acflux=[Acflux acflux]; Apflux=[Apflux apflux]; Geflux=[Geflux geflux]; % diagnostics for ai part, ai comp, gas ex fluxes all in units of ncc/g (or ucc/g)
    Acflux=[Acflux acfluxcum]; Apflux=[Apflux apfluxcum]; Geflux=[Geflux gefluxcum]; % diagnostics for ai part, ai comp, gas ex fluxes all in units of ncc/g (or ucc/g)
    FluxNum=[FluxNum fluxcumnum];
    acfluxcum=zeros(ngas,1); apfluxcum=zeros(ngas,1); gefluxcum=zeros(ngas,1); % reset fluxes to start accumulating again
    fluxcumnum=0; 
    
    %DICa=[DICa DIC]; % store DIC values
    %Acfluxdic=[Acfluxdic acfluxcumdic]; Apfluxdic=[Apfluxdic apfluxcumdic]; Gefluxdic=[Gefluxdic gefluxcumdic]; % diagnostics for ai part, ai comp, gas ex fluxes all in units of ncc/g (or ucc/g)
    %acfluxcumdic=0; apfluxcumdic=0; gefluxcumdic=0; % reset fluxes to start accumulating again

   
    nbri=0;ngri=0;nstin=0;		% reset activity counters
    %he3flux=tday*4.45*he3flux/n3flux;  He3Flux=[He3Flux he3flux];     % average & save helium 3 flux info as %-m/d
    %he3flux=0; n3flux=0;                % reset counter and accumulator
end

