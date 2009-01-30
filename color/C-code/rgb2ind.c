/*
 * rgb2ind.c  -  contains the 24-to-8-bit Conv24to8 procedure
 *
 * The Conv24to8 procedure takes a pointer to a 24-bit image (loaded
 * previously).  The image will be a w * h * 3 byte array of
 * bytes.  The image will be arranged with 3 bytes per pixel (in order
 * R, G, and B), pixel 0 at the top left corner.  (As normal.)
 * The procedure also takes a maximum number of colors to use (numcols)
 *
 * The Conv24to8 procedure will set up the following:  it will allocate and
 * create 'pic', a pWIDE*pHIGH 8-bit picture.  it will set up pWIDE and pHIGH.
 * it will load up the r[], g[], and b[] colormap arrays.  it will NOT 
 * calculate numcols, since the cmap sort procedure has to be called anyway
 *
 * Conv24to8 returns '0' if successful, '1' if it failed (presumably on a 
 * malloc())
 *
 * contains:
 *   Cont24to8()
 */

/*
 * Copyright 1989, 1990 by the University of Pennsylvania
 *
 * Permission to use, copy, and distribute for non-commercial purposes,
 * is hereby granted without fee, providing that the above copyright
 * notice appear in all copies and that both the copyright notice and this
 * permission notice appear in supporting documentation.
 *
 * The software may be modified for your own purposes, but modified versions
 * may not be distributed.
 *
 * This software is provided "as is" without any express or implied warranty.
 */

#include <stdio.h>
#include <math.h>
#include "mex.h"

typedef unsigned char byte;

/* RANGE forces a to be in the range b..c (inclusive) */
#define RANGE(a,b,c) { if (a < b) a = b;  if (a > c) a = c; }

#define	MAX_CMAP_SIZE	256
#define	COLOR_DEPTH	8
#define	MAX_COLOR	256
#define	B_DEPTH		5		/* # bits/pixel to use */
#define	B_LEN		(1<<B_DEPTH)
#define	C_DEPTH		2
#define	C_LEN		(1<<C_DEPTH)	/* # cells/color to use */

typedef	struct colorbox {
  struct colorbox *next, *prev;
  int              rmin,rmax, gmin,gmax, bmin,bmax;
  int              total;
} CBOX;

typedef struct {
  int num_ents;
  int entries[MAX_CMAP_SIZE][2];
} CCELL;

/* global vars from .h file*/
static byte           *pic;                   /* ptr to 8-bit picture */
static unsigned int   pWIDE,pHIGH;           /* size of 'pic' */
static byte           r[256],g[256],b[256];  /* colormap */

static byte *pic24;
static int   num_colors, WIDE, HIGH;
static int   histogram[B_LEN][B_LEN][B_LEN];

CBOX   *freeboxes, *usedboxes;
CCELL **ColorCells;

static void   get_histogram();
static CBOX  *largest_box();
static void   splitbox();
static void   shrinkbox();
static void   assign_color();
static CCELL *create_colorcell();
static void   map_colortable();
static int    quant_fsdither();
static int    QuickCheck();



/****************************/
void mexFunction(int nlhs,   /* number of arguments on lhs */
                 Matrix *plhs[],   /* Matrices on lhs      */
                 int nrhs,         /* no. of mat on rhs    */
                 Matrix *prhs[]    /* Matrices on rhs      */
                 )
/****************************/
/*
mexFunction(nlhs, plhs, nrhs, prhs)
int nlhs;
Matrix *plhs[];
int nrhs;
Matrix *prhs[];
*/
{
  int localh, localw, local_no_colors;
  double *localr, *localg, *localb;
  byte *localp;
  int localM, localN;
  int localMtN;
  int i,j,k;
  double *localX, *localmap, *local_ncolors;

  /* convert from matlab matrix (3 or 1) into one long vector */
  localh = mxGetM(prhs[0]);
  localw = mxGetN(prhs[0]);
  localr = mxGetPr(prhs[0]);
  localg = mxGetPr(prhs[1]);
  localb = mxGetPr(prhs[2]);
  if (nrhs>3){
      local_ncolors = (double *) mxGetPr(prhs[3]);
      local_no_colors = (int) *local_ncolors;
  }
  else
      local_no_colors = 256;

  /* create input matrix for Conv24to8 */
  localM = localh;
  localN = localw;
  localp = (byte *) mxCalloc(localw * localh * 3,1);
  localMtN = localM*localN;
  for(i=0, k=0; i<localM; i++)
    for(j=0; j<localN; k+=3, j++)
    {
      localp[k+0] = (byte) (localr[j*localM+i] * 255.0);
      localp[k+1] = (byte) (localg[j*localM+i] * 255.0);
      localp[k+2] = (byte) (localb[j*localM+i] * 255.0);
    }


  /* do the error diffusion */
  Conv24to8(localp, localw, localh, local_no_colors);
  /* free localp */
  mxFree(localp);
  /* convert back to matlab */

  /* first create the target matrices */
  plhs[0] = mxCreateFull(localM, localN, REAL);
  localX = mxGetPr(plhs[0]);
  plhs[1] = mxCreateFull(local_no_colors,3,REAL);
  localmap = mxGetPr(plhs[1]);

  /* first convert the map from r[] g[] b[] to a single matlab style map */
  for(i = 0; i < local_no_colors; i++) {
    localmap[i] = (double) r[i];
    localmap[i] /= 256;
    localmap[i+local_no_colors] = (double) g[i];
    localmap[i+local_no_colors] /= 256;
    localmap[i+2*local_no_colors] = (double) b[i];
    localmap[i+2*local_no_colors] /= 256;
  }
  
  /* then recreate localX */
  for(i=0, k=0; i<localM; i++)
    for(j=0; j<localN; k++, j++)
      localX[j*localM+i] = (double) (1+pic[k]);


}


/****************************/
int Conv24to8(p,w,h,nc)
/****************************/
byte *p;
int   w,h,nc;
{
  int   i;
  CBOX *box_list, *ptr;

  /* copy arguments to local-global variables */
  pic24 = p;  pWIDE = WIDE = w;  pHIGH = HIGH = h;  num_colors = nc;


  /* allocate pic immediately, so that if we can't allocate it, we don't
     waste time running this algorithm */

  pic = (byte *) mxCalloc(WIDE * HIGH,1);
  if (pic == NULL) {
    mexErrMsgTxt("rgb2ind: Conv24to8() - failed to allocate 'pic'\n");
    return(1);
  }


  if (QuickCheck(pic24,w,h,nc)) { 
    return 0;   
  }
  else 
    mexPrintf("Doing full 24-bit to 8-bit conversion.\n");


  /**** STEP 1:  create empty boxes ****/

  usedboxes = NULL;
  box_list = freeboxes = (CBOX *) mxCalloc(num_colors,sizeof(CBOX));

  if (box_list == NULL) {
    mexErrMsgTxt("rgb2ind: Conv24to8() - failed to allocate 'freeboxes'\n");
    return(1);
  }

  for (i=0; i<num_colors; i++) {
    freeboxes[i].next = &freeboxes[i+1];
    freeboxes[i].prev = &freeboxes[i-1];
  }
  freeboxes[0].prev = NULL;
  freeboxes[num_colors-1].next = NULL;


  /**** STEP 2: get histogram, initialize first box ****/

  ptr = freeboxes;
  freeboxes = ptr->next;
  if (freeboxes) freeboxes->prev = NULL;

  ptr->next = usedboxes;
  usedboxes = ptr;
  if (ptr->next) ptr->next->prev = ptr;
	
  get_histogram(ptr);


  /**** STEP 3: continually subdivide boxes until no more free boxes remain */

  while (freeboxes) {
    ptr = largest_box();
    if (ptr) splitbox(ptr);
    else break;
  }

  
  /**** STEP 4: assign colors to all boxes ****/

  for (i=0, ptr=usedboxes; i<num_colors && ptr; i++, ptr=ptr->next) {
    assign_color(ptr, &r[i], &g[i], &b[i]);
  }

  /* We're done with the boxes now */
  num_colors = i;
  mxFree(box_list);
  box_list = freeboxes = usedboxes = NULL;
 

  /**** STEP 5: scan histogram and map all values to closest color */

  /* 5a: create cell list as described in Heckbert[2] */

  ColorCells = (CCELL **) mxCalloc(C_LEN*C_LEN*C_LEN, sizeof(CCELL *));


  /* 5b: create mapping from truncated pixel space to color table entries */

  map_colortable();


  /**** STEP 6: scan image, match input values to table entries */

  i=quant_fsdither();

  /* free everything that can be freed */
  mxFree(ColorCells);

  return i;
}


/****************************/
static void get_histogram(box)
     CBOX *box;
/****************************/
{
  int   i,j,r,g,b,*ptr;
  byte *p;

  box->rmin = box->gmin = box->bmin = 999;
  box->rmax = box->gmax = box->bmax = -1;
  box->total = WIDE * HIGH;

  /* zero out histogram */
  ptr = &histogram[0][0][0];
  for (i=B_LEN*B_LEN*B_LEN; i>0; i-- )  *ptr++ = 0;

  /* calculate histogram */
  p = pic24;
  for (i=0; i<HIGH; i++)
    for (j=0; j<WIDE; j++) {
      r = (*p++) >> (COLOR_DEPTH-B_DEPTH);
      g = (*p++) >> (COLOR_DEPTH-B_DEPTH);
      b = (*p++) >> (COLOR_DEPTH-B_DEPTH);

      if (r < box->rmin) box->rmin = r;
      if (r > box->rmax) box->rmax = r;

      if (g < box->gmin) box->gmin = g;
      if (g > box->gmax) box->gmax = g;

      if (b < box->bmin) box->bmin = b;
      if (b > box->bmax) box->bmax = b;
      histogram[r][g][b]++;
    }
}



/******************************/
static CBOX *largest_box()
/******************************/
{
  CBOX *tmp, *ptr;
  int   size = -1;

  tmp = usedboxes;
  ptr = NULL;

  while (tmp) {
    if ( (tmp->rmax > tmp->rmin  ||
	  tmp->gmax > tmp->gmin  ||
	  tmp->bmax > tmp->bmin)  &&  tmp->total > size ) {
      ptr = tmp;
      size = tmp->total;
    }
    tmp = tmp->next;
  }
  return(ptr);
}



/******************************/
static void splitbox(ptr)
     CBOX *ptr;
/******************************/
{
  int   hist2[B_LEN], first, last, i, rdel, gdel, bdel;
  CBOX *new;
  int  *iptr, *histp, ir, ig, ib;
  int  rmin,rmax,gmin,gmax,bmin,bmax;
  enum {RED,GREEN,BLUE} which;

  /*
   * see which axis is the largest, do a histogram along that
   * axis.  Split at median point.  Contract both new boxes to
   * fit points and return
   */

  first = last = 0;   /* shut RT hcc compiler up */

  rmin = ptr->rmin;  rmax = ptr->rmax;
  gmin = ptr->gmin;  gmax = ptr->gmax;
  bmin = ptr->bmin;  bmax = ptr->bmax;

  rdel = rmax - rmin;
  gdel = gmax - gmin;
  bdel = bmax - bmin;

  if      (rdel>=gdel && rdel>=bdel) which = RED;
  else if (gdel>=bdel)               which = GREEN;
  else                               which = BLUE;

  /* get histogram along longest axis */
  switch (which) {

  case RED:
    histp = &hist2[rmin];
    for (ir=rmin; ir<=rmax; ir++) {
      *histp = 0;
      for (ig=gmin; ig<=gmax; ig++) {
	iptr = &histogram[ir][ig][bmin];
	for (ib=bmin; ib<=bmax; ib++) {
	  *histp += *iptr;
	  ++iptr;
	}
      }
      ++histp;
    }
    first = rmin;  last = rmax;
    break;

  case GREEN:
    histp = &hist2[gmin];
    for (ig=gmin; ig<=gmax; ig++) {
      *histp = 0;
      for (ir=rmin; ir<=rmax; ir++) {
	iptr = &histogram[ir][ig][bmin];
	for (ib=bmin; ib<=bmax; ib++) {
	  *histp += *iptr;
	  ++iptr;
	}
      }
      ++histp;
    }
    first = gmin;  last = gmax;
    break;

  case BLUE:
    histp = &hist2[bmin];
    for (ib=bmin; ib<=bmax; ib++) {
      *histp = 0;
      for (ir=rmin; ir<=rmax; ir++) {
	iptr = &histogram[ir][gmin][ib];
	for (ig=gmin; ig<=gmax; ig++) {
	  *histp += *iptr;
	  iptr += B_LEN;
	}
      }
      ++histp;
    }
    first = bmin;  last = bmax;
    break;
  }


  /* find median point */
  {
    int sum, sum2;

    histp = &hist2[first];

    sum2 = ptr->total/2;
    histp = &hist2[first];
    sum = 0;
        
    for (i=first; i<=last && (sum += *histp++)<sum2; i++);
    if (i==first) i++;
  }


  /* Create new box, re-allocate points */
  
  new = freeboxes;
  freeboxes = new->next;
  if (freeboxes) freeboxes->prev = NULL;

  if (usedboxes) usedboxes->prev = new;
  new->next = usedboxes;
  usedboxes = new;

  {
    int sum1,sum2,j;
    
    histp = &hist2[first];
    sum1 = 0;
    for (j = first; j < i; ++j) sum1 += *histp++;
    sum2 = 0;
    for (j = i; j <= last; ++j) sum2 += *histp++;
    new->total = sum1;
    ptr->total = sum2;
  }


  new->rmin = rmin;  new->rmax = rmax;
  new->gmin = gmin;  new->gmax = gmax;
  new->bmin = bmin;  new->bmax = bmax;

  switch (which) {
  case RED:    new->rmax = i-1;  ptr->rmin = i;  break;
  case GREEN:  new->gmax = i-1;  ptr->gmin = i;  break;
  case BLUE:   new->bmax = i-1;  ptr->bmin = i;  break;
  }

  shrinkbox(new);
  shrinkbox(ptr);
}


/****************************/
static void shrinkbox(box)
     CBOX *box;
/****************************/
{
  int *histp,ir,ig,ib;
  int  rmin,rmax,gmin,gmax,bmin,bmax;

  rmin = box->rmin;  rmax = box->rmax;
  gmin = box->gmin;  gmax = box->gmax;
  bmin = box->bmin;  bmax = box->bmax;

  if (rmax>rmin) {
    for (ir=rmin; ir<=rmax; ir++)
      for (ig=gmin; ig<=gmax; ig++) {
	histp = &histogram[ir][ig][bmin];
	for (ib=bmin; ib<=bmax; ib++)
	  if (*histp++ != 0) {
	    box->rmin = rmin = ir;
	    goto have_rmin;
	  }
      }

  have_rmin:
    if (rmax>rmin)
      for (ir=rmax; ir>=rmin; --ir)
	for (ig=gmin; ig<=gmax; ig++) {
	  histp = &histogram[ir][ig][bmin];
	  for (ib=bmin; ib<=bmax; ib++)
	    if (*histp++ != 0) {
	      box->rmax = rmax = ir;
	      goto have_rmax;
	    }
	}
  }


 have_rmax:

  if (gmax>gmin) {
    for (ig=gmin; ig<=gmax; ig++)
      for (ir=rmin; ir<=rmax; ir++) {
	histp = &histogram[ir][ig][bmin];
	for (ib=bmin; ib<=bmax; ib++)
	  if (*histp++ != 0) {
	    box->gmin = gmin = ig;
	    goto have_gmin;
	  }
      }
  have_gmin:
    if (gmax>gmin)
      for (ig=gmax; ig>=gmin; --ig)
	for (ir=rmin; ir<=rmax; ir++) {
	  histp = &histogram[ir][ig][bmin];
	  for (ib=bmin; ib<=bmax; ib++)
	    if (*histp++ != 0) {
	      box->gmax = gmax = ig;
	      goto have_gmax;
	    }
	}
  }


 have_gmax:

  if (bmax>bmin) {
    for (ib=bmin; ib<=bmax; ib++)
      for (ir=rmin; ir<=rmax; ir++) {
	histp = &histogram[ir][gmin][ib];
	for (ig=gmin; ig<=gmax; ig++) {
	  if (*histp != 0) {
	    box->bmin = bmin = ib;
	    goto have_bmin;
	  }
	  histp += B_LEN;
	}
      }
  have_bmin:
    if (bmax>bmin)
      for (ib=bmax; ib>=bmin; --ib)
	for (ir=rmin; ir<=rmax; ir++) {
	  histp = &histogram[ir][gmin][ib];
	  for (ig=gmin; ig<=gmax; ig++) {
	    if (*histp != 0) {
	      bmax = ib;
	      goto have_bmax;
	    }
	    histp += B_LEN;
	  }
	}
  }

 have_bmax: return;
}



/*******************************/
static void assign_color(ptr,rp,gp,bp)
     CBOX *ptr;
     byte *rp,*gp,*bp;
/*******************************/
{
  *rp = ((ptr->rmin + ptr->rmax) << (COLOR_DEPTH - B_DEPTH)) / 2;
  *gp = ((ptr->gmin + ptr->gmax) << (COLOR_DEPTH - B_DEPTH)) / 2;
  *bp = ((ptr->bmin + ptr->bmax) << (COLOR_DEPTH - B_DEPTH)) / 2;
}



/*******************************/
static CCELL *create_colorcell(r1,g1,b1)
     int r1,g1,b1;
/*******************************/
{
  register int    i,tmp, dist;
  register CCELL *ptr;
  register byte  *rp,*gp,*bp;
  int             ir,ig,ib, mindist;

  ir = r1 >> (COLOR_DEPTH-C_DEPTH);
  ig = g1 >> (COLOR_DEPTH-C_DEPTH);
  ib = b1 >> (COLOR_DEPTH-C_DEPTH);

  r1 &= ~1 << (COLOR_DEPTH-C_DEPTH);
  g1 &= ~1 << (COLOR_DEPTH-C_DEPTH);
  b1 &= ~1 << (COLOR_DEPTH-C_DEPTH);

  ptr = (CCELL *) mxCalloc(1,sizeof(CCELL));
  *(ColorCells + ir*C_LEN*C_LEN + ig*C_LEN + ib) = ptr;
  ptr->num_ents = 0;

  /* step 1: find all colors inside this cell, while we're at
     it, find distance of centermost point to furthest
     corner */

  mindist = 99999999;

  rp=r;  gp=g;  bp=b;
  for (i=0; i<num_colors; i++,rp++,gp++,bp++)
    if( *rp>>(COLOR_DEPTH-C_DEPTH) == ir  &&
        *gp>>(COLOR_DEPTH-C_DEPTH) == ig  &&
        *bp>>(COLOR_DEPTH-C_DEPTH) == ib) {

      ptr->entries[ptr->num_ents][0] = i;
      ptr->entries[ptr->num_ents][1] = 0;
      ++ptr->num_ents;

      tmp = *rp - r1;
      if (tmp < (MAX_COLOR/C_LEN/2)) tmp = MAX_COLOR/C_LEN-1 - tmp;
      dist = tmp*tmp;

      tmp = *gp - g1;
      if (tmp < (MAX_COLOR/C_LEN/2)) tmp = MAX_COLOR/C_LEN-1 - tmp;
      dist += tmp*tmp;

      tmp = *bp - b1;
      if (tmp < (MAX_COLOR/C_LEN/2)) tmp = MAX_COLOR/C_LEN-1 - tmp;
      dist += tmp*tmp;

      if (dist < mindist) mindist = dist;
    }


  /* step 3: find all points within that distance to box */

  rp=r;  gp=g;  bp=b;
  for (i=0; i<num_colors; i++,rp++,gp++,bp++)
    if (*rp >> (COLOR_DEPTH-C_DEPTH) != ir  ||
	*gp >> (COLOR_DEPTH-C_DEPTH) != ig  ||
	*bp >> (COLOR_DEPTH-C_DEPTH) != ib) {

      dist = 0;

      if ((tmp = r1 - *rp)>0 || (tmp = *rp - (r1 + MAX_COLOR/C_LEN-1)) > 0 )
	dist += tmp*tmp;

      if( (tmp = g1 - *gp)>0 || (tmp = *gp - (g1 + MAX_COLOR/C_LEN-1)) > 0 )
	dist += tmp*tmp;

      if( (tmp = b1 - *bp)>0 || (tmp = *bp - (b1 + MAX_COLOR/C_LEN-1)) > 0 )
	dist += tmp*tmp;

      if( dist < mindist ) {
	ptr->entries[ptr->num_ents][0] = i;
	ptr->entries[ptr->num_ents][1] = dist;
	++ptr->num_ents;
      }
    }


  /* sort color cells by distance, use cheap exchange sort */
  {
    int n, next_n;

    n = ptr->num_ents - 1;
    while (n>0) {
      next_n = 0;
      for (i=0; i<n; ++i) {
	if (ptr->entries[i][1] > ptr->entries[i+1][1]) {
	  tmp = ptr->entries[i][0];
	  ptr->entries[i][0] = ptr->entries[i+1][0];
	  ptr->entries[i+1][0] = tmp;
	  tmp = ptr->entries[i][1];
	  ptr->entries[i][1] = ptr->entries[i+1][1];
	  ptr->entries[i+1][1] = tmp;
	  next_n = i;
	}
      }
      n = next_n;
    }
  }
  return (ptr);
}




/***************************/
static void map_colortable()
/***************************/
{
  int    ir,ig,ib, *histp;
  CCELL *cell;

  histp  = &histogram[0][0][0];
  for (ir=0; ir<B_LEN; ir++)
    for (ig=0; ig<B_LEN; ig++)
      for (ib=0; ib<B_LEN; ib++) {
	if (*histp==0) *histp = -1;
	else {
	  int	i, j, tmp, d2, dist;
	  
	  cell = *(ColorCells +
		   ( ((ir>>(B_DEPTH-C_DEPTH)) << C_DEPTH*2)
		   + ((ig>>(B_DEPTH-C_DEPTH)) << C_DEPTH)
		   +  (ib>>(B_DEPTH-C_DEPTH)) ) );
		
	  if (cell==NULL)
	    cell = create_colorcell(ir<<(COLOR_DEPTH-B_DEPTH),
				    ig<<(COLOR_DEPTH-B_DEPTH),
				    ib<<(COLOR_DEPTH-B_DEPTH));

	  dist = 9999999;
	  for (i=0; i<cell->num_ents && dist>cell->entries[i][1]; i++) {
	    j = cell->entries[i][0];
	    d2 = r[j] - (ir << (COLOR_DEPTH-B_DEPTH));
	    d2 *= d2;
	    tmp = g[j] - (ig << (COLOR_DEPTH-B_DEPTH));
	    d2 += tmp*tmp;
	    tmp = b[j] - (ib << (COLOR_DEPTH-B_DEPTH));
	    d2 += tmp*tmp;
	    if( d2 < dist ) { dist = d2;  *histp = j; }
	  }
	}
	histp++;
      }
}



/*****************************/
static int quant_fsdither()
/*****************************/
{
  register int  *thisptr, *nextptr;
  int           *thisline, *nextline, *tmpptr;
  int            r1, g1, b1, r2, g2, b2;
  int            i, j, imax, jmax, oval;
  byte          *inptr, *outptr, *tmpbptr;
  int            lastline, lastpixel;

  imax = HIGH - 1;
  jmax = WIDE - 1;
  
  thisline = (int *) mxCalloc(WIDE * 3 , sizeof(int));
  nextline = (int *) mxCalloc(WIDE * 3 , sizeof(int));

  if (thisline == NULL || nextline == NULL) {
    mexErrMsgTxt("rgb2ind: unable to allocate stuff for the 'dither' routine\n");
    return 1;
  }


  inptr  = (byte *) pic24;
  outptr = (byte *) pic;

  /* get first line of picture */
  for (j=WIDE * 3, tmpptr=nextline, tmpbptr=inptr; j; j--) 
    *tmpptr++ = (int) *tmpbptr++;

  for (i=0; i<HIGH; i++) {
    /* swap thisline and nextline */
    tmpptr = thisline;  thisline = nextline;  nextline = tmpptr;
    lastline = (i==imax);

    /* read in next line */
    for (j=WIDE * 3, tmpptr=nextline; j; j--) 
      *tmpptr++ = (int) *inptr++;

    /* dither this line and put it into the output picture */
    thisptr = thisline;  nextptr = nextline;

    for (j=0; j<WIDE; j++) {
      lastpixel = (j==jmax);

      r2 = *thisptr++;  g2 = *thisptr++;  b2 = *thisptr++;

      if (r2<0) r2=0;  else if (r2>=MAX_COLOR) r2=MAX_COLOR-1;
      if (g2<0) g2=0;  else if (g2>=MAX_COLOR) g2=MAX_COLOR-1;
      if (b2<0) b2=0;  else if (b2>=MAX_COLOR) b2=MAX_COLOR-1;

      r1 = r2;  g1 = g2;  b1 = b2;

      r2 >>= (COLOR_DEPTH-B_DEPTH);
      g2 >>= (COLOR_DEPTH-B_DEPTH);
      b2 >>= (COLOR_DEPTH-B_DEPTH);

      if ( (oval=histogram[r2][g2][b2]) == -1) {
	int ci, cj, dist, d2, tmp;
	CCELL *cell;

	cell = *( ColorCells + 
		( ((r2>>(B_DEPTH-C_DEPTH)) << C_DEPTH*2)
	        + ((g2>>(B_DEPTH-C_DEPTH)) << C_DEPTH )
		+  (b2>>(B_DEPTH-C_DEPTH)) ) );
	      
	if (cell==NULL) cell = create_colorcell(r1,g1,b1);

	dist = 9999999;
	for (ci=0; ci<cell->num_ents && dist>cell->entries[ci][1]; ci++) {
	  cj = cell->entries[ci][0];
	  d2 = (r[cj] >> (COLOR_DEPTH-B_DEPTH)) - r2;
	  d2 *= d2;
	  tmp = (g[cj] >> (COLOR_DEPTH-B_DEPTH)) - g2;
	  d2 += tmp*tmp;
	  tmp = (b[cj] >> (COLOR_DEPTH-B_DEPTH)) - b2;
	  d2 += tmp*tmp;
	  if (d2<dist) { dist = d2;  oval = cj; }
	}
	histogram[r2][g2][b2] = oval;
      }

      *outptr++ = oval;

      r1 -= r[oval];  g1 -= g[oval];  b1 -= b[oval];
      /* can't use tables because r1,g1,b1 go negative */

      if (!lastpixel) {
	thisptr[0] += (r1*7)/16;
	thisptr[1] += (g1*7)/16;
	thisptr[2] += (b1*7)/16;
      }

      if (!lastline) {
	if (j) {
	  nextptr[-3] += (r1*3)/16;
	  nextptr[-2] += (g1*3)/16;
	  nextptr[-1] += (b1*3)/16;
	}

	nextptr[0] += (r1*5)/16;
	nextptr[1] += (g1*5)/16;
	nextptr[2] += (b1*5)/16;

	if (!lastpixel) {
	  nextptr[3] += r1/16;
	  nextptr[4] += g1/16;
	  nextptr[5] += b1/16;
	}
	nextptr += 3;
      }
    }
  }
  mxFree(thisline);  mxFree(nextline);
  return 0;
}




/****************************/
static int QuickCheck(pic24,w,h,maxcol)
byte *pic24;
int   w,h,maxcol;
{
  /* scans picture until it finds more than 'maxcol' different colors.  If it
     finds more than 'maxcol' colors, it returns '0'.  If it DOESN'T, it does
     the 24-to-8 conversion by simply sticking the colors it found into
     a colormap, and changing instances of a color in pic24 into colormap
     indicies (in pic) */

  unsigned long colors[256],col;
  int           i, nc, low, high, mid;
  byte         *p, *pix;

  if (maxcol>256) maxcol = 256;

  /* put the first color in the table by hand */
  nc = 0;  mid = 0;  

  for (i=w*h,p=pic24; i; i--) {
    col  = (*p++ << 16);  
    col += (*p++ << 8);
    col +=  *p++;

    /* binary search the 'colors' array to see if it's in there */
    low = 0;  high = nc-1;
    while (low <= high) {
      mid = (low+high)/2;
      if      (col < colors[mid]) high = mid - 1;
      else if (col > colors[mid]) low  = mid + 1;
      else break;
    }

    if (high < low) { /* didn't find color in list, add it. */
      /* WARNING: this is an overlapped memory copy.  memcpy doesn't do
	 it correctly, hence 'bcopy', which claims to */
      if (nc>=maxcol) return 0;
/*      mexPrintf("adding color %i %i %i\n",
		(colors[i]>>16),((colors[i]>>8) & 0xff),(colors[i] & 0xff));
*/
      bcopy(&colors[low], &colors[low+1], (nc - low) * sizeof(unsigned long));
      colors[low] = col;
      nc++;
    }
  }


  /* run through the data a second time, this time mapping pixel values in
     pic24 into colormap offsets into 'colors' */

  for (i=w*h,p=pic24, pix=pic; i; i--,pix++) {
    col  = (*p++ << 16);  
    col += (*p++ << 8);
    col +=  *p++;

    /* binary search the 'colors' array.  It *IS* in there */
    low = 0;  high = nc-1;
    while (low <= high) {
      mid = (low+high)/2;
      if      (col < colors[mid]) high = mid - 1;
      else if (col > colors[mid]) low  = mid + 1;
      else break;
    }

    if (high < low) {
      mexErrMsgTxt("rgb2ind: QuickCheck:  impossible!\n");
    }
    *pix = mid;
  }

  /* and load up the 'desired colormap' */
  for (i=0; i<nc; i++) {
    r[i] =  colors[i]>>16;  
    g[i] = (colors[i]>>8) & 0xff;
    b[i] =  colors[i]     & 0xff;
  }

  return 1;
}
