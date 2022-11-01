function lr2 = initLR2(fs,fc)
    global M_PI
     fpi = M_PI * fc;
     wc = 2 * fpi;
     wc2 = wc * wc;
     wc22 = 2 * wc2;
     k = wc / tan(fpi / fs);
     k2 = k * k;
     k22 = 2 * k2;
     wck2 = 2 * wc*k;
     tmpk = (k2 + wc2 + wck2);
    lr2.b1 = (-k22 + wc22) / tmpk;
    lr2.b2 = (-wck2 + k2 + wc2) / tmpk;
    lr2.a1_lp = (wc22) / tmpk;
    lr2.a2_lp = (wc2) / tmpk;
    lr2.a1_hp = (-k22) / tmpk;
    lr2.a2_hp = (k2) / tmpk;
end