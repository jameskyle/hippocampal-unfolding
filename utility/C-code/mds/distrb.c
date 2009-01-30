#include <stdio.h>
#include <math.h>
#define  BIG   2147483647.0
#define  ADDS   30
#define  SEED  21

#ifdef HPUX
#define random lrand48
#define srandom srand48
#endif


/*
 this function returs a gaussian noise N(AV,SIGMA)
___________________________________________________ */

double gss_distr(av,sigma)
double av,sigma ;
{
  double sum,y ;
  int i ;
  static int  entr=0 ;


  if (entr == 0) {
    srandom(SEED);
    entr = 1;
  }

  sum = 0.0 ; 

  for(i=0;i<ADDS;i++) {
    sum+=2.0*(double)random()/BIG-1.0;
  }

  y=sum/sqrt((double)(ADDS/3.0));
  return(sigma*y + av) ;
}


/*
 this function returns a uniform random noise U(LBOUND,HBOUND) 
----------------------------------------------------------------- */

double unif_distr(lb,hb)
double lb,hb ;
{
	static int  entr=0 ;
	if (entr == 0) {
		srandom(SEED);
		entr = 1;
	}


	if (lb>hb) printerr("ERROR in unif_distr: lb>hb.") ;
		
	return((double)random()/BIG*(hb-lb)+lb) ;
}
