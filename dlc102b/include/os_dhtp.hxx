/*****************************************************************/
/* Copyright (c) 1984-2007 by Progress Software Corporation      */
/*                                                               */
/* All rights reserved.  No part of this program or document     */
/* may be  reproduced in  any form  or by  any means without     */
/* permission  in  writing  from  Progress Software Corporation. */
/*****************************************************************/

#ifndef	os_dhtp_included
#define	os_dhtp_included

/* These are the maximum values for single-byte, */
/* double-byte, and utf8 character sets.         */

#define DH_SINGLE_BYTE_CHAR_MAX              127  /* x7F */

#define DH_DOUBLE_BYTE_LEAD_MAX              254  /* xFE */
#define DH_DOUBLE_BYTE_TRAIL_MAX             254  /* xFE */

#define DH_UTF8_2B_LEAD_MAX                  223  /* xDF */
#define DH_UTF8_2B_TRAIL_MAX                 191  /* xBF */

#define DH_UTF8_3B_LEAD_MAX                  239  /* xEF */
#define DH_UTF8_3B_TRAIL1_MAX                191  /* xBF */
#define DH_UTF8_3B_TRAIL2_MAX                191  /* xBF */

#define DH_UTF8_4B_LEAD_MAX                  244  /* xF4 */
#define DH_UTF8_4B_TRAIL1_MAX                143  /* x8F */
#define DH_UTF8_4B_TRAIL2_MAX                191  /* xBF */
#define DH_UTF8_4B_TRAIL3_MAX                191  /* xBF */


#if (defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
#include   "tchar.h"
#endif
                                                                               
#if defined (c_plusplus) && !defined (__cplusplus)
#define	__cplusplus
#endif

#if !defined (c_plusplus) && defined (__cplusplus)
#define	c_plusplus
#endif

#if defined (__cplusplus)
extern          "C"
{
#endif

#if !defined (__cplusplus)
#define	inline static
#endif

#if (defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
#include <tchar.h>
#include <float.h>
#endif

#if !(defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
#include   <values.h>
#include   <limits.h>
#endif


#include <stdio.h>
#include <time.h>
#include <sys/types.h>

#if defined(DH_OS_UNIX_SOLARIS)

#if (__SUNPRO_CC >= 0x500) 
#define STATIC_CAST(type, expr)  static_cast<type>(expr)
#else/* old solaris compiler doesn't support static cast */
#define STATIC_CAST(type, expr)  ((type)(expr))
#endif

#else  /* define Non Solaris static cast support */

#if defined(DH_OS_UNIX_HP) || \
  (defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
#define STATIC_CAST(type, expr)  static_cast<type>(expr)
#else
/* AIX & ALPHA do not support the new style casting on all its platforms yet */
#define STATIC_CAST(type, expr)  ((type)(expr))
#endif

#endif 


#if !(defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
#define DH_LONGLONG_SUPPORT
#endif

/* Definitions for specific  data types.  */

/* specific long long data type */
#ifdef DH_LONGLONG_SUPPORT
#if defined(DH_OS_UNIX_64)
typedef   long             dh_longlong_t;
#else
typedef   long long             dh_longlong_t;
#endif
#endif


#ifdef DH_LONGLONG_SUPPORT
#if defined(DH_OS_UNIX_64)
typedef   long              dh_i64_t;
#else
typedef   long long         dh_i64_t;
#endif
#else
typedef   __int64           dh_i64_t;
#endif

typedef   char    		dh_i8_t;
typedef   unsigned char 	dh_u8_t;
typedef   short    		dh_i16_t;

#if defined(DH_OS_UNIX_64)
typedef   int    	dh_i32_t;
#else
typedef   long    	dh_i32_t;
#endif

typedef   long    	        dh_long_t;
typedef   float    		dh_f32_t;
typedef   double   		dh_f64_t;

typedef   unsigned short   	dh_u16_t;

#if defined(DH_OS_UNIX_64)
typedef   unsigned int    	dh_u32_t;
#else
typedef   unsigned long    	dh_u32_t;
#endif

typedef   unsigned char    	dh_boolean;

typedef	  FILE			dh_file_t ;

/*	DS_19960412_472 BEGIN
	A new variable dh_os_time_t is type defined as time_t
*/
typedef   time_t		dh_os_time_t ;
/*
	DS_19960412_472 END
*/

/* Large-file(>2GB) support */    
#if (defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
typedef __int64         dh_off_t;
#else /* UNIX */
typedef off_t           dh_off_t;
#endif

/* 
 * UNICODE related definitions for character data type.
*/

#if (defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
typedef   _TCHAR             	dh_char_t;
typedef   _TUCHAR		dh_uchar_t;
#else

#ifndef DH_UNICODE
typedef   char 			dh_char_t;
typedef   unsigned char 	dh_uchar_t;
#else
typedef   wchar_t             	dh_char_t;
typedef   unsigned wchar_t    	dh_uchar_t;
#endif

#endif


/*
 * Data type range definitions
*/

/*
 * DS_19960624_552 START 
 * The range of system dependent data types are actually defined  in
 * \include\limits.h or \include\float.h. The range of these data 
 * types may vary from one system to another. Instead of hard 
 * coding the range of the data types, their range should 
 * be set to the defined value of the corresponding system data type
 * which it maps to.
 */

#ifdef SCHAR_MIN
	#define   DH_MIN_I8      SCHAR_MIN
#else
	#define   DH_MIN_I8      -128
#endif

#ifdef SCHAR_MAX
	#define   DH_MAX_I8      SCHAR_MAX
#else
	#define   DH_MAX_I8      127
#endif


#ifdef SHRT_MIN
	#define   DH_MIN_I16    SHRT_MIN
#else
	#define   DH_MIN_I16    -32768
#endif

#ifdef SHRT_MAX
	#define   DH_MAX_I16     SHRT_MAX 
#else
	#define   DH_MAX_I16     32767
#endif


#ifdef INT_MIN
	#define   DH_MIN_I32    INT_MIN	
#else
	#define   DH_MIN_I32    ((-2147483647L) - 1L)
#endif

#ifdef INT_MAX 
	#define   DH_MAX_I32    INT_MAX
#else
	#define   DH_MAX_I32    2147483647L
#endif

#if (defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
/* max and min values for I64  begin */
#ifdef LLONG_MAX
        #define   DH_MAX_I64    LLONG_MAX
#else
        #define   DH_MAX_I64    9223372036854775807
#endif

#ifdef LLONG_MIN
        #define   DH_MIN_I64    LLONG_MIN
#else
        #define   DH_MIN_I64    -9223372036854775808
#endif
/* max and min values for I64  end   */                        
#endif

#if defined(DH_OS_UNIX_AIX)
/* max and min values for I64  begin */
#ifdef LONGLONG_MAX 
	#define   DH_MAX_I64    LONGLONG_MAX
#else
	#define   DH_MAX_I64    9223372036854775807 
#endif

#ifdef LONGLONG_MIN 
	#define   DH_MIN_I64    LONGLONG_MIN
#else
	#define   DH_MIN_I64    -9223372036854775808 
#endif
/* max and min values for I64  end */
#endif



#if defined(DH_OS_UNIX_ALPHAOSF) || defined(DH_OS_UNIX_SOLARIS) || \
    defined(DH_OS_UNIX_UNIX486V4)
/* max and min values for I64  begin */
#ifdef LLONG_MAX 
	#define   DH_MAX_I64    LLONG_MAX
#else
	#define   DH_MAX_I64    9223372036854775807 
#endif

#ifdef LLONG_MIN 
	#define   DH_MIN_I64    LLONG_MIN
#else
	#define   DH_MIN_I64    -9223372036854775808 
#endif
/* max and min values for I64  end */
#endif



#if defined(DH_OS_UNIX_HP)
/* max and min values for I64  begin */
#ifdef LONG_LONG_MAX 
	#define   DH_MAX_I64    LONG_LONG_MAX
#else
	#define   DH_MAX_I64    9223372036854775807 
#endif

#ifdef LONG_LONG_MIN 
	#define   DH_MIN_I64    LONG_LONG_MIN
#else
	#define   DH_MIN_I64    -9223372036854775808 
#endif
/* max and min values for I64  end */
#endif

#if defined(DH_OS_UNIX_LINUXX86) || defined(DH_OS_UNIX_ULINUXX86)
#if defined(DH_OS_UNIX_ULINUXX86)
/* max and min values for I64  begin */
#include <stdint.h>
#endif
#ifdef LLONG_MAX
        #define   DH_MAX_I64    LLONG_MAX
#else
        #define   DH_MAX_I64    9223372036854775807LL 
#endif

#ifdef LLONG_MIN
        #define   DH_MIN_I64    LLONG_MIN
#else
        #define   DH_MIN_I64    -9223372036854775808LL 
#endif
      /* max and min values for I64  end */
#endif



#ifdef  FLT_MIN                 
	#define   DH_MIN_F32    FLT_MIN 	
#else
	#define   DH_MIN_F32    1.175494351E-38F
#endif

#ifdef FLT_MAX
	#define   DH_MAX_F32    FLT_MAX	
#else
	#define   DH_MAX_F32    3.402823466E+38F
#endif


#ifdef  DBL_MIN
	#define   DH_MIN_F64    DBL_MIN
#else
	#define   DH_MIN_F64    2.2250738585072014E-308
#endif


#ifdef  DBL_MAX
	#define   DH_MAX_F64    DBL_MAX	
#else
	#define   DH_MAX_F64    1.7976931348623157E+308
#endif

/*  DS_19960624_522 END */

/* 
 * UNICODE related definitions for literals.
*/

#if (defined(DH_OS_WINNT) || defined(DH_OS_WIN95))
#define DH_PSTRING_LITERAL(string_lit)  _T(string_lit)
#define DH_STRING_LITERAL(string_lit)   _T(string_lit)
#define DH_CHAR_LITERAL(char_lit)       _T(char_lit)
#else

#ifndef DH_UNICODE
#define DH_PSTRING_LITERAL(string_lit)  (dh_char_t *)string_lit
#define DH_STRING_LITERAL(string_lit)   string_lit
#define DH_CHAR_LITERAL(char_lit)       char_lit
#else
#define DH_PSTRING_LITERAL(string_lit)  (dh_char_t *)Lstring_lit
#define DH_STRING_LITERAL(string_lit)   Lstring_lit
#define DH_CHAR_LITERAL(char_lit)       char_lit
#endif 

#endif

/* 
 * UNICODE related definitions for null terminator.
*/

#define DH_NULLTERM_SZ          sizeof(dh_char_t)

#define DH_VOIDSTAR_SZ 		sizeof(void *)

/* Support for IP protocol versions passed from broker to 
 * server.
 */
typedef enum {
    DH_IPVER_IPV4 = 0,
    DH_IPVER_IPV6,
    DH_IPVER_IPV4ONLY,         /* qa purposes, force only v4 connections */
    DH_IPVER_IPV6ONLY          /* qa purposes, force only v6 connections */
} dh_ip_family_t;


#if defined (__cplusplus)
}				/* extern "C" */

#endif
#endif

