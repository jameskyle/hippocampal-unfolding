%	function for buxton balloon model to calclulate volume
%	and deoxy concentration
%	x(1) = v,  x(2) = q

	function xdot = vqfn(t, x);

	global lam1 lam2 tau0 E0 fin alp1; 

	fi = fin(fix(t));
	v = x(1);
	q = x(2);
	fout = 1 + lam1*(v-1) + lam2*(v-1)^alp1;
	vdot = (fi - fout)/tau0;
	E = 1 - (1-E0)^(1/fi);
	qdot = (fi*E/E0 - fout*q/v)/tau0;
	xdot = [vdot; qdot];



