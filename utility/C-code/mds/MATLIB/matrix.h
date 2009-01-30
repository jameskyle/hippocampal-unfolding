#ifndef _matrix_h_
#define _matrix_h_

#define PI           3.14159265359
#define ROUND(x)     ((x)<0.0 ? ((int)((x)-0.5)) : ((int)((x)+0.5)))
#define ABS(x)       ((x) > 0.0 ? (x) : -(x))
#define ROWS(a)      ROUND(a[1][0])
#define COLS(a)      ROUND(a[0][1])


typedef double **matrix;

matrix add_mtx(),sub_mtx(),mul_mtx(),mul_scalar_mtx(),div_scalar_mtx(),
	transpose_mtx(),inv_mtx(),ident_mtx(),cross_mtx(),normalize_mtx(),
	mtx_hor_concatenate(),mtx_ver_concatenate(),mtx_ver_cut(),mtx_cut(),
	copy_mtx(),cross_vectors(),eigen_val_symm_mtx(),eigen_vec_symm_mtx(),
	cholesky_dcmp_mtx(),inv_L_mtx(),smallest_eigen_vec_symm_mtx(),
	mtx_ver_thread(),mtx_hor_thread();

double  det_mtx(),norm_mtx(),trace_mtx(),dot_vectors();

extern matrix tmp_mtx[10];

#endif