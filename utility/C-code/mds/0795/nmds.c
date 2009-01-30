#include <stdio.h>
#include <min_func.h>
#include <math.h>
#include "mds.h"
#include "nmds.h"

#define SIGN(x)   ( (x)>=0.0 ? (1) : (-1) )

Pair sorted_list[5000];

#define sl_from(i)	sorted_list[i].point_from
#define sl_to(i)	sorted_list[i].point_to
#define sl_dist(i)	sorted_list[i].dist

/*  sort delta values into sorted_list array
______________________________________________*/
int sort_dim_delta(matrix delta,int pointNum)
{
	int i,j;
	int from,to,pair_no;
	double dist;
	Node *tree=NULL,*elm=NULL,*alloc_node();

	for (i=1; i<=pointNum; i++)
		for (j=i+1; j<=pointNum; j++) {
			if (delta[i][j] > 0.0) {
				from = i;
				to = j;
				dist = delta[i][j];
			}
			else {
				from = j;
				to = i;
				dist = delta[i][j];
			}
			if (dist != LARGE_COEFF) {
				elm = alloc_node(dist,from,to);
				insert_node(&tree,dist,from,to,elm);
			}
		}
	pair_no = built_sorted_list(tree);
	free_tree(tree);
	return(pair_no);
}



/* alloc a node and insert the data into it
__________________________________________________*/
Node *alloc_node(double dist,int from,int to)
{
	Node *new_node;

	new_node = (Node *) calloc (1,sizeof(Node));
	fromPoint(new_node) = from;
	toPoint(new_node) = to;
	distPoints(new_node) = dist;
	smallPoint(new_node) = NULL;
	bigPoint(new_node) = NULL; 
	
	return(new_node);
}



/* insert a new node into the sorted tree "tree"
__________________________________________________*/
insert_node(Node **tree,double dist,int from,int to, Node *elm)
{

        double thresh = 0.01;

	if ((*tree) == NULL) *tree = elm;
	else 

		if ( dist < distPoints(*tree) )  
			insert_node( &(smallPoint(*tree)),dist,from,to,elm);
		else  insert_node( &(bigPoint(*tree)),dist,from,to,elm);

}



free_tree(Node *tree)
{
	if (tree == NULL) return;
	 
	free_tree(smallPoint(tree));
	free_tree(bigPoint(tree));
	free(tree);
}
	
/* built the sorted_list according to the dist values 
________________________________________________________*/
built_sorted_list(Node *tree)
{
	int no =0;
	
	return(fill_sorted_list(tree,&no));
}


int fill_sorted_list(Node *tree, int *index) 
{
	if (tree == NULL) return;
	fill_sorted_list(smallPoint(tree), index);

	*index +=1;
	sl_from(*index) = fromPoint(tree);
	sl_to(*index) = toPoint(tree);
	sl_dist(*index) = distPoints(tree);

	fill_sorted_list(bigPoint(tree), index);
	return(*index);
}

/* build the monotone delta (d hat) for the first time by equadistance d.
_______________________________________________________________________*/
matrix  build_first_dim_delta(int pointcount,int pair_no,matrix guess,Pair sorted_list[])
{
	matrix delta = NULL;
	int i,m,n,j;

   	alloc_mtx(&delta,pointcount,pointcount);

       	for (i=1 ; i<=pair_no ; i++) {
         	m = sl_from(i);
         	n = sl_to(i);
         	delta[m][n] = (double)i;
         	delta[n][m] = delta[m][n]; 
      	}

   	for (i=1; i<=pointcount; i++)
      		for (j=1; j<=pointcount; j++)
         		if (delta[i][j] == 0.0)  delta[i][j] = LARGE_COEFF;

   	return(delta);
}

/* build the monotone delta (d hat) for the minimization procedure
The algorithm is according to  Kruskal - psychometrika vol 29 no 2 june 1964, pp. 115
_______________________________________________________________________*/
matrix  build_monotone_dim_delta(int pointcount,int pair_no,matrix guess,Pair sorted_list[])
{
	Block *block_list,*build_block_list();
	matrix delta = NULL,delta_dim_recon();

	block_list = build_block_list(pair_no,guess,sorted_list);


	delta = delta_dim_recon(pointcount,pair_no,sorted_list,block_list);
	free_block_list(block_list);

	return(delta);
}


/* build the block_list according to the order defining in sorted_list
_______________________________________________________________________*/

Block *build_block_list(int pair_no,matrix guess,Pair sorted_list[])
{
	Block *start_list,*current_list,*merge_blocks(),*build_first_block_list();

	start_list = build_first_block_list(pair_no,guess,sorted_list);

/*
printf("BEFORE\n\n");
print_list(start_list); 
printf("\n\n");
*/
	
	for (current_list = blockNext(start_list);
	     blockNext(current_list) != NULL ;
	     current_list = blockNext(current_list)) {

		do {
			if ( blockVal(current_list) > blockVal(blockNext(current_list)) )
				current_list = merge_blocks(current_list,blockNext(current_list));

			if ( blockVal(current_list) < blockVal(blockPrev(current_list)) )
				current_list = merge_blocks(blockPrev(current_list),current_list);

		} while ( (blockVal(current_list) > blockVal(blockNext(current_list))) ||
			  (blockVal(current_list) < blockVal(blockPrev(current_list))) );

	} /* for */
/*
printf("AFTER\n\n");
print_list(start_list); 
printf("\n\n");
*/
	return(start_list);

}


/* build the first block_list according to the order defining in sorted_list
_______________________________________________________________________*/

Block *build_first_block_list(int pair_no,matrix guess,Pair sorted_list[])
{
	int i;
	Block *new_block,*start_list,*last_block;
	double dist;

	last_block = start_list = (Block *) calloc (1,sizeof(Block));	
	fill_block(start_list,0,0,0,0.0,-9999.0,NULL,NULL);  /* dummy first block */
	for (i=1; i<=pair_no; i++) {
		blockNext(last_block) = new_block = (Block *) calloc (1,sizeof(Block));
		dist = guess[sl_to(i)][1] - guess[sl_from(i)][1];  /* to change to dim >1 */
		fill_block(new_block,i,i,1,dist,dist,NULL,last_block);		
		last_block = new_block;
	}
	blockNext(last_block) = new_block = (Block *) calloc (1,sizeof(Block));
	fill_block(new_block,0,0,0,0.0,9999.0,NULL,last_block);	 /* dummy last block */	

	return(start_list);
}

/* insert the content into a block record 
____________________________________________________________*/
fill_block(Block *new_block,int from,int to,int units,double sum,double val,Block *next,Block *prev)
{
	blockFrom(new_block) = from;
	blockTo(new_block) = to;
	blockUnits(new_block) = units;
	blockSum(new_block) = sum;
	blockVal(new_block) = val;
	blockNext(new_block) = next;
	blockPrev(new_block) = prev;
}

/* merge two blocks into a single one
______________________________________________________*/
Block *merge_blocks(Block *first_block,Block *second_block)
{
	Block *new_block;

	new_block = (Block *) calloc (1,sizeof(Block));
	
	blockFrom(new_block) = blockFrom(first_block);
	blockTo(new_block) = blockTo(second_block);
	blockUnits(new_block) = blockUnits(first_block) + blockUnits(second_block);
	blockSum(new_block) = blockSum(first_block) + blockSum(second_block);
	blockVal(new_block) = blockSum(new_block)/blockUnits(new_block);

	blockNext(new_block) = blockNext(second_block);
	blockPrev(new_block) = blockPrev(first_block);
	blockNext(blockPrev(first_block)) = new_block;
	blockPrev(blockNext(second_block)) = new_block;

	free(first_block);
	free(second_block);
	
	return(new_block);
}

/* reconstruct the delta matrix and insert the proper values (d hat)
  into it
_____________________________________________________________________*/
matrix delta_dim_recon(int pointcount,int pair_no,Pair sorted_list[],Block *block_list)
{
   matrix delta=NULL;
   int i,j,m,n;
   Block *block_node;

   alloc_mtx(&delta,pointcount,pointcount);

   for (block_node=blockNext(block_list); blockNext(block_node)!=NULL; 
	   block_node=blockNext(block_node)) 
      for (i=blockFrom(block_node) ; i<=blockTo(block_node) ; i++) {
         m = sl_from(i);
         n = sl_to(i);
         delta[m][n] = blockVal(block_node);
         delta[n][m] = delta[m][n]; 
      }

   for (i=1; i<=pointcount; i++)
      for (j=1; j<=pointcount; j++)
         if (delta[i][j] == 0.0)  delta[i][j] = LARGE_COEFF;

   return(delta);
}

/* free the elements of block list
_____________________________________*/
free_block_list(Block *block_list)
{
      Block *block_p;

      for (block_p=blockNext(block_list); block_p!=NULL;
           block_p=blockNext(block_p)) {
         free(block_list);
         block_list = block_p;
      }
}

            
/*-----------------------------------------------
called from main
------------------------------------------------*/
matrix non_metric_mds(int dim,int pointNum,matrix firstGuess,matrix prox,
	double (*func_to_minimize)(),void (*dfunc_to_minimize)())
{
   int pair_no,k;
   matrix guess=NULL,delta=NULL,y_res=NULL,diff=NULL;
   double inc;

   pair_no = sort_dim_delta(prox,pointNum);
   guess = copy_mtx(firstGuess); 

   printf("___________________ new iteration __________________\n");

   k=0;
   do {
	k++;
       	if (k==1) delta = build_first_dim_delta(pointNum,pair_no,guess,sorted_list);
       	else  delta = build_monotone_dim_delta(pointNum,pair_no,guess,sorted_list);
                         
      	y_res = metric_mds(dim,pointNum,guess,delta,func_to_minimize,dfunc_to_minimize);

      	diff = sub_mtx(y_res,guess);
      	inc = norm_mtx(diff);

      	free_all_mtx(3,&diff,&delta,&guess);
      	guess = y_res; y_res=NULL;

   } 	while (inc > 0.01);

   return(guess);

}

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  CHECKS   $$$$$$$$$$$$$$$$$$$$$$$$ */
print_list(Block *block_list)
{
   int i,m,n;
   Block *block_node;
   double delta,d;

   for (block_node=block_list; block_node!=NULL; block_node=blockNext(block_node)) 
      for (i=blockFrom(block_node) ; i<=blockTo(block_node) ; i++) {
         m = sl_from(i);
         n = sl_to(i);
         d = blockVal(block_node);
         delta = sl_dist(i); 

	 printf("delta(%d,%d)=%.4lf  d=%.4lf\n",m,n,delta,d);
      }

}
