%
%	mlmix -	mixes up the mixed layer
%
	Tm=mean(T(1:mld));T(1:mld)=Tm*ones(mld,1);
	Sm=mean(S(1:mld));S(1:mld)=Sm*ones(mld,1); 
	Sigm=mean(Sig(1:mld)); Sig(1:mld)=Sigm*ones(mld,1);
	UVm=mean(UV(1:mld,:),1); 
		UV(1:mld,1)=UVm(1)*ones(mld,1);
		UV(1:mld,2)=UVm(2)*ones(mld,1);
%
%	comment out below if not using gases
%
	for igas=1:ngas
        gas = gases{igas};
	    Trmean=mean(Tracer(1:mld,tr2ind(gas)));
	    Tracer(1:mld,tr2ind(gas))=Trmean*ones(mld,1);
	end


