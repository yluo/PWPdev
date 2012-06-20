function [h] = humidity(t)
%
%	h = humidity(temperature)
%			returns humidity in torr 
%			temperature in celsius
%			valid between -15 and 40C
%			based on H = exp(a0 + a1*t + a2*t^2 + a3*t^3)
%			fit is accurate to 0.0014 torr
	a = [-1.00874e-9 9.713036e-7 -2.967419e-4 0.07265607 1.5221896];
	h = exp(polyval(a,t));

