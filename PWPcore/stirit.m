% stirs two density layers when grad. Ri is unstable
	Tm=mean(T(ii:ii+1));T(ii:ii+1)=Tm*ones(2,1);
	Sm=mean(S(ii:ii+1));S(ii:ii+1)=Sm*ones(2,1); 
	Sigm=mean(Sig(ii:ii+1)); Sig(ii:ii+1)=Sigm*ones(2,1);
	UVm=mean(UV(ii:ii+1,:)); 
		UV(ii:ii+1,1)=UVm(1)*ones(2,1);
		UV(ii:ii+1,2)=UVm(2)*ones(2,1);
%
%	comment out below if you are not using gases
%
	for igas=1:ngas
		gas = gases{igas};
        Trmean=mean(Tracer(ii:ii+1,tr2ind(gas)));
		Tracer(ii:ii+1,tr2ind(gas))=Trmean*ones(2,1);
    end
%     
%     
%     for igas=1:ngas
% 		Gmean=mean(o18(ii:ii+1));
% 		o18(ii:ii+1)=Gmean;
%     end
%     
%     for igas=1:ngas
% 		Gmean=mean(o17(ii:ii+1));
% 		o17(ii:ii+1)=Gmean;
% 	end
	
