#include <stdio.h>
#include <matrix.h>

extern int dncom;	/* defined in DLINMIN */
extern matrix  dpcom,dxicom;
extern double (*nrfunc)();
extern void (*nrdfun)();

double df1dim(double x)
{
	int j;
	double df1=0.0;
	matrix xt=NULL,df=NULL;

	alloc_mtx(&xt,dncom,1);
	alloc_mtx(&df,dncom,1);

	for (j=1;j<=dncom;j++) xt[j][1]=dpcom[j][1]+x*dxicom[j][1];
	(*nrdfun)(xt,df);
	for (j=1;j<=dncom;j++) df1 += df[j][1]*dxicom[j][1];
	free_mtx(&df);
	free_mtx(&xt);
	return (df1);
}
