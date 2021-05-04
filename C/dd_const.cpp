/*
 * src/dd_const.cc
 *
 * This work was supported by the Director, Office of Science, Division
 * of Mathematical, Information, and Computational Sciences of the
 * U.S. Department of Energy under contract number DE-AC03-76SF00098.
 *
 * Copyright (c) 2000-2007
 */
#include "qd_config.h"
#include "dd_real.h"

dd_real dd_real::_2pi;
dd_real dd_real::_pi;
dd_real dd_real::_pi2;
dd_real dd_real::_pi4;
dd_real dd_real::_3pi4;
dd_real dd_real::_e;
dd_real dd_real::_log2;
dd_real dd_real::_log10;
dd_real dd_real::_nan;
dd_real dd_real::_inf;
dd_real dd_real::_max;
dd_real dd_real::_safe_max;
dd_real dd_real::_pi16;
const double dd_real::_eps = 4.93038065763132e-32;  // 2^-104
const double dd_real::_min_normalized = 2.0041683600089728e-292;  // = 2^(-1022 + 53)
const int dd_real::_ndigits = 31;


