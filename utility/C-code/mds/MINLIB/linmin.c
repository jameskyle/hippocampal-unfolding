#include <matrix.h>
#include <stdio.h>

#define TOL 2.0e-4

int ncom=0;	/* defining declarations */
double (*nrfunc)();
matrix pcom=NULL,xicom=NULL;

void linmin(p,xi,n,fret,func)
double *fret,(*func)();
matrix p,xi;
int n;
{
	int j;
	double xx,xmin,fx,fb,fa,bx,ax;
	double brent(),f1dim();
	void mnbrak();

	ncom=n;
	alloc_mtx(&pcom,n,1);  
	alloc_mtx(&xicom,n,1); 
	nrfunc=func;
	for (j=1;j<=n;j++) {
		pcom[j][1]=p[j][1];
		xicom[j][1]=xi[j][1];
	}
	ax=0.0;
	xx=1.0;
	bx=2.0;
	mnbrak(&ax,&xx,&bx,&fa,&fx,&fb,f1dim);
	*fret=brent(ax,xx,bx,f1dim,TOL,&xmin);
	for (j=1;j<=n;j++) {
		xi[j][1] *= xmin;
		p[j][1] += xi[j][1];
	}
	free_mtx(&xicom);
	free_mtx(&pcom);
}


#undef TOL
