
/*****************************************************************
GENERAL: This program constructs the coordinates of n points from 
their mutual distances.

USAGE: run distances_data_file

INPUT: a file with the following style:

num_of_points
point_i point_j dist_i_j
.
.
.

OUTPUT: coordinates of these points (in this program the points are 
	in R^3). The results are in the nx3 matrix RES.

NOTE: if there are no sufficient relations between points
	the results can be wrong!!!

BUGS: The function metric_mds calculates the coordinates with
	the function <func_to_minimize> and without 
	<Dfunc_to_minimize>. Adding the <Dfunc..> will speed the
	program.

Programmer: Yacov Hel-Or,  March 1994

**********************************************************************/

#include <stdio.h>
#include "matrix.h"
#include <math.h>
#include "mds.h"

/* #define DIM 3 */
#define DIM 2

int pnts;

main(int ac, char **av)
{
	FILE *fp;
	matrix prox=NULL,prepare_prox_mtx(),first_guess=NULL;
	matrix TMP=NULL,RES=NULL,mds2res();


	if (ac != 2) {
		printf("USAGE: %s <data_file>\n",av[0]);
		exit(1);
	}

	fp = fopen(av[1],"r");

	prox = prepare_prox_mtx(fp);
	first_guess = generate_first_guess(DIM,pnts,50);
	TMP = metric_mds(DIM,pnts,first_guess,prox,J_ee,DJ_ee);
	RES = mds2res(TMP);
/*	compare_results(RES,prox); */

	free_all_mtx(DIM,&TMP,&prox,&first_guess);

        print_mtx(RES);
	

}


matrix prepare_prox_mtx(FILE *fp)
{
	int i,j,n;
	matrix RES=NULL;
	double dist;

	fscanf(fp,"%d",&pnts);

	alloc_mtx(&RES,pnts,pnts);

	for (i=1; i<=pnts; i++) {
	  for (j=1; j<=pnts; j++){
	    fscanf(fp,"%lf",&RES[i][j]);
	  }
	}

/*
			RES[i][j] = LARGE_COEFF;
	while ((n=fscanf(fp,"%d %d %lf",&i,&j,&dist))==3) 
		RES[i][j] = RES[j][i] = dist;

*/

	return(RES);
}


compare_results(matrix RES,matrix prox)	
{
	double dist();

	int i,j;

	for (i=1; i<=pnts; i++)
	   for (j=i; j<=pnts; j++)
		if (prox[i][j] != LARGE_COEFF)
		   printf("(%d,%d):  real_dist=%lf  res_dist=%lf\n",
			i,j,prox[i][j],dist(RES,i,j));
	printf("\n");
}

	
double dist(matrix MAT,int i,int j)
{
	double val;
	int d;


	val = 0.0;
	for (d=1; d<=DIM; d++)
		val += SQR(MAT[i][d]-MAT[j][d]);


	return(sqrt(val));
}


matrix mds2res(matrix MDS)
{

	int i,d;
	matrix RES=NULL;

	alloc_mtx(&RES,pnts,DIM);

	for (i=1; i<=pnts; i++) 
		for (d=1; d<=DIM; d++)
			RES[i][d] = VecEntry(MDS,DIM,i,d);

	return(RES);
}
