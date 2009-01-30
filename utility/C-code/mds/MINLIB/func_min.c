#include <stdio.h>
#include <math.h>
#include <matrix.h>

#define FTOL 1.0E-6

matrix param_min(dim,start_guess,func_to_minimize)
int dim;
matrix start_guess;      /*dim x 1 */
double (*func_to_minimize)();
{
	matrix xi=NULL,p=NULL;
	double fret;
	int iter_num;
	int i;
	int m,n;
	void powell();

	m=(ROWS(start_guess)); n=(COLS(start_guess)); 
	if  ((m != dim) || (n!=1)) 
		printerrW("param_min: start_guess bad dimenssion");



	xi = ident_mtx(dim);
	p = copy_mtx(start_guess);

/*  
Powell - Minimization of a function func on n variables. Input consists
of an initial starting points p[1..n]; an initial matrix xi[1..n][1..n]
whose columns contain the initial set of directions (usually the
n unit vectors); and ftol, the fractional tolerance in the function
value such that the failure to decrease by more than this amount 
on one iteration signals doeness.
On output, p is set of best point found, xi is the then-current
directions set, fret is the returned function value at p, and iter is
the number of iteration taken. The rutine linmin is used.
 */


	powell(p,xi,dim,FTOL,&iter_num,&fret,func_to_minimize);

	/* printf("iter_num=%d   fret=%lf \n",iter_num,fret); */
	
	free_mtx(&xi);
	return(p);

}



matrix param_dmin(dim,start_guess,func_to_minimize,dfunc_to_minimize)
int dim;
matrix start_guess;      /*dim x 1 */
double (*func_to_minimize)();
void (*dfunc_to_minimize)();
{
	matrix p=NULL;
	double fret;
	int iter_num;
	int i;
	int m,n;
	int frprmn();

	m=(ROWS(start_guess)); n=(COLS(start_guess)); 
	if  ((m != dim) || (n!=1)) 
		printerrW("param_min: start_guess bad dimenssion");


	p = copy_mtx(start_guess);


/* Given a starting point P[1..n], Fletcher-Reeves/Polak-Ribiere
minimization is performed on a function func, using its gradient as
calculated by routine dfunc. 
(The routine presumes the existence of a function func(p) where
p[1..n] is a vector of length n, and also presumes the existence of a
function dfunc(p,df) that sets the vector gradient df[1..n] evaluated
at the input point p.)
The convergence tolerance on the function
value is input as ftol. Returned quantities are p (the location of the
minimum), iter (the number of iterations that were performed), and
fret (the minimum value of the function). The routine dlinmin is called
to performed line minimization.
--------------------------------------------------------------- */

	frprmn(p,dim,FTOL,&iter_num,&fret,
		func_to_minimize,dfunc_to_minimize);

	/* printf("iter_num=%d   fret=%lf \n",iter_num,fret); */
	
	return(p);

}


printerrW(s)
char **s;
{
        printf("%s\n",s);
        exit(1);
}
