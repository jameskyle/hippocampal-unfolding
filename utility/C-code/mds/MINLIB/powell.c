#include <stdio.h>
#include <math.h>
#include <matrix.h>

#define ITMAX 200
static double sqrarg;
#define SQR(a) (sqrarg=(a),sqrarg*sqrarg)


/* Minimization of a function func on n variables. Input consists
of an initial starting points p[1..n]; an initial matrix xi[1..n][1..n]
whose columns contain the initial set of directions (usually the
n unit vectors); and ftol, the fractional tolerance in the function
value such that the failure to decrease by more than this amount 
on one iteration signals doeness.
On output, p is set of best point found, xi is the then-current
directions set, fret is the returned function value at p, and iter is
the number of iteration taken. The rutine linmin is used.
--------------------------------------------------------------- */

void powell(p,xi,n,ftol,iter,fret,func)
double ftol,*fret,(*func)();
matrix p,xi;
int n,*iter;
{
	int i,ibig,j;
	double t,fptt,fp,del;
	matrix  pt=NULL,ptt=NULL,xit=NULL;
	void linmin();

	alloc_mtx(&pt,n,1); 
	alloc_mtx(&ptt,n,1); 
	alloc_mtx(&xit,n,1); 
	*fret=(*func)(p);
	for (j=1;j<=n;j++) pt[j][1]=p[j][1];
	for (*iter=1;;(*iter)++) {
		fp=(*fret);
		ibig=0;
		del=0.0;
		for (i=1;i<=n;i++) {
			for (j=1;j<=n;j++) xit[j][1]=xi[j][i];
			fptt=(*fret);
			linmin(p,xit,n,fret,func);
			if (fabs(fptt-(*fret)) > del) {
				del=fabs(fptt-(*fret));
				ibig=i;
			}
		}
		if (2.0*fabs(fp-(*fret)) <= ftol*(fabs(fp)+fabs(*fret))) {
			free_mtx(&xit);
			free_mtx(&ptt);
			free_mtx(&pt);
			return;
		}
		if (*iter == ITMAX) nrerror("Too many iterations in routine POWELL");
		for (j=1;j<=n;j++) {
			ptt[j][1]=2.0*p[j][1]-pt[j][1];
			xit[j][1]=p[j][1]-pt[j][1];
			pt[j][1]=p[j][1];
		}
		fptt=(*func)(ptt);
		if (fptt < fp) {
			t=2.0*(fp-2.0*(*fret)+fptt)*SQR(fp-(*fret)-del)-del*SQR(fp-fptt);
			if (t < 0.0) {
				linmin(p,xit,n,fret,func);
				for (j=1;j<=n;j++) xi[j][ibig]=xit[j][1];
			}
		}
	}
}


#undef ITMAX
#undef SQR
