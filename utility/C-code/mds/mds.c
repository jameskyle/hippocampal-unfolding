#include <stdio.h>
#include "mds.h"
#include "distrb.h"
#include "min_func.h"
#include <math.h>


matrix delta=NULL;
int pointcount, Dim;
double parr_coeff=0.0,line_coeff=0.0;


/* J_ee Stress Function 
   See declaration in Duda & Hart
   the matrix M is a (pointcount*DIM)x1 matrix (a parameter vector). 
--------------------------------------------------*/
double J_ee(matrix M)
{
	double res,d,d_i,sqrt(),res_i,tot_delta,cons_add,Dij();
	int i,j,k;
	static double coeff;

	res=0.0;
	tot_delta = 0.0;

	for (i=1; i<=pointcount; i++) 
	   for (j=1 ; j<i; j++) {

	      	if (delta[i][j] != LARGE_COEFF)  {
			res_i = Dij(M,i,j) - delta[i][j];
			res_i = res_i*res_i;
			res +=  res_i;
			tot_delta += delta[i][j]*delta[i][j];
		}
	   }
 	res = res/tot_delta;
/*
	cons_add = parr_coeff*parr_penalty(M) + line_coeff*line_penalty(M,Dim);
        res += cons_add;
*/
        return(res);
}


/* Dij returns the norm 2 of Xi-Xj
   the matrix M is a (pointcount*DIM)x1 matrix
-----------------------------------------------*/

double Dij(matrix M,int i,int j)
{
   	double d=0.0,d_i;
   	int k;

   	for (k=1; k<=Dim; k++) {
		d_i = VecEntry(M,Dim,j,k) - VecEntry(M,Dim,i,k);
		d_i = d_i*d_i ;
		d += d_i;
   	}
  	return(sqrt(d));  
}



/* DJ_ee differential of the Stress Function 
   See declaration in Duda & Hart
   the matrix M is a (pointcount*DIM)x1 matrix
----------------------------------------------*/
void DJ_ee(matrix M,matrix D)
{
   	int i,j,k,q;
	double tot_delta,stat_coeff,Dij();
	double coeff_i,d_kj;
	matrix Y_k=NULL,Y_j=NULL,vec_kj=NULL,diff_k=NULL;
	 
	
	tot_delta = 0.0;
   	for (i=1; i<=pointcount; i++) 
		for (j=1 ; j<i; j++)  
			if (delta[i][j] != LARGE_COEFF)  
				tot_delta += delta[i][j]*delta[i][j];
	stat_coeff = 2.0/tot_delta;

	for (k=1; k<=pointcount; k++)  {

		Y_k = mtx_ver_cut(M,Sentry(k,Dim),Eentry(k,Dim));
		alloc_mtx(&diff_k,Dim,1);

		for (j=1; j<=pointcount; j++)  {
			if ((j!=k) && (delta[k][j] != LARGE_COEFF) ){
				d_kj = Dij(M,k,j);
				coeff_i = (d_kj - delta[k][j])/d_kj;
				Y_j = mtx_ver_cut(M,Sentry(j,Dim),Eentry(j,Dim));
				vec_kj = sub_mtx(Y_k,Y_j);
				mul_scalar_in_mtx(vec_kj,coeff_i);
				add_in_mtx(diff_k,vec_kj,1,1);

				free_all_mtx(2,&Y_j,&vec_kj);
			}
		}
		mul_scalar_in_mtx(diff_k,stat_coeff);
		for (q=1; q<=Dim; q++)  
			VecEntry(D,Dim,k,q) = diff_k[q][1] ;
		free_all_mtx(2,&Y_k,&diff_k);
	}
}
		
/*=====================ONE DIMENSSIONAL =========================*/

#define coeff1  M[pointcount+1][1]
#define coeff2  M[pointcount+2][1]

/* J_ee Stress Function 
   See declaration in Duda & Hart
   the matrix M is a (pointcount*DIM)x1 matrix
-----------------------------------------*/
double OneJ_ee(matrix M)
{
	double res,d,d_i,sqrt(),res_i,tot_delta,cons_add,OneDij();
	int i,j,k;
	static double coeff;
	double OneJ_ee2();	/* trying 3 views !!!!! */

	res=0.0;
	tot_delta = 0.0;

	for (i=1; i<=pointcount; i++) 
	   for (j=1 ; j<i; j++) {
	      		if (delta[i][j] != LARGE_COEFF)  {
				res_i = OneDij(M,i,j) - delta[i][j];
				res_i = res_i*res_i;
				res +=  res_i;
				tot_delta += delta[i][j]*delta[i][j];
			}
	   
	   }

 	res = res/tot_delta ;  

/* 	res = res/tot_delta + OneJ_ee2(M);  trying 3 views !!!!! */
/*
	cons_add = parr_coeff*parr_penalty(M) + line_coeff*line_penalty(M,Dim);
        res += cons_add;
*/
        return(res);
}


/* Dij returns Xj-Xi
   the matrix M is a (pointcount*DIM)x1 matrix
-----------------------------------------------*/

double OneDij(matrix M,int i,int j)
{
   	double d=0.0,d_i;

	d = M[j][1] - M[i][1];
  	return(d);  
}



/* DJ_ee differential of the Stress Function 
   See declaration in Duda & Hart
   the matrix M is a (pointcount*DIM)x1 matrix
----------------------------------------------*/
void DOneJ_ee(matrix M,matrix D)
{
   	int i,j,k,q;
	double tot_delta,stat_coeff,Dij();
	double add_i,d_kj,D_k,Y_k;

	 	
	tot_delta = 0.0;
   	for (i=1; i<=pointcount; i++) 
		   for (j=1 ; j<i; j++) 
			if (delta[i][j] != LARGE_COEFF)  
				  tot_delta += delta[i][j]*delta[i][j];
	stat_coeff = 2.0/tot_delta;

	for (k=1; k<=pointcount; k++)  {

		D_k =0.0;
		Y_k = M[k][1];

		for (j=1; j<=pointcount; j++)  {
			if ( (j!=k) && (delta[k][j] != LARGE_COEFF) ) {
				d_kj = OneDij(M,k,j);
				add_i = (d_kj - delta[k][j]);
				D_k += add_i;
			}
		}
		D_k = -D_k*stat_coeff;
		D[k][1] = D_k;
	}
}
		




/* J_ff Stress Function 
   See declaration in Duda & Hart
-----------------------------------------*/
double J_ff(matrix M)
{
	double res,d,d_i,sqrt(),res_i,tot_delta;
	int i,j,k;

	res=0.0;
	tot_delta = 0.0;

	for (i=1; i<=pointcount; i++) 
	   for (j=1 ; j<i; j++) {

	      	if (delta[i][j] >= 0.0) {

		 	d = 0;
	         	for (k=1; k<=Dim; k++) {
		        	d_i = VecEntry(M,Dim,i,k) - VecEntry(M,Dim,j,k);
				d_i = d_i*d_i ;
				d += d_i;
		 	}
 		 	d = sqrt(d);
	     	}
		res_i = d - delta[i][j];
		res_i /= delta[i][j];
		res_i = res_i*res_i;
		res +=  res_i;
	   }
 	return(res/tot_delta);
}


void DJ_ff()
{
}


/* J_ef Stress Function 
   See declaration in Duda & Hart
-----------------------------------------*/
double J_ef(matrix M)
{
	double res,d,d_i,sqrt(),res_i,tot_delta;
	int i,j,k;

	res=0.0;
	tot_delta = 0.0;

	for (i=1; i<=pointcount; i++) 
	   for (j=1 ; j<i; j++) {

	      	if (delta[i][j] >= 0.0) {

		 	d = 0;
	         	for (k=1; k<=Dim; k++) {
		        	d_i = VecEntry(M,Dim,i,k) - VecEntry(M,Dim,j,k);
				d_i = d_i*d_i ;
				d += d_i;
		 	}
 		 	d = sqrt(d);
	     	}
		res_i = d - delta[i][j];
		res_i = res_i*res_i/delta[i][j];
		res +=  res_i;
		tot_delta += delta[i][j];
	   }
 	return(res/tot_delta);
}

void DJ_ef()
{
}

/* ============  Stress function for general functions ==========*/


/*  perp function defines the following relation:
    d_ij = 1/y_i - 1/y_j
------------------------------------------------------*/
double PerpStr(matrix M)
{

	double res,d,d_i,sqrt(),res_i,tot_delta,cons_add;
	int i,j,k;
	static double coeff;

	res=0.0;
	tot_delta = 0.0;

	for (i=1; i<=pointcount; i++) 
	   for (j=1 ; j<i; j++) {
		
			res_i = (PerpStr_ij(M,i,j) - delta[i][j]);
			res_i = res_i*res_i;
			res +=  res_i;
			tot_delta += delta[i][j]*delta[i][j];
		
	   }

 	res = res/tot_delta ;   
        return(res);
}

/*--------------------------------------------------*/
double PerpStr_ij(matrix M,int i,int j)
{
   	double d=0.0,d_i;

	d = (M[j][1] - M[i][1])/( M[j][1]*M[i][1]);
  	return(d);  

}

/*--------------------------------------------------*/
double DPerpStr(matrix M,matrix D)
{
   	int i,j,k,q;
	double tot_delta,stat_coeff;
	double add_i,d_kj,D_k,Y_k;

	 	
	tot_delta = 0.0;
   	for (i=1; i<=pointcount; i++) 
		   for (j=1 ; j<i; j++) 
			tot_delta += delta[i][j]*delta[i][j];

	stat_coeff = -2.0/tot_delta;

	for (k=1; k<=pointcount; k++)  {

		D_k =0.0;
		Y_k = M[k][1];

		for (j=1; j<=pointcount; j++)  {
			if ( (j!=k) ) {
				d_kj = PerpStr_ij(M,k,j);
				add_i = (d_kj - delta[k][j])/(Y_k*Y_k);
				D_k += add_i;
			}
		}
		D_k = D_k*stat_coeff;
		D[k][1] = D_k;
	}


}


/* ========================   General Routines =====================*/

matrix metric_mds(int dim,int pointNum,matrix firstGuess,matrix prox,
	double (*func_to_minimize)(),void (*dfunc_to_minimize)())
{
  matrix res =NULL,res_cons=NULL;

  pointcount = pointNum;
  Dim = dim;
  delta = prox;

  parr_coeff=line_coeff=0.0 ; 

  /* res = param_min(pointNum*dim,firstGuess,func_to_minimize);  */ 

  res=param_dmin(pointNum*dim,firstGuess,func_to_minimize,dfunc_to_minimize);   


  return(res);   

}


/* return a vector with the first guess */
matrix generate_first_guess(int dim ,int pointNum,int range)
{
   int i,j,k;
   matrix guess=NULL;

   alloc_mtx(&guess,dim*pointNum,1);   
  
   for (k=1; k<=dim; k++) 
	for (i=1; i<=pointNum; i++) 
		VecEntry(guess,dim,i,k) = unif_distr(0.0,(double)range);   
   
/*   guess[dim*pointNum+1][1] = unif_distr(0.0,1.0) ;     trying 3 views !!!!! */

   return(guess);  
}






