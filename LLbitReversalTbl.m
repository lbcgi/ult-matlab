function  LLbitReversalTbl(n)
global msr;
    bits = round(log2(n));
    for i = 0:n-1
        msr.mBitRev(i+1) = LLRevBits(i,bits);
    end
end