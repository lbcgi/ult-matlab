function [x,y] = cartesianMap(magPhaseDiff2Cartesian,xAxis,arg)
    global M_PI
    global TBL_SIZE
    yAxis = arg * (2.0/ M_PI) - 1.0;
	[q,xAxis] = map_to_grid(xAxis, TBL_SIZE);
	[p,yAxis] = map_to_grid(yAxis, TBL_SIZE);
	x = ((1.0 - xAxis) * (1.0 - yAxis)) * magPhaseDiff2Cartesian(0 * TBL_SIZE * TBL_SIZE + q * TBL_SIZE + p+1) + (xAxis * (1.0 - yAxis)) * magPhaseDiff2Cartesian(0 * TBL_SIZE * TBL_SIZE + (q + 1) * TBL_SIZE + p+1) + ((1.0 - xAxis) * yAxis) * magPhaseDiff2Cartesian(0 * TBL_SIZE * TBL_SIZE + q * TBL_SIZE + p+1 + 1) + (xAxis * yAxis) * magPhaseDiff2Cartesian(0 * TBL_SIZE * TBL_SIZE + (q + 1) * TBL_SIZE + p+1 + 1);
	y = ((1.0 - xAxis) * (1.0 - yAxis)) * magPhaseDiff2Cartesian(1 * TBL_SIZE * TBL_SIZE + q * TBL_SIZE + p+1) + (xAxis * (1.0 - yAxis)) * magPhaseDiff2Cartesian(1 * TBL_SIZE * TBL_SIZE + (q + 1) * TBL_SIZE + p+1) + ((1.0 - xAxis) * yAxis) * magPhaseDiff2Cartesian(1 * TBL_SIZE * TBL_SIZE + q * TBL_SIZE + p+1 + 1) + (xAxis * yAxis) * magPhaseDiff2Cartesian(1 * TBL_SIZE * TBL_SIZE + (q + 1) * TBL_SIZE + p+1 + 1); 
end