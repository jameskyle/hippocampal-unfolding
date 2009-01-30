/* ################################################################# */
/*								     */
/*			    M A T R I X . C 			     */
/*								     */
/* ################################################################# */


/* ################################################################# */
/* This library was written by Yacov Hel-Or 1992                     */
/* ################################################################# */

#include <stdio.h>
#include <math.h>
#include <varargs.h>
#include "matrix.h"


matrix tmp_mtx[10];

/*
alloc mxn array of doubles. when allocated M must contains NULL
_______________________________________________________*/

alloc_mtx(M,m,n)
int m,n;
matrix *M;
{
	int i ;
	double *B ;
	matrix R=NULL;

	if (*M != NULL) printerr("ERROR in alloc_mtx: alocating matrix to non nil pointer");
	if (! (R = (matrix) calloc (m+1,sizeof(B)))) 
		printerr("ERROR in alloc_mtx: can't allocating space.");
	if (! (B = (double *) calloc((unsigned)((m+1)*(n+1)), (unsigned)sizeof(double))))
		printerr("ERROR in alloc_mtx: can't allocating space."); 
	for (i=0 ; i<= m ; i++)
			R[i] =  B+i*(n+1);

	R[1][0] = (double)m;
	R[0][1] = (double)n ;
	*M = R;
}

/*
Frees the place of the matrix A.
_______________________________________________________*/

free_mtx(A)
matrix *A;
{

	if (*A == NULL) return ;
 	free((*A)[0]) ;
	free(*A);
	*A=NULL;
}


/*
USAGE: free_all_mtx(num,&mat1,&mat2,&mat3,......)
Frees the place of num matrices.
_______________________________________________________*/
free_all_mtx(va_alist) va_dcl
{
	va_list ap;
	matrix *A;
	int i,num;
	
	va_start(ap);
	num = va_arg(ap,int);

	for (i=0; i<num;i++) {
		A = va_arg(ap,matrix*);
		if (*A!=NULL) {
			free((*A)[0]) ;
			free(*A);
			*A=NULL;
		}
	}
	va_end(ap);
}

/*
frees all the allocated matrix in tmp_mtx array
_______________________________________________________*/

free_tmp(num)
int num;
{
	int i;

	for (i=0 ; i<=num ; i++) 
		if (tmp_mtx[i] != NULL)
			free_mtx(&(tmp_mtx[i]));
}


/*
returns  A + B  where A and B are matrices.
_______________________________________________________*/

matrix add_mtx(A,B)
matrix  A, B;
{
	register int i, j;
	int  m, n;
	matrix C=NULL ;

	m = (ROWS(A)); n = (COLS(A));

	if (m!=(ROWS(B)) || n!=(COLS(B))) 
		printerr("ERROR in add_mtx: Inappropriate dimensions");


 	alloc_mtx(&C,m,n) ;
	for (i=1 ; i <=  m ; i++) 
		for (j=1; j <= n ; j++)
			C[i][j] = A[i][j] + B[i][j] ;

	return(C);
 }

/*
This function adds to matrix A (mxn) the matrix B (kxl)
from the place (p,q).
_______________________________________________________*/
add_in_mtx(A,B,p,q)
matrix A,B;
int p,q;
{
	int m,n,k,l;
	int i,j ;

	m=(ROWS(A)); n=(COLS(A)); 
	k=(ROWS(B)); l=(COLS(B)); 

	if (m<(k+p-1) || n<(l+q-1) )
		 printerr("ERROR in add_in_mtx: illegal indices.");

	for (i=1 ; i<=k ; i++)
		for (j=1 ; j<=l ; j++)
			A[p+i-1][q+j-1] += B[i][j];

}


/*
returns  A - B  where A and B are matrices.
_______________________________________________________*/

matrix sub_mtx(A,B)
matrix  A, B ;
{
	register int i, j;
	int  m,n ;
	matrix C=NULL;

	m = (ROWS(A)); n = (COLS(A));

	if (m!=(ROWS(B)) || n!=(COLS(B))) 
		printerr("ERROR in add_mtx: Unappropriate dimensions");


 	alloc_mtx(&C,m,n) ;
	for (i=1 ; i <=  m ; i++) 
		for (j=1; j <= n ; j++)
			C[i][j] = A[i][j] - B[i][j] ;

	return(C);
 }

/*
This function subs from matrix A (mxn) the matrix B (kxl)
from the place (p,q).
_______________________________________________________*/
sub_in_mtx(A,B,p,q)
matrix A,B;
int p,q;
{
	int m,n,k,l;
	int i,j ;

	m=(ROWS(A)); n=(COLS(A)); 
	k=(ROWS(B)); l=(COLS(B)); 

	if (m<(k+p-1) || n<(l+q-1) )
		 printerr("ERROR in sub_in_mtx: illegal indexes.");

	for (i=1 ; i<=k ; i++)
		for (j=1 ; j<=l ; j++)
			A[p+i-1][q+j-1] -= B[i][j];

}

/*
returns  A * B  where A is a mxk matrix and 
B is a kxn matrix.
_______________________________________________________*/

matrix mul_mtx(A,B)
matrix  A, B ;
{
	int  i, j , r;
	int  m,n;
	matrix C=NULL ;
	double res ;

	if (COLS(A) != ROWS(B) ) 
		printerr("ERROR in mul_mtx: inappropriate dimensions");

	m=(ROWS(A)); n=(COLS(B)); 

 	alloc_mtx(&C,m,n) ;


	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) {
			res = 0.0 ;
 			for (r=1; r <= A[0][1]; r++)
				res += A[i][r]*B[r][j] ;
			C[i][j] = res ;
		}

	return(C); 
}


/*
returns s * B  where s is a scalar.
_______________________________________________________*/

matrix mul_scalar_mtx(B,s)
double s;
matrix  B;
{
	register int i, j;
	int m,n;
	matrix C=NULL;
	register double res ;

	m=(ROWS(B)); n=(COLS(B)); 

 	alloc_mtx(&C,m,n) ;


	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			C[i][j] = B[i][j]*s ;

	return(C);
}

/*
returns s * B  where s is a scalar.
_______________________________________________________*/

mul_scalar_in_mtx(B,s)
double s;
matrix  B;
{
	register int i, j;
	int m,n;
	matrix C=NULL;
	register double res ;

	m=(ROWS(B)); n=(COLS(B)); 


	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			B[i][j] = B[i][j]*s ;

}

/*
returns  B/s  where s is a scalar.
_______________________________________________________*/

matrix div_scalar_mtx(B,s)
double s;
matrix  B;
{
	register int i, j;
	int m,n;
	matrix C=NULL;
	register double res ;

	m=(ROWS(B)); n=(COLS(B)); 

	alloc_mtx(&C,m,n);

	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			C[i][j] = B[i][j]/s ;

}


/*
returns  B/s  where s is a scalar.
_______________________________________________________*/

div_scalar_in_mtx(B,s)
double s;
matrix  B;
{
	register int i, j;
	int m,n;
	matrix C=NULL;
	register double res ;

	m=(ROWS(B)); n=(COLS(B)); 


	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			B[i][j] = B[i][j]/s ;

}




/*
returns transpose(A)  where A is mxn matrix . 
_______________________________________________________*/

matrix transpose_mtx(A)
matrix  A;
{
	int m,n;
	register int i, j ;
	matrix C=NULL;

	m=(ROWS(A)); n=(COLS(A)); 

 	alloc_mtx(&C,n,m) ;


	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			C[j][i] = A[i][j] ;

	return(C);
}


/***
returns  (A)^(-1).
_______________________________________________________***/

matrix inv_mtx(A)
matrix  A;
{
	int n,m;
	int i, j , *indx;
	matrix C=NULL, B=NULL;
	double d ;

	m=(ROWS(A)); n=(COLS(A)); 
	if (m!=n) printerr("ERROR in inv_mtx: the matrix is not squared") ;

 	alloc_mtx(&C,n,n) ;
 	alloc_mtx(&B,n,n) ;

	indx = (int *)calloc(n+1,sizeof(int)) ; 

	for (i=1 ; i <=  n ; i++) {
		for (j=1; j <= n ; j++) {
			C[i][j] = 0.0 ;
			B[i][j] = A[i][j] ;
		}
		C[i][i] = 1.0 ;
	}

	ludcmp(B,n,indx,&d);

	for (i=1 ; i <=  n ; i++) 
		lubksb(B,n,indx,C[i]) ;

	
	free(indx);
	free_mtx(&B);
	B = transpose_mtx(C) ;
	free_mtx(&C);
	return(B);
}


/***
returns  det(A).
_______________________________________________________***/

double det_mtx(A)
matrix  A;
{
	int n,m;
	int i, j , *indx;
	matrix  B=NULL,copy_mtx();
	double d ;

	m=(ROWS(A)); n=(COLS(A)); 
	if (m!=n) printerr("ERROR in inv_mtx: the matrix is not squared") ;

 	B = copy_mtx(A) ;

	indx = (int *)calloc(n+1,sizeof(int)) ; 
	
	ludcmp(B,n,indx,&d);

	for (i=1 ; i<=n ; i++)
		d = d*B[i][i] ;

	
	free(indx);
	free_mtx(&B);
	return(d) ;
}


/***
returns an nxn identity matrix.
_______________________________________________________***/

matrix ident_mtx(n) 
int n ;
{
	matrix C=NULL;
	int i,j, m ;

	alloc_mtx(&C,n,n);

	for (i=1 ; i <=  n ; i++) {
		for (j=1; j <= n ; j++) 
			C[i][j] = 0.0 ;
		C[i][i] = 1.0 ;
	}

	return(C);

}


/*
prints the matrix A
_____________________________________________________________*/
print_mtx(A)
matrix A ;
{
	int i, j ,m,n;

	if (A == NULL) printerr("ERROR in print_mtx: NULL matrix.");
	m=(ROWS(A)); n=(COLS(A)); 

	for (i=1 ; i <= m  ; i++) {
		for (j=1 ; j <= n  ; j++)
			printf("%f  ",A[i][j]);
		printf("\n");
	}
}


/*
If w=vxu is a cross product when v and u are 3x1 vectors
then it could be calculated as a w=Vu when V is a 
cross-matrix of v.
This function calculates cross-matrix V when v (3x1)
is supplied.
-------------------------------------------------------*/ 

matrix cross_mtx(v)
matrix v;
{
	int m, n;
	matrix V=NULL ;

	m=(ROWS(v)); n=(COLS(v)); 
	if ((m!=3) || (n!=1))  
		printerr("ERROR in cross_mtx m!=1 | n!=3");
	alloc_mtx(&V,3,3);
	
	V[1][1] = 0.0 ;
	V[2][2] = 0.0 ;
	V[3][3] = 0.0 ;
	V[1][2] = -v[3][1] ;
	V[1][3] = v[2][1] ;
	V[2][1] = v[3][1] ;
	V[2][3] = -v[1][1] ;
	V[3][1] = -v[2][1] ;
	V[3][2] = v[1][1] ;

	return(V);
}

/*
This function gets the matrix A (mxn) and returns
the square-root of its norm 2. 
-------------------------------------------------------*/ 
double norm_mtx(A)
matrix A;
{
	int m,n;
	int i,j;
	double val,sqrt();

	m=(ROWS(A)); n=(COLS(A)); 
	val = 0.0;

	for (i=1; i<=m; i++) 
		for (j=1; j<=n; j++)   val = val + A[i][j]*A[i][j] ;

	return(sqrt(val)) ;
}

/*
This function gets the matrix A (mxn) and returns
a unit matrix in the same direction. 
-------------------------------------------------------*/ 
matrix normalize_mtx(A)
matrix A;
{
	int m,n;
	int i,j;
	double val,norm_mtx(),sqrt();
	matrix R=NULL,div_scalar_mtx();

	val = norm_mtx(A);
	R = div_scalar_mtx(A,val);

	return(R);
}



/*
A - an mxn matrix. B - an kxl matrix. If m=k then:
R = (A,B)  an mx(n+l) matrix. This function returns the R.
_______________________________________________________*/

matrix mtx_hor_concatenate(A,B)
matrix A,B;
{
	int m,n,k,l,i,j ;
	matrix C=NULL,copy_mtx();

	if (A==NULL) {C = copy_mtx(B); return(C); }
	if (B==NULL) {C = copy_mtx(A); return(C); }

	m=(ROWS(A)); n=(COLS(A)); 
	k=(ROWS(B)); l=(COLS(B)); 

	if (k != m)  
		printerr ("ERROR in mtx_hor_concatenate: k != m.");

	alloc_mtx(&C,m,(n+l)) ;
		for (i = 1 ; i <= m ; i++)
			for (j=1 ; j <= n ; j++) 
				C[i][j] = A[i][j] ;

		for (i = 1 ; i <= k ; i++)
			for (j=1 ; j <= l ; j++) 
				C[i][n+j] = B[i][j] ;

	return(C);
}


/*
A - an mxn matrix. B - an kxl matrix. If n=l then:
R = |A|
    |B|  
an (m+k)xn matrix. This function returns the R.
_______________________________________________________*/
matrix mtx_ver_concatenate(A,B)
matrix A,B;
{
	int m,n,k,l ;
	matrix C=NULL ;
	int i,j ;

	if (A==NULL) return (B);
	if (B==NULL) return (A);

	m=(ROWS(A)); n=(COLS(A)); 
	k=(ROWS(B)); l=(COLS(B)); 

	if (n != l)  
		printerr ("ERROR in mtx_ver_concatenate: n != l.");

	alloc_mtx(&C,(m+k),n) ;

	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			C[i][j] = A[i][j] ;

	for (i = 1 ; i <= k ; i++)
		for (j=1 ; j <= l ; j++) 
			C[m+i][j] = B[i][j] ;

	return(C);
}


/*
A - an mxn matrix. B - an kxl matrix. if m=k then:
return mx(n+l) matrix which  the columns from,..,from+l-1
are the matrix B. the columns from+l,..,n+l are the rest
of matrix A.
_______________________________________________________*/
matrix mtx_ver_thread(A,B,from)
matrix A,B;
int from;
{
	matrix R=NULL;
	int i,j,m,n,k,l;

	if (A==NULL) return (B);
	if (B==NULL) return (A);

	m=(ROWS(A)); n=(COLS(A)); 
	k=(ROWS(B)); l=(COLS(B)); 

	if (m != k)  
		printerr ("ERROR in mtx_ver_thred: m != k.");
	if ( from > (n+1) ) 
		printerr ("ERROR in mtx_ver_thred: from>(n+1) ");

	alloc_mtx(&R,m,n+l);

	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j < from ; j++) 
			R[i][j] = A[i][j] ;

	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= l ; j++) 
			R[i][from+j-1] = B[i][j] ;

	for (i = 1 ; i <= m ; i++)
		for (j=from ; j <= n ; j++) 
			R[i][j+l] = A[i][j] ;

	return(R);
}

/*
A - an mxn matrix. B - an kxl matrix. if n=l then:
return (m+k)xn matrix which  the rows from,..,from+k-1
are the matrix B. the rows from+k,..,m+k are the rest
of matrix A.
_______________________________________________________*/
matrix mtx_hor_thread(A,B,from)
matrix A,B;
int from;
{
	matrix R=NULL;
	int i,j,m,n,k,l;

	if (A==NULL) return (B);
	if (B==NULL) return (A);

	m=(ROWS(A)); n=(COLS(A)); 
	k=(ROWS(B)); l=(COLS(B)); 

	if (n != l)  
		printerr ("ERROR in mtx_hor_thred: n != l.");
	if ( from > (m+1) ) 
		printerr ("ERROR in mtx_hor_thred: from>(m+1) ");

	alloc_mtx(&R,m+k,n);

	for (i = 1 ; i < from ; i++)
		for (j=1 ; j <=n ; j++) 
			R[i][j] = A[i][j] ;

	for (i = 1 ; i <= k ; i++)
		for (j=1 ; j <= n ; j++) 
			R[from+i-1][j] = B[i][j] ;

	for (i = from ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			R[i+k][j] = A[i][j] ;

	return(R);
}


/*
if  A is an mxn matrix. 
then R is an (to-from+1)xn matrix, and is a vertical part of A.
This function returns the R.
_______________________________________________________________*/
matrix mtx_ver_cut(A,from,to)
matrix A ;
int from,to ;
{
	matrix B=NULL ;
	int i,j,m,n ;

	m=(ROWS(A)); n=(COLS(A)); 

	if ((from > to) || (from > m) || (to > m))
		printerr("ERROR in mtx_ver_cut: wrong indices.");

	alloc_mtx(&B,to-from+1,n) ;

	for (i=1 ; i <= to-from+1 ; i++)
		for (j=1 ; j <= n ; j++)
			B[i][j] = A[from+i-1][j] ;

	return(B);
}

/*
if  A is an mxn matrix. 
then R is an (to_x-from_x+1)x(to_y-from_y+1) matrix, 
and is a vertical part of A.
This function returns the R.
_______________________________________________________________*/
matrix mtx_cut(A,from_row,from_col,to_row,to_col)
matrix A ;
int from_row,to_row,from_col,to_col ;
{
	matrix B=NULL ;
	int i,j,m,n ;

	m=(ROWS(A)); n=(COLS(A)); 

	if ((from_row > to_row) || (from_col > to_col) ||
	  (from_row > m) || (from_col > n) || 
	  (to_row > m) || (to_col > n) )
		printerr("ERROR in mtx_cut: wrong indices.");

	alloc_mtx(&B,to_row-from_row+1,to_col-from_col+1) ;

	for (i=1 ; i <= to_row-from_row+1 ; i++)
		for (j=1 ; j <= to_col-from_col+1 ; j++)
			B[i][j] = A[from_row+i-1][from_col+j-1] ;

	return(B);
}

 
/* copy contents of martrix A.
_______________________________________________________*/
matrix copy_mtx(A)
matrix A;
{
	int i,j,m,n ;
	matrix B=NULL;

	m=(ROWS(A)); n=(COLS(A)); 

	alloc_mtx(&B,m,n);
				
	
	for (i = 1 ; i <= m ; i++)
		for (j=1 ; j <= n ; j++) 
			B[i][j] = A[i][j] ;

	return(B);

}


/*
This function returns the trace of A (nxn)
_______________________________________________________*/
double  trace_mtx(A)
matrix A;
{
	double trace;
	int i,m,n;

	m=(ROWS(A)); n=(COLS(A)); 
	if (m != n) 	
		printerr("ERROR in trace_mtx: unsquared matrix.");

	trace = 0.0 ;

	for (i=1; i <= n; i++)
		trace += A[i][i] ;
	return(trace) ;
}


/* if  a and b are (3x1) vectors then the function 
returns the axb where "x" is the cross product   
_______________________________________________________*/
matrix cross_vectors(a,b)
matrix a,b;
{
	matrix R=NULL;

	if ((ROWS(a))!=3 || (ROWS(b))!=3 || (COLS(a))!=1 || (COLS(b))!=1)
		printerr("ERROR in cross_vectors: illegal dimension.");

	alloc_mtx(&R,3,1);

	R[1][1] = a[2][1]*b[3][1] - a[3][1]*b[2][1];
	R[2][1] = a[3][1]*b[1][1] - a[1][1]*b[3][1];
	R[3][1] = a[1][1]*b[2][1] - a[2][1]*b[1][1];

	return(R);
}

/* if  a and b are (nx1) vectors then the function 
returns the a.b where "." is the dot product   
_______________________________________________________*/
double dot_vectors(a,b)
matrix a,b;
{
	double res;
	int i;

	if ((ROWS(a))!=(ROWS(b)) || (COLS(a))!=1 || (COLS(b))!=1)
		printerr("ERROR in cross_vectors: illegal dimension.");

	res = 0.0 ;
	for (i=1; i<=(ROWS(a)); i++)
		res += a[i][1]*b[i][1];

	return(res);
}


/* 
this function gets a matrix A (nxn) and returns a symmetric
matrix where A[i,j]=(A[i,j]+A[j,i])/2
************************************************************/
make_symm_mtx(A)
matrix A;
{
	int i,j ,n;
	
	n = (ROWS(A));
	if ((COLS(A)) != n) printerr("ERROR in make_symm_mtx: not a square matrix."); 

	for (i=1 ; i<=n ; i++)
		for (j=i ; j<=n ; j++)
			A[i][j] = A[j][i] = (A[i][j]+A[j][i])/2.0 ;
}


/*
This function gets a real symmetric real symmetric matrix A (nxn) 
and return a vector (nx1) which contains the eigen values of A.
************************************************************/
matrix eigen_val_symm_mtx(A)
matrix A;
{
	int m,n,i,j,nrot;
	matrix C=NULL,d=NULL,V=NULL;
	
	n = (ROWS(A));
	if ((COLS(A)) != n) printerr("ERROR in eigen_val_symm_mtx: not a square matrix.");
	
	for (i=1 ; i<=n ; i++)
		for (j=i ; j<=n ; j++)
			if (A[i][j] != A[j][i])  
			    printerr("ERROR in eigen_val_symm_mtx: non symmetric matrix.");

	C = copy_mtx(A);
	alloc_mtx(&d,n,1);
	alloc_mtx(&V,n,n);

	jacobi(C,n,d,V,&nrot);
	
	free_mtx(&C);
	free_mtx(&V);

	return(d);
}

/*
This function gets a real symmetric real symmetric matrix A (nxn) 
and returns a matrix (nxn) which its columns contain the normalized 
eigen vectors of A.
************************************************************/
matrix eigen_vec_symm_mtx(A)
matrix A;
{
	int m,n,i,j,nrot;
	matrix C=NULL,d=NULL,V=NULL;
	
	n = (ROWS(A));
	if ((COLS(A)) != n) printerr("ERROR in eigen_vec_symm_mtx: not a square matrix.");
 
	for (i=1 ; i<=n ; i++)
		for (j=i ; j<=n ; j++)
			if (A[i][j] != A[j][i])  
			    printerr("ERROR in eigen_vec_symm_mtx: non symmetric matrix.");

	C = copy_mtx(A);
	alloc_mtx(&d,n,1);
	alloc_mtx(&V,n,n);

	jacobi(C,n,d,V,&nrot);
	
	free_mtx(&C);
	free_mtx(&d);

	return(V);
}

/*
This function gets a real symmetric real symmetric matrix A (nxn) 
and returns a matrix (nx1) which  contain the normalized smallest
eigen vectors of A.
************************************************************/
matrix smallest_eigen_vec_symm_mtx(A)
matrix A;
{
	int m,n,i,j,nrot;
	matrix C=NULL,d=NULL,V=NULL,vec=NULL;
	int min_i;
	double min_val;
	
	n = (ROWS(A));
	if ((COLS(A)) != n) printerr("ERROR in eigen_vec_symm_mtx: not a square matrix.");
 
	for (i=1 ; i<=n ; i++)
		for (j=i ; j<=n ; j++)
			if (A[i][j] != A[j][i])  
			    printerr("ERROR in eigen_vec_symm_mtx: non symmetric matrix.");

	C = copy_mtx(A);
	alloc_mtx(&d,n,1);
	alloc_mtx(&V,n,n);

	jacobi(C,n,d,V,&nrot);
	
	min_val = 1E20;
	for (i=1 ; i<=n ; i++) 
		if (ABS(d[i][1])<min_val) {
			min_val = ABS(d[i][1]);
			min_i = i;
		}
	vec = mtx_cut(V,1,min_i,n,min_i);

	free_mtx(&C);
	free_mtx(&d);
	free_mtx(&V);

	return(vec);
}

/* this function generate the Cholesky square-root decomposition of
 a positive defenite matrix. A Cholesy decomposition
 decompose a positive definite matrix A to be B*transp(B)=A
 where  B is a lower triangular matrix. 
(for refference see: Stochastic Models / Maybeck, pp. 371
************************************************************/
matrix cholesky_dcmp_mtx(A)
matrix A;
{
	int i,j,k,m,n;
	matrix C=NULL;
	double res,sqrt();

	n = (ROWS(A));
	if ((COLS(A)) != n) printerr("ERROR in cholesky_dcmp_mtx: not a square matrix.");
 
	for (i=1 ; i<=n ; i++)
		for (j=i ; j<=n ; j++)
			if (A[i][j] != A[j][i])  
			    printerr("ERROR in cholesky_dcmp_mtx: non symmetric matrix.");
	alloc_mtx(&C,n,n);

	for (i=1; i<=n; i++)
		for (j=1; j<=i; j++) {
			if (i==j)    {
				res = 0.0 ;
				for (k=1; k<=i-1; k++)   res += C[i][k]*C[i][k];
				C[i][j] = sqrt(A[i][i] - res);
			}
			else	{
				res = 0.0 ;
			      	for (k=1; k<=j-1; k++)   res += C[i][k]*C[j][k];
				C[i][j] = (A[i][j] - res)/C[j][j] ;
				}
		}
	return(C);
}


/*
This function gets a Lower triangular matrix and returns its inverse. 
___________________________________________________________________ */
matrix  inv_L_mtx(L)
matrix L;
{
	int i,j,k,m,n;
	matrix A=NULL;
	double sum,sqrt();
 
	n = (ROWS(L));
	if ((COLS(L)) != n) printerr("ERROR in inv_L_mtx: not a square matrix.");
	alloc_mtx(&A,n,n);

	for (k=1; k<=n; k++)
		for (i=1; i<=n; i++) {
			sum = 0.0;
			for (j=1; j<=i-1; j++)  sum += L[i][j]*A[j][k];
			if (i==k)  sum -= 1.0;
			A[i][k] = sum/-L[i][i];
		}
	return(A);
}	





/***************************************************************
From here to the end are 
some utilities functions from Numerical-Recepies. note that all 
the vectors/matrices indices are starting from 1 (and not 0)!
****************************************************************/


/**
Given an nXn matrix a, with dimension n, this routine replaces it
by the LU decomposition of a rowwise permutation of itself.
a and n are input. a is output, arranged by superimposed L and U
together. indx is an output vector which records the row permutation 
effected by the partial pivoting. d is output as +-1 depending on
wheather the number of row interchanges was even or odd, resp.
This function is used in combination with LUBKSB to solve linear
equations or invert matrix (see Numerical Recipies pp. 35)
----------------------------------------------------------------------**/

#define TINY 1.0e-20;

ludcmp(a,n,indx,d)
int n,*indx;
double **a,*d;
{
	int i,imax,j,k;
	double big,dum,sum,temp;
	void nrerror();
	matrix vv=NULL;

	alloc_mtx(&vv,1,n);
	*d=1.0;
	for (i=1;i<=n;i++) {
		big=0.0;
		for (j=1;j<=n;j++)
			if ((temp=fabs(a[i][j])) > big) big=temp;
		if (big == 0.0) nrerror("Singular matrix in routine LUDCMP");
		vv[1][i]=1.0/big;
	}
	for (j=1;j<=n;j++) {
		for (i=1;i<j;i++) {
			sum=a[i][j];
			for (k=1;k<i;k++) sum -= a[i][k]*a[k][j];
			a[i][j]=sum;
		}
		big=0.0;
		for (i=j;i<=n;i++) {
			sum=a[i][j];
			for (k=1;k<j;k++)
				sum -= a[i][k]*a[k][j];
			a[i][j]=sum;
			if ( (dum=vv[1][i]*fabs(sum)) >= big) {
				big=dum;
				imax=i;
			}
		}
		if (j != imax) {
			for (k=1;k<=n;k++) {
				dum=a[imax][k];
				a[imax][k]=a[j][k];
				a[j][k]=dum;
			}
			*d = -(*d);
			vv[1][imax]=vv[1][j];
		}
		indx[j]=imax;
		if (a[j][j] == 0.0) a[j][j]=TINY;
		if (j != n) {
			dum=1.0/(a[j][j]);
			for (i=j+1;i<=n;i++) a[i][j] *= dum;
		}
	}
	free_mtx(&vv);
}

#undef TINY




void nrerror(stat)
char *stat;
{
fprintf(stderr,"%s\n",stat);
exit(0);
}

/***
Solves the set of n linear equations AX=B. Here A is input not as the
matrix A but rather as its LU decomposition, determined by the function 
LUDCMP. INDX is input as the permutation vector returned by LUDCMP.
B is input as the right-hand side vector B, and returns with the 
solution vector X. A,N, and INDX are not modified bt this function
and can be left in place for succesive calls with different right-hand
sides B. This function takes into account the possibility that B will
begin with many zero elements, so it is efficient for use in matrix 
inversion
----------------------------------------------------------------------**/

lubksb(a,n,indx,b)
double **a,*b;
int n,*indx;
{
	int i,ii=0,ip,j;
	double sum;

	for (i=1;i<=n;i++) {
		ip=indx[i];
		sum=b[ip];
		b[ip]=b[i];
		if (ii)
			for (j=ii;j<=i-1;j++) sum -= a[i][j]*b[j];
		else if (sum) ii=i;
		b[i]=sum;
	}
	for (i=n;i>=1;i--) {
		sum=b[i];
		for (j=i+1;j<=n;j++) sum -= a[i][j]*b[j];
		b[i]=sum/a[i][i];
	}
}


/* 
Computes all eigenvalues and eigenvectors of a real symmetric matrix
a[1..n,1..n]. On output, elements of a above the diagonal are destroyed.
d[1..n] returns the eigenvalues of a. v[1..n,1..n] is a matrix whose
columns contain, on output, the normalized eigenvectors of a.
nrot returns the number of jacobi rotations that where required.
----------------------------------------------------------------------**/

#define ROTATE(a,i,j,k,l) g=a[i][j];h=a[k][l];a[i][j]=g-s*(h+g*tau);\
	a[k][l]=h+s*(g-h*tau);

jacobi(a,n,d,v,nrot)
matrix a,d,v;
int n,*nrot;
{
	int j,iq,ip,i;
	double tresh,theta,tau,t,sm,s,h,g,c;
	matrix b=NULL,z=NULL;
	void nrerror();

	alloc_mtx(&b,n,1); 
	alloc_mtx(&z,n,1); 
	for (ip=1;ip<=n;ip++) {
		for (iq=1;iq<=n;iq++) v[ip][iq]=0.0;
		v[ip][ip]=1.0;
	}
	for (ip=1;ip<=n;ip++) {
		b[ip][1]=d[ip][1]=a[ip][ip];
		z[ip][1]=0.0;
	}
	*nrot=0;
	for (i=1;i<=50;i++) {
		sm=0.0;
		for (ip=1;ip<=n-1;ip++) {
			for (iq=ip+1;iq<=n;iq++)
				sm += fabs(a[ip][iq]);
		}
		if (sm == 0.0) {
			free_mtx(&z);
			free_mtx(&b);
			return;
		}
		if (i < 4)
			tresh=0.2*sm/(n*n);
		else
			tresh=0.0;
		for (ip=1;ip<=n-1;ip++) {
			for (iq=ip+1;iq<=n;iq++) {
				g=100.0*fabs(a[ip][iq]);
				if (i > 4 && fabs(d[ip][1])+g == fabs(d[ip][1])
					&& fabs(d[iq][1])+g == fabs(d[iq][1]))
					a[ip][iq]=0.0;
				else if (fabs(a[ip][iq]) > tresh) {
					h=d[iq][1]-d[ip][1];
					if (fabs(h)+g == fabs(h))
						t=(a[ip][iq])/h;
					else {
						theta=0.5*h/(a[ip][iq]);
						t=1.0/(fabs(theta)+sqrt(1.0+theta*theta));
						if (theta < 0.0) t = -t;
					}
					c=1.0/sqrt(1+t*t);
					s=t*c;
					tau=s/(1.0+c);
					h=t*a[ip][iq];
					z[ip][1] -= h;
					z[iq][1] += h;
					d[ip][1] -= h;
					d[iq][1] += h;
					a[ip][iq]=0.0;
					for (j=1;j<=ip-1;j++) {
						ROTATE(a,j,ip,j,iq)
					}
					for (j=ip+1;j<=iq-1;j++) {
						ROTATE(a,ip,j,j,iq)
					}
					for (j=iq+1;j<=n;j++) {
						ROTATE(a,ip,j,iq,j)
					}
					for (j=1;j<=n;j++) {
						ROTATE(v,j,ip,j,iq)
					}
					++(*nrot);
				}
			}
		}
		for (ip=1;ip<=n;ip++) {
			b[ip][1] += z[ip][1];
			d[ip][1]=b[ip][1];
			z[ip][1]=0.0;
		}
	}
	nrerror("Too many iterations in routine JACOBI");
}

#undef ROTATE

/*
Error Message.
---------------------------------------------------------------------- */
printerr(s)
char **s;
{
        printf("%s\n",s);
        exit(1);
}
