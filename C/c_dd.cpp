/*
 * src/c_dd.cc
 *
 * This work was supported by the Director, Office of Science, Division
 * of Mathematical, Information, and Computational Sciences of the
 * U.S. Department of Energy under contract number DE-AC03-76SF00098.
 *
 * Copyright (c) 2000-2001
 *
 * Contains the C wrapper functions for double-double precision arithmetic.
 * This can be used from Fortran code.
 */
#include "qd_config.h"
#include "dd_real.h"
#include "c_dd.h"
#include "dd_real.cpp"
#include "dd_const.cpp"

extern "C" {

void c_dd_init() {
	qd::_d_nan = qd_nan();
	qd::_d_inf = qd_inf();

	dd_real::_2pi = dd_real(6.283185307179586232e+00,
		2.449293598294706414e-16);
	dd_real::_pi = dd_real(3.141592653589793116e+00,
		1.224646799147353207e-16);
	dd_real::_pi2 = dd_real(1.570796326794896558e+00,
		6.123233995736766036e-17);
	dd_real::_pi4 = dd_real(7.853981633974482790e-01,
		3.061616997868383018e-17);
	dd_real::_3pi4 = dd_real(2.356194490192344837e+00,
		9.1848509936051484375e-17);
	dd_real::_e = dd_real(2.718281828459045091e+00,
		1.445646891729250158e-16);
	dd_real::_log2 = dd_real(6.931471805599452862e-01,
		2.319046813846299558e-17);
	dd_real::_log10 = dd_real(2.302585092994045901e+00,
		-2.170756223382249351e-16);
	dd_real::_nan = dd_real(qd::_d_nan, qd::_d_nan);
	dd_real::_inf = dd_real(qd::_d_inf, qd::_d_inf);

	dd_real::_max =
		dd_real(1.79769313486231570815e+308, 9.97920154767359795037e+291);
	dd_real::_safe_max =
		dd_real(1.7976931080746007281e+308, 9.97920154767359795037e+291);
	
	dd_real::_pi16 = dd_real(1.963495408493620697e-01,
		7.654042494670957545e-18);
}

/* add */
void c_dd_add(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = *a + *b;
}
void c_dd_add_d_d(const double *a, const double *b, dd_real *c) {
	*c = dd_real::add(*a, *b);
}
void c_dd_add_dd_d(const dd_real *a, const double *b, dd_real *c) {
	*c = *a + *b;
}
void c_dd_add_d_dd(const double *a, const dd_real *b, dd_real *c) {
	*c = *a + *b;
}


/* sub */
void c_dd_sub(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = *a - *b;	
}
void c_dd_sub_d_d(const double *a, const double *b, dd_real *c) {
	*c = dd_real::sub(*a, *b);
}
void c_dd_sub_dd_d(const dd_real *a, const double *b, dd_real *c) {
	*c = *a - *b;
}
void c_dd_sub_d_dd(const double *a, const dd_real *b, dd_real *c) {
	*c = *a - *b;
}


/* mul */
void c_dd_mul(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = *a * *b;
}
void c_dd_mul_d_d(const double *a, const double *b, dd_real *c) {
	*c = dd_real::mul(*a, *b);	
}
void c_dd_mul_dd_d(const dd_real *a, const double *b, dd_real *c) {
	*c = *a * *b;
}
void c_dd_mul_d_dd(const double *a, const dd_real *b, dd_real *c) {
	*c = *a * *b;
}
void c_dd_mul_pot(const dd_real *a, const double *b, dd_real *c) {
	*c = mul_pwr2(*a, *b);
}

/* div */
void c_dd_div(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = *a / *b;
}
void c_dd_div_d_d(const double *a, const double *b, dd_real *c) {
	*c = dd_real::div(*a, *b);
}
void c_dd_div_dd_d(const dd_real *a, const double *b, dd_real *c) {
	*c = *a / *b;
}
void c_dd_div_d_dd(const double *a, const dd_real *b, dd_real *c) {
	*c = *a / *b;
}

void c_dd_rem(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = drem(*a, *b);
}
void c_dd_divrem(const dd_real *a, const dd_real *b, dd_real_pair *c) {
	c->v2 = divrem(*a, *b, c->v1);
}
void c_dd_fmod(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = fmod(*a, *b);
}


void c_dd_sqrt(const dd_real *a, dd_real *b) {
	*b = sqrt(*a);
}
void c_dd_sqrt_d(const double *a, dd_real *b) {
	*b = sqrt(*a);
}
void c_dd_sqr(const dd_real *a, dd_real *b) {
	*b = sqr(*a);
}
void c_dd_sqr_d(const double *a, dd_real *b) {
	*b = sqr(*a);
}

void c_dd_abs(const dd_real *a, dd_real *b) {
	*b = abs(*a);
}

void c_dd_npwr(const dd_real *a, int n, dd_real *b) {
	*b = npwr(*a, n);
}
void c_dd_pow(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = pow(*a, *b);
}

void c_dd_nroot(const dd_real *a, int n, dd_real *b) {
	*b = nroot(*a, n);
}

void c_dd_ldexp(const dd_real *a, int b, dd_real *c) {
	*c = ldexp(*a, b);
}

void c_dd_nint(const dd_real *a, dd_real *b) {
	*b = nint(*a);
}
void c_dd_aint(const dd_real *a, dd_real *b) {
	*b = aint(*a);
}
void c_dd_floor(const dd_real *a, dd_real *b) {
	*b = floor(*a);
}
void c_dd_ceil(const dd_real *a, dd_real *b) {
	*b = ceil(*a);
}

void c_dd_log(const dd_real *a, dd_real *b) {
	*b = log(*a);
}
void c_dd_log10(const dd_real *a, dd_real *b) {
	*b = log10(*a);
}
void c_dd_exp(const dd_real *a, dd_real *b) {
	*b = exp(*a);
}

void c_dd_sin(const dd_real *a, dd_real *b) {
	*b = sin(*a);
}
void c_dd_cos(const dd_real *a, dd_real *b) {
	*b = cos(*a);
}
void c_dd_tan(const dd_real *a, dd_real *b) {
	*b = tan(*a);
}

void c_dd_asin(const dd_real *a, dd_real *b) {
	*b = asin(*a);
}
void c_dd_acos(const dd_real *a, dd_real *b) {
	*b = acos(*a);
}
void c_dd_atan(const dd_real *a, dd_real *b) {
	*b = atan(*a);
}

void c_dd_atan2(const dd_real *a, const dd_real *b, dd_real *c) {
	*c = atan2(*a, *b);
}

void c_dd_sinh(const dd_real *a, dd_real *b) {
	*b = sinh(*a);
}
void c_dd_cosh(const dd_real *a, dd_real *b) {
	*b = cosh(*a);
}
void c_dd_tanh(const dd_real *a, dd_real *b) {
	*b = tanh(*a);
}

void c_dd_asinh(const dd_real *a, dd_real *b) {
	*b = asinh(*a);
}
void c_dd_acosh(const dd_real *a, dd_real *b) {
	*b = acosh(*a);
}
void c_dd_atanh(const dd_real *a, dd_real *b) {
	*b = atanh(*a);
}

void c_dd_sincos(const dd_real *a, dd_real *s, dd_real *c) {
    sincos(*a, *s, *c);
}

void c_dd_sincosh(const dd_real *a, dd_real *s, dd_real *c) {
	sincosh(*a, *s, *c);
}

void c_dd_neg(const dd_real *a, dd_real *b) {
	b->x[0] = -a->x[0];
	b->x[1] = -a->x[1];
}

void c_dd_inv(const dd_real *a, dd_real *b) {
	*b = inv(*a);
}

int c_dd_comp(const dd_real *a, const dd_real *b) {
  if (*a < *b)
    return -1;

  if (*a > *b)
    return 1;

  return 0;
}

int c_dd_comp_dd_d(const dd_real *a, const double *b) {
  dd_real bb(*b);
  if (*a < bb)
    return -1;

  if (*a > bb)
    return 1;

  return 0;
}

int c_dd_comp_d_dd(const double *a, const dd_real *b) {
  dd_real aa(*a);
  if (aa < *b)
    return -1;
  
  if (aa > *b)
    return 1;
  
  return 0;
}

}