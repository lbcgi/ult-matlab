%  LUTSurroundRefreshParameter
global TBL_SIZE
global msr
for i = 1:TBL_SIZE
  for j = 1:TBL_SIZE		

         [x,y] = cartesianPrecomputer(msr.XYaxis(i), msr.XYaxis(j), msr.spread, msr.separation);
         x = max(-1,min(x* (msr.spatialEnhancement + msr.spatialEnhancement * y + 1.0 - y) * 0.5,1));
         msr.magPhaseDiff2Cartesian(0 * TBL_SIZE * TBL_SIZE + (i-1) * TBL_SIZE + j) = x;
         msr.magPhaseDiff2Cartesian(1 * TBL_SIZE * TBL_SIZE + (i-1) * TBL_SIZE + j) = y;

  end
end
