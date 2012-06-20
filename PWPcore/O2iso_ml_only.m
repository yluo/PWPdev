% set 18O/16O and 17O/16O to mixed layer value for all depths below m.l.


r18ml = mean(Gas(1:mld,o18ind)./Gas((1:mld),o2ind));
r17ml = mean(Gas(1:mld,o17ind)./Gas((1:mld),o2ind));
O2ml = mean(Gas(1:mld,o2ind));


Gas(mld:end,o18ind) = Gas(mld:end,o2ind).*r18ml;
Gas(mld:end,o17ind) = Gas(mld:end,o2ind).*r17ml;

