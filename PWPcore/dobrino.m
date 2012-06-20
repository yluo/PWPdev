%
%		doBRiNo - do bulk Ri No adjustment
%	checks to see if BRi is less than critical value, and 
%	if so, deepens mixed layer
%
  %vd=sum((diff(UV).^2)')'+epsUV;	% epsUV to avoid divide by zero
  vd=sum((diff(UV).^2),2)+epsUV;	% epsUV to avoid divide by zero
  dS = diff(Sig);
  dS(dS < 0) = 0.001;
  Ri=BRiFac*dS./vd;		% compute Ri No (but not H)
  for ii=mld:nz-1			% start at base of mixed layer
      if ii*Ri(ii) < BRiCrit		% i* to make it BRN
          mld=ii+1;			% deepen by one step?
          mlmix;			% mix everything up
            % now need to recalculate the Ri no, but only to mld+1
          Ri=BRiFac*dS./(sum((diff(UV).^2),2)+epsUV); 
          nbri=nbri+1;			% keep track of activity
      end
  end          
