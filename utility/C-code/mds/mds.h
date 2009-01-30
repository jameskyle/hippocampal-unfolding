#ifndef _mds_h_
#define _mds_h_

#include "matrix.h"

#define LARGE_COEFF 100000.0

#define  VecEntry(str,dim,i,k)	  ( str[((i)-1)*dim+(k)][1] ) 
#define  Xentry(i,dim) 		  ( ((i)-1)*dim + 1 )
#define  Yentry(i,dim) 		  ( ((i)-1)*dim + 2 )
#define  Zentry(i,dim) 		  ( ((i)-1)*dim + 3 )
#define  Sentry(i,dim)		  ( ((i)-1)*dim + 1 )
#define  Eentry(i,dim)		  ( ((i)-1)*dim + dim )
#define  SQR(x)			((x)*(x))


typedef enum {JEF,JFF,JEE} objT;

double J_ef(),J_ff(),J_ee(),OneJ_ee();
matrix metric_mds(),generate_first_guess(),metric_mds();
void DJ_ee(),DOneJ_ee(); 
double DPerpStr(),PerpStr_ij(),PerpStr();
#endif