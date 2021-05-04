/*
 * include/c_dd.h
 *
 * This work was supported by the Director, Office of Science, Division
 * of Mathematical, Information, and Computational Sciences of the
 * U.S. Department of Energy under contract number DE-AC03-76SF00098.
 *
 * Copyright (c) 2000-2001
 *
 * Contains C wrapper function prototypes for double-double precision
 * arithmetic.  This can also be used from fortran code.
 */
#ifndef _QD_C_DD_H
#define _QD_C_DD_H

#include "qd_config.h"
#include "dd_real.h"

struct dd_real_pair {
	dd_real v1;
	dd_real v2;
};

#ifdef __cplusplus
extern "C" {
#endif

QD_API void c_dd_init();

/* add */
QD_API void c_dd_add(const dd_real *a, const dd_real *b, dd_real *c);
QD_API void c_dd_add_d_d(const double *a, const double *b, dd_real *c);
QD_API void c_dd_add_d_dd(const double *a, const dd_real *b, dd_real *c);
QD_API void c_dd_add_dd_d(const dd_real *a, const double *b, dd_real *c);

/* sub */
QD_API void c_dd_sub(const dd_real *a, const dd_real *b, dd_real *c);
QD_API void c_dd_sub_d_d(const double *a, const double *b, dd_real *c);
QD_API void c_dd_sub_d_dd(const double *a, const dd_real *b, dd_real *c);
QD_API void c_dd_sub_dd_d(const dd_real *a, const double *b, dd_real *c);

/* mul */
QD_API void c_dd_mul(const dd_real *a, const dd_real *b, dd_real *c);
QD_API void c_dd_mul_d_d(const double *a, const double *b, dd_real *c);
QD_API void c_dd_mul_d_dd(const double *a, const dd_real *b, dd_real *c);
QD_API void c_dd_mul_dd_d(const dd_real *a, const double *b, dd_real *c);
QD_API void c_dd_mul_pot(const dd_real *a, const double *b, dd_real *c);

/* div */
QD_API void c_dd_div(const dd_real *a, const dd_real *b, dd_real *c);
QD_API void c_dd_div_d_d(const double *a, const double *b, dd_real *c);
QD_API void c_dd_div_d_dd(const double *a, const dd_real *b, dd_real *c);
QD_API void c_dd_div_dd_d(const dd_real *a, const double *b, dd_real *c);

QD_API void c_dd_rem(const dd_real *a, const dd_real *b, dd_real *c);
QD_API void c_dd_divrem(const dd_real *a, const dd_real *b, dd_real_pair *c);
QD_API void c_dd_fmod(const dd_real *a, const dd_real *b, dd_real *c);

QD_API void c_dd_sqrt(const dd_real *a, dd_real *b);
QD_API void c_dd_sqrt_d(const double *a, dd_real *b);
QD_API void c_dd_sqr(const dd_real *a, dd_real *b);
QD_API void c_dd_sqr_d(const double *a, dd_real *b);

QD_API void c_dd_abs(const dd_real *a, dd_real *b);

QD_API void c_dd_npwr(const dd_real *a, int b, dd_real *c);
QD_API void c_dd_pow(const dd_real *a, const dd_real *b, dd_real *c);
QD_API void c_dd_nroot(const dd_real *a, int b, dd_real *c);
QD_API void c_dd_ldexp(const dd_real *a, int b, dd_real *c);

QD_API void c_dd_nint(const dd_real *a, dd_real *b);
QD_API void c_dd_aint(const dd_real *a, dd_real *b);
QD_API void c_dd_floor(const dd_real *a, dd_real *b);
QD_API void c_dd_ceil(const dd_real *a, dd_real *b);

QD_API void c_dd_exp(const dd_real *a, dd_real *b);
QD_API void c_dd_log(const dd_real *a, dd_real *b);
QD_API void c_dd_log10(const dd_real *a, dd_real *b);

QD_API void c_dd_sin(const dd_real *a, dd_real *b);
QD_API void c_dd_cos(const dd_real *a, dd_real *b);
QD_API void c_dd_tan(const dd_real *a, dd_real *b);

QD_API void c_dd_asin(const dd_real *a, dd_real *b);
QD_API void c_dd_acos(const dd_real *a, dd_real *b);
QD_API void c_dd_atan(const dd_real *a, dd_real *b);
QD_API void c_dd_atan2(const dd_real *a, const dd_real *b, dd_real *c);

QD_API void c_dd_sinh(const dd_real *a, dd_real *b);
QD_API void c_dd_cosh(const dd_real *a, dd_real *b);
QD_API void c_dd_tanh(const dd_real *a, dd_real *b);

QD_API void c_dd_asinh(const dd_real *a, dd_real *b);
QD_API void c_dd_acosh(const dd_real *a, dd_real *b);
QD_API void c_dd_atanh(const dd_real *a, dd_real *b);

QD_API void c_dd_sincos(const dd_real *a, dd_real *s, dd_real *c);
QD_API void c_dd_sincosh(const dd_real *a, dd_real *s, dd_real *c);

QD_API void c_dd_neg(const dd_real *a, dd_real *b);
QD_API void c_dd_inv(const dd_real *a, dd_real *b);
QD_API int c_dd_comp(const dd_real *a, const dd_real *b);
QD_API int c_dd_comp_dd_d(const dd_real *a, const double *b);
QD_API int c_dd_comp_d_dd(const double *a, const dd_real *b);

#ifdef __cplusplus
}
#endif

#endif  /* _QD_C_DD_H */
