#include <stdio.h>
#include <matrix.h>

extern int ncom;	/* defined in LINMIN */
extern matrix pcom,xicom ;
extern double (*nrfunc)();

double f1dim(x)
double x;
{
	int j;
	double f;
	matrix xt=NULL;

	alloc_mtx(&xt,ncom,1);   
	for (j=1;j<=ncom;j++) xt[j][1]=pcom[j][1]+x*xicom[j][1];
	f=(*nrfunc)(xt);
	free_mtx(&xt);
	return (f);
}



