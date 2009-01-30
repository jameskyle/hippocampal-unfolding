#ifndef _nmds_h_
#define _nmds_h_

#include <matrix.h>

#define MAX_PAIRS 5000

typedef struct  pair {
	int point_from,point_to;
	double dist;
	} Pair;

typedef struct node {
	Pair pair;
	struct node *small,*big;
	} Node;

#define fromPoint(p)  ((p)->pair.point_from)
#define toPoint(p)    ((p)->pair.point_to)
#define distPoints(p) ((p)->pair.dist)
#define smallPoint(p) ((p)->small)
#define bigPoint(p)   ((p)->big)

typedef struct block {
	int from,to,units;
	double sum,val;
	struct block *next,*prev;
	} Block;

#define blockFrom(p)	((p)->from)  
#define blockTo(p)	((p)->to)    
#define blockUnits(p)	((p)->units) 
#define blockSum(p)	((p)->sum) 
#define blockVal(p)	((p)->val) 
#define blockNext(p)	((p)->next)    
#define blockPrev(p)	((p)->prev) 


matrix non_metric_mds(int dim,int pointNum,matrix firstGuess,matrix prox,
	double (*func_to_minimize)(),void (*dfunc_to_minimize)());

#endif