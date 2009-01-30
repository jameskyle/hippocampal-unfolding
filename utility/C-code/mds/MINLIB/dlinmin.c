#include <stdio.h>
#include <matrix.h>
#define TOL 2.0e-4


int dncom=0;	/* defining declarations to df1dim */
matrix  dpcom=NULL,dxicom=NULL;
double (*nrfunc)();
void (*nrdfun)();


/*
Given an n-dimensional point p[1..n] and an n-dimensional direction xi[1..n],
moves and resets p to where the function func(p) takes on a minimum along the
direction xi from p, the value of func at the returened location p. This is
actually all acocomplished by calling the routines mnbrak and dbrent
--------------------------------------------------------------------------- */
int dlinmin(matrix p,matrix xi,int n,double *fret,
	double (*func)(),void (*dfunc)())
{
	int j;
	double xx,xmin,fx,fb,fa,bx,ax;
	double dbrent(),ff1dim(),df1dim();
	void mnbrak();

	dncom=n;
	alloc_mtx(&dpcom,n,1);
	alloc_mtx(&dxicom,n,1);

	nrfunc=func;
	nrdfun=dfunc;
	for (j=1;j<=n;j++) {
		dpcom[j][1]=p[j][1];
		dxicom[j][1]=xi[j][1];
	}
	ax=0.0;
	xx=1.0;
	bx=2.0;
	mnbrak(&ax,&xx,&bx,&fa,&fx,&fb,ff1dim);
	*fret=dbrent(ax,xx,bx,ff1dim,df1dim,TOL,&xmin);


	for (j=1;j<=n;j++) {
		xi[j][1] *= xmin;
		p[j][1] += xi[j][1];
	}
	free_mtx(&dxicom);
	free_mtx(&dpcom);
}

#undef TOL
