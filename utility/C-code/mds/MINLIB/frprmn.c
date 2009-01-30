#include <stdio.h>
#include <math.h>
#include <matrix.h>

#define ITMAX 200
#define EPS 1.0e-10

/* Given a starting point P[1..n], Fletcher-Reeves/Polak-Ribiere
minimization is performed on a function func, using its gradient as
calculated by routine dfunc. 
(The routine presumes the existence of a function func(p) where
p[1..n] is a vector of length n, and also presumes the existence of a
function dfunc(p,df) that sets the vector gradient df[1..n] evaluated
at the input point p.)
The convergence tolerance on the function
value is input as ftol. Returned quantities are p (the location of the
minimum), iter (the number of iterations that were performed), and
fret (the minimum value of the function). The routine dlinmin is called
to performed line minimization.
--------------------------------------------------------------- */

int frprmn(matrix p,int n,double ftol,int *iter,double *fret,
  	double (*func)(),void (*dfunc)())
{
	int j,its;
	float gg,gam,fp,dgg;
	matrix g=NULL,h=NULL,xi=NULL;
	int dlinmin();

/*
	g=vector(1,n);
	h=vector(1,n);
	xi=vector(1,n);
*/
	alloc_mtx(&g,n,1);
	alloc_mtx(&h,n,1);
	alloc_mtx(&xi,n,1);
	fp=(*func)(p);

	(*dfunc)(p,xi);
	for (j=1;j<=n;j++) {
		g[j][1] = -xi[j][1];
		xi[j][1]=h[j][1]=g[j][1];
	}
	for (its=1;its<=ITMAX;its++) {
		*iter=its;
	/*	linmin(p,xi,n,fret,func);   */
		dlinmin(p,xi,n,fret,func,dfunc);  


		if (2.0*fabs(*fret-fp) <= ftol*(fabs(*fret)+fabs(fp)+EPS)) {
			free_all_mtx(3,&g,&h,&xi);
			return;
		}
		fp=(*func)(p);
		(*dfunc)(p,xi);
		dgg=gg=0.0;
		for (j=1;j<=n;j++) {
			gg += g[j][1]*g[j][1];
/*		  dgg += xi[j][1]*xi[j][1];	*/
			dgg += (xi[j][1]+g[j][1])*xi[j][1];
		}
		if (gg == 0.0) {
			free_all_mtx(3,&g,&h,&xi);
			return;
		}
		gam=dgg/gg;
		for (j=1;j<=n;j++) {
			g[j][1] = -xi[j][1];
			xi[j][1]=h[j][1]=g[j][1]+gam*h[j][1];
		}
	}
	printerr("Too many iterations in FRPRMN");
}

#undef ITMAX
#undef EPS
