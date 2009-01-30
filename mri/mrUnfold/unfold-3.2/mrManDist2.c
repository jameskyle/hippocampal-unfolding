/*
   mrManDist2.c

   AUTHOR:  Engel, Wandell
   DATE:    Nov., 1994
   PURPOSE:
   This code is used to create a mex-file for matlab for the routine
   mrManifoldDistance().
   
   The input is an array of sample point coordinates that should form
   a connected manifold in three-space.

   The point of the routine is to compute the distances between a point 
   in three-space and a set of other points in three-space.  The distance
   is measured through the connected space of points. 

   DESCRIPTION:

    dist = mrManDist2(grayNodes,grayEdges,startPt,[noVal],[radius])

   ARGUMENTS:
    startPt:   node index defining where to start the flood fill

   OPTIONAL ARGUMENTS:
    dimdist:Array of y,x and z separations between points.
    noVal:  The value returned for unreached locations (default 0)
    radius: The max distance to flood out
     (default 0 == flood as far as can)

   RETURNS:
    dist:  distances to each point from startPt -- same size as grayM
    nPntsReached:  The number of points reached from the start point.
   

Modifications:
	2/28/03:  PFR changed some conventions for compatibility with matlab 5+
			see specific comments below in code	

*/

#include "mex.h"

#include <stdio.h>
#include <sys/types.h>
#include <ctype.h>
#include <math.h>
/* #include <assert.h>*/
#define assert(arg)

#include "pqueue.h"


#define V4_COMPAT  



/**********************************************************************/

/*
 * Computes distance between two adjacent nodes.
 */
double node_dist(node1, node2, dimdist)
     double	*node1, *node2;
     double	dimdist[3];
{
  double	dist, tmp;

  tmp = (node1[XCOORD]-node2[XCOORD])*dimdist[XCOORD];
  dist = tmp*tmp;

  tmp = (node1[YCOORD]-node2[YCOORD])*dimdist[YCOORD];
  dist += tmp*tmp;

  tmp = (node1[ZCOORD]-node2[ZCOORD])*dimdist[ZCOORD];
  dist += tmp*tmp;

  return( sqrt(dist) );
}

/**********************************************************************/

/*
 * Single source shortest path algorithm (Dijkstra's algorithm).
 */
static int shortest_path(nodeArray, num_nodes, edgeArray, num_edges,
			 start_index, dimdist, radius)
     double	*nodeArray, *edgeArray;
     int	num_nodes, num_edges, start_index;
     double	dimdist[3], radius;
{
  int		i, cnt, num_nbhrs;
  double	*node, *new_node, *nbhrs, new_dist;
  PQueue	*PQ;

  /* Initialize distance to HUGE_VAL. */
  for (i=0, node=&nodeArray[DIST]; i<num_nodes; 
       i++, node+=NUM_ATTRS) *node = HUGE_VAL;

  /* Allocate priority queue and insert start_index as first node. */
  PQ = make_pqueue(num_nodes);
  node = NODEN(nodeArray,start_index-1);
  node[DIST] = 0.0;
  pqueue_insert(PQ, (PQueueNode)node);
  
  /* Dijkstra's algorithm. */
  cnt = 0;
  while (!pqueue_empty_p(PQ)) {
    node = (double *) pqueue_extract_min(PQ);
    node[DIST] = -node[DIST]; 		/* computed */ 
    cnt++;
    
    /* Relax all the neighboring nodes. */
    num_nbhrs = (int) node[NUM_NBHRS];
    nbhrs = &edgeArray[((int)node[NBHRS])-1];
    for (i=0; i<num_nbhrs; i++) {
      new_node = NODEN(nodeArray,((int)nbhrs[i])-1);
      if (new_node[DIST]>=0) {	/* not computed yet */
	/* node[DIST] has been negated a couple of lines above.
	 * so, we need to negate it again to get the actual
	 * (positive) distance. 
	 * -node[DIST] is the distance from our working node
	 * to the start point.  node_dist() is the distance
	 * between our working node and its ith neighbor. */
	new_dist = -node[DIST] + node_dist(node, new_node, dimdist);

	if (new_dist<radius) {
	  /* This is the first time that we've gotten here, we
	   * use this new distance and add the node into the
	   * priority queue. */
	  if (new_node[DIST]==HUGE_VAL) {
	    new_node[DIST] = new_dist;
	    pqueue_insert(PQ, (PQueueNode)new_node);
	  } 
	  /* Otherwise, if the new distance is less than
	   * the previously computed distance, then we pick
	   * the new (shorter) distance and adjust its
	   * position in the priority queue. */
	  else {
	    if (new_dist<new_node[DIST]) {
	      new_node[DIST] = new_dist;
	      pqueue_deckey(PQ, (PQueueNode)new_node);
	    }
	  }
	}
      }
    }
  }
  free_pqueue(PQ);

  return(cnt);
}

/**********************************************************************/

/* PFR
replace this with below mexfunctoin
void mexFunction(int nlhs,		  //# arguments on lhs 
		 Matrix	*plhs[], 	// Matrices on lhs 
		 int nrhs,		 //# arguments on rhs 
		 Matrix	*prhs[]		// Matrices on rhs 
		 )

*/

void
mexFunction( int nlhs, mxArray *plhs[],
	     int nrhs, const mxArray *prhs[] )

{
  double *dist, *nodeArray, *edgeArray, *nPointsReached, *tmp;
  double dimdist[3], num_dist, radius, nuldist;
  int	 num_nodes, num_edges, start_index, count, i;

  /* Check for proper number of arguments */
  if (nrhs == 0) {
       mexErrMsgTxt("[dist nPntsReached] = mrManDist2(grayNodes,grayEdges,startPt,[noVal],[radius])\n");
  } else {

    /* Create space for return arguments on the lhs */

    /* The size of dist is equal to the size of grayNodes */

/***** ***********************************************
PFR 12/20/02
replaced    plhs[0] = mxCreateFull(1,mxGetN(prhs[0]),mxREAL);
****  ******************************** */
    plhs[0] = mxCreateDoubleMatrix(1,mxGetN(prhs[0]),mxREAL);
    dist = mxGetPr(plhs[0]);

    /* Interpret the input arguments on the rhs */
    if (nrhs < 3) {
      mexErrMsgTxt("mrManDist2: At least three arguments are needed.");
    }
    
    /* Arg 1.  'nodes' */
    nodeArray = mxGetPr(prhs[0]);
    num_nodes = mxGetN(prhs[0]);
    assert(mxGetM(prhs[0])==8);

    /* Arg 2.  'edges' */
    edgeArray = mxGetPr(prhs[1]);
    num_edges = mxGetN(prhs[1]);
    assert(mxGetM(prhs[1])==1);

    /* Arg 3.  'start_index' */
    tmp = mxGetPr(prhs[2]);
    start_index = (int) tmp[0];

    /* Analyze the optional arguments */

    /* Arg 4.  Figure out the distances in and between planes. */
    if (nrhs < 4) {
      dimdist[0] = YSEPARATION;
      dimdist[1] = XSEPARATION;
      dimdist[2] = ZSEPARATION;
    }
    else {
      tmp = mxGetPr(prhs[3]);
      dimdist[0] = tmp[0]; /* x, y, z distances */
      dimdist[1] = tmp[1];
      dimdist[2] = tmp[2];
    }

    /* Arg 5.  Choose the default value when points are unreached. */
    if (nrhs < 5) {
      nuldist = POINT_UNREACHED;
    }
    else {
      tmp = mxGetPr(prhs[4]);
      nuldist = tmp[0];
    }

    /* Arg 6.   'radius' */
    if (nrhs >= 6) {
      tmp = mxGetPr(prhs[5]);
      radius = tmp[0];
    }
    else {
      radius = HUGE_VAL;
    }
    /* mexPrintf("radius:  %d\n",radius);*/

    /* Compute shortest path distances. */
    count = shortest_path(nodeArray, num_nodes,
			  edgeArray, num_edges,
			  start_index, dimdist, radius);
    /* mexPrintf("count:  %d\n",count);*/

    /* Copy distances to output. */
    for (i=0, tmp=&nodeArray[DIST]; i<num_nodes; i++, tmp+=NUM_ATTRS)
      dist[i] = (*tmp==HUGE_VAL) ? nuldist : -(*tmp);

    if (nlhs>1) {

/*PFR 12/20/02
replaced       plhs[1] = mxCreateFull(1,1,mxREAL);
*/
      plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
      nPointsReached = mxGetPr(plhs[1]);
      *nPointsReached = (double) count;
      /* mexPrintf("count:  %f\n", *nPointsReached);*/
    }
  }
}


