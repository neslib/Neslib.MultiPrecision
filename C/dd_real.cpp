/*
 * src/dd_real.cc
 *
 * This work was supported by the Director, Office of Science, Division
 * of Mathematical, Information, and Computational Sciences of the
 * U.S. Department of Energy under contract number DE-AC03-76SF00098.
 *
 * Copyright (c) 2000-2007
 *
 * Contains implementation of non-inlined functions of double-double
 * package.  Inlined functions are found in dd_inline.h (in include directory).
 */

#include "qd_config.h"
#include "dd_real.h"

#ifndef QD_INLINE
#include "dd_inline.h"
#endif

/* This routine is called whenever a fatal error occurs. */
void dd_real::error(const char *msg) { 
}

/* Computes the square root of the double-double number dd.
   NOTE: dd must be a non-negative number.                   */
QD_API dd_real sqrt(const dd_real &a) {
  /* Strategy:  Use Karp's trick:  if x is an approximation
     to sqrt(a), then

        sqrt(a) = a*x + [a - (a*x)^2] * x / 2   (approx)

     The approximation is accurate to twice the accuracy of x.
     Also, the multiplication (a*x) and [-]*x can be done with
     only half the precision.
  */

  if (a.is_zero())
    return 0.0;

  if (a.is_negative()) {
    dd_real::error("(dd_real::sqrt): Negative argument.");
    return dd_real::_nan;
  }

  double x = 1.0 / qd_sqrt(a.x[0]);
  double ax = a.x[0] * x;
  return dd_real::add(ax, (a - dd_real::sqr(ax)).x[0] * (x * 0.5));
}

/* Computes the square root of a double in double-double precision. 
   NOTE: d must not be negative.                                   */
dd_real dd_real::sqrt(double d) {
  return ::sqrt(dd_real(d));
}

/* Computes the n-th root of the double-double number a.
   NOTE: n must be a positive integer.  
   NOTE: If n is even, then a must not be negative.       */
dd_real nroot(const dd_real &a, int n) {
  /* Strategy:  Use Newton iteration for the function

          f(x) = x^(-n) - a

     to find its root a^{-1/n}.  The iteration is thus

          x' = x + x * (1 - a * x^n) / n

     which converges quadratically.  We can then find 
    a^{1/n} by taking the reciprocal.
  */

  if (n <= 0) {
    dd_real::error("(dd_real::nroot): N must be positive.");
    return dd_real::_nan;
  }

  if (n%2 == 0 && a.is_negative()) {
    dd_real::error("(dd_real::nroot): Negative argument.");
    return dd_real::_nan;
  }

  if (n == 1) {
    return a;
  } 
  if (n == 2) {
    return sqrt(a);
  }

  if (a.is_zero())
    return 0.0;

  /* Note  a^{-1/n} = exp(-log(a)/n) */
  dd_real r = abs(a);
  dd_real x = qd_exp(-qd_log(r.x[0]) / n);

  /* Perform Newton's iteration. */
  x += x * (1.0 - r * npwr(x, n)) / static_cast<double>(n);
  if (a.x[0] < 0.0)
    x = -x;
  return 1.0/x;
}

/* Computes the n-th power of a double-double number. 
   NOTE:  0^0 causes an error.                         */
dd_real npwr(const dd_real &a, int n) {
  
  if (n == 0) {
    if (a.is_zero()) {
      dd_real::error("(dd_real::npwr): Invalid argument.");
      return dd_real::_nan;
    }
    return 1.0;
  }

  dd_real r = a;
  dd_real s = 1.0;
  int N = qd_abs(n);

  if (N > 1) {
    /* Use binary exponentiation */
    while (N > 0) {
      if (N % 2 == 1) {
        s *= r;
      }
      N /= 2;
      if (N > 0)
        r = sqr(r);
    }
  } else {
    s = r;
  }

  /* Compute the reciprocal if n is negative. */
  if (n < 0)
    return (1.0 / s);
  
  return s;
}

dd_real pow(const dd_real &a, int n) {
  return npwr(a, n);
}

dd_real pow(const dd_real &a, const dd_real &b) {
  return exp(b * log(a));
}

static const int n_inv_fact = 15;
static const double inv_fact[n_inv_fact][2] = {
  { 1.66666666666666657e-01,  9.25185853854297066e-18},
  { 4.16666666666666644e-02,  2.31296463463574266e-18},
  { 8.33333333333333322e-03,  1.15648231731787138e-19},
  { 1.38888888888888894e-03, -5.30054395437357706e-20},
  { 1.98412698412698413e-04,  1.72095582934207053e-22},
  { 2.48015873015873016e-05,  2.15119478667758816e-23},
  { 2.75573192239858925e-06, -1.85839327404647208e-22},
  { 2.75573192239858883e-07,  2.37677146222502973e-23},
  { 2.50521083854417202e-08, -1.44881407093591197e-24},
  { 2.08767569878681002e-09, -1.20734505911325997e-25},
  { 1.60590438368216133e-10,  1.25852945887520981e-26},
  { 1.14707455977297245e-11,  2.06555127528307454e-28},
  { 7.64716373181981641e-13,  7.03872877733453001e-30},
  { 4.77947733238738525e-14,  4.39920548583408126e-31},
  { 2.81145725434552060e-15,  1.65088427308614326e-31}
};

/* Exponential.  Computes exp(x) in double-double precision. */
dd_real exp(const dd_real &a) {
  /* Strategy:  We first reduce the size of x by noting that
     
          exp(kr + m * log(2)) = 2^m * exp(r)^k

     where m and k are integers.  By choosing m appropriately
     we can make |kr| <= log(2) / 2 = 0.347.  Then exp(r) is 
     evaluated using the familiar Taylor series.  Reducing the 
     argument substantially speeds up the convergence.       */  

  const double k = 512.0;
  const double inv_k = 1.0 / k;

  if (a.x[0] <= -709.0)
    return 0.0;

  if (a.x[0] >=  709.0)
    return dd_real::_inf;

  if (a.is_zero())
    return 1.0;

  if (a.is_one())
    return dd_real::_e;

  double m = qd_floor(a.x[0] / dd_real::_log2.x[0] + 0.5);
  dd_real r = mul_pwr2(a - dd_real::_log2 * m, inv_k);
  dd_real s, t, p;

  p = sqr(r);
  s = r + mul_pwr2(p, 0.5);
  p *= r;
  t = p * dd_real(inv_fact[0][0], inv_fact[0][1]);
  int i = 0;
  do {
    s += t;
    p *= r;
    ++i;
    t = p * dd_real(inv_fact[i][0], inv_fact[i][1]);
  } while (qd_fabs(to_double(t)) > inv_k * dd_real::_eps && i < 5);

  s += t;

  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s = mul_pwr2(s, 2.0) + sqr(s);
  s += 1.0;

  return ldexp(s, static_cast<int>(m));
}

/* Logarithm.  Computes log(x) in double-double precision.
   This is a natural logarithm (i.e., base e).            */
dd_real log(const dd_real &a) {
  /* Strategy.  The Taylor series for log converges much more
     slowly than that of exp, due to the lack of the factorial
     term in the denominator.  Hence this routine instead tries
     to determine the root of the function

         f(x) = exp(x) - a

     using Newton iteration.  The iteration is given by

         x' = x - f(x)/f'(x) 
            = x - (1 - a * exp(-x))
            = x + a * exp(-x) - 1.
           
     Only one iteration is needed, since Newton's iteration
     approximately doubles the number of digits per iteration. */

  if (a.is_one()) {
    return 0.0;
  }

  if (a.x[0] <= 0.0) {
    dd_real::error("(dd_real::log): Non-positive argument.");
    return dd_real::_nan;
  }

  dd_real x = qd_log(a.x[0]);   /* Initial approximation */

  x = x + a * exp(-x) - 1.0;
  return x;
}

dd_real log10(const dd_real &a) {
  return log(a) / dd_real::_log10;
}

/* Table of sin(k * pi/16) and cos(k * pi/16). */
static const double sin_table [4][2] = {
  {1.950903220161282758e-01, -7.991079068461731263e-18},
  {3.826834323650897818e-01, -1.005077269646158761e-17},
  {5.555702330196021776e-01,  4.709410940561676821e-17},
  {7.071067811865475727e-01, -4.833646656726456726e-17}
};

static const double cos_table [4][2] = {
  {9.807852804032304306e-01, 1.854693999782500573e-17},
  {9.238795325112867385e-01, 1.764504708433667706e-17},
  {8.314696123025452357e-01, 1.407385698472802389e-18},
  {7.071067811865475727e-01, -4.833646656726456726e-17}
};

/* Computes sin(a) using Taylor series.
   Assumes |a| <= pi/32.                           */
static dd_real sin_taylor(const dd_real &a) {
  const double thresh = 0.5 * qd_fabs(to_double(a)) * dd_real::_eps;
  dd_real r, s, t, x;

  if (a.is_zero()) {
    return 0.0;
  }

  int i = 0;
  x = -sqr(a);
  s = a;
  r = a;
  do {
    r *= x;
    t = r * dd_real(inv_fact[i][0], inv_fact[i][1]);
    s += t;
    i += 2;
  } while (i < n_inv_fact && qd_fabs(to_double(t)) > thresh);

  return s;
}

static dd_real cos_taylor(const dd_real &a) {
  const double thresh = 0.5 * dd_real::_eps;
  dd_real r, s, t, x;

  if (a.is_zero()) {
    return 1.0;
  }

  x = -sqr(a);
  r = x;
  s = 1.0 + mul_pwr2(r, 0.5);
  int i = 1;
  do {
    r *= x;
    t = r * dd_real(inv_fact[i][0], inv_fact[i][1]);
    s += t;
    i += 2;
  } while (i < n_inv_fact && qd_fabs(to_double(t)) > thresh);

  return s;
}

static void sincos_taylor(const dd_real &a, 
                          dd_real &sin_a, dd_real &cos_a) {
  if (a.is_zero()) {
    sin_a = 0.0;
    cos_a = 1.0;
    return;
  }

  sin_a = sin_taylor(a);
  cos_a = sqrt(1.0 - sqr(sin_a));
}


dd_real sin(const dd_real &a) {  

  /* Strategy.  To compute sin(x), we choose integers a, b so that

       x = s + a * (pi/2) + b * (pi/16)

     and |s| <= pi/32.  Using the fact that 

       sin(pi/16) = 0.5 * sqrt(2 - sqrt(2 + sqrt(2)))

     we can compute sin(x) from sin(s), cos(s).  This greatly 
     increases the convergence of the sine Taylor series. */

  if (a.is_zero()) {
    return 0.0;
  }

  // approximately reduce modulo 2*pi
  dd_real z = nint(a / dd_real::_2pi);
  dd_real r = a - dd_real::_2pi * z;

  // approximately reduce modulo pi/2 and then modulo pi/16.
  dd_real t;
  double q = qd_floor(r.x[0] / dd_real::_pi2.x[0] + 0.5);
  t = r - dd_real::_pi2 * q;
  int j = static_cast<int>(q);
  q = qd_floor(t.x[0] / dd_real::_pi16.x[0] + 0.5);
  t -= dd_real::_pi16 * q;
  int k = static_cast<int>(q);
  int abs_k = qd_abs(k);

  if (j < -2 || j > 2) {
    dd_real::error("(dd_real::sin): Cannot reduce modulo pi/2.");
    return dd_real::_nan;
  }

  if (abs_k > 4) {
    dd_real::error("(dd_real::sin): Cannot reduce modulo pi/16.");
    return dd_real::_nan;
  }

  if (k == 0) {
    switch (j) {
      case 0:
        return sin_taylor(t);
      case 1:
        return cos_taylor(t);
      case -1:
        return -cos_taylor(t);
      default:
        return -sin_taylor(t);
    }
  }

  dd_real u(cos_table[abs_k-1][0], cos_table[abs_k-1][1]);
  dd_real v(sin_table[abs_k-1][0], sin_table[abs_k-1][1]);
  dd_real sin_t, cos_t;
  sincos_taylor(t, sin_t, cos_t);
  if (j == 0) {
    if (k > 0) {
      r = u * sin_t + v * cos_t;
    } else {
      r = u * sin_t - v * cos_t;
    }
  } else if (j == 1) {
    if (k > 0) {
      r = u * cos_t - v * sin_t;
    } else {
      r = u * cos_t + v * sin_t;
    }
  } else if (j == -1) {
    if (k > 0) {
      r = v * sin_t - u * cos_t;
    } else if (k < 0) {
      r = -u * cos_t - v * sin_t;
    }
  } else {
    if (k > 0) {
      r = -u * sin_t - v * cos_t;
    } else {
      r = v * cos_t - u * sin_t;
    }
  }

  return r;
}

dd_real cos(const dd_real &a) {

  if (a.is_zero()) {
    return 1.0;
  }

  // approximately reduce modulo 2*pi
  dd_real z = nint(a / dd_real::_2pi);
  dd_real r = a - z * dd_real::_2pi;

  // approximately reduce modulo pi/2 and then modulo pi/16
  dd_real t;
  double q = qd_floor(r.x[0] / dd_real::_pi2.x[0] + 0.5);
  t = r - dd_real::_pi2 * q;
  int j = static_cast<int>(q);
  q = qd_floor(t.x[0] / dd_real::_pi16.x[0] + 0.5);
  t -= dd_real::_pi16 * q;
  int k = static_cast<int>(q);
  int abs_k = qd_abs(k);

  if (j < -2 || j > 2) {
    dd_real::error("(dd_real::cos): Cannot reduce modulo pi/2.");
    return dd_real::_nan;
  }

  if (abs_k > 4) {
    dd_real::error("(dd_real::cos): Cannot reduce modulo pi/16.");
    return dd_real::_nan;
  }

  if (k == 0) {
    switch (j) {
      case 0:
        return cos_taylor(t);
      case 1:
        return -sin_taylor(t);
      case -1:
        return sin_taylor(t);
      default:
        return -cos_taylor(t);
    }
  }

  dd_real sin_t, cos_t;
  sincos_taylor(t, sin_t, cos_t);
  dd_real u(cos_table[abs_k-1][0], cos_table[abs_k-1][1]);
  dd_real v(sin_table[abs_k-1][0], sin_table[abs_k-1][1]);

  if (j == 0) {
    if (k > 0) {
      r = u * cos_t - v * sin_t;
    } else {
      r = u * cos_t + v * sin_t;
    }
  } else if (j == 1) {
    if (k > 0) {
      r = - u * sin_t - v * cos_t;
    } else {
      r = v * cos_t - u * sin_t;
    }
  } else if (j == -1) {
    if (k > 0) {
      r = u * sin_t + v * cos_t;
    } else {
      r = u * sin_t - v * cos_t;
    }
  } else {
    if (k > 0) {
      r = v * sin_t - u * cos_t;
    } else {
      r = - u * cos_t - v * sin_t;
    }
  }

  return r;
}

void sincos(const dd_real &a, dd_real &sin_a, dd_real &cos_a) {

  if (a.is_zero()) {
    sin_a = 0.0;
    cos_a = 1.0;
    return;
  }

  // approximately reduce modulo 2*pi
  dd_real z = nint(a / dd_real::_2pi);
  dd_real r = a - dd_real::_2pi * z;

  // approximately reduce module pi/2 and pi/16
  dd_real t;
  double q = qd_floor(r.x[0] / dd_real::_pi2.x[0] + 0.5);
  t = r - dd_real::_pi2 * q;
  int j = static_cast<int>(q);
  int abs_j = qd_abs(j);
  q = qd_floor(t.x[0] / dd_real::_pi16.x[0] + 0.5);
  t -= dd_real::_pi16 * q;
  int k = static_cast<int>(q);
  int abs_k = qd_abs(k);

  if (abs_j > 2) {
    dd_real::error("(dd_real::sincos): Cannot reduce modulo pi/2.");
    cos_a = sin_a = dd_real::_nan;
    return;
  }

  if (abs_k > 4) {
    dd_real::error("(dd_real::sincos): Cannot reduce modulo pi/16.");
    cos_a = sin_a = dd_real::_nan;
    return;
  }

  dd_real sin_t, cos_t;
  dd_real s, c;

  sincos_taylor(t, sin_t, cos_t);

  if (abs_k == 0) {
    s = sin_t;
    c = cos_t;
  } else {
    dd_real u(cos_table[abs_k-1][0], cos_table[abs_k-1][1]);
    dd_real v(sin_table[abs_k-1][0], sin_table[abs_k-1][1]);

    if (k > 0) {
      s = u * sin_t + v * cos_t;
      c = u * cos_t - v * sin_t;
    } else {
      s = u * sin_t - v * cos_t;
      c = u * cos_t + v * sin_t;
    }
  }

  if (abs_j == 0) {
    sin_a = s;
    cos_a = c;
  } else if (j == 1) {
    sin_a = c;
    cos_a = -s;
  } else if (j == -1) {
    sin_a = -c;
    cos_a = s;
  } else {
    sin_a = -s;
    cos_a = -c;
  }
  
}

dd_real atan(const dd_real &a) {
  return atan2(a, dd_real(1.0));
}

dd_real atan2(const dd_real &y, const dd_real &x) {
  /* Strategy: Instead of using Taylor series to compute 
     arctan, we instead use Newton's iteration to solve
     the equation

        sin(z) = y/r    or    cos(z) = x/r

     where r = sqrt(x^2 + y^2).
     The iteration is given by

        z' = z + (y - sin(z)) / cos(z)          (for equation 1)
        z' = z - (x - cos(z)) / sin(z)          (for equation 2)

     Here, x and y are normalized so that x^2 + y^2 = 1.
     If |x| > |y|, then first iteration is used since the 
     denominator is larger.  Otherwise, the second is used.
  */

  if (x.is_zero()) {
    
    if (y.is_zero()) {
      /* Both x and y is zero. */
      dd_real::error("(dd_real::atan2): Both arguments zero.");
      return dd_real::_nan;
    }

    return (y.is_positive()) ? dd_real::_pi2 : -dd_real::_pi2;
  } else if (y.is_zero()) {
    return (x.is_positive()) ? dd_real(0.0) : dd_real::_pi;
  }

  if (x == y) {
    return (y.is_positive()) ? dd_real::_pi4 : -dd_real::_3pi4;
  }

  if (x == -y) {
    return (y.is_positive()) ? dd_real::_3pi4 : -dd_real::_pi4;
  }

  dd_real r = sqrt(sqr(x) + sqr(y));
  dd_real xx = x / r;
  dd_real yy = y / r;

  /* Compute double precision approximation to atan. */
  dd_real z = qd_atan2(to_double(y), to_double(x));
  dd_real sin_z, cos_z;

  if (qd_fabs(xx.x[0]) > qd_fabs(yy.x[0])) {
    /* Use Newton iteration 1.  z' = z + (y - sin(z)) / cos(z)  */
    sincos(z, sin_z, cos_z);
    z += (yy - sin_z) / cos_z;
  } else {
    /* Use Newton iteration 2.  z' = z - (x - cos(z)) / sin(z)  */
    sincos(z, sin_z, cos_z);
    z -= (xx - cos_z) / sin_z;
  }

  return z;
}

dd_real tan(const dd_real &a) {
  dd_real s, c;
  sincos(a, s, c);
  return s/c;
}

dd_real asin(const dd_real &a) {
  dd_real abs_a = abs(a);

  if (abs_a > 1.0) {
    dd_real::error("(dd_real::asin): Argument out of domain.");
    return dd_real::_nan;
  }

  if (abs_a.is_one()) {
    return (a.is_positive()) ? dd_real::_pi2 : -dd_real::_pi2;
  }

  return atan2(a, sqrt(1.0 - sqr(a)));
}

dd_real acos(const dd_real &a) {
  dd_real abs_a = abs(a);

  if (abs_a > 1.0) {
    dd_real::error("(dd_real::acos): Argument out of domain.");
    return dd_real::_nan;
  }

  if (abs_a.is_one()) {
    return (a.is_positive()) ? dd_real(0.0) : dd_real::_pi;
  }

  return atan2(sqrt(1.0 - sqr(a)), a);
}
 
dd_real sinh(const dd_real &a) {
  if (a.is_zero()) {
    return 0.0;
  }

  if (abs(a) > 0.05) {
    dd_real ea = exp(a);
    return mul_pwr2(ea - inv(ea), 0.5);
  }

  /* since a is small, using the above formula gives
     a lot of cancellation.  So use Taylor series.   */
  dd_real s = a;
  dd_real t = a;
  dd_real r = sqr(t);
  double m = 1.0;
  double thresh = qd_fabs((to_double(a)) * dd_real::_eps);

  do {
    m += 2.0;
    t *= r;
    t /= (m-1) * m;

    s += t;
  } while (abs(t) > thresh);

  return s;

}

dd_real cosh(const dd_real &a) {
  if (a.is_zero()) {
    return 1.0;
  }

  dd_real ea = exp(a);
  return mul_pwr2(ea + inv(ea), 0.5);
}

dd_real tanh(const dd_real &a) {
  if (a.is_zero()) {
    return 0.0;
  }

  if (qd_fabs(to_double(a)) > 0.05) {
    dd_real ea = exp(a);
    dd_real inv_ea = inv(ea);
    return (ea - inv_ea) / (ea + inv_ea);
  } else {
    dd_real s, c;
    s = sinh(a);
    c = sqrt(1.0 + sqr(s));
    return s / c;
  }
}

void sincosh(const dd_real &a, dd_real &s, dd_real &c) {
  if (qd_fabs(to_double(a)) <= 0.05) {
    s = sinh(a);
    c = sqrt(1.0 + sqr(s));
  } else {
    dd_real ea = exp(a);
    dd_real inv_ea = inv(ea);
    s = mul_pwr2(ea - inv_ea, 0.5);
    c = mul_pwr2(ea + inv_ea, 0.5);
  }
}

dd_real asinh(const dd_real &a) {
  return log(a + sqrt(sqr(a) + 1.0));
}

dd_real acosh(const dd_real &a) {
  if (a < 1.0) {
    dd_real::error("(dd_real::acosh): Argument out of domain.");
    return dd_real::_nan;
  }

  return log(a + sqrt(sqr(a) - 1.0));
}

dd_real atanh(const dd_real &a) {
  if (abs(a) >= 1.0) {
    dd_real::error("(dd_real::atanh): Argument out of domain.");
    return dd_real::_nan;
  }

  return mul_pwr2(log((1.0 + a) / (1.0 - a)), 0.5);
}

QD_API dd_real fmod(const dd_real &a, const dd_real &b) {
  dd_real n = aint(a / b);
  return (a - b * n);
}