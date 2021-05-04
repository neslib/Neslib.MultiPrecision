/*
 * src/qd_const.cc
 *
 * This work was supported by the Director, Office of Science, Division
 * of Mathematical, Information, and Computational Sciences of the
 * U.S. Department of Energy under contract number DE-AC03-76SF00098.
 *
 * Copyright (c) 2000-2001
 *
 * Defines constants used in quad-double package.
 */
#include "qd_config.h"
#include "qd_real.h"

/* Some useful constants. */
qd_real qd_real::_2pi;
qd_real qd_real::_pi;
qd_real qd_real::_pi2;
qd_real qd_real::_pi4;
qd_real qd_real::_3pi4;
qd_real qd_real::_e;
qd_real qd_real::_log2;
qd_real qd_real::_log10;
qd_real qd_real::_nan;
qd_real qd_real::_inf;

qd_real qd_real::_max;
qd_real qd_real::_safe_max;
qd_real qd_real::_pi1024;

const double qd_real::_eps = 1.21543267145725e-63; // = 2^-209
const double qd_real::_min_normalized = 1.6259745436952323e-260; // = 2^(-1022 + 3*53)

const int qd_real::_ndigits = 62;

