

if ismember(it,tprofind)
    oldTracer = Tracer;
    Sold = S;
    Told = T;
    diven = find(tprofind == it);
    for ii = 1:nactive
        tr = float_tracers{ii};
        d = find(~isnan(float.tr(:,diven,tr2ind(tr))));
        Tracer(d,tr2ind(tr)) = float.tr(d,diven,tr2ind(tr));
        % nudge T and S to profile values
        d = find(~isnan(float.T(:,diven)));
        T(d) = float.T(d,diven);
        d = find(~isnan(float.S(:,diven)));
        S(d) = float.S(d,diven);
    end
    
    %Tracer = squeeze(tr_float(:,:,diven));
    D_Tracer = Tracer-oldTracer; 
    outt = [outt t(it)];
    outdS = [outdS S-Sold];
    outdT = [outdT T-Told];
    outS = [outS S];
    outT = [outT T];
    outTra=cat(3,outTra, Tracer);
    outD_Tra = cat(3,outD_Tra, D_Tracer);
    outPV = [outPV gpvo];
end
