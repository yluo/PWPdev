function [tg,c14GOPml] = c14ml_int(c14t,c14z,c14l,ta,zmld,GPP_NPP)

 c14g = interp1([0; c14z(2:end)],c14l,1:1000);
 %c14g(isnan(c14g)) = 0;
 d = find(c14t >= ta(1) & c14t <= ta(end));
 tg = c14t(d);
 c14g = c14g(:,d);
 zmldg = interp1(ta,zmld,tg);
 if length(GPP_NPP) == 1;
     GPP_NPP = 0.*ta+GPP_NPP;
 end
 GOP_c14 = interp1(ta,GPP_NPP,tg);
 c14GOPml = zeros(length(tg),1);
 for i = 1:length(tg)
     c14GOPml(i) = GOP_c14(i).*sum(c14g(1:round(zmldg(i)),i));
 end