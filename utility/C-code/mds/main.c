
/*****************************************************************
GENERAL: This program constructs the coordinates of n points in
R^d from their mutual distances.

USAGE: mds <distances_data_file> <dimension> 

The distances_data_file is of the following style:

num_of_points
point_i point_j dist_i_j
.
.
.

OUTPUT: coordinates of these points (in this program the points are 
	in R^3). The results are in the nx3 matrix RES.

NOTE: if there are not enough distance-relationships between the points,
	the results can be wrong!!!

BUGS: The function metric_mds calculates the coordinates with
	the function <func_to_minimize> and without 
	<Dfunc_to_minimize>. Adding the <Dfunc..> will speed the
	program.

Programmer: Yacov Hel-Or,  March 1994
Update: June 1995.

**********************************************************************/

#include <stdio.h>
#include "matrix.h"
#include <math.h>
#include "mds.h"

/* #define DIM 3 */
/* #define DIM 2 */

int pnts;

main(int ac, char **av)
{
  FILE *fp;
  matrix prox=NULL,prepare_prox_mtx(),first_guess=NULL;
  matrix TMP=NULL,RES=NULL,mds2res();
  int dim ;


  if (ac != 3) {
    printf("USAGE: %s <data_file> <dimension> \n",av[0]);
    exit(1);
  }

  fp = fopen(av[1],"r");
  dim = atoi(av[2]);

  /* Read in the data from the proximity matrix */
  /* The matrix need not be complete, but if it doesn't have */
  /* enough constraints the final results may not be accurate */
  prox = prepare_prox_mtx(fp,dim);

  /* If we can think of a smarter way to do this part, the convergence */
  /* will probably speed up */
  first_guess = generate_first_guess(dim,pnts,50);
  if (dim > 1 ) {
    TMP = metric_mds(dim,pnts,first_guess,prox,J_ee,DJ_ee);
  }
  else {
    TMP = metric_mds(dim,pnts,first_guess,prox,OneJ_ee,DOneJ_ee);
  }

  RES = mds2res(TMP,dim);
  /* compare_results(RES,prox,dim);  */

  free_all_mtx(dim,&TMP,&prox,&first_guess);

  /* printf("Points coordinates are: \n \n"); */
  /* Output the results */
  print_mtx(RES);   
	

}


matrix prepare_prox_mtx(FILE *fp,int dim)
{
  int i,j,n;
  matrix RES=NULL;
  double dist;

  fscanf(fp,"%d",&pnts);
  alloc_mtx(&RES,pnts,pnts);

  for (i=1; i<=pnts; i++) {
    for (j=1; j<=pnts; j++) {
      RES[i][j] = LARGE_COEFF;
    }
  }

  while ((n=fscanf(fp,"%d %d %lf",&i,&j,&dist))==3) {
    RES[i][j]  = dist;
    if (dim!=1)   {
      RES[j][i]  = dist;
    }
    else {
      RES[j][i]  = -dist;
    }
  }

  return(RES);
}

/*
compare_results(matrix RES,matrix prox, int dim)	
{
  double dist();

  int i,j;

  for (i=1; i<=pnts; i++)
    for (j=i; j<=pnts; j++)
      if (prox[i][j] != LARGE_COEFF)
	printf("(%d,%d):  real_dist=%lf  res_dist=%lf\n",
	       i,j,prox[i][j],dist(RES,i,j,dim));
  printf("\n");
}
*/

	
double dist(matrix MAT,int i,int j, int dim)
{
  double val;
  int d;


  val = 0.0;

  if (dim==1)  return(MAT[j][1] - MAT[i][1]);

  for (d=1; d<=dim; d++)
    val += SQR(MAT[i][d]-MAT[j][d]);


  return(sqrt(val));
}


matrix mds2res(matrix MDS, int dim)
{

  int i,d;
  matrix RES=NULL;

  alloc_mtx(&RES,pnts,dim);

  for (i=1; i<=pnts; i++) 
    for (d=1; d<=dim; d++)
      RES[i][d] = VecEntry(MDS,dim,i,d);

  return(RES);
}
