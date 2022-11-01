function [lp1,lp2,hp1,hp2] = processLR2(in1,in2)
    global lr2
	lp1_out = lr2.a2_lp * in1 + lr2.lp1_xm0;
	lr2.lp1_xm0 = lr2.a1_lp * in1 - lr2.b1 * lp1_out + lr2.lp1_xm1;
	lr2.lp1_xm1 = lr2.a2_lp  *in1 - lr2.b2 * lp1_out;
	lp2_out = lr2.a2_lp * in2 + lr2.lp2_xm0;
	lr2.lp2_xm0 = lr2.a1_lp  *in2 - lr2.b1 * lp2_out + lr2.lp2_xm1;
	lr2.lp2_xm1 = lr2.a2_lp  *in2 - lr2.b2 * lp2_out;
	hp1_out = lr2.a2_hp *in1 + lr2.hp1_xm0;
	lr2.hp1_xm0 = lr2.a1_hp *in1 - lr2.b1 * hp1_out + lr2.hp1_xm1;
	lr2.hp1_xm1 = lr2.a2_hp *in1 - lr2.b2 * hp1_out;
	hp2_out = lr2.a2_hp *in2 + lr2.hp2_xm0;
	lr2.hp2_xm0 = lr2.a1_hp  *in2 - lr2.b1 * hp2_out + lr2.hp2_xm1;
	lr2.hp2_xm1 = lr2.a2_hp *in2 - lr2.b2 * hp2_out;
	lp1 = -lp1_out;
	lp2 = -lp2_out;
    hp1 = in1;
    hp2 = in2;

end