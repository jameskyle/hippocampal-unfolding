% buxton.m
%	to calculate the buxton balloon model of brain signal
%	times are in sec
%	6/5/98

	global lam1 lam2 lam3 tau0 E0 fin alp1;

	dt = 0.1;		% time sampling
	tau0 = 2.0;		% transit time thru venous
	%E0 = 0.4;		% O2 extraction fraction
	E0 = 0.2;		% O2 extraction fraction
	alpha = 0.3;		% power law coeff for v=f^alpha
	V0 = 0.02;		% venous blood fraction
	tau0 = tau0/dt;		
	k1 = 7*E0;
	k2 = 2.0;
	k3 = 2*E0-0.2;

	foo = input('fout coeffs: [lam1 lam2 alpha] =');
	lam1 = foo(1);  lam2 = foo(2); alpha = foo(3); 
	alp1 = 1./alpha;
	foo = input('fin: [ramp, flat top duration (s), amplitude]=');
	tramp = foo(1)/dt;  tflat = foo(2)/dt; finmax = foo(3)-1;
	nrep = input('number of cycle repeats=');

	framp = (0:tramp)*finmax/tramp;
	nr = length(framp);
	if(tflat>0)	
	  fin = [framp ones(1,fix(tflat)-1)*finmax (finmax-framp(2:nr))];
	else
	  fin = [framp (finmax-framp(2:nr))];
	end
	T = 30/dt;
	% T = input('tmax (s) =')/dt;
	t = (1:T);
	nz = length(t) - length(fin);
	fin = [fin zeros(1,nz)];
	fin = fin + 1;

	fin1 = fin;
	for j =2:nrep
	  fin = [fin fin1];
	end
	t = (1:nrep*T);

	options = odeset('RelTol', .001);
	x0 = [1 1];
	[tout x] = ode23('vqfn', t, x0, options);
	v = x(:,1);
	q = x(:,2);
	B = V0*(k1*(1-q) + k2*(1-q./v) + k3*(1-v));
	time = tout*dt;		% seconds
	E = 1 - (1-E0).^(1./fin);
	fout = 1 + lam1*(v-1) + lam2*(v-1).^alp1; 
	CMRO2 = E.*fin/E0;

	subplot(3,3,1);
	plot(time,fin, time,fout); grid
	xlabel('time, s');
	title('flow in, fout');

	subplot(3,3,2);
	plot(time,v, time,CMRO2); grid
	xlabel('time, s');
	title('v, CMRO2');

	subplot(3,3,3);
	plot(time,q); grid
	xlabel('time, s');
	title('deoxy');

	subplot(3,3,4);
	plot(v,fout); grid
	xlabel('volume');
	ylabel('fout');

	subplot(3,3,5);
	plot(time,V0*(k1*(1-q)+k3*(1-v)),'-',time,V0*k2*(1-q./v),'--'); 	grid;
	xlabel('time, s');
	ylabel('-: extrav, --: intrav');

	subplot(3,3,6);
	plot(time,B); grid
	xlabel('time, s');
	ylabel('BOLD response');

	y = B(1+(nrep-1)*T:nrep*T);
	subplot(3,3,7);
	plot(time(1:T),y-y(1)); grid
	xlabel('time, s');
	ylabel('time-lock ave BOLD');


---------- buxton1.m ------------------


%	to calculate the buxton balloon model of brain signal
%	times are in sec
%	rev 0	6/5/98
%	rev 1	7/23/98	has fermi calc of input flow

	global lam1 lam2 lam3 tau0 E0 fin alp1;

	dt = 0.1;		% time sampling
	tau0 = 2.0;		% transit time thru venous
	E0 = 0.4;		% O2 extraction fraction
	alpha = 0.3;		% power law coeff for v=f^alpha
	V0 = 0.02;		% venous blood fraction
	tau0 = tau0/dt;		
	k1 = 7*E0;
	k2 = 2.0;
	k3 = 2*E0-0.2;

	foo = input('fout coeffs: [lam1 lam2 alpha] =');
	lam1 = foo(1);  lam2 = foo(2); alpha = foo(3); 
	alp1 = 1./alpha;
	foo = input('fin: [ramp, stim duration (s), amplitude]=');
	tramp = foo(1)/dt;  tstim = foo(2); finmax = foo(3)-1;
	foo1 = input('in flow: [t0, w]=');
	t0 = foo1(1); w = foo1(2);
	tflat = tstim*exp((tstim-t0)/w)/(1+exp((tstim-t0)/w));
	tflat = tflat/dt;

	nrep = input('number of cycle repeats=');

	framp = (0:tramp)*finmax/tramp;
	nr = length(framp);
	if(tflat>0)	
	  fin = [framp ones(1,fix(tflat)-1)*finmax (finmax-framp(2:nr))];
	else
	  fin = [framp (finmax-framp(2:nr))];
	end
	T = 30/dt;
	% T = input('tmax (s) =')/dt;
	t = (1:T);
	nz = length(t) - length(fin);
	fin = [fin zeros(1,nz)];
	fin = fin + 1;

	fin1 = fin;
	for j =2:nrep
	  fin = [fin fin1];
	end
	t = (1:nrep*T);

	options = odeset('RelTol', .001);
	x0 = [1 1];
	[tout x] = ode23('vqfn', t, x0, options);
	v = x(:,1);
	q = x(:,2);
	B = V0*(k1*(1-q) + k2*(1-q./v) + k3*(1-v));
	time = tout*dt;		% seconds
	E = 1 - (1-E0).^(1./fin);
	fout = 1 + lam1*(v-1) + lam2*(v-1).^alp1; 
	CMRO2 = E.*fin/E0;

	subplot(3,3,1);
	plot(time,fin, time,fout); grid
	xlabel('time, s');
	title('flow in, fout');

	subplot(3,3,2);
	plot(time,v, time,CMRO2); grid
	xlabel('time, s');
	title('v, CMRO2');

	subplot(3,3,3);
	plot(time,q); grid
	xlabel('time, s');
	title('deoxy');

	subplot(3,3,4);
	plot(v,fout); grid
	xlabel('volume');
	ylabel('fout');

	subplot(3,3,5);
	plot(time,V0*(k1*(1-q)+k3*(1-v)),'-',time,V0*k2*(1-q./v),'--'); 	grid;
	xlabel('time, s');
	ylabel('-: extrav, --: intrav');

	subplot(3,3,6);
	plot(time,B); grid
	xlabel('time, s');
	ylabel('BOLD response');

	y = B(1+(nrep-1)*T:nrep*T);
	subplot(3,3,7);
	plot(time(1:T),y-y(1)); grid
	xlabel('time, s');
	ylabel('time-lock ave BOLD');
