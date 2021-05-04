/*
 * src/c_qd.cc
 *
 * This work was supported by the Director, Office of Science, Division
 * of Mathematical, Information, and Computational Sciences of the
 * U.S. Department of Energy under contract number DE-AC03-76SF00098.
 *
 * Copyright (c) 2000-2001
 *
 * Contains C wrapper function for quad-double precision arithmetic.
 * This can be used from fortran code.
 */
#include <cstring>

#include "qd_config.h"
#include "qd_real.h"
#include "c_qd.h"
#include "qd_real.cpp" 
#include "qd_const.cpp" 

extern "C" {

void c_qd_init() {
	qd::_d_nan = qd_nan();
	qd::_d_inf = qd_inf();

	qd_real::_2pi = qd_real(6.283185307179586232e+00,
		2.449293598294706414e-16,
		-5.989539619436679332e-33,
		2.224908441726730563e-49);
	qd_real::_pi = qd_real(3.141592653589793116e+00,
		1.224646799147353207e-16,
		-2.994769809718339666e-33,
		1.112454220863365282e-49);
	qd_real::_pi2 = qd_real(1.570796326794896558e+00,
		6.123233995736766036e-17,
		-1.497384904859169833e-33,
		5.562271104316826408e-50);
	qd_real::_pi4 = qd_real(7.853981633974482790e-01,
		3.061616997868383018e-17,
		-7.486924524295849165e-34,
		2.781135552158413204e-50);
	qd_real::_3pi4 = qd_real(2.356194490192344837e+00,
		9.1848509936051484375e-17,
		3.9168984647504003225e-33,
		-2.5867981632704860386e-49);
	qd_real::_e = qd_real(2.718281828459045091e+00,
		1.445646891729250158e-16,
		-2.127717108038176765e-33,
		1.515630159841218954e-49);
	qd_real::_log2 = qd_real(6.931471805599452862e-01,
		2.319046813846299558e-17,
		5.707708438416212066e-34,
		-3.582432210601811423e-50);
	qd_real::_log10 = qd_real(2.302585092994045901e+00,
		-2.170756223382249351e-16,
		-9.984262454465776570e-33,
		-4.023357454450206379e-49);
	qd_real::_nan = qd_real(qd::_d_nan, qd::_d_nan,
		qd::_d_nan, qd::_d_nan);
	qd_real::_inf = qd_real(qd::_d_inf, qd::_d_inf,
		qd::_d_inf, qd::_d_inf);

	qd_real::_max = qd_real(
		1.79769313486231570815e+308, 9.97920154767359795037e+291,
		5.53956966280111259858e+275, 3.07507889307840487279e+259);
	qd_real::_safe_max = qd_real(
		1.7976931080746007281e+308, 9.97920154767359795037e+291,
		5.53956966280111259858e+275, 3.07507889307840487279e+259);

	qd_real::_pi1024 = qd_real(
		3.067961575771282340e-03, 1.195944139792337116e-19,
		-2.924579892303066080e-36, 1.086381075061880158e-52);

}


/* add */
void c_qd_add(const qd_real *a, const qd_real *b, qd_real *c) {
	*c = *a + *b;
}
void c_qd_add_qd_dd(const qd_real *a, const dd_real *b, qd_real *c) {
	*c = *a + *b;
}
void c_qd_add_dd_qd(const dd_real *a, const qd_real *b, qd_real *c) {
	*c = *a + *b;
}
void c_qd_add_qd_d(const qd_real *a, const double *b, qd_real *c) {
	*c = *a + *b;
}
void c_qd_add_d_qd(const double *a, const qd_real *b, qd_real *c) {
	*c = *a + *b;
}



/* sub */
void c_qd_sub(const qd_real *a, const qd_real *b, qd_real *c) {
	*c = *a - *b;
}
void c_qd_sub_qd_dd(const qd_real *a, const dd_real *b, qd_real *c) {
	*c = *a - *b;
}
void c_qd_sub_dd_qd(const dd_real *a, const qd_real *b, qd_real *c) {
	*c = *a - *b;
}
void c_qd_sub_qd_d(const qd_real *a, const double *b, qd_real *c) {
	*c = *a - *b;
}
void c_qd_sub_d_qd(const double *a, const qd_real *b, qd_real *c) {
	*c = *a - *b;
}



/* mul */
void c_qd_mul(const qd_real *a, const qd_real *b, qd_real *c) {
	*c = *a * *b;
}
void c_qd_mul_qd_dd(const qd_real *a, const dd_real *b, qd_real *c) {
	*c = *a * *b;
}
void c_qd_mul_dd_qd(const dd_real *a, const qd_real *b, qd_real *c) {
	*c = *a * *b;
}
void c_qd_mul_qd_d(const qd_real *a, const double *b, qd_real *c) {
	*c = *a * *b;
}
void c_qd_mul_d_qd(const double *a, const qd_real *b, qd_real *c) {
	*c = *a * *b;
}

void c_qd_mul_pot(const qd_real *a, const double *b, qd_real *c) {
	*c = mul_pwr2(*a, *b);
}



/* div */
void c_qd_div(const qd_real *a, const qd_real *b, qd_real *c) {
	*c = *a / *b;
}
void c_qd_div_qd_dd(const qd_real *a, const dd_real *b, qd_real *c) {
	*c = *a / *b;
}
void c_qd_div_dd_qd(const dd_real *a, const qd_real *b, qd_real *c) {
	*c = *a / *b;
}
void c_qd_div_qd_d(const qd_real *a, const double *b, qd_real *c) {
	*c = *a / *b;
}
void c_qd_div_d_qd(const double *a, const qd_real *b, qd_real *c) {
	*c = *a / *b;
}

void c_qd_rem(const qd_real *a, const qd_real *b, qd_real *c) {
	*c = drem(*a, *b);
}
void c_qd_divrem(const qd_real *a, const qd_real *b, qd_real_pair *c) {
	c->v2 = divrem(*a, *b, c->v1);
}
void c_qd_fmod(const qd_real *a, const qd_real *b, qd_real *c) {
	*c = fmod(*a, *b);
}



/* selfadd */
void c_qd_selfadd(const qd_real *a, qd_real *b) {
	*b += *a;
}
void c_qd_selfadd_dd(const dd_real *a, qd_real *b) {
	*b += *a;
}
void c_qd_selfadd_d(const double *a, qd_real *b) {
	*b += *a;
}



/* selfsub */
void c_qd_selfsub(const qd_real *a, qd_real *b) {
	*b -= *a;
}
void c_qd_selfsub_dd(const dd_real *a, qd_real *b) {
	*b -= *a;
}
void c_qd_selfsub_d(const double *a, qd_real *b) {
	*b -= *a;
}



/* selfmul */
void c_qd_selfmul(const qd_real *a, qd_real *b) {
	*b *= *a;
}
void c_qd_selfmul_dd(const dd_real *a, qd_real *b) {
	*b *= *a;
}
void c_qd_selfmul_d(const double *a, qd_real *b) {
	*b *= *a;
}



/* selfdiv */
void c_qd_selfdiv(const qd_real *a, qd_real *b) {
	*b /= *a;
}
void c_qd_selfdiv_dd(const dd_real *a, qd_real *b) {
	*b /= *a;
}
void c_qd_selfdiv_d(const double *a, qd_real *b) {
	*b /= *a;
}



/* copy */
void c_qd_copy(const qd_real *a, qd_real *b) {
  b->x[0] = a->x[0];
  b->x[1] = a->x[1];
  b->x[2] = a->x[2];
  b->x[3] = a->x[3];
}
void c_qd_copy_dd(const dd_real *a, qd_real *b) {
  b->x[0] = a->x[0];
  b->x[1] = a->x[1];
  b->x[2] = 0.0;
  b->x[3] = 0.0;
}
void c_qd_copy_d(const double *a, qd_real *b) {
  b->x[0] = *a;
  b->x[1] = 0.0;
  b->x[2] = 0.0;
  b->x[3] = 0.0;
}


void c_qd_sqrt(const qd_real *a, qd_real *b) {
  *b = sqrt(*a);
}
void c_qd_sqr(const qd_real *a, qd_real *b) {
  *b = sqr(*a);
}

void c_qd_abs(const qd_real *a, qd_real *b) {
  *b = abs(*a);
}

void c_qd_npwr(const qd_real *a, int n, qd_real *b) {
  *b = npwr(*a, n);
}

void c_qd_pow(const qd_real *a, const qd_real *b, qd_real *c) {
	*c = pow(*a, *b);
}

void c_qd_nroot(const qd_real *a, int n, qd_real *b) {
  *b = nroot(*a, n);
}

void c_qd_ldexp(const qd_real *a, int b, qd_real *c) {
	*c = ldexp(*a, b);
}

void c_qd_nint(const qd_real *a, qd_real *b) {
  *b = nint(*a);
}
void c_qd_aint(const qd_real *a, qd_real *b) {
  *b = aint(*a);
}
void c_qd_floor(const qd_real *a, qd_real *b) {
  *b = floor(*a);
}
void c_qd_ceil(const qd_real *a, qd_real *b) {
  *b = ceil(*a);
}

void c_qd_log(const qd_real *a, qd_real *b) {
  *b = log(*a);
}
void c_qd_log10(const qd_real *a, qd_real *b) {
  *b = log10(*a);
}
void c_qd_exp(const qd_real *a, qd_real *b) {
  *b = exp(*a);
}

void c_qd_sin(const qd_real *a, qd_real *b) {
  *b = sin(*a);
}
void c_qd_cos(const qd_real *a, qd_real *b) {
  *b = cos(*a);
}
void c_qd_tan(const qd_real *a, qd_real *b) {
  *b = tan(*a);
}

void c_qd_asin(const qd_real *a, qd_real *b) {
  *b = asin(*a);
}
void c_qd_acos(const qd_real *a, qd_real *b) {
  *b = acos(*a);
}
void c_qd_atan(const qd_real *a, qd_real *b) {
  *b = atan(*a);
}

void c_qd_atan2(const qd_real *a, const qd_real *b, qd_real *c) {
  *c = atan2(*a, *b);
}

void c_qd_sinh(const qd_real *a, qd_real *b) {
  *b = sinh(*a);
}
void c_qd_cosh(const qd_real *a, qd_real *b) {
  *b = cosh(*a);
}
void c_qd_tanh(const qd_real *a, qd_real *b) {
  *b = tanh(*a);
}

void c_qd_asinh(const qd_real *a, qd_real *b) {
  *b = asinh(*a);
}
void c_qd_acosh(const qd_real *a, qd_real *b) {
  *b = acosh(*a);
}
void c_qd_atanh(const qd_real *a, qd_real *b) {
  *b = atanh(*a);
}

void c_qd_sincos(const qd_real *a, qd_real *s, qd_real *c) {
  sincos(*a, *s, *c);
}

void c_qd_sincosh(const qd_real *a, qd_real *s, qd_real *c) {
  sincosh(*a, *s, *c);
}

void c_qd_neg(const qd_real *a, qd_real *b) {
	b->x[0] = -a->x[0];
	b->x[1] = -a->x[1];
	b->x[2] = -a->x[2];
	b->x[3] = -a->x[3];
}

void c_qd_inv(const qd_real *a, qd_real *b) {
	*b = inv(*a);
}

int c_qd_comp(const qd_real *a, const qd_real *b) {
  if (*a < *b)
	return -1;

  if (*a > *b)
	return 1;

  return 0;
}

int c_qd_comp_qd_d(const qd_real *a, const double *b) {
  qd_real bb(*b);
  if (*a < bb)
	return -1;

  if (*a > bb)
	return 1;

  return 0;
}

int c_qd_comp_d_qd(const double *a, const qd_real *b) {
  qd_real aa(*a);
  if (aa < *b)
	return -1;

  if (aa > *b)
	return 1;

  return 0;
}

}