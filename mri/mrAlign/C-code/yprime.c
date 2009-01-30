/* $Revision: 1.2 $ */
/*
 *
 * YPRIME.C	Sample .MEX file corresponding to YPRIME.M
 *	        Solves simple 3 body orbit problem 
 *
 * The calling syntax is:
 *
 *		[yp] = yprime(t, y)
 *
 * Copyright (c) 1984-1998 by The MathWorks, Inc.
 * All Rights Reserved.
 */

#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	T_IN	prhs[0]
#define	Y_IN	prhs[1]


/* Output Arguments */

#define	YP_OUT	plhs[0]

#if !defined(max)
#define	max(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(min)
#define	min(A, B)	((A) < (B) ? (A) : (B))
#endif

#define pi 3.14159265

static	double	mu = 1/82.45;
static	double	mus = 1 - 1/82.45;


static void yprime(
		   double	yp[],
		   double	*t,
		   double	y[]
		   )
{
  double	r1,r2;
  
  r1 = sqrt((y[0]+mu)*(y[0]+mu) + y[2]*y[2]);
  r2 = sqrt((y[0]-mus)*(y[0]-mus) + y[2]*y[2]);
  
  yp[0] = y[1];
  yp[1] = 2*y[3]+y[0]-mus*(y[0]+mu)/(r1*r1*r1)-mu*(y[0]-mus)/(r2*r2*r2);
  yp[2] = y[3];
  yp[3] = -2*y[1] + y[2] - mus*y[2]/(r1*r1*r1) - mu*y[2]/(r2*r2*r2);
  return;
}

void mexFunction(
                 int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]
		 )
{
  double	*yp;
  double	*t,*y;
  unsigned int	m,n;
  
  /* Check for proper number of arguments */
  
  if (nrhs != 2) {
    mexErrMsgTxt("YPRIME requires two input arguments.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("YPRIME requires one output argument.");
  }
  
  
  /* Check the dimensions of Y.  Y can be 4 X 1 or 1 X 4. */
  
  m = mxGetM(Y_IN);
  n = mxGetN(Y_IN);
  if (!mxIsNumeric(Y_IN) || mxIsComplex(Y_IN) || 
      mxIsSparse(Y_IN)  || !mxIsDouble(Y_IN) ||
      (max(m,n) != 4) || (min(m,n) != 1)) {
    mexErrMsgTxt("YPRIME requires that Y be a 4 x 1 vector.");
  }
  
  
  /* Create a matrix for the return argument */
  
  YP_OUT = mxCreateDoubleMatrix(m, n, mxREAL);
  
  
  /* Assign pointers to the various parameters */
  
  yp = mxGetPr(YP_OUT);
  
  t = mxGetPr(T_IN);
  y = mxGetPr(Y_IN);
  
  
  /* Do the actual computations in a subroutine */
  
  yprime(yp,t,y);
  return;
}


