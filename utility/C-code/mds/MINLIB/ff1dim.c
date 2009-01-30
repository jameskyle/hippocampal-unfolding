#include <stdio.h>
#include <matrix.h>

extern int dncom;	/* defined in LINMIN */
extern matrix dpcom,dxicom ;
extern double (*nrfunc)();

double ff1dim(x)
double x;
{
	int j;
	double f;
	matrix xt=NULL;

	alloc_mtx(&xt,dncom,1);   
	for (j=1;j<=dncom;j++) xt[j][1]=dpcom[j][1]+x*dxicom[j][1];
	f=(*nrfunc)(xt);
	free_mtx(&xt);
	return (f);
}



