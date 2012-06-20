% adddeepo2.m

% use in pwpa. adds in o2 below 140 m in accordance with 1/tau - idea is to
% compensate for lateral ventilation of o2. does it according to
% saturation.

r18old = Gas(:,o18ind)./Gas(:,o2ind);
r17old = Gas(:,o17ind)./Gas(:,o2ind);

solo2 = gasmoleq(S,T,'O2'); % calculate solubility
sato2=Gas(:,o2ind)./solo2; % calculation saturdation 
sato2new=(1-fturnover').*sato2+fturnover'.*1; 

% calculate new oxygen conc. w/ same sat/ratios
Gas(:,o2ind) = sato2new.*solo2; 
Gas(:,o18ind) = Gas(:,o2ind).*r18old;
Gas(:,o17ind) = Gas(:,o2ind).*r17old;

