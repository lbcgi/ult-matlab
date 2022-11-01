function [x,y] = cartesianPrecomputer(arg1, arg2, refangle,separation)
    global angleMapper
    global M_PI
	 [u,arg1] = map_to_grid2(arg1);
	 [v,arg2] = map_to_grid2(arg2);
     v = v + 1;
     
	 panningPlaneMagnitude = ((1.0 - arg1) * (1.0 - arg2)) * angleMapper(0 * 256 * 256 + u * 256 + v) + (arg1 * (1.0 - arg2)) * angleMapper(0 * 256 * 256 + (u + 1) * 256 + v) + ((1.0 - arg1) * arg2) * angleMapper(0 * 256 * 256 + u * 256 + v + 1) + (arg1 * arg2) * angleMapper(0 * 256 * 256 + (u + 1) * 256 + v + 1);
	 panningPlanePhase = ((1.0 - arg1) * (1.0 - arg2)) * angleMapper(1 * 256 * 256 + u * 256 + v) + (arg1 * (1.0 - arg2)) * angleMapper(1 * 256 * 256 + (u + 1) * 256 + v) + ((1.0 - arg1) * arg2) * angleMapper(1 * 256 * 256 + u * 256 + v + 1) + (arg1 * arg2) * angleMapper(1 * 256 * 256 + (u + 1) * 256 + v + 1);
	 xAxis = map(panningPlanePhase, -M_PI, M_PI, -1.0, 1.0);
	arg2 = map(refangle, 0.0, 2.0 * M_PI, -1.0, 1.0);
	[u,xAxis] = map_to_grid2(xAxis);
	[v,arg2] = map_to_grid2(arg2);
     v = v + 1;
	 panningPlanePhase = ((1.0 - xAxis) * (1.0 - arg2)) * angleMapper(2 * 256 * 256 + u * 256 + v) + (xAxis * (1.0 - arg2)) * angleMapper(2 * 256 * 256 + (u + 1) * 256 + v) + ((1.0 - xAxis) * arg2) * angleMapper(2 * 256 * 256 + u * 256 + v + 1) + (xAxis * arg2) * angleMapper(2 * 256 * 256 + (u + 1) * 256 + v + 1);
	xAxis = map(panningPlaneMagnitude, 0.0, sqrt(2.0), -1.0, 1.0);
	arg2 = map(separation, -0.3, 0.3, -1.0, 1.0);
	[u,xAxis] = map_to_grid2(xAxis);
	[v,arg2] = map_to_grid2(arg2);
     v = v + 1;
	panningPlaneMagnitude = ((1.0 - xAxis) * (1.0 - arg2)) * angleMapper(3 * 256 * 256 + u * 256 + v) + (xAxis * (1.0 - arg2)) * angleMapper(3 * 256 * 256 + (u + 1) * 256 + v) + ((1.0 - xAxis) * arg2) * angleMapper(3 * 256 * 256 + u * 256 + v + 1) + (xAxis * arg2) * angleMapper(3 * 256 * 256 + (u + 1) * 256 + v + 1);
    x = panningPlaneMagnitude*cos(panningPlanePhase);
    y = panningPlaneMagnitude*sin(panningPlanePhase);
