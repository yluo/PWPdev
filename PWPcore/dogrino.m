%
%		doGRiNo - do gradient Ri No adjustment
%	checks to see if GRi is less than critical value, and 
%	if so, deepens mixed layer
%
  Ri=GRiFac*dS./(sum((diff(UV).^2)')'+epsUV);	% calculate GRi
  for ii=mld:nz-1				% need do only for ML
      if Ri(ii) < GRiCrit
      	stirit;				% if < critical, stir two layers
      	ngri=ngri+1;			% keep track of activity
        end
   end
