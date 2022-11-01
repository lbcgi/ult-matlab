function  [lpl,lpr,hpl,hpr] = time_domain_filter(xl,xr)

lpl = zeros(size(xl));
lpr = lpl;
hpl = lpl;
hpr = lpl;
for m = 1:length(xl)
    [lpl(m),lpr(m),hpl(m),hpr(m)] = processLR2(xl(m),xr(m));
end