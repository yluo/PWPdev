%
%
%		Adds Momentum to top layer at a time tpf
%		wind speed in m/s, wind stress in N/m2
%		added momentum = wstress/1000(kg/m3)
%		coupling coefficient = 1.5e-3
%
  ws=1.5e-6*wspeed(it)^2;		% compute wind stress from wind speed
  UV=UV*rotn;				% rotate half angle
  UV(1:mld,1)=UV(1:mld,1)+taux(it)*ones(mld,1)/mld;	% add x momentum
  UV(1:mld,2)=UV(1:mld,2)+tauy(it)*ones(mld,1)/mld;	% add y momentum
  UV=UV*rotn;				% rotate half angle
