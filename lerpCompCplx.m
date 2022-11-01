function magnitude = lerpCompCplx(idx,i,magSqrt,chmaskPtr,u,v,x,y)
    global msr
    a = chmaskPtr((idx-1)*21*21+1:idx*21*21); 
    gf = ((1.0 - x)*(1.0 - y)*a(u * 21 + v) + x * (1.0 - y)*a((u + 1) * 21 + v) + (1.0 - x)*y*a(u * 21 + v + 1) + x * y*a((u + 1) * 21 + v + 1));
    difGf = gf - msr.smoothedFunc(idx,i); 
    if (difGf > msr.smoothing) 
       gf = msr.smoothedFunc(idx,i) + msr.smoothing; 
    end
    if (difGf < -msr.smoothing) 
        gf = msr.smoothedFunc(idx,i) - msr.smoothing; 
    end
    msr.smoothedFunc(idx,i) = gf; 
    magnitude = magSqrt * gf;

end