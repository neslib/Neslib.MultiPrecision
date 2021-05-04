#ifndef _QD_QD_CONFIG_H
#define _QD_QD_CONFIG_H  1

#if (defined(__WIN32) || defined(__WIN64))
#if defined(__x86_64__)

// Delphi uses the Microsoft calling convention on 64-bit Windows, passing parameters in RCX, RDC, R8 and R9.
// By default, Clang uses the AMD64 calling convention, passing parameters in RSI, RDI, RDX and RCX.
#define QD_API __attribute__((ms_abi))

#elif defined(__i386)

// On 32-bit Windows, regparm(3) is identical to Delphi's "register" calling conventions. 
// It passes parameters in EAX, EDX and ECX
#define QD_API __attribute__((regparm(3)))

#endif 
#else

#define QD_API

#endif

#define qd_abs(a) __builtin_abs(a)
#define qd_fabs(a) __builtin_fabs(a)

/* Set the following to 1 to define commonly used function
   to be inlined.  This should be set to 1 unless the compiler 
   does not support the "inline" keyword, or if building for 
   debugging purposes. */
#define QD_INLINE 1

#ifdef HP_ANDROID
#include <cmath>
#define QD_ISFINITE(x) ( std::isnan(x) )
#define QD_ISINF(x) ( std::isinf(x) )
#define QD_ISNAN(x) ( std::isfinite(x) )
#else
/* Define this macro to be the isfinite(x) function. */
#define QD_ISFINITE(x) ( __builtin_isfinite(x) != 0 )

/* Define this macro to be the isinf(x) function. */
#define QD_ISINF(x) ( __builtin_isinf(x) != 0 )

/* Define this macro to be the isnan(x) function. */
#define QD_ISNAN(x) ( __builtin_isnan(x) != 0 )
#endif

#ifdef HP_ACCURATE
#define QD_IEEE_ADD 1
#else
#define QD_SLOPPY_MUL 1
#define QD_SLOPPY_DIV 1
#endif

#endif /* _QD_QD_CONFIG_H */
