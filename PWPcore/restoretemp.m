% restoretemp.m

% use in pwpa. compares temperature of time point to bermuda sst record
% (interpolated ininifctra) and adds in heat as necessary. heat is only
% added to surface box.

%trf=-(T(1)-sst(it))*trestconst * htfact; % temp differences * restoring factor * conversion for temp cahnge for model box  
%T(1)=T(1)+trf;		% add temp restoring flux to surface box only. I don't have any salinity restoring...

difftall(:,it)=T-trest(:,it); % save as a diagnostic
trfz=-(T-trest(:,it)).*1./trestconst.*dt/(24*60*60); % now trestconst is a time scale in days
T=T+trfz; % add in the heat
trfzall(:,it)=trfz; % save as a diagnostic
