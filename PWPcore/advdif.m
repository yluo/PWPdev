%
%	advdif.m
%
%		advects and diffuses properties in the vertical
%		uses precalculated weights (probably FUDM)
%			NB: must do one-sided on top box
%				and leaves bottom box alone
%

%	first, we must recalculate weights to accomodate vertical vel.
w0=wi0-wv(it)*wvf; wm=wim+wv(it)*wvf; w0(1)=wi0(1);
w0t=wi0t-wv(it)*wvf; wmt=wimt+wv(it)*wvf; w0t(1)=wi0t(1);

%
%
  Sold=S; Told=T; UVold=UV; %He3old=He3;	TritOld=Trit;	% save old values first
%
  T(2:nz-1)=wm(2:nz-1).*Told(1:nz-2)+w0(2:nz-1).*Told(2:nz-1)+...
  			wp(2:nz-1).*Told(3:nz);
  T(1)=w0(1)*Told(1)+wp(1)*Told(2);
%					
  S(2:nz-1)=wm(2:nz-1).*Sold(1:nz-2)+w0(2:nz-1).*Sold(2:nz-1)+...
  			wp(2:nz-1).*Sold(3:nz);
  S(1)=w0(1)*Sold(1)+wp(1)*Sold(2);
%
  UV(2:nz-1,1)=wm(2:nz-1).*UVold(1:nz-2,1)+w0(2:nz-1).*UVold(2:nz-1,1)+...
  			wp(2:nz-1).*UVold(3:nz,1);
  UV(2:nz-1,2)=wm(2:nz-1).*UVold(1:nz-2,2)+w0(2:nz-1).*UVold(2:nz-1,2)+...
  			wp(2:nz-1).*UVold(3:nz,2);
  UV(1,:)=w0(1)*UVold(1,:)+wp(1)*UVold(2,:);


  
  for igas=1:ngas
      gas = gases{igas};
      Trold=Tracer(:,tr2ind(gas));
      Tracer(2:nz-1,tr2ind(gas))=wmt(2:nz-1).*Trold(1:nz-2)+w0t(2:nz-1).*Trold(2:nz-1)+...
          wpt(2:nz-1).*Trold(3:nz);
      Tracer(1,tr2ind(gas))=w0t(1)*Trold(1)+wpt(1)*Trold(2);
  end




% % advect and diffuse DIC
% DICold=DIC;
%    DIC(2:nz-1)=wmt(2:nz-1).*DICold(1:nz-2)+w0t(2:nz-1).*DICold(2:nz-1)+...
%    			wpt(2:nz-1).*DICold(3:nz);
%    DIC(1)=w0t(1)*DIC(1)+wpt(1)*DIC(2);


%   then advect and diffuse
%
%He3(2:nz-1)=wmt(2:nz-1).*He3old(1:nz-2)+w0t(2:nz-1).*He3old(2:nz-1)+wpt(2:nz-1).*He3old(3:nz);
%Trit(2:nz-1)=wmt(2:nz-1).*TritOld(1:nz-2)+w0t(2:nz-1).*TritOld(2:nz-1)+wpt(2:nz-1).*TritOld(3:nz);
%
%       must do something about the bottom boundary condition for tritium
%       and 3He, as the transient propagates downward. Fixing the bottom
%       value at zero or some arbitrary value creates an artifical flux, so
%       we loosen the bottom boundary condition to conserver mass at least
%       (i.e., zero flux through the bottom: not quite correct but what can
%       one do?)
 
%He3(nz)=He3(nz-1);
%Trit(nz)=Trit(nz-1);
