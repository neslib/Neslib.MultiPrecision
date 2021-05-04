/*
 * include/c_qd.h
 *
 * This work was supported by the Director, Office of Science, Division
 * of Mathematical, Information, and Computational Sciences of the
 * U.S. Department of Energy under contract number DE-AC03-76SF00098.
 *
 * Copyright (c) 2000-2001
 *
 * Contains C wrapper function prototypes for quad-double precision 
 * arithmetic.  This can also be used from fortran code.
 */
#ifndef _QD_C_QD_H
#define _QD_C_QD_H

#include "c_dd.h"
#include "qd_config.h"
#include "dd_real.h"
#include "qd_real.h"

struct qd_real_pair {
	qd_real v1;
	qd_real v2;
};

#ifdef __cplusplus
extern "C" {
#endif

QD_API void c_qd_init();

/* add */
QD_API void c_qd_add(const qd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_add_dd_qd(const dd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_add_qd_dd(const qd_real *a, const dd_real *b, qd_real *c);
QD_API void c_qd_add_d_qd(const double *a, const qd_real *b, qd_real *c);
QD_API void c_qd_add_qd_d(const qd_real *a, const double *b, qd_real *c);
QD_API void c_qd_selfadd(const qd_real *a, qd_real *b);
QD_API void c_qd_selfadd_dd(const dd_real *a, qd_real *b);
QD_API void c_qd_selfadd_d(const double *a, qd_real *b);

/* sub */
QD_API void c_qd_sub(const qd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_sub_dd_qd(const dd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_sub_qd_dd(const qd_real *a, const dd_real *b, qd_real *c);
QD_API void c_qd_sub_d_qd(const double *a, const qd_real *b, qd_real *c);
QD_API void c_qd_sub_qd_d(const qd_real *a, const double *b, qd_real *c);
QD_API void c_qd_selfsub(const qd_real *a, qd_real *b);
QD_API void c_qd_selfsub_dd(const dd_real *a, qd_real *b);
QD_API void c_qd_selfsub_d(const double *a, qd_real *b);

/* mul */
QD_API void c_qd_mul(const qd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_mul_dd_qd(const dd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_mul_qd_dd(const qd_real *a, const dd_real *b, qd_real *c);
QD_API void c_qd_mul_d_qd(const double *a, const qd_real *b, qd_real *c);
QD_API void c_qd_mul_qd_d(const qd_real *a, const double *b, qd_real *c);
QD_API void c_qd_selfmul(const qd_real *a, qd_real *b);
QD_API void c_qd_selfmul_dd(const dd_real *a, qd_real *b);
QD_API void c_qd_selfmul_d(const double *a, qd_real *b);
QD_API void c_qd_mul_pot(const qd_real *a, const double *b, qd_real *c);

/* div */
QD_API void c_qd_div(const qd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_div_dd_qd(const dd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_div_qd_dd(const qd_real *a, const dd_real *b, qd_real *c);
QD_API void c_qd_div_d_qd(const double *a, const qd_real *b, qd_real *c);
QD_API void c_qd_div_qd_d(const qd_real *a, const double *b, qd_real *c);
QD_API void c_qd_selfdiv(const qd_real *a, qd_real *b);
QD_API void c_qd_selfdiv_dd(const dd_real *a, qd_real *b);
QD_API void c_qd_selfdiv_d(const double *a, qd_real *b);

QD_API void c_qd_rem(const qd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_divrem(const qd_real *a, const qd_real *b, qd_real_pair *c);
QD_API void c_qd_fmod(const qd_real *a, const qd_real *b, qd_real *c);

/* copy */
QD_API void c_qd_copy(const qd_real *a, qd_real *b);
QD_API void c_qd_copy_dd(const dd_real *a, qd_real *b);
QD_API void c_qd_copy_d(const double *a, qd_real *b);

QD_API void c_qd_sqrt(const qd_real *a, qd_real *b);
QD_API void c_qd_sqr(const qd_real *a, qd_real *b);

QD_API void c_qd_abs(const qd_real *a, qd_real *b);

QD_API void c_qd_npwr(const qd_real *a, int b, qd_real *c);
QD_API void c_qd_pow(const qd_real *a, const qd_real *b, qd_real *c);
QD_API void c_qd_nroot(const qd_real *a, int b, qd_real *c);
QD_API void c_qd_ldexp(const qd_real *a, int b, qd_real *c);

QD_API void c_qd_nint(const qd_real *a, qd_real *b);
QD_API void c_qd_aint(const qd_real *a, qd_real *b);
QD_API void c_qd_floor(const qd_real *a, qd_real *b);
QD_API void c_qd_ceil(const qd_real *a, qd_real *b);

QD_API void c_qd_exp(const qd_real *a, qd_real *b);
QD_API void c_qd_log(const qd_real *a, qd_real *b);
QD_API void c_qd_log10(const qd_real *a, qd_real *b);

QD_API void c_qd_sin(const qd_real *a, qd_real *b);
QD_API void c_qd_cos(const qd_real *a, qd_real *b);
QD_API void c_qd_tan(const qd_real *a, qd_real *b);

QD_API void c_qd_asin(const qd_real *a, qd_real *b);
QD_API void c_qd_acos(const qd_real *a, qd_real *b);
QD_API void c_qd_atan(const qd_real *a, qd_real *b);
QD_API void c_qd_atan2(const qd_real *a, const qd_real *b, qd_real *c);

QD_API void c_qd_sinh(const qd_real *a, qd_real *b);
QD_API void c_qd_cosh(const qd_real *a, qd_real *b);
QD_API void c_qd_tanh(const qd_real *a, qd_real *b);

QD_API void c_qd_asinh(const qd_real *a, qd_real *b);
QD_API void c_qd_acosh(const qd_real *a, qd_real *b);
QD_API void c_qd_atanh(const qd_real *a, qd_real *b);

QD_API void c_qd_sincos(const qd_real *a, qd_real *s, qd_real *c);
QD_API void c_qd_sincosh(const qd_real *a, qd_real *s, qd_real *c);

QD_API void c_qd_neg(const qd_real *a, qd_real *b);
QD_API void c_qd_inv(const qd_real *a, qd_real *b);
QD_API int c_qd_comp(const qd_real *a, const qd_real *b);
QD_API int c_qd_comp_qd_d(const qd_real *a, const double *b);
QD_API int c_qd_comp_d_qd(const double *a, const qd_real *b);
#ifdef __cplusplus
}
#endif

#endif  /* _QD_C_QD_H */
