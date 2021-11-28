/*****************************************************************/
/* Copyright (c) 1984-2010 by Progress Software Corporation      */
/*                                                               */
/* All rights reserved.  No part of this program or document     */
/* may be  reproduced in  any form  or by  any means without     */
/* permission  in  writing  from  Progress Software Corporation. */
/*****************************************************************/

/*
	We have expanded the sqlda and sqlca objects to handle larger 
	sizes of databases and the data within them.

	Temporarily we are using SQL_BIG_SQLDA as a compile time switch 
	to allow both the old and the new structures to exist.  Once we
	have completely switched over, we can get rid of the old code
	and make this file somewhat simpler.
*/

#ifndef		sql_lib_included
#define		sql_lib_included
 
/* Force SQL_BIG_SQLDA to be define for everyone */
#ifndef SQL_BIG_SQLDA
#define SQL_BIG_SQLDA 1
#endif

#include <stdio.h> 
#include <stddef.h>
#include "os_dhtp.hxx" 

#ifdef  DH_OS_MSWIN

#ifndef EXPORT
#define EXPORT __export
#endif
#else /* MSWIN */
#if defined (DH_OS_WINNT) || defined (DH_OS_WIN95)
#define EXPORT __declspec(dllexport)
#else /* Winnt / Win95 */

#ifndef EXPORT
#define EXPORT 
#else
#undef EXPORT
#define EXPORT
#endif
#endif /* Winnt / Win95 */
#endif /* MSWIN */

#define TPE_MAX_THREADS 100

/*
 * enumerated type for procedure arguments (input arg or input/output arg) 
 */
typedef enum  {
    INPUT_PARAM,
    INPUT_OUTPUT_PARAM,
    OUTPUT_PARAM,
    NONE_PARAM
} proc_argtype_t ;


typedef		void	   *tpe_db_hdl_t ;
typedef		void	   *tpe_cursor_t ;
typedef		void	   *tpe_tm_hdl_t ;

typedef         void       *tpe_tm_xid_t ;

typedef  dh_i32_t tpe_status_t  ;

typedef struct {
     dh_u32_t time_high ; 
     dh_u16_t time_low ; 
     dh_u16_t reserved ; 
     dh_char_t family ; 
     dh_char_t host1 ; 
     dh_char_t host2 ; 
     dh_char_t host3 ; 
     dh_char_t host4 ; 
     dh_char_t host5 ; 
     dh_char_t host6 ; 
     dh_char_t host7 ; 
} tpe_uuid__t  ;


/* Attach to a database */

typedef enum {
    SQL_ATTACH_REMOTE, /* for attaching to a remote database */
    SQL_ATTACH_LOCAL   /* for attaching to a local database  */
} tpe_attachtype_t ; 

typedef enum {
    SQL_COMPAT_ANSI    /* ANSI SQL compatibility. */
} tpe_sqlcompat_t ;

typedef enum {
	SQL_DISCONNECT_CONNECTION,
	SQL_DISCONNECT_ALL,
	SQL_DISCONNECT_DEFAULT,
	SQL_DISCONNECT_CURRENT
} tpe_discon_sp_t;

typedef struct {
       /* 
        * In case data members in cost_card_t or cost_time_t are changed  to 
        * type other than dh_u32_t, these also should be changed .
        */	
/* DC118 BEGIN

	dh_u32_t cost;
	dh_u32_t card; */

	dh_f64_t cost;
	dh_f64_t card;

/* DC118 END */
	dh_i32_t treesize;
        dh_i32_t rss_calls;
} cost_val_t ;
	
/* DC317
 *
 * The following is used for all variables and function arguments that
 * hold length (in bytes) of a data object.  It is also used for variables
 * that hold a (byte) position within a data object.
 * 
 * Correspondingly, there is a similar typedef for character (not byte)
 * lengths and positions in objects.
 *
 * Both of these are unsigned because they are lengths and it makes no
 * sense to have a negative length.
 */

typedef dh_i32_t pro_DataLengthBytes_t;
typedef dh_i32_t pro_DataLengthChars_t;


#if defined (__cplusplus)
extern "C" {
#endif


/* (DC044) .BEGIN */
/* enhanced sqlca data structure to contain the sql-92 diagnostics
 * informations
 */

#define PROSQL_MAX_ERRMSG_LEN 512

struct sqlca {
        dh_char_t       sqlcaid[8] ;
        dh_i32_t        sqlcabc ;
        dh_i32_t        sqlcode ;
        dh_u32_t        sqlerrml ;
        dh_char_t       sqlerrm[PROSQL_MAX_ERRMSG_LEN] ; /* SQLDA size chg, PWW, was 250 */
        dh_char_t       sqlerrp[8] ;
        dh_u32_t        sqlerrd[8];              /* SQLDA size chg, PWW, was dh_i32_t */
        dh_char_t       sqlwarn[8] ;
        dh_char_t       sqlext[8] ;
        cost_val_t      estimated_cost,          /* estimated cost information */
                        actual_cost;             /* actual cost information */
        dh_i32_t        number ;
        dh_char_t       more[1];
        dh_char_t       command_function[128] ;
        dh_char_t       dynamic_function[128] ;

        dh_i32_t        condition_number ;
        dh_char_t       returned_sqlstate[6] ;
        dh_char_t       class_origin[128] ;
        dh_char_t       subclass_origin[250] ;
        dh_char_t       table_name[128] ;
        dh_char_t       column_name[128] ;
} ;

typedef struct  sqlca dh_sqlca_t ;

/*
 * sqlca and SQLCODE shoud be defined in the TPE application, 
 * e.g., in isqlmain, syscreat etc
 */


extern	struct	sqlca sqlca ;
extern  dh_i32_t	SQLCODE;
extern dh_char_t  SQLSTATE[6];

#define DIAG_MAX_CONDNUM  1L
#define DIAG_MAX_DIAGVAR  19
#define  DIAG_MAX_DETAIL_AREA 1
#define  DIAG_MIN_HEADER_INFONUM   0
#define  DIAG_MAX_HEADER_INFONUM   4
#define  DIAG_MIN_DETAIL_INFONUM   5
#define  DIAG_MAX_DETAIL_INFONUM   15


typedef enum {
	    NUMCOND,
	    MORE_KW,
	    CMD_FUNC,
	    DYN_FUNC,
	    ROW_CNT,
	    CONDNUM,
	    RET_STATE,
	    CLS_ORG,
	    SCLS_ORG,
	    TBL_NAME,
	    CLM_NAME,
	    MSG_TXT,
	    MSG_LTH,
	    SQCD,
	    SQWN,
	    EST_COST,
	    ACT_COST,
	    POSN,
	    FET_CNT
	  } diag_kwd_t;

/*  (DC044) .END */

/* DC065 .BEGIN. */

/* DC317 - ???BUG - should any of the sqlda members use the new
           pro_DataLengthBytes_t datatypes???
*/

/* SQLDA size chg, PWW, the sqlda struct has undergone massive changes
	These are two fold: 1) many of the element sizes have been increased
    and 2) we added accessor functions for accessing the sqlda (see below)
	The whole change is being done in 2 phases. Phase 1 does the above so
	that both the structure and the functions are usable for setting and 
	getting sqlda values.  With phase 2, the structure will be made opaque
	and only the functions will be able to access the sqlda data.

	In the following code, we use the word DEPRECATED.  When this is used,
	we mean that the item in question will not be supported in the next
	release.  It is currently supported to give you a chance to convert 
	your code.  In the next release, it will be taken from this file so
	your program will no longer compile.  If you try use an already compiled
	program, it will either give a runtime error or just not do what you
	were hoping it would.
*/

struct sqlda {
 	dh_i32_t    sqld_size;             /* da,  DEPRECATED, max # cols in da */
 	dh_i32_t    sqld_nvars;            /* da,  DEPRECATED, actual/desired # cols */        
 	void      **sqld_varptrs;          /* col, ptr to data buffer  */  
 	dh_u32_t   *sqld_lengths;          /* col, size (bytes) of data in col as bin (+1 if char data) */ 
 	dh_i32_t   *sqld_types;            /* col, data type */
 	dh_u32_t   *sqld_precision;        /* col, size (chars) of data in col as char */
 	dh_i16_t   *sqld_scale;            /* col, decimal digits to right of DP */
 	dh_u32_t   *sqld_flags;            /* col, col allows nulls */
 	dh_i32_t  **sqld_ivarptrs;         /* col, ptr to indicator data (sz,null) */
 	dh_i16_t    sqld_varnmsize;        /* da,  max size (bytes) data col name */
 	dh_i16_t    sqld_indvarnmsz;       /* da,  DEPRECATED, max size (bytes) of indicator name */
 	dh_char_t **sqld_varnames;         /* col, ptr to user's data col name */
 	dh_char_t **sqld_indvarnames;      /* col, DEPRECATED, ptr to user's indicator name */
 	dh_u32_t    sqld_arraysz;          /* da,  # rows in multi-row operation */
	dh_u32_t   *sqld_clengths;         /* col, actual data size in chars */
	dh_u32_t   *sqld_returned_lengths; /* col, dictionary size of col */
	dh_u32_t   *sqld_odbc_flags;       /* col, ODBC flags: AUTO, SIGN, UNNAMED, etc */
 	dh_i16_t   *sqld_date_int_code;    /* col, DEPRECATED, internal date code */
 	dh_i16_t   *sqld_date_int_prec;    /* col, DEPRECATED, # seconds digits to right of DP */
 	dh_char_t **sqld_collat_name;  	   /* col, collation sequence name */
 	dh_char_t **sqld_charset_name;     /* col, charset name */
 	dh_i32_t    sqld_max_size;         /* da,  DEPRECATED, Max # cols in da */
 	dh_char_t **sqld_base_column_name; /* col, base column name */
 	dh_char_t **sqld_base_table_name;  /* col, base table name */
 	dh_i16_t   *sqld_searchable;       /* col, col is searchable (where clause) */
 	dh_i16_t   *sqld_updatable;        /* col, col is updateable (insert, update, etc.) */
	dh_i16_t   *sqld_param_type;       /* col, param is in, out, or inout */
	dh_char_t **sqld_table_name;       /* col, table name */
	dh_i16_t   *sqld_verbose_types;    /* col, DEPRECATED, MS SQL Extension for dates */
	dh_u32_t    sqld_v0;               /* opaque */
	dh_u32_t    sqld_v1;               /* opaque */
	dh_u32_t    sqld_v2;               /* opaque */
	dh_u32_t    sqld_v3;               /* opaque */
    dh_u32_t    sqld_v7;               /* opaque */
    dh_u32_t    sqld_v8;               /* opaque */
 };

/* these states are returned when you ask for the PRO_SQLDA_DA_ATTR_STATE value */
/* Remember: do not change the order of the following enums */

typedef enum sqlda_state {
     PRO_SQLDA_DA_STATE_NONE = 0
    ,PRO_SQLDA_DA_STATE_INITIALIZED
    ,PRO_SQLDA_DA_STATE_QUERY_OPENED
    ,PRO_SQLDA_DA_STATE_DESCRIBED
    ,PRO_SQLDA_DA_STATE_DESCRIBED_PARAM
    ,PRO_SQLDA_DA_STATE_EXECUTED
    ,PRO_SQLDA_DA_STATE_FETCHED
    ,PRO_SQLDA_DA_STATE_CLOSED
    ,PRO_SQLDA_DA_STATE_BEFORE_EXECUTE
    ,PRO_SQLDA_DA_STATE_BEFORE_FETCH
    ,PRO_SQLDA_DA_STATE_ALLOCATED
} sqlda_state_t;

/* the follow define is used when an indicator variable can not hold the invalid size,
   should the indicator variable have this value, you can only get the size via the 
   accessor function.
*/

/* Version numbers of the sqlda structure - set internally by the 
   sql engine, application users should use NONE enum only */
typedef enum sqlda_versionid {
     PRO_SQLDA_VERSIONID_NONE = 0,
     PRO_SQLDA_VERSIONID_DA1 = 1,
     PRO_SQLDA_VERSIONID_BIGDA = 4
} sqlda_versionid_t;


typedef	struct	sqlda sqlda ;

#if defined (DH_SQL_DEFS)
/*
 * Types of nullability for sqlda_flags 
 */
typedef enum  {
	SQL_NO_NULLS,
	SQL_NULLABLE,
	SQL_NULLABLE_UNKNOWN
} tpe_nullability_t ;

#else

typedef enum  {
	P_SQL_NO_NULLS,
	P_SQL_NULLABLE,
	P_SQL_NULLABLE_UNKNOWN
} tpe_nullability_t ;


#endif  /* if defined (DH_SQL_DEFS) */
/* 
For sqld_odbc_flags bit operations
*/

#define ITEM_AUTO	    0x0001	/*AUTO increment flag*/
					/* DEPRECATED, Using AUTO will get you an error */
#define ITEM_SIGN	    0x0002	/*IS_SIGNED flag */
#define ITEM_UNNAMED        0x0004	/*IS_UNNAMED flag */
#define ITEM_CS		    0x0008	/*IS_CASE_SENSITIVITY flag */
  /* SQL92 Engine Enhancement */
#define ITEM_VLEN           0x0010  /*Is item variable length? Allows
					 char/varchar distinction and
					 binary/varbinary distinction. */
					/* DEPRECATED, VLEN will not be set */

  /* Note, for consistency, there should be a corresponding addition
     (for ITEM_VLEN)
     to descr_kwd_t below, as well as changes to sql_fe.cxx,
     sql_gen.cxx, fgl_gram.y, and odbccli.cxx. However, currently we
     choose to support this flag only via direct use of SQLDA, not via
     getdesc/setdesc capability. */
  /* End SQL92 Engine Enhancement */

/* 
An enumerated data type descr_kwd_t consisting of all the
descriptor field names 
*/

typedef enum {
	  COUNT_T,
	  TYPE_T,
	  LEN_T,
	  OCT_LEN_T,
	  RET_LEN_T,
	  PREC_T,
	  SCALE_T,
	  DATE_INT_CODE_T,
	  DATE_INT_PREC_T,
	  NULL_T,
	  NAME_T,
	  UNNAMED_T,
	  COLLAT_NAME_T,
	  CHAR_SET_NAME_T,
	  DAT_T,
	  IND_T,
	  COL_NAME_T,
	  TBL_NAME_T,
	  CS_T,
	  SEARCH_T,
	  UNSIGN_T,
	  UPD_T,
	  PARAM_T,
	  TBL_T,
	  AUTO_T,
	  VERBOSE_T
	}descr_kwd_t;

# define DESC_MAX_VAR 27

/* strcture containing the field and host variable informations */

typedef struct {
	   descr_kwd_t  field_info[DESC_MAX_VAR];  
	   /* DC148 */
	   dh_char_t	** host_info;
	   dh_boolean  is_const[DESC_MAX_VAR];
	   }item_lst;

/* **************************************************************************
*/

/* The functions used to access the SQLDA are defined in the following code.

   These include:

 		PRO_SQLDA_Allocate    (used only by ESQL/C)
		PRO_SQLDA_Deallocate  (used only by ESQL/C)

		PRO_SQLDA_Get_DA_Attribute_* (* -> a data type)
		PRO_SQLDA_Set_DA_Attribute_* (* -> a data type)
		PRO_SQLDA_Get_Col_Attribute_* (* -> a data type)
		PRO_SQLDA_Set_Col_Attribute_* (* -> a data type)

*/

#ifdef __cplusplus
extern "C" { /* extern "C" */
#endif 

#define pro_sqlda sqlda  /* take out when it is an opaque class */

	/*
	// PRO_SQLDA_Allocate allocates memory for a SQLDA that can hold at least 
	//	MaxNumColumns columns of data with variables whose names are
	//	no more than MaxVarNameSize characters long.  The value of MaxVarNameSize
	//	can be 0 when the SQLDA  is used for input.  We will add 1 character to
	//	MaxVarNameSize (internally) for the NULL terminating character.
	//	A NULL (0, zero) return value indicates that memory could not be 
	//	obtained for your SQLDA object.
	//	PRO_SQLDA_Allocate will also allocate all of the internal arrays that
	//	hold SQLDA data.  It will initialize all of the storage to an
	//	appropriate value (usually zero).
	*/

	extern pro_sqlda EXPORT *
		PRO_SQLDA_Allocate(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
		dh_u32_t MaxNumColumns /* aka size */
               ,dh_i16_t MaxVarNameSize
#endif
               );


	/*
	// PRO_SQLDA_Deallocate will return all of the memory PRO_SQLDA_Allocate obtained
	//	for your SQLDA object.  Any memory you allocated for data buffers
	//	and the like, you are responsible for returning prior to the call
	//	to PRO_SQLDA_Deallocate.
	*/

	extern void EXPORT 
		PRO_SQLDA_Deallocate(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
		pro_sqlda *SQLDA
#endif
		);


	/*
	// PRO_SQLDA_Get_DA_Attribute_<dt> returns an attribute value for attributes that
	//	pertain to the overall SQLDA (e.g. not column info).  The function
	//	returns error info in the SQLCA argument. if all is ok, it will 
	//	modify a by-reference argument to hold the value desired.
	//	See the pro_sqlda_da_attribute enumeration for the list of attributes.
        //
	//      Do NOT reassign enum values in pro_sqlda_da_attribute.  It will cause
	//	problems for people who have compiled code and then just link.
        //
        //      Attributes are RO (read only), RW (read/write) or RU (read anytime,
        //      writeable when you are working with an 'update' SQLDA.
	//		
        //      Each attribute has two items in parentheses in the trailing comment.
        //      The first of these is the data of the value gotten or set.  The
        //      second of these is the "old" SQLDA sqld_* structure member name such
        //      as sqld_varptrs or sqld_size.  These were the SQLDA structure member 
        //      names prior to the SQL 92 (.!A FCS product release and are meant to
        //      help with any transitional conversion issues.  The second item does
        //      not apply for new attributes.
	*/

	typedef enum pro_sqlda_da_attribute {
	   /* original sqlda attributes (with amendments) */
            PRO_SQLDA_DA_ATTR_NONE = 0      /*    INVALID */
           ,PRO_SQLDA_DA_ATTR_MAXCOLS = 1   /* RO MaxNumColumns possible (dh_u32_t, sqld_size) */
           ,PRO_SQLDA_DA_ATTR_ACTUALCOLS= 2 /* RW Actual # columns in use (dh_u32_t, sqld_nvars) */
	   ,PRO_SQLDA_DA_ATTR_DESIREDCOLS=3 /* RO Desired # columns (when > MAXCOLS) (dh_u32_t, sqld_nvars) */
	   ,PRO_SQLDA_DA_ATTR_VARNMSIZE = 4 /* RO Size (bytes) of VarName (dh_i16_t, sqld_varnmsize) */
           /* The sqld_indvarnmsz data was never filled in and the attribute is deprecated */
	   ,PRO_SQLDA_DA_ATTR_ARRAYSIZE = 6 /* RW Array Size/MultiRow Fetch (dh_u32_t, sqld_arraysz) */
	   /* The sqld_max_size info is available thru PRO_SQLDA_DA_ATTR_MAXCOLS */
	   /* new sqlda attributes */
           ,PRO_SQLDA_DA_ATTR_VERSION = 7   /* RO sqlda structure version code (dh_u32_t) */
           ,PRO_SQLDA_DA_ATTR_STATE = 8     /* RO sqlda state (dh_u32_t) */
           ,PRO_SQLDA_DA_ATTR_DASIZE = 9    /* RO sqlda structure size (bytes) (dh_u32_t) */
/*         ,PRO_SQLDA_DA_ATTR_NTS = 10 */   /* RW strings are NULL terminated (1/0) */
       /* */
           ,PRO_SQLDA_DA_ATTR_LAST          /*    not valid - used to position */
                                            /*    INTERNAL attributes */
	} pro_sqlda_da_attribute_t;

    
    extern void EXPORT
        PRO_SQLDA_Get_DA_Attribute_dh_u32_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_da_attribute_t DA_Attribute
            ,dh_u32_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Get_DA_Attribute_dh_i16_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_da_attribute_t DA_Attribute
            ,dh_i16_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );


	/*
	// PRO_SQLDA_Set_DA_Attribute_<dt> sets an attribute value for attributes that
	//	pertain to the overall SQLDA (e.g. not column info).  The function
	//	returns error info in the SQLCA argument. if all is ok, it will 
	//	modify the internal data to hold the value of the by-reference argument.
	//	See the pro_sqlda_da_attribute enumeration for the list of attributes.
        //      Not all attributes are setable.
	*/

    extern void EXPORT
        PRO_SQLDA_Set_DA_Attribute_dh_u32_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
              pro_sqlda *SQLDA
             ,pro_sqlda_da_attribute_t DA_Attribute
             ,dh_u32_t Value
             ,dh_sqlca_t *SQLCA
#endif
             );
    
    extern void EXPORT
        PRO_SQLDA_Set_DA_Attribute_dh_i16_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
              pro_sqlda *SQLDA
             ,pro_sqlda_da_attribute_t DA_Attribute
             ,dh_i16_t Value
             ,dh_sqlca_t *SQLCA
#endif
             );

	
	/*
	// PRO_SQLDA_Get_Col_Attribute_<dt> returns an attribute value for attributes that
	//	pertain to a particular column of SQLDA.  The function
	//	returns error info in the SQLCA argument. if all is ok, it will 
	//	modify a by-reference argument to hold the value desired.
	//	See the pro_sqlda_col_attribute enumeration for the list of attributes.
	//
        //      *** Columns in the SQL statement are numbered from 1 (one) to N. ***
	//
	//      Do NOT reassign enum values in pro_sqlda_col_attribute.  It will cause
	//	problems for people who have compiled code and then just link.
        //      
        //      Attributes are RO (read only), RW (read/write) or RU (read anytime,
        //      writeable when you are working with an 'update' SQLDA.
	//		
        //      Each attribute has two items in parentheses in the trailing comment.
        //      The first of these is the data of the value gotten or set.  The
        //      second of these is the "old" SQLDA sqld_* structure member name such
        //      as sqld_varptrs or sqld_size.  These were the SQLDA structure member 
        //      names prior to the SQL 92 (.!A FCS product release and are meant to
        //      help with any transitional conversion issues.  The second item does
        //      not apply for new attributes.
	*/

	typedef enum pro_sqlda_col_attribute {
	   /* original sqlda attributes (with amendments) */
            PRO_SQLDA_COL_ATTR_NONE = 0      /*    INVALID */
           ,PRO_SQLDA_COL_ATTR_VARPTR = 1    /* RW Ptr to Data Buffer (void *, sqld_varptrs) */
           ,PRO_SQLDA_COL_ATTR_LENGTH = 2    /* RU Actual Size (bytes+1) of Data in Buffer (dh_u32_t, sqld_lengths) */
           ,PRO_SQLDA_COL_ATTR_DATATYPE = 3  /* RU Datatype of value in DataBuff (dh_i32_t, sqld_types) */
           ,PRO_SQLDA_COL_ATTR_PRECISION =4  /* RO Precision of value in DataBuff (dh_u32_t, sqld_precision) */
           ,PRO_SQLDA_COL_ATTR_SCALE = 5     /* RU Scale of value in DataBuff (dh_i16_t, sqld_scale) */
    	   ,PRO_SQLDA_COL_ATTR_FLAGS = 6     /* RO Flags - (nullable) (dh_u32_t, sqld_flags) */
           ,PRO_SQLDA_COL_ATTR_IVARPTR = 7   /* RW Ptr to Indicator variable (dh_i32_t *, sqld_ivaptrs) */
	   ,PRO_SQLDA_COL_ATTR_VARNAME = 8   /* RO Variable Name (dh_char_t *, sqld_varnames) */
           /* The sqld_indvarnames data was never filled in and the attribute is deprecated */
	   ,PRO_SQLDA_COL_ATTR_CLENGTH = 10  /* RO Actual Size (chars+0) of Data in Buffer (dh_u32_t, sqld_clengths) */
	   ,PRO_SQLDA_COL_ATTR_RETLENGTH =11 /* RO Returned Length (bytes+1) (dh_u32_t, sqld_returned_lengths) */
	   ,PRO_SQLDA_COL_ATTR_ODBCFLAGS =12 /* RO ODBC Flags (dh_u32_t, sqld_odbc_flags) */
           /* The sqld_date_int_code info is available thru PRO_SQLDA_COL_ATTR_DATATYPE */
           /* The sqld_date_int_prec info is available thru PRO_SQLDA_COL_ATTR_SCALE ??? */
	   ,PRO_SQLDA_COL_ATTR_COLLATION =13 /* RO Collation Name (dh_char_t *, sqld_collat_name) */
	   ,PRO_SQLDA_COL_ATTR_CHARSET = 14  /* RO CHARSET Name (dh_char_t *, sqld_charset_name) */
	   ,PRO_SQLDA_COL_ATTR_BASECOLNAME=15/* RO Base Column Name (dh_char_t *, sqld_base_column_name) */
	   ,PRO_SQLDA_COL_ATTR_BASETBLNAME=16/* RO Base Table Name (dh_char_t *, sqld_base_table_name) */
	   ,PRO_SQLDA_COL_ATTR_SEARCHABLE =17/* RO Column is searchable (dh_i16_t, sqld_searchable) */
	   ,PRO_SQLDA_COL_ATTR_UPDATEABLE =18/* RO Column is updateable (dh_i16_t, sqld_updatable) */
	   ,PRO_SQLDA_COL_ATTR_PARAMTYPE = 19/* RW Parameter Type (R/W/RW) (dh_i16_t, sqld_param_type) */
	   ,PRO_SQLDA_COL_ATTR_TABLENAME = 20/* RO Table name (dh_char_t *, sqld_table_name) */
	   /* The sqld_verbose_types info is available thru PRO_SQLDA_COL_ATTR_DATATYPE */
           /* new sqlda attributes */
           /* */
           ,PRO_SQLDA_COL_ATTR_LAST          /*    not valid - used to position  */
                                             /*    INTERNAL attributes */
           } pro_sqlda_col_attribute_t;
	

    extern void EXPORT
        PRO_SQLDA_Get_Col_Attribute_void_p(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,void **Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Get_Col_Attribute_dh_u32_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_u32_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );
        
    extern void EXPORT
        PRO_SQLDA_Get_Col_Attribute_dh_i16_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_i16_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Get_Col_Attribute_dh_i32_t_p(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_i32_t **Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Get_Col_Attribute_dh_i32_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_i32_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Get_Col_Attribute_dh_u8_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_u8_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Get_Col_Attribute_dh_char_t_p(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             const pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_char_t **Value
            ,dh_sqlca_t *SQLCA
#endif
            );
     

	/*
	// PRO_SQLDA_Set_Col_Attribute_<dt> sets an attribute value for attributes that
	//	pertain to a particular column of SQLDA.  The function
	//	returns error info in the SQLCA argument. if all is ok, it will 
	//	modify the internal data to hold the value of the by-reference argument.
	//	See the pro_sqlda_col_attribute enumeration for the list of attributes.
        //      Columns are numbered from 1 (one).
        //
        //      Not all attributes are setable.
	*/
    

    extern void EXPORT
        PRO_SQLDA_Set_Col_Attribute_void_p(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,void *Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Set_Col_Attribute_dh_u32_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_u32_t Value
            ,dh_sqlca_t *SQLCA
#endif
            );
        
    extern void EXPORT
        PRO_SQLDA_Set_Col_Attribute_dh_i16_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_i16_t Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Set_Col_Attribute_dh_i32_t_p(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_i32_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );

    extern void EXPORT
        PRO_SQLDA_Set_Col_Attribute_dh_i32_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_i32_t Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Set_Col_Attribute_dh_u8_t(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_u8_t Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    
    extern void EXPORT
        PRO_SQLDA_Set_Col_Attribute_dh_char_t_p(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
             pro_sqlda *SQLDA
            ,pro_sqlda_col_attribute_t Col_Attribute
            ,dh_u32_t ColumnNumber /* cols count from 1 */
            ,dh_char_t *Value
            ,dh_sqlca_t *SQLCA
#endif
            );
    

#ifdef __cplusplus
} /* extern "C" */
#endif

/* **************************************************************************
*/

/* DC065 END */
/* 
 * Structure for getting a piece of data from a field of LONG type
 */
 
struct getdata_t {
    dh_i32_t   position;      /* IN offset , OUT balance data length */
    void      *buf;           /* buffer pointer */
    dh_i32_t   buf_len;       /* length of buffer (could be negative/NULL) */
    dh_char_t *hdl;           /* Field handle */
    dh_i16_t   htype;         /* host type  */
    dh_char_t *code_page;     /* code-page */
    dh_i16_t   endian;        /* little endian or big endian */
    dh_i32_t   totalByteSize; /* total size of the lob, in bytes */
    dh_i16_t   lastChunk;     /* flag indicating last chunk of lob being sent */
};
 
typedef struct getdata_t getdata_t;

/* 
 * Structure for writing a piece of data in to a field of LONG type
 */

struct putdata_t {
    dh_i32_t   position;    /* IN offset */
    void      *buf;         /* buffer pointer */
    dh_i32_t   buf_len;     /* length of buffer (could be negative/NULL) */
    dh_char_t *hdl;         /* Field handle */
    dh_i16_t   htype;       /* host type  */
    dh_char_t *code_page;   /* code-page */
    dh_i16_t   endian;      /* little endian or big endian */
    struct sqlda *da;	    /* sqlda pointer, for update */
};
 
typedef struct putdata_t putdata_t;

 
 /* values for type of info in tpe_sqlgetinfo */
 
 typedef enum {
 	DH_SQL_CONVERT_FUNCTIONS,
 	DH_SQL_NUMERIC_FUNCTIONS,
 	DH_SQL_STRING_FUNCTIONS,
 	DH_SQL_SYSTEM_FUNCTIONS,
 	DH_SQL_TIMEDATE_FUNCTIONS,
 	DH_SQL_TIMEDATE_ADD_INTERVALS,
 	DH_SQL_TIMEDATE_DIFF_INTERVALS,
 	DH_SQL_DATASOURCE_READ_ONLY,
 	DH_SQL_IDENTIFIER_QUOTE_CHAR,
 	DH_SQL_OWNER_USAGE,
 	DH_SQL_MISC1_FUNCTIONS,
 	DH_SQL_MISC2_FUNCTIONS,
 	DH_SQL_MISC3_FUNCTIONS
 }dh_infoid_t;
 	
 
 /* values for type of info in tpe_sqlgetfunction */
 /* The order should not be changed since the mapping will be effected */
 
typedef enum {
 	DH_SQL_API_ALL_FUNCTIONS,
 	DH_SQL_API_SQLALLOCCONNECT,
 	DH_SQL_API_SQLALLOCENV,
 	DH_SQL_API_SQLALLOCSTMT,
 	DH_SQL_API_SQLBINDCOL,
 	DH_SQL_API_SQLCANCEL,
 	DH_SQL_API_SQLCOLATTRIBUTES,
 	DH_SQL_API_SQLCONNECT,
 	DH_SQL_API_SQLDESCRIBECOL,
 	DH_SQL_API_SQLDISCONNECT,
 	DH_SQL_API_SQLERROR,
 	DH_SQL_API_SQLEXECDIRECT,
 	DH_SQL_API_SQLEXECUTE,
 	DH_SQL_API_SQLFETCH,
 	DH_SQL_API_SQLFREECONNECT,
 	DH_SQL_API_SQLFREEENV,
 	DH_SQL_API_SQLFREESTMT,
 	DH_SQL_API_SQLGETCURSORNAME,
 	DH_SQL_API_SQLNUMRESULTCOLS,
 	DH_SQL_API_SQLPREPARE,
 	DH_SQL_API_SQLROWCOUNT,
 	DH_SQL_API_SQLSETCURSORNAME,
	DH_SQL_API_SQLSETPARAM,
        DH_SQL_API_SQLTRANSACT,
 	DH_SQL_API_SQLCOLUMNS = 40,        /*  Level 1 Functions */
	DH_SQL_API_SQLDRIVERCONNECT,
 	DH_SQL_API_SQLGETCONNECTOPTION,
 	DH_SQL_API_SQLGETDATA,
 	DH_SQL_API_SQLGETFUNCTIONS,
 	DH_SQL_API_SQLGETINFO,
 	DH_SQL_API_SQLGETSTMTOPTION,
 	DH_SQL_API_SQLGETTYPEINFO,
 	DH_SQL_API_SQLPARAMDATA,
 	DH_SQL_API_SQLPUTDATA,
 	DH_SQL_API_SQLSETCONNECTOPTION,
 	DH_SQL_API_SQLSETSTMTOPTION,
 	DH_SQL_API_SQLSPECIALCOLUMNS,
 	DH_SQL_API_SQLSTATISTICS,
 	DH_SQL_API_SQLTABLES,
 	DH_SQL_API_SQLBROWSECONNECT,     
 	DH_SQL_API_SQLCOLUMNPRIVILEGES,
 	DH_SQL_API_SQLDATASOURCES,
 	DH_SQL_API_SQLDESCRIBEPARAM,
 	DH_SQL_API_SQLEXTENDEDFETCH,
 	DH_SQL_API_SQLFOREIGNKEYS,
 	DH_SQL_API_SQLMORERESULTS,
 	DH_SQL_API_SQLNATIVESQL,
 	DH_SQL_API_SQLNUMPARAMS,
 	DH_SQL_API_SQLPARAMOPTIONS,
 	DH_SQL_API_SQLPRIMARYKEYS,
 	DH_SQL_API_SQLPROCEDURECOLUMNS,
 	DH_SQL_API_SQLPROCEDURES,
 	DH_SQL_API_SQLSETPOS,
 	DH_SQL_API_SQLSETSCROLLOPTIONS,
 	DH_SQL_API_SQLTABLEPRIVILEGES,
 	DH_SQL_API_SQLDRIVERS,
 	DH_SQL_API_SQLBINDPARAMETRE
}dh_fnid_t;
 
 	
/*
 * Set a db handle as the current db handle.
 */

extern void EXPORT
tpe_set_curdbhdl (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_db_hdl_t,				/* IN  db handle     	*/
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

/* DS_19970121_682 START */
extern void EXPORT
tpe_sqlconnect(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    const dh_char_t * ,				/* IN connect_string	*/
    const dh_char_t * ,				/* IN connection_name	*/
    const dh_char_t * ,				/* IN user_id		*/
    const dh_char_t * ,				/* IN user authentication*/
    const dh_char_t * ,                         /* IN user dboptions     */
    struct sqlca    * 				/* OUT sqlca pointer */
#endif
);

/* DS_19960121_682 END */

extern void EXPORT
tpe_sql_setconnection(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_char_t * ,					/* IN connection_name	*/
    struct sqlca	*			/* OUT sqlca pointer	     */
#endif
);


/* the cancel api used by the client to send
   a cancel request to the server */
extern tpe_status_t EXPORT
tpe_cancel(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
     tpe_db_hdl_t ,				/* IN dbhdl */
     tpe_cursor_t 				/* IN cursor  */
#endif
);

extern void EXPORT
tpe_sql_disconnect(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_discon_sp_t,				/* Disconnection specification
							type		*/
    dh_char_t * ,					/* IN connection_name	*/
    struct sqlca	*			/* OUT sqlca pointer	     */
#endif
);

extern void  EXPORT
tpe_get_dbhdl_list(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_db_hdl_t	[],			/* OUT  dbhandle 	*/
    dh_i16_t		*,			/* OUT nhandles		*/
    struct sqlca	*			/* OUT sqlca pointer	*/
#endif
);


extern void EXPORT
tpe_get_connection_info(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_db_hdl_t,				/* IN  db handle 	*/
    dh_char_t		*,			/* OUT dbname		*/
    dh_char_t		*,			/* OUT connection name	*/
    dh_boolean		*,			/* OUT is_default	*/
    struct sqlca	*			/* OUT sqlca pointer	*/
#endif
);


extern dh_boolean  EXPORT
tpe_validate_dbhdl(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_db_hdl_t				/* IN  db handle 	*/
#endif
);



extern dh_boolean EXPORT
tpe_conn_to_dflt_if_any(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    struct sqlca	*			/* OUT sqlca pointer	     */
#endif
);


/*
 * Print out the error message associated with the error code.
 * Also print out the message specified by the app.
 */
extern dh_i32_t  EXPORT
tpe_print_error (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	  dh_i32_t,		/* error code */
	  const dh_char_t *	/* message */
#endif
);

/* 
 * Print out the error message and code stored in the SQLCA.
 */ 
extern dh_i32_t  EXPORT
tpe_check_error (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	  struct sqlca *
#endif
);

/*
 * Set the fields of a sqlda with the given values.
 * 	(Used to allocate sqlda on stack).
 */

extern void  EXPORT
tpe_set_sqlda (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct	sqlda	*,		/* INOUT pointer to sqlda   */
    dh_u32_t		,	/* IN    sqlda size         */
    dh_u32_t		,	/* IN    sqlda array size   */
    dh_i32_t		*,	/* IN    array of types     */
    /* DC065 BEGIN .*/
    dh_u32_t 		*,	/* IN    array of lengths   */
    /* DC065 END. */
    void    		**,	/* IN    array of var ptrs  */
    dh_i32_t 		**,	/* IN    array of indvar ptrs */
    dh_char_t                   /* IN    'i' or 'o' for input/output DA */
#endif
) ;

/*
 * Set the fields of a sqlda to use the given buffer of given size.
 */

extern tpe_status_t  EXPORT
tpe_setup_sqlda (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct	sqlda	*,		/* INOUT pointer to sqlda */
	dh_char_t	*,		/* IN    array of bytes	*/
	dh_u32_t			/* IN    size of array */
#endif
) ;

/* DC317 { 
 * The function tpe_data_gethostlen() has been changed to take
 * one more input argument. This variable is of type dh_char_t *.
 * A parameter for this argument has been added to take charset_name
 * as the input argument to calculate the hostlen in the case of
 * nchar and nvarchar data.
 * DC317 }
 */
  
extern tpe_status_t   EXPORT
tpe_data_gethostlen (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	dh_i16_t,			/* IN  sqlda type  */
	pro_DataLengthBytes_t,		/* IN  sqlda precision  */
	dh_i16_t,			/* IN  sqlda scale  */
        /* DC065 . sqld lengths has been changed to long type */
	pro_DataLengthBytes_t *	,	/* OUT sqlda length  */
	const dh_char_t *	        /* IN charset_name */
 
#endif
) ;

/*
 * Set all the field types to CHAR so that the BE must do all the conversion
 * and data can be returned as character strings using the given buffer.
 */

extern tpe_status_t   EXPORT
tpe_char_sqlda (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct	sqlda	*,		/* INOUT pointer to sqlda   */
	dh_char_t	*,		/* IN    array of bytes	*/
	dh_u32_t			/* IN    size of array */
#endif
) ;

/*
 * Set all the field types to the appropriate host types
 * and have data returned using the given buffer.
 */

extern tpe_status_t   EXPORT
tpe_host_sqlda (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct	sqlda	*,		/* INOUT pointer to sqlda   */
	dh_i8_t		*,		/* IN    array of bytes	*/
	dh_u32_t			/* IN    size of array */
#endif
) ;

/* Prdh_i32_t the tuples stored in the SQLDA to the given file. */

extern tpe_status_t	 EXPORT 
tpe_print_sqlda(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct sqlda *,		/* IN contains the tuples */
	struct sqlca *,		/* IN contains # of tuples */
	dh_file_t *		/* IN output file */
#endif
);

  
/* Print the tuples with LONG data to the given file. */

extern dh_i32_t EXPORT
tpe_print_sqlda_data (
#if     defined(__cplusplus) || !defined(NO_PROTOTYPE)
        struct sqlda *,               /* IN contains the data */
        tpe_db_hdl_t,                 /* IN database */
        tpe_tm_hdl_t,                 /* IN transaction */
        tpe_cursor_t,                 /* IN cursor */
        struct sqlca *,               /* INOUT # tuples & errors */
        dh_file_t *                   /* IN output file */
#endif
);


/* Print the info(colnames,types,...) stored in the SQLDA to the given file. */

extern tpe_status_t     EXPORT
tpe_print_header (
#if   defined(__cplusplus) || !defined(NO_PROTOTYPE)
          struct sqlda *,     /* IN contains the header */
          dh_file_t *         /* IN output file */
#endif
      );

/* Print the info(#rows affected,...) stored in the SQLDA to the given file. */

extern tpe_status_t     EXPORT
tpe_print_footer (
#if   defined(__cplusplus) || !defined(NO_PROTOTYPE)
          const dh_char_t *,  /* IN command_type */
          struct sqlca *,     /* IN */
          dh_file_t *         /* IN output file */
#endif
      );

/* Print the content of the SQLCA to the given file. */

extern tpe_status_t   EXPORT
tpe_print_sqlca (
#if   defined(__cplusplus) || !defined(NO_PROTOTYPE)
          const dh_char_t *,  /* IN the SQL statement */
          struct sqlca *,     /* IN contains # of tuples */
          dh_file_t *         /* IN output file */
#endif
      );


/* Prdh_i32_t the parameters stored in the SQLDA to the given file. */

extern tpe_status_t	 EXPORT
tpe_print_input_sqlda(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct sqlda *,		/* IN contains the tuples */
	struct sqlca *,		/* IN contains # of tuples */
	dh_file_t *			/* IN output file */
#endif
);


/* Prdh_i32_t the sqlda_var from an sqlda structure dh_i32_to a file. */

extern void  EXPORT
tpe_print_sqlda_var(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct sqlda *,		/* IN contains the tuples */
	dh_file_t *,		/* IN output file */
        dh_i32_t  var_idx,      /* var_index      */
	dh_i32_t  array_idx     /* array_index     */
#endif
);



extern void  EXPORT
tpe_sqlfetchrid (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_tm_hdl_t 	,	/* IN - transaction handle */
	tpe_db_hdl_t	,       /* IN - db handle */	
	tpe_cursor_t	,	/* IN - cursor pointer */
	struct sqlda	*,	/* IN - input parameters */
	struct sqlda	*,	/* IN - input parameters */
	struct sqlca	*	/* OUT - sqlca pointer */
#endif
);

/*
 * Get the current db handle.
 */

extern tpe_db_hdl_t EXPORT
tpe_get_curdbhdl () ;

/*
 * Check transaction hdl
 */

extern tpe_status_t EXPORT
tpe_tm_chk_hdl (
#if     defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t                                /* IN  transaction handle */
#endif
);

/* 
 * set up cursor structure.
 */

extern void EXPORT
tpe_set_cursor (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,		/* IN  transaction handle   */
    tpe_db_hdl_t	,		/* IN  db handle	    */
    tpe_cursor_t	*,		/* IN  cursor pointer       */
    tpe_uuid__t		*,		/* IN  sql stmt uid         */
    dh_i32_t		,		/* IN  1-dynamic , 0-static */
    dh_char_t		*,		/* IN  sql stmt             */
    struct sqlca	*		/* OUT sqlca pointer        */
#endif
) ;

extern void   EXPORT
tpe_set_cursorname (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_cursor_t ,			/* IN  cursor pointer   */
    dh_char_t	 *,			/* IN  cursor name	*/
    struct sqlca *			/* OUT sqlca pointer    */
#endif
) ;

/*
 *  free cursor resources
 */
extern void   EXPORT
tpe_free_cursor (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_cursor_t *			/* IN  cursor * pointer   */
#endif
) ;


/*
 * execute a non-select sql statement.
 */

extern void  EXPORT
tpe_sqlexecute (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,		/* IN  transaction handle   */
    tpe_db_hdl_t	,		/* IN  db handle            */
    tpe_cursor_t	,		/* IN  cursor               */
    struct sqlda	*,		/* IN  input params         */
    struct sqlca	*		/* OUT sqlca pointer        */
#endif
) ;


extern void EXPORT
tpe_sqlexecdirect (
#if   	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,		/* IN transaction handle */
    tpe_db_hdl_t	,		/* IN db handle		 */
    tpe_cursor_t	,		/* IN cursor 		 */
    struct sqlda	*,		/* IN input params	 */
    struct sqlca	*		/* OUT sqlca pointer	 */
#endif
) ;

/*
 * declare a cursor
 */

extern void EXPORT
tpe_sqldeclare (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,		/* IN  transaction handle   */
    tpe_db_hdl_t	,		/* IN  db handle            */
    tpe_cursor_t	,		/* IN  cursor               */
    struct sqlda	*,		/* IN  input params         */
    struct sqlca	*		/* OUT sqlca pointer        */
#endif
) ;

/*
 * single tuple select
 */

extern void  EXPORT
tpe_sqlselect (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,		/* IN  transaction handle   */
    tpe_db_hdl_t	,		/* IN  db handle            */
    tpe_cursor_t	,		/* IN  cursor               */
    struct sqlda	*,		/* IN  input params         */
    struct sqlda	*,		/* OUT output params        */
    struct sqlca	*		/* OUT sqlca pointer        */
#endif
) ;

/*
 * open a cursor.
 */

extern void  EXPORT
tpe_sqlopen (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,		/* IN  transaction handle   */
    tpe_db_hdl_t	,		/* IN  db handle            */
    tpe_cursor_t	,		/* IN  cursor               */
    struct sqlda	*,		/* IN  input params         */
    struct sqlca	*		/* OUT sqlca pointer        */
#endif
) ;

 
extern void EXPORT
tpe_sqlgetinfo(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_db_hdl_t    ,      		/* IN  database hdl          */
	dh_infoid_t     ,       	/* IN  infoid                */
	void   *        ,		/* OUT output buffer ptr     */
	dh_i32_t       ,		/* IN  bufle                 */
	dh_i32_t *     ,        	/* OUT bytes in buffer       */
	struct sqlca *  	        /* IN  sqlca	             */
#endif
) ;           			
 
 
 
 
 
/*
 * Get a piece of data from a field of dh_i32_t type
 */
 
extern void  EXPORT
tpe_sqlgetdata (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
     tpe_tm_hdl_t	,		/* IN  transaction handle   */
     tpe_db_hdl_t	,		/* IN  db handle            */
     tpe_cursor_t	,		/* IN  cursor               */
     dh_i32_t  		,    		/* htypeid 		    */
     void  * 		,		/* hdl to field	 	    */
     dh_i32_t  		,		/* bufferlen 	  	    */
     dh_i32_t  		,		/* offset into field        */
     void  *		,		/* buffer  		    */
     dh_i32_t  *	,		/* balance data from offset */
     struct sqlca	*		/* OUT sqlca pointer        */
#endif
 ) ;
 
/*
 * Put a piece of data dh_i32_to a field of dh_i32_t type
 */
 
extern void  EXPORT
tpe_sqlputdata (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
     tpe_tm_hdl_t	,		/* IN  transaction handle   */
     tpe_db_hdl_t	,		/* IN  db handle            */
     tpe_cursor_t	,		/* IN  cursor               */
     dh_i32_t  		,      		/* htypeid 		    */
     void  * 		,		/* hdl to field	 	    */
     dh_i32_t  		,		/* bufferlen 	  	    */
     dh_i32_t  		,		/* offset into field        */
     void  *		,		/* buffer  		    */
     struct sqlca	*,		/* OUT sqlca pointer        */
     struct sqlda	*		/* IN sqlda pointer	    */
#endif
 ) ;
 
 
 
 
extern void EXPORT
tpe_sqlgetfunctions(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_db_hdl_t    ,      			/* IN  database hdl 	*/
        dh_fnid_t       , 	       		/* IN  funcid 		*/
        dh_u16_t *	,  	 	        /* OUT Exists 		*/
        struct sqlca *  		        /* OUT sqlca pointer 	*/
#endif
);           			
 
 
 /* 
 * fetch one or more tuples using a cursor
 */

extern void   EXPORT
tpe_sqlfetch (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    struct sqlda	*,			/* OUT output params        */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;


/* 
 * Prepare and execute SQLTables procedure.
 */

extern void  EXPORT
tpe_sqltables (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    dh_char_t                *,                      /* IN  table owner          */
    dh_char_t                *,                      /* IN  table name           */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

/* 
 * Prepare and execute SQLColumns procedure.
 */

extern void  EXPORT
tpe_sqlcolumns (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    dh_char_t                *,                      /* IN  table owner          */
    dh_char_t                *,                      /* IN  table name           */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

/* 
 * Prepare and execute SQLStatistics procedure.
 */

extern void  EXPORT
tpe_sqlstatistics (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    dh_char_t                *,                      /* IN  table owner          */
    dh_char_t                *,                      /* IN  table name           */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

/* 
 * Prepare and execute SQLPrimaryKeys procedure.
 */
extern void  EXPORT
tpe_sqlprimarykeys (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    dh_char_t                *,                      /* IN  table owner          */
    dh_char_t                *,                      /* IN  table name           */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

/* 
 * Prepare and execute SQLForeignKeys procedure.
 */

extern void  EXPORT
tpe_sqlforeignkeys (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    dh_char_t                *,                      /* IN  primary table owner  */
    dh_char_t                *,                      /* IN  primary table name   */
    dh_char_t                *,                      /* IN  foreign table owner  */
    dh_char_t                *,                      /* IN  foreign table name   */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;


/*
 * Check for the validity of the database handle before using it.	
 */

extern void  EXPORT
tpe_sql_chk_connection(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct sqlca	*
#endif
);


/*
 * prepare a dynamic statement.
 */

extern void  EXPORT
tpe_sqlprepare (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ; 

/*
 * get the types and lengths of outputs for a dynamic statement.
 */

extern void   EXPORT
tpe_sqldescribe (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    struct sqlda	*,			/* OUT output desc          */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

/*
 * get the types, precision and scale of inputs for a dynamic statement.
 */

extern void   EXPORT
tpe_sqldescribe_param (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
     tpe_tm_hdl_t	,			/* IN  transaction handle   */
     tpe_db_hdl_t	,			/* IN  db handle            */
     tpe_cursor_t	,			/* IN  cursor               */
     struct sqlda	*,			/* OUT output desc          */
     struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;
 
extern void  EXPORT
tpe_sqldescribe_input (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    struct sqlda	*,			/* OUT output desc          */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

/*
 * close a cursor.
 */

extern void  EXPORT
tpe_sqlclose (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t	,			/* IN  transaction handle   */
    tpe_db_hdl_t	,			/* IN  db handle            */
    tpe_cursor_t	,			/* IN  cursor               */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;


extern void  EXPORT
tpe_set_ptrs (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)

void 	**	varptrlist, 
dh_u32_t nvars,
...    /* data ptrs */
#endif
);

extern void  EXPORT
tpe_set_arraysz (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
dh_u32_t arraysz, dh_u32_t nvars, ...
#endif
) ;


extern  sqlda	EXPORT
*sqld_alloc (
/* This is for tm_dlib.c compiled in rds directory */
#if	defined(__cplusplus)
    dh_u32_t maxColumns, 
    dh_i16_t maxVarNameSize = 0
#endif
) ;

extern  tpe_status_t EXPORT
sqld_validate (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    const struct sqlda * 
#endif
) ;

extern  tpe_status_t EXPORT
sql_da_validate (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    const struct sqlda * 
   ,dh_sqlca_t *sqlca_arg
#endif
) ;

extern	void	EXPORT
sqld_free (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    sqlda *sqldaptr
#endif
) ;



extern	dh_u32_t	EXPORT 
PRO_SQLDA_getnbytes (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_u32_t MaxNumColumns, 
    dh_i16_t MaxVarNameSize
#endif
) ;

extern	void	EXPORT 
PRO_SQLDA_setup (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
sqlda *sqldaptr,
dh_u32_t MaxNumColumns, 
dh_i16_t MaxVarNameSize
#endif
) ;
/* DC065 .BEGIN. */

extern	void	EXPORT 
tpe_sqlallocdesc( 
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
dh_char_t *sqlda_name,
dh_u32_t NumCols,
struct sqlca * ca  
#endif
);

extern	void	EXPORT 
tpe_sqldeallocdesc(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
dh_char_t *,
struct sqlca * 
#endif
);

extern	void	EXPORT 
tpe_sqlgetdesc (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
struct sqlda   *,
dh_u32_t item_num,
item_lst * tgt_list,
dh_i32_t List_length,
struct sqlca * 
#endif
);

extern	void	EXPORT 
tpe_sqlsetdesc (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
struct sqlda   *,
dh_i32_t , 
item_lst * ,
dh_i32_t ,
struct sqlca * 
#endif
);

/* [sjp] extern	struct sqlda  * EXPORT */
extern	struct sqlda  EXPORT *
tpe_sqlgetsqldaptr(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
dh_char_t *, 
/* struct sqlda *,*/ 
struct sqlca * 
#endif
);


/* DC065 .END. */

/* 
 * Check_esqlc is used by the ODBC driver to check for the no. of connections.
 */
extern dh_i32_t EXPORT 
check_esqlc();


/* Maximum # of participants in a distributed transaction */
#define	TPE_MAX_PARTICIPANTS	10

/* Transaction flags */
#define TPE_TRANS_CB_CLOSE	0x00 /* default */
#define TPE_TRANS_ABORTED	0x01
#define TPE_TRANS_CB_PRESERVE	0x02
#define TPE_TRANS_CB_DELETE	0x04


#if defined (DH_SQL_DEFS)

/* SOFTCOMMIT */
typedef enum {
    SQL_CB_INVALID   = -1,
    SQL_CB_DELETE    =  0,
    SQL_CB_CLOSE     =  1,
    SQL_CB_PRESERVED =  2
}  tpe_cursor_behavior_t;

#else

typedef enum {
    P_SQL_CB_INVALID   = -1,
    P_SQL_CB_DELETE    =  0,
    P_SQL_CB_CLOSE     =  1,
    P_SQL_CB_PRESERVED =  2
}  tpe_cursor_behavior_t;


#endif /* if defined (DH_SQL_DEFS) */

/* Maximum id for a REAL table. The values above this are assigned for
 virtual tables. */
#define         TPE_MAX_TBLID           32767

typedef enum { 
    INVALID_ISOLATION_LEVEL = -1,
    READ_UNCOMMITTED        = 0, 
    READ_COMMITTED          = 1,
    REPEATABLE_READ         = 2, 
    SERIALIZABLE            = 3,
    ISOL_LVL_UNCHANGED      = 100  // used by odbc/jdbc drivers to signal no
                                   // change to current isolation level
} tpe_tm_isolation_lvl_t ; 


/*
 * Transaction manager library
 */





/*
 * Allocate a transaction handle.
 */

extern tpe_tm_hdl_t  EXPORT
tpe_tm_alloc_handle (
) ;
/*
 * Get the current user 
 */
extern tpe_status_t EXPORT
tpe_get_cur_user( 
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
       const dh_char_t *dbname,
       dh_char_t *user
#endif
);

/*
 * Get the current user's passwd 
 */
extern tpe_status_t EXPORT
tpe_get_cur_userpw( 
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	const dh_char_t *dbname,
	const dh_char_t *username,
        dh_char_t *passwd
#endif
);

/* 
 * Validate the input username and password
 * Called only from sample rss_init.  Use is at discretion of implementor
 */
extern tpe_status_t EXPORT
tpe_validate(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	const dh_char_t *userid,
	const dh_char_t *passwd,
        const dh_char_t *super_user
#endif
);

/*
 * Set a tm handle  as the current tm handle.
 */

extern void  EXPORT
tpe_set_curtmhdl (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t,				/* IN tm handle */
    struct sqlca	*			/* OUT sqlca pointer        */
#endif
) ;

extern void  EXPORT
tpe_tm_set_level(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_isolation_lvl_t,       /* IN - the isolation level to be set */
    struct	sqlca	*			/* OUT sqlca pointer */
#endif
);

extern tpe_tm_isolation_lvl_t   EXPORT
tpe_tm_get_level();


/*  SOFTCOMMIT */
extern void  EXPORT
tpe_set_cursor_behavior(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_cursor_behavior_t,      /* IN - the cursor behavior to be set */
    struct	sqlca	*	/* OUT sqlca pointer */
#endif
);

extern tpe_cursor_behavior_t  EXPORT
tpe_get_cursor_behavior(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    struct	sqlca	*			/* OUT sqlca pointer */
#endif
);

/*
 * Get the current tm handle.
 */
extern tpe_tm_hdl_t EXPORT
tpe_get_curtmhdl () ;

/*
 * start a new or sub transaction
 */
extern void  EXPORT
tpe_tm_begin_trans (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_isolation_lvl_t,			/* IN    consistency level */
    tpe_tm_hdl_t, 				/* INOUT transaction info  */
    struct	sqlca	*			/* OUT sqlca pointer       */
#endif
);


/*
 * mark transaction as aborted
 */

extern void  EXPORT
tpe_tm_mark_abort (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t,  				/* INOUT transaction info */
    struct	sqlca	*			/* OUT sqlca pointer */
#endif
);


/*
 * Complete a transaction:
 */

extern void  EXPORT
tpe_tm_end_trans (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_tm_hdl_t, 				/* INOUT transaction info */
    struct	sqlca	*			/* OUT sqlca pointer */
#endif
);

extern void	EXPORT
tpe_print_banner(
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
				 const dh_char_t *	/* banner */
#endif
);

extern void	EXPORT
tpe_sqlc_clear (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	struct sqlca *		/* IN  SQLCA pointer */
#endif
);

#ifndef	TRUE
#define		TRUE	 	1	
#define		FALSE		0
#endif

#ifndef	NULL
#define		NULL		((dh_char_t *)0)
#endif

#ifndef	STATUS_OK
#define	  STATUS_OK	0L
#endif

#ifndef		MAX
#define		MAX(x,y)	((y)>(x)?(y):(x))
#endif

#ifndef		MIN
#define		MIN(x,y)	((y)<(x)?(y):(x))
#endif



/* Default directory where we should look for tpe specific files */

#if	defined(DH_OS_MSDOS) || defined(DH_OS_WIN32S) || defined (DH_OS_WINNT)
#if defined(DH_ODBC_INT)
#define	DEF_TPEDIR	DH_PSTRING_LITERAL("C:\\ODBCI")
#else
#define DEF_TPEDIR      DH_PSTRING_LITERAL("\\SQL")
#endif
#else
#define	DEF_TPEDIR	DH_PSTRING_LITERAL("/usr/tpe")
#endif


dh_char_t * tpe_itoa (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
dh_i32_t 
#endif
) ;

void tpe_fatal (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
dh_char_t *, dh_i32_t, dh_char_t * 
#endif
);

#ifndef	STATIC
#ifdef	DEBUG
#define		STATIC	
#else
#define		STATIC		static
#endif
#endif

/* Base on LONG_MAX where LONG is a 64 bit integer */
#define     SQL_ROWID_SIZE  19

#define		TPE_MAX_PROC_ARGS	100

/* DC215 (DS_19971118_783) BEGIN 
The statement size is increased so as to accomodate for large procedures */

/* DC317 { 
 * The statement size is increased to insert extended field data. The
 * statement size has been increased to 131000 to take at least one 
 * extended field value of TPE_EXT_MAX_FLDLEN (32K) in the INSERT statement
 * through ISQL and the rest can be used for inserting other fields in 
 * that table.   Because of I18N conversion expansion, we could need up to 
 * 96k bytes to convert 32k to/from other character sets.
 */  
/* #define		TPE_MAX_SQLSTMTLEN      25000	*/

#define		TPE_MAX_SQLSTMTLEN      131000

#define         PROSQL_TRIGGER_TYPE_V1    DH_PSTRING_LITERAL("tp")
#define         PROSQL_TRIGGER_TYPE_V0    DH_PSTRING_LITERAL("TP")
#define         PROSQL_PROCEDURE_TYPE_V1  DH_PSTRING_LITERAL("sp")
#define         PROSQL_PROCEDURE_TYPE_V0  DH_PSTRING_LITERAL("SP")

/* DC317 } */

/* DC215 (DS_19971118_783) END   */
#define		TPE_MAX_SQLSTMTLEN_P1	(TPE_MAX_SQLSTMTLEN + 1)

/* TPE_MAX_FLDLEN can be increased further if the storage system allows */

/* Progress Software customization - I18N */
/* Define new constant for maximum length in characters and */
/* increase the value of TPE_MAX_FLDLEN to accomodate double-byte and */
/* triple-byte character sets. */

#define		TPE_MAX_FLDCHARLEN	2000 /* max length for CHAR data */
#define		TPE_MAX_FLDLEN		(TPE_MAX_FLDCHARLEN * 3) 
			/* see also TPE_MAX_I18N_CONVERTSZ below */

/* End of Progress Software customization - I18N */
 
#define		TPE_MAX_FLDLEN_P1	(TPE_MAX_FLDLEN + 1)

#define		TPE_MAX_DFLT_LEN        250 /* Maximum length of default value*/
#define		TPE_MAX_DFLT_LEN_P1     251 /* Maximum length of default value*/

#define		TPE_UUID_LEN		36
#define		TPE_UUID_LEN_P1		(TPE_UUID_LEN + 1)

#define		TPE_MAX_CONNLEN		100
#define		TPE_MAX_CONNLEN_P1	(TPE_MAX_CONNLEN + 1)

#define		TPE_MAX_IDLEN		32
#define		TPE_MAX_IDLEN_P1	(TPE_MAX_IDLEN + 1)

#define         TPE_MAX_SWITCHES_LEN    255
#define         TPE_MAX_SWITCHES_LEN_P1 (TPE_MAX_SWITCHES_LEN +1)

/*
* The value of TPE_MAX_PATHLEN is set to the same value used for file path
* manipulation in rocket code ( MAXUTAPATH ).
*/
#define		TPE_MAX_PATHLEN		300
#define		TPE_MAX_PATHLEN_P1	(TPE_MAX_PATHLEN + 1)

#define		TPE_UNAME_LEN		TPE_MAX_IDLEN
#define		TPE_UNAME_LEN_P1	TPE_MAX_IDLEN_P1

/*
 * DC317 { 
 */

/* 
 * TPE_EXT_MAX_FLDLEN - Maximum field width for extended data types.
 *                      This covers both VARCHAR and VARBINARY.
 */
 
#define		TPE_EXT_MAX_FLDLEN	31995

/* Note TPE_EXT_MAX_FLDLEN must be smaller than YYLMAX (defined in
 *			<star>/make.inc)
 *      This seems extremely convoluted to me but everyone seems to like
 *      it and I refuse to make TPE_EXT_MAX_FLDLEN be based on something
 *      called YYLMAX defined in a make script.  And in any case, there 
 *      is no good relationship except that one is smaller than the other.
 *
 *      Note that the TPE_EXT_MAX_FLDLEN value must fit within the
 *      TPE_FLDLEN_MASK to get everything working properly.
 *
 *      TPE_EXT_MAX_FLDLEN must match the maximum length the 4GL can
 *      handle for a single column (char) table
 *
 * Further Note: the value above (31995) for TPE_EXT_MAX_FLDLEN comes from
 *      the maximum value that the V8 4GL can handle in a single column
 *      (char) table.  This is calculated as 32000-5 overhead bytes.  The
 *      overhead bytes are: 1 length byte, 1 table ID byte, and 3 length
 *      bytes (for the single column).
 *
 *      In V9, the actual maximum is 31983 (32000 + 1 -18 overhead bytes as 
 *      follows: 4 bytes for the indicator,length, and end byte, 8 bytes 
 *      for the ARRAY FID, 1 byte for the version #, 1 byte for the table
 *      ID, 1 byte for something else and 3 bytes for the length of the
 *      single CHAR column).  
 *
 *      While 31995 can not be created in V9, it can be seen (via a
 *      converted DB) in V9.  Therefore we must handle it.
 *		
 * Further Note: Actually, to be compatible with exsiting and legacy database, 
 *		31995 can be created after V9, but 31983 is the maximum length of a 
 *		record to be inserted.
 */


/*
 * Note TPE_MAX_I18N_CONVERTSZ used to be TPE_MAX_FLDLEN, but it was
 *      changed to avoid confusion between CHAR and VARCHAR data which
 *      now have different sizes 
 */
 
#define		TPE_MAX_I18N_CONVERTSZ	(MAX(TPE_MAX_FLDCHARLEN, TPE_EXT_MAX_FLDLEN) * 3)


/*
 * DC317 }
 */

/* DC113 BEGIN */
/* SQL92 Engine bug fix (98-11-09-053) */
/* Increase the value of TPE_MAX_RECS_LEVEL from 2 to 5 */
#define     TPE_MAX_RECS_LEVEL  5
/* End of SQL92 Engine bug fix (98-11-09-053) */
/* DC113 END */

/*
 * If this length is increased, then the SUP_USER_STRING in rds/ddm.hxx must
 * be padded out with spaces to the correct length.  This length must be
 * less than or equal to TPE_UNAME_LEN
 */

#define         TPE_SUNAME_LEN          32

#define		TPE_MAX_ERRLEN		256
#define		TPE_MAX_ERRLEN_P1	(TPE_MAX_ERRLEN + 1)

#define		TPE_MAX_PARAM    	32 // used to build internal param clause

#define		TPE_MAX_NO_CONN		1000

#define		TPE_CONSTR_LEN		100


/* The scale and the length share a intword with the scale in the low order
   byte;
*/
#define         TPE_FLDLEN_MASK         0xffffff
#define         TPE_FLDLEN_SHIFT        8
#define         TPE_SCALE_MASK          0xff


/* Updating DH_ACCESS_VERSION requires also updating
   test output (tst080401.out) for the subsql92/subjava/dbsys
   test
*/
#define DH_ACCESS_VERSION DH_STRING_LITERAL("10.2B08")
#define DH_DRIVER_VERSION DH_STRING_LITERAL("10.92.2B08")

#ifdef __cplusplus
#ifdef DH_TRANSLATE_ONLY
/* 
 * Generating the 'c' files from 'c++' files to be compiled on a different
 * platform where 'c++' is not available ; suppress sizeof computation by
 * 'c++' translator 
 */
extern dh_i32_t	v_sizeof ; 
#define	DH_SIZEOF(x)	(sizeof(x) + v_sizeof)
#else
#define	DH_SIZEOF(x)	(sizeof(x))
#endif /* DH_TRANSLATE_ONLY */
#endif /* __cplusplus */

/* TPE field types.	*/

/* IMPORTANT: if the TPE_DT_* datatypes are changed, added to or 
 *            deleted from, make sure that you also change the
 *            duplicate list (in java) in src/sqlsp/java/SQLDA.java
 *            and a similar list in src/sqlsp/java/JavaBaseSP.java
 *            that maps java types to sqlsrv types.
 *
 *            ANY CHANGE MADE TO THE NUMERICAL REPRESENTATION OF THE
 *            DATATYES WILL INVALIDATE EXISTING STORED PROCEDURES
 *
 *            These two need to match.  The list here is the master
 *            list but the slave list in SQLDA.java also must be
 *            fixed.
 *
 *            Ideally, we should generate a java header file/class
 *            from the following info and include it in SQLDA.java
 *            but that has not happened yet.
 *
 *            There are also numerous (100's ?) of switch statements
 *            throughout the product that must be extended if you 
 *            add any new data types or shrunk if you delete any.
 *            IN PARTICULAR, THERE IS ONE IN generic/pfengine.cxx
 *            THAT MAPS THESE VALUES FOR ARRAY ACCESS THAT MUST BE 
 *            FIXED.
*/

/* the values in the tpe_datatype enum match the ODBC/JDBC values */

/* Unfortunately, we had to use both the enum and defines.  The enums
   because we wanted to take advantage of C++ type checking where we
   could and the defines because there was one spot (in rdscreat.cxx)
   where we could not use the enum and had to have a define.

   Except for the one spot (in rdscreat.cxx) and in the enum below,
   DO NOT USE (hence the dnu_ prefix) the dnu_* defines anywhere else
*/

#define dnu_TPE_DT_ERR	     0
        /* standard data types */
#define dnu_TPE_DT_CHAR      1    /* dh_char_t* (array) */
#define dnu_TPE_DT_NUMERIC   2    /* tpe_num_t, arbitary precison (1-50) integer,
                                     also DECIMAL */
#define dnu_TPE_DT_INTEGER   4    /* dh_i32_t */
#define dnu_TPE_DT_SMALLINT  5    /* dh_i16_t */
#define dnu_TPE_DT_REAL      7    /* dh_f32_t */
#define dnu_TPE_DT_FLOAT     8    /* dh_f64_t, also DOUBLE */
#define dnu_TPE_DT_VARCHAR   12   /* dh_char_t* (array) */
#define dnu_TPE_DT_DATE      91   /* tpe_date_t */
#define dnu_TPE_DT_TIME      92   /* tpe_time_t */
#define dnu_TPE_DT_TIMESTAMP 93   /* tpe_timestamp_t */
#define dnu_TPE_DT_TS_TIMEZONE 94   /* tpe_ts_timezone_t */
#define dnu_TPE_DT_ARRAY       95   /* array (not supported in ODBC/JDBC yet) */
        /* implementation defined data types */
#define dnu_TPE_DT_LVC       -1   /* not yet supported */ 
#define dnu_TPE_DT_BINARY    -2   /* tpe_binary_t */
#define dnu_TPE_DT_VARBINARY -3   /* tpe_binary_t */
#define dnu_TPE_DT_LVB       -4   /* tpe_lvb_locator_t, locator to chunks of 
                                     dh_u8_t* (arrays), not supported for ESQL/C */
#define dnu_TPE_DT_BIGINT    -5   /* tpe_bigint_t */
#define dnu_TPE_DT_TINYINT   -6   /* dh_i8_t */
#define dnu_TPE_DT_BIT       -7   /* dh_u8_t (but only 1 bit used) */
#define dnu_TPE_DT_BIGINT64  -8   /* dh_i64_t */
#define dnu_TPE_DT_NCHAR     -65  /* not for external CLI or ESQL/C 92 use */
#define dnu_TPE_DT_NVARCHAR  -66  /* not for external CLI or ESQL/C 92 use */

    /*
    // Following type value does NOT represent  a true datatype, and it
    // is NOT supported generally. Its use is limited to 2 modules.
    */
#define dnu_TPE_SVC_NUMERIC   (-129) /* intermediate form, for sql engine use
                                        * only, for transitioning db decimal
                                        * data to engine internal numeric data.
                                        * Not generally supported by type uses.
                                        */


typedef enum tpe_datatype {
     TPE_DT_ERR       = dnu_TPE_DT_ERR
        /* standard data types */
    ,TPE_DT_CHAR      = dnu_TPE_DT_CHAR
    ,TPE_DT_NUMERIC   = dnu_TPE_DT_NUMERIC
    ,TPE_DT_INTEGER   = dnu_TPE_DT_INTEGER
    ,TPE_DT_SMALLINT  = dnu_TPE_DT_SMALLINT
    ,TPE_DT_REAL      = dnu_TPE_DT_REAL
    ,TPE_DT_FLOAT     = dnu_TPE_DT_FLOAT
    ,TPE_DT_VARCHAR   = dnu_TPE_DT_VARCHAR
    ,TPE_DT_DATE      = dnu_TPE_DT_DATE
    ,TPE_DT_TIME      = dnu_TPE_DT_TIME
    ,TPE_DT_TIMESTAMP = dnu_TPE_DT_TIMESTAMP
    ,TPE_DT_TS_TIMEZONE = dnu_TPE_DT_TS_TIMEZONE
    ,TPE_DT_ARRAY       = dnu_TPE_DT_ARRAY
        /* implementation defined data types */
    ,TPE_DT_LVC       = dnu_TPE_DT_LVC
    ,TPE_DT_BINARY    = dnu_TPE_DT_BINARY
    ,TPE_DT_VARBINARY = dnu_TPE_DT_VARBINARY
    ,TPE_DT_LVB       = dnu_TPE_DT_LVB
    ,TPE_DT_BIGINT    = dnu_TPE_DT_BIGINT
    ,TPE_DT_BIGINT64  = dnu_TPE_DT_BIGINT64
    ,TPE_DT_TINYINT   = dnu_TPE_DT_TINYINT
    ,TPE_DT_BIT       = dnu_TPE_DT_BIT
    ,TPE_DT_NCHAR     = dnu_TPE_DT_NCHAR
    ,TPE_DT_NVARCHAR  = dnu_TPE_DT_NVARCHAR
     
     ,TPE_SVC_NUMERIC = dnu_TPE_SVC_NUMERIC        /* Not valid for customer use. */
                                             /* Only valid in 2 engine modules.... */

} tpe_datatype_t;

#define         TPE_DT_MAXTYPES        19

/* Precision and scale for numeric data_t. */

#define		TPE_MIN_PRECISION	1
#define		TPE_MAX_PRECISION	50
#define         TPE_DFT_PRECISION       32
#define		TPE_MIN_SCALE      	-84
#define		TPE_MAX_SCALE		127

  /* Max and default size for blobs */
#define  TPE_MAX_BLOBSIZE      1073741823 
#define  TPE_MAX_GETLOBSIZE    1073741823
#define  TPE_DEFAULT_BLOBSIZE       32000

/*
 * Internal representation of some of the 4GL/SQL data types
 */

/* Representation for NUMERIC types.  */
#define TPE_NUMERIC_SIZE 26

typedef struct {
	dh_i16_t	dec_num;
	dh_i8_t		dec_digits[TPE_NUMERIC_SIZE + 1];
} tpe_num_t;

/* Representation for DATE type */
typedef struct {
	dh_i16_t 	year ;
	dh_u8_t 	month;
	dh_u8_t 	day ;
} tpe_date_t ;

/* Internal representation for DATE type */
typedef dh_i32_t	tpe_idate_t;

/* Representation for TIME type */
typedef struct {
	dh_u8_t	hours;
	dh_u8_t	mins;
	dh_u8_t	secs;
	dh_u16_t	msecs;
} tpe_time_t;

/* Representation for TIMESTAMP type */
typedef struct {
	tpe_date_t   	ts_date ;
        tpe_time_t      ts_time ;
}  tpe_timestamp_t ;    

/* Representation for TIMESTAMP WITH TIMEZONE  type */
typedef struct {
	tpe_timestamp_t		tz_ts;
	dh_boolean		tz_zone_offset;
        tpe_time_t      	tz_displacement;
}  tpe_ts_timezone_t ;    

/* Host Representation for BINARY type */

/* The tb_data array size is being changed from
 * TPE_MAX_FLDLEN + 1 to
 * TPE_EXT_MAX_FLDLEN for the support of 32752
 * length varbinary type.
 *
 * NOTE : NEVER use DH_SIZEOF(tpe_binary_t) in the code. This
 * will result in allocation of large memory on stack. Therefore
 * either use data_max_hostsize () which is a member function of
 * data_t or use tpe_data_gethostlen () for calculating the
 * hostsize.
 *
 */
typedef struct {
         pro_DataLengthBytes_t  tb_len ;
         dh_u8_t                tb_data [TPE_EXT_MAX_FLDLEN] ;
} tpe_binary_t ;

/* tpe_binary_t equivalent with minimal size allocation.
 * For use only for pointer based access.
 * Not ordinarily for local, structure, or class data allocation.
 */
typedef struct {
         pro_DataLengthBytes_t  tb_len ;
         dh_u8_t                tb_data [1] ;
} tpe_binary_minspace_t ;

    
    
/* Host Representation for BIGINT type */
typedef struct {
	dh_u32_t		ll ;
	dh_i32_t		hl ;
} tpe_bigint_t ;

/* BEGIN DC091
 * Host Representaion for National Character type
 */


/* DC317 { 
 * The nchar_data array size is being changed from
 * TPE_MAX_FLDLEN*sizeof(dh_char_t) to
 * TPE_EXT_MAX_FLDLEN*sizeof(dh_char_t) for the support of 32752
 * length national varcharacter type.
 *
 * NOTE : NEVER use DH_SIZEOF(tpe_nchar_t) in the code. This
 * will result in allocation of large memory on stack. Therefore
 * either use data_max_hostsize () which is a member function of
 * data_t or use tpe_data_gethostlen () for calculating the
 * hostsize.
 *
 * DC317 }
 */

typedef struct{
  dh_char_t   charset_name[TPE_MAX_IDLEN_P1]; /* Character set Name */
  dh_char_t   collation[TPE_MAX_IDLEN_P1]; /* Collation Name */
  pro_DataLengthBytes_t data_len;      /* Length of data buffer in bytes */
  
  /* DC317 { 
   * This code is commented out.
   * dh_u8_t     nchar_data[TPE_MAX_FLDLEN*sizeof(dh_char_t) ];*/    

  dh_u8_t     nchar_data[(TPE_EXT_MAX_FLDLEN+1)*sizeof(dh_char_t) ]; /* Stores 
					data as array of bytes */
  /* DC317 } */

} tpe_nchar_t;

/* END DC091 */

/* DC317 { 
 * TPE_NCHAR_HDR_SZ macro is introduced for calculating the
 * sizeof (charset_name + collation + data_len). These data members
 * are present in tpe_nchar_t structure. This macro can be used
 * in places where hostsize is having the sizeof tpe_nchar_t
 * structure to get the actual data length.
 */

#define TPE_NCHAR_HDR_SZ offsetof(tpe_nchar_t,nchar_data)

/* TPE_BINARY_HDR_SZ macro is introduced for calculating the
 * sizeof (tb_len). This data member
 * is present in tpe_binary_t structure. This macro can be used
 * in places where hostsize is having the sizeof tpe_binary_t
 * structure to get the actual data length.
 */

#define TPE_BINARY_HDR_SZ offsetof(tpe_binary_t,tb_data)

/* DC317 } */


/* structure for holding a BLOB locator object.  This is what
   is actually stored in the table record on disk.
*/
typedef struct {
   dh_char_t locator[150]; /* includes some space for expansion & null terminator */
} tpe_lvb_locator_t;


/* Internal representation for TIME type (# of millisecs from start of day) */
typedef dh_i32_t	tpe_itime_t;

/* 
 * Internal representation for TIMESTAMP type
 */ 

typedef struct {
	tpe_idate_t	ts_idate ;
        tpe_itime_t     ts_itime ;
}  tpe_itimestamp_t ;

 
/* Convert from one type to another */
extern tpe_status_t tpe_conv_data (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_i32_t,			/* IN  input type */
    pro_DataLengthBytes_t,	/* IN  length of input buffer */
    void *,			/* IN  input buffer */
    const dh_char_t *,		/* IN  conversion format */
    dh_i32_t,			/* IN  output type desired */
    pro_DataLengthBytes_t,	/* IN  length of the output buffer */
    void *			/* OUT output buffer for result */
#endif
);


extern tpe_status_t tpe_get_datelen (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
     dh_char_t *,		/* IN   format string */
    pro_DataLengthBytes_t *	/* OUT  length */
#endif
);

extern tpe_status_t tpe_get_timelen (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_char_t *,		/* IN   format string */
    pro_DataLengthBytes_t *	/* OUT  length */
#endif
);

extern tpe_status_t tpe_get_timestamplen (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_char_t *,		/* IN   format string */
    pro_DataLengthBytes_t *	/* OUT  length */
#endif
);

extern tpe_status_t tpe_get_tstzlen (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_char_t *,		/* IN   format string */
    pro_DataLengthBytes_t *	/* OUT  length */
#endif
);

/* DC166 begin result changed to dh_i32_t */
/* Compare one data object with another */
extern tpe_status_t tpe_compare_data (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_i32_t,			/* IN  type for data object1 and data object2 */
    pro_DataLengthBytes_t,	/* IN  length of input buffer for data object1 */
    void *,			/* IN  input buffer for data object1 */
    pro_DataLengthBytes_t,	/* IN  length of the input buffer for data object2 */
    void *,			/* IN  input buffer for data object2 */
    dh_i32_t *			/* OUT comparison result */
#endif
);
/* DC166 end result changed to dh_i32_t */

/* Return day of the week from date */
extern dh_i32_t		tpe_dayofweek (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_date_t		/* IN  date */
#endif
);

/* Add two numeric data */
extern tpe_status_t	tpe_num_add (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_num_t *,	/* IN  operand 1 */
	tpe_num_t *,	/* IN  operand 2 */
	tpe_num_t *	/* OUT result */
#endif
);

/* Subtract two numeric data */
extern tpe_status_t	tpe_num_sub (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_num_t *,	/* IN  operand 1 */
	tpe_num_t *,	/* IN  operand 2 */
	tpe_num_t *	/* OUT result */
#endif
);

/* Multiply */
extern tpe_status_t	tpe_num_mul (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_num_t *,	/* IN  operand 1 */
	tpe_num_t *,	/* IN  operand 2 */
	tpe_num_t *	/* OUT result */
#endif
);

/* Divide */
extern tpe_status_t	tpe_num_div (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_num_t *,	/* IN  operand 1 */
	tpe_num_t *,	/* IN  operand 2 */
	tpe_num_t *	/* OUT result */
#endif
);

/* Convert to dh_i32_ternal representation of date */
extern tpe_status_t tpe_convdatetoi (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_date_t,		/* IN  date */
    tpe_idate_t *	/* OUT dh_i32_ternal form */
#endif
);

/* Convert from dh_i32_ternal representation of date */
extern tpe_status_t tpe_convitodate (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    tpe_idate_t,	/* IN  dh_i32_ternal date */
    tpe_date_t *	/* OUT date */
#endif
);

/* Convert to dh_i32_ternal representation of time */
extern tpe_status_t	tpe_convtimetoi (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_time_t,	/* IN  time */
	tpe_itime_t *	/* OUT dh_i32_ternal time */
#endif
);

/* Convert to dh_i32_ternal representation of time 
In this case we do not store time in msecs but in mins
This is a special case primarily created for time
zone offset of 'timestamp with time zone' data type*/
extern tpe_status_t	tpe_convtimetoimin (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_time_t,	/* IN  time */
	tpe_itime_t *	/* OUT dh_i32_ternal time */
#endif
);

/* Convert a string to a binary format */
extern tpe_status_t tpe_convstrtobinary (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	pro_DataLengthBytes_t,	 /* IN  input buffer length */
	const dh_char_t *,	 /* IN  input buffer        */
	tpe_binary_t *		 /* OUT output buffer	       */ 
#endif
);

/* Convert from dh_i32_ternal representation of time 
(in msecs) to hostform of time */
extern tpe_status_t	tpe_convitotime (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_itime_t,	/* IN  dh_i32_ternal time */
	tpe_time_t *	/* OUT time */
#endif
);

/* Convert from dh_i32_ternal representation of time
(in mins) to hostform of time */
extern tpe_status_t	tpe_convimintotime (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_itime_t,	/* IN  dh_i32_ternal time */
	tpe_time_t *	/* OUT time */
#endif
);

/* Round */
extern tpe_status_t tpe_round ( 
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_num_t * ,
	pro_DataLengthBytes_t	precision,
	dh_i32_t	scale
#endif
);

/* Numdecimal */
extern tpe_status_t tpe_getnumdecimal (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
	tpe_num_t *	,
	pro_DataLengthBytes_t *DigitsLeftOfDP,
	dh_i16_t *DigitsRightOfDP 
#endif
);


/* (DC044) .BEGIN */

/* For getting the sql diagnostics information, a new C API is
   defined */

extern dh_i32_t EXPORT 				
	    tpe_sqlgetdiag (
				struct sqlca* ,
				diag_kwd_t  *   ,
				dh_i16_t ,
				dh_i32_t ,
				dh_char_t *   ,
				struct sqlda  	*   
				);
/* (DC044) .END */

/* prdh_i32_t the tuples stored in the SQLCA to the given file */


extern tpe_status_t nomem (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_i32_t  , 
    const dh_char_t * 
#endif     
);

extern tpe_status_t assert_internal (
#if	defined(__cplusplus) || !defined(NO_PROTOTYPE)
    dh_i32_t  , 
    const dh_char_t * 
#endif 
 );

#define     FLD_MAXTYPES        TPE_DT_MAXTYPES

#define     SQL_NOT_FOUND       100L


/* The 500 ~ 999 range is reserved for Progress
 * sql92 server's native warning code.
 * Each warning code will be bypassed by the odbc/jdbc
 * driver and treated as warning, so that the warning
 * status(e.g SQL_SUCCESS_WITH_INFO for ODBC) will be
 * returned to the application with accessable native
 * warning code.
 */
#define     SQL_WARNING_MIN     500L
#define     SQL_WARNING_MAX     999L
#define     SQL_INCOMPLETE_RESULTSET          SQL_WARNING_MIN  
#define     SQL_ISOLATION_LVL_NOT_CHANGED     SQL_WARNING_MIN + 1
#define     SQL_INVAL_CONN_PROPERTY_IGNORED   SQL_WARNING_MIN + 2
#define     SQL_NO_AUX_DBS_CONNECTED          SQL_WARNING_MIN + 3
#define     SQL_ERR_PARSE_PROPERTY_FILE       SQL_WARNING_MIN + 4

#define     SQL_ERR_INTERNAL            assert_internal(__LINE__,__FILE__)
#define     SQL_ERR_NOMEM               nomem (__LINE__,__FILE__)
#define     SQL_ERR_INITFAIL            -20002L
#define     SQL_ERR_INSYNTAX            -20003L
#define     SQL_ERR_NOUSER              -20004L
#define     SQL_ERR_NOTBL               -20005L
#define     SQL_ERR_NOCOL               -20006L
#define     SQL_ERR_NOCOLS              -20007L
#define     SQL_ERR_INTYPES             -20008L
#define     SQL_ERR_AMBCOL              -20009L
#define     SQL_ERR_DUPCOL              -20010L
#define     SQL_ERR_BADLEN              -20011L
#define     SQL_ERR_BADPREC             -20012L
#define     SQL_ERR_BADSC               -20013L
#define     SQL_ERR_NOINS               -20014L
#define     SQL_ERR_SUBQRETS            -20015L
#define     SQL_ERR_BADNULL             -20016L
#define     SQL_ERR_MOREVALS            -20017L
#define     SQL_ERR_LESSVALS            -20018L
#define     SQL_ERR_BADTBLREF           -20019L
#define     SQL_ERR_BADGBCOL            -20020L
#define     SQL_ERR_NOTGEIN_HVG         -20021L
#define     SQL_ERR_NOTGEIN_SLCT        -20022L
#define     SQL_ERR_BADSETFN            -20023L
#define     SQL_ERR_NOTYET              -20024L
#define     SQL_ERR_AFNESTED            -20025L
#define     SQL_ERR_TBLREFCNT           -20026L
#define     SQL_ERR_BADSORTFNUM         -20027L
#define     SQL_ERR_DUPIDX              -20028L
#define     SQL_ERR_NOIDX               -20029L
#define     SQL_ERR_SEGEXISTS           -20030L
#define     SQL_ERR_DUPCLUST            -20031L
#define     SQL_ERR_NOCLUST             -20032L
#define     SQL_ERR_NOTBLSP             -20033L
#define     SQL_ERR_BADFPCT             -20034L
#define     SQL_ERR_NONULL              -20035L
#define     SQL_ERR_NOTPREPARED         -20036L
#define     SQL_ERR_EXECSELECT          -20037L
#define     SQL_ERR_NOTCLOSED           -20038L
#define     SQL_ERR_NOTSELECT           -20039L
#define     SQL_ERR_NOTOPENED           -20040L
#define     SQL_ERR_TBLEXISTS           -20041L
#define     SQL_ERR_MULTIDIST           -20042L
#define     SQL_ERR_TPLSZHI             -20043L
#define     SQL_ERR_ARRAYSZHI           -20044L
#define     SQL_ERR_NOFILE              -20045L
#define     SQL_ERR_FVNONULL            -20046L
#define     SQL_ERR_GRSELF              -20047L
#define     SQL_ERR_RVKSELF             -20048L
#define     SQL_ERR_KEYWDUSED           -20049L
#define     SQL_ERR_FLDCNTHI            -20050L
#define     SQL_ERR_IDXCNTHI            -20051L
#define     SQL_ERR_OVERFLOW            -20052L
#define     SQL_ERR_DBNOTOPEN           -20053L
#define     SQL_ERR_NODB                -20054L
#define     SQL_ERR_DBNOTSTARTED        -20055L
#define     SQL_ERR_NOTDBA              -20056L
#define     SQL_ERR_NORES               -20057L
#define     SQL_ERR_TRANS_ABORTED       -20058L
#define     SQL_ERR_NOTSFILES           -20059L
#define     SQL_ERR_TBLNOTEMPTY         -20060L
#define     SQL_ERR_INPUTSZHI           -20061L
#define     SQL_ERR_NOTPATHNM           -20062L
#define     SQL_ERR_DUPFILE             -20063L
#define     SQL_ERR_BADATCHT            -20064L
#define     SQL_ERR_BADSTMTT            -20065L
#define     SQL_ERR_BADSQLDA            -20066L
#define     SQL_ERR_1LOCALONLY          -20067L
#define     SQL_ERR_BADARG              -20068L
#define     SQL_ERR_SMLSQLDA            -20069L
#define     SQL_ERR_BUFLENHI            -20070L
#define     SQL_ERR_INVALID_OPN         -20071L
#define     SQL_ERR_SVRNOTALLOCD        -20072L
#define     SQL_ERR_STMT_TOOLONG        -20073L
#define     SQL_ERR_NOVIEWCOLLIST       -20074L
#define     SQL_ERR_LESSCOLNS           -20075L
#define     SQL_ERR_MORECOLNS           -20076L
#define     SQL_ERR_CHK_OPTION          -20077L
#define     SQL_ERR_ILLEGAL_OPN         -20078L
#define     SQL_ERR_MAXTBL              -20079L
#define     SQL_ERR_CHKOPT              -20080L
#define     SQL_ERR_INVAL_CNT           -20081L
#define     SQL_ERR_BADSORTFLD          -20082L
#define     SQL_ERR_NOTCOLREF           -20083L
#define     SQL_ERR_OJONSUBQUERY        -20084L
#define     SQL_ERR_ERRINOUTER          -20085L
#define     SQL_ERR_DUPCNST             -20086L
#define     SQL_ERR_COLCNTMM            -20087L
#define     SQL_ERR_INVUSER             -20088L
#define     SQL_ERR_SDATESETTING        -20089L
#define     SQL_ERR_NOTBLCOLLIST        -20090L
#define     SQL_ERR_QSTMTTOOLONG        -20091L
#define     SQL_ERR_NOTPL               -20092L
#define     SQL_ERR_SYNEXISTS           -20093L
#define     SQL_ERR_LINKEXISTS          -20094L
#define     SQL_ERR_NOLINK              -20095L
#define     SQL_ERR_MANDUSER            -20096L
#define     SQL_ERR_OPNNOTALLWD         -20097L
#define     SQL_ERR_MUL_ROWS            -20098L
#define     SQL_ERR_FTCH_RID            -20099L
#define     SQL_ERR_BADSUBQRY           -20100L
#define     SQL_ERR_NOREFS              -20101L
#define     SQL_ERR_PKEYNULL            -20102L
#define     SQL_ERR_NOKEY               -20103L
#define     SQL_ERR_INCPKEYS            -20104L
#define     SQL_ERR_NOPERM              -20105L
#define     SQL_ERR_BADTID              -20106L
#define     SQL_ERR_REMDBNOTUP          -20107L
#define     SQL_ERR_REMSVRNOTUP         -20108L
#define     SQL_ERR_NOREMDB             -20109L
#define     SQL_ERR_NOREMHOST           -20110L
#define     SQL_ERR_BAD_TAB_ATTR        -20111L

#define     SQL_ERR_BAD_IDX_ATTR        -20113L
#define     SQL_ERR_REFSPRSNT           -20115L
#define     SQL_ERR_CNSTVIOLN           -20116L
#define     SQL_ERR_TBLINCMPL           -20117L
#define     SQL_ERR_DUPCONSTRAINT       -20118L
#define     SQL_ERR_NOCONSTRAINT        -20119L
#define     SQL_ERR_RESERVEWORD         -20120L
#define     SQL_ERR_NOPERMISSION        -20121L
#define     SQL_ERR_NOPROC              -20122L
#define     SQL_ERR_INVALPROC           -20123L
#define     SQL_QUERY_TERMINATE         -20124L
#define     SQL_ERR_EXCEEDSMAX_OPNCURS  -20125L
#define     SQL_ERR_INV_CURSNAME        -20126L
#define     SQL_ERR_BADPARAM            -20127L
#define     SQL_ERR_NUMRANGE            -20128L
#define     SQL_ERR_DATATRUNC           -20129L
#define     SQL_ERR_TRNSRLBK            -20130L
#define     SQL_ERR_MISSINGPARAM        -20131L
#define     SQL_ERR_RVKRESTRICT         -20132L
#define     SQL_ERR_FENOTSUP            -20133L
#define     SQL_ERR_INV_LONGREF         -20134L
#define     SQL_ERR_GETDIAG             -20135L
#define     SQL_ERR_BADCNTNS            -20136L
#define     SQL_ERR_BADCNTNSTP          -20137L
#define     SQL_ERR_NOCNTNSIDX          -20138L
#define     SQL_ERR_BADLNGIDX           -20139L
#define     SQL_ERR_PROCEXISTS          -20140L
#define     SQL_ERR_JAVA_COMPILE_JAVAC  -20141L
#define     SQL_ERR_JAVA_EXEC           -20142L
#define     SQL_ERR_TOOMANYRECS         -20143L
#define     SQL_ERR_NULLVAL             -20144L
#define     SQL_ERR_INVALFLD            -20145L
#define     SQL_ERR_TRGEXISTS           -20146L
#define     SQL_ERR_NOTRIGGER           -20147L
#define     SQL_ERR_TRIGEXEC            -20148L
#define     SQL_ERR_NOTFOUND            -20149L
#define     SQL_ERR_NOVIEWRSSID         -20150L
#define     SQL_ERR_USEDRTBL            -20151L
#define     SQL_ERR_STRING_TOO_LONG     -20152L
#define     SQL_ERR_DSM_NOMEM			-20153L
#define     SQL_ERR_INVAL_ISOLTN_LVL    -20154L
#define     SQL_ERR_GTM_DISABLED		-20155L
#define     SQL_ERR_INVAL_SEQREF        -20170L
#define     SQL_ERR_NOSEQ               -20171L
#define     SQL_ERR_SEQEXISTS           -20172L
#define     SQL_ERR_BLOB_LIKE_UNSUPPF   -20173L
#define     SQL_ERR_INVALID_COLNUM      -20174L
#define     SQL_ERR_DATATYPE_MISMATCH   -20175L
#define     SQL_ERR_JAVA_COMPILE_IO     -20176L
#define     SQL_ERR_COLEXISTS           -20177L
#define     SQL_ERR_TBLHASCHKCNST       -20178L
#define     SQL_ERR_INVALID_CURSOR      -20179L
#define     SQL_ERR_LONG_BIGGER_COLWIDE -20180L
#define     SQL_ERR_LONG_TOOBIG_GET     -20181L
#define     SQL_ERR_LONG_MULTIROW_UPD   -20182L
#define     SQL_ERR_LONG_DERIVED_TBL    -20183L
#define     SQL_ERR_INVALID_LOB_HANDLE  -20184L
#define     SQL_ERR_ATTACH_PROGRESS_VER -20185L
#define     SQL_ERR_ATTACH_PROTOCOL_VER -20186L
#define	    SQL_ERR_PROTOCOL_VER_MISMATCH -20187L
#define	    SQL_ERR_NOPARAM_INSELECT      -20188L
#define	    SQL_ERR_HIT_PARAM             -20189L
#define     SQL_ERR_DUP_ATTR              -20190L
#define     SQL_ERR_INVAL_CONN_STRING     -20191L
#define     SQL_ERR_INVAL_CONN_PROPERTY   -20192L
#define     SQL_ERR_TBL_FROZEN            -20193L
#define     SQL_ERR_INDEX_IN_PREP_MODE    -20194L
#define     SQL_ERR_DROPTBL_IDX_PREP_MODE -20195L
#define     SQL_ERR_CRACTIDX_NOIXLOCK     -20196L
#define     SQL_ERR_NOTIN_INDEXTBL        -20197L
#define	    SQL_ERR_BAD_ARRAY_SIZE        -20198L
#define	    SQL_ERR_BAD_ARRAY_ELEMENT_REF -20199L
#define	    SQL_ERR_ARRAY_VALUE_OVERFLOW  -20200L
#define	    SQL_ERR_ARRAY_TOO_MANY_VALUES -20201L
#define	    SQL_ERR_INACTIVE_INDEX        -20202L
#define     SQL_ERR_INV_WORD_INDEX        -20203L
#define     SQL_ERR_DROP_RESTRICT_COND    -20204L
#define     SQL_ERR_DROP_CASCADE_NOTYET   -20205L
#define     SQL_ERR_INVAL_RECIDREF        -20206L
#define     SQL_ERR_IDX_COL_CASE_SENS     -20207L
#define     SQL_ERR_GTM_ACTIVE            -20208L
#define     SQL_ERR_TM_TABLE_FULL         -20209L
#define     SQL_ERR_64BIT_LOB_HANDLE      -20210L

/* To add new Progress statuses, see 20300, below.  */


#define     ARRAY_SIZE_MIN     1        /* minimum array size */
#define     ARRAY_SIZE_MAX     9999     /* maximum array size */

/* These precisely replicate JTA error codes */
#define     SQL_GTM_OK                  0L
#define     SQL_GTM_RBBASE              100L
#define     SQL_GTM_RBROLLBACK              SQL_GTM_RBBASE
#define     SQL_GTM_RBCOMMFAIL              SQL_GTM_RBBASE + 1  /* not yet in use 05-23-05 */
#define     SQL_GTM_RBDEADLOCK              SQL_GTM_RBBASE + 2  /* not yet in use 05-23-05 */
#define     SQL_GTM_RBINTEGRITY             SQL_GTM_RBBASE + 3  /* not yet in use 05-23-05 */
#define     SQL_GTM_RBOTHER                 SQL_GTM_RBBASE + 4  /* not yet in use 05-23-05 */
#define     SQL_GTM_RBPROTO                 SQL_GTM_RBBASE + 5
#define     SQL_GTM_RBTIMEOUT               SQL_GTM_RBBASE + 6  /* not yet in use 05-23-05 */
#define     SQL_GTM_RBTRANSIENT             SQL_GTM_RBBASE + 7  /* not yet in use 05-23-05 */
#define     SQL_GTM_RBEND                   SQL_GTM_RBTRANSIENT /* not yet in use 05-23-05 */

#define     SQL_GTM_NOMIGRATE               9L  /* not yet in use 05-23-05 */
#define     SQL_GTM_HUERHAZ                 8L  /* not yet in use 05-23-05 */
#define     SQL_GTM_HUERCOM                 7L  /* not yet in use 05-23-05 */
#define     SQL_GTM_HUERRB                  6L  /* not yet in use 05-23-05 */
#define     SQL_GTM_HUERMIX                 5L  /* not yet in use 05-23-05 */
#define     SQL_GTM_RDONLY                  3L  /* not yet in use 05-23-05 */
#define     SQL_ERR_GTM_RMERR           -3L
#define     SQL_ERR_GTM_NOTA            -4L
#define     SQL_ERR_GTM_INVAL           -5L
#define     SQL_ERR_GTM_PROTO           -6L
#define     SQL_ERR_GTM_RMFAIL          -7L
#define     SQL_ERR_GTM_DUPID           -8L
#define     SQL_ERR_GTM_OUTSIDE         -9L    
       
/* End of precisely replicated JTA error codes */

/* SQL_NETWORK errcodes */
#define		SQL_ERR_RPC		-20211L
#define		SQL_ERR_DAEMON		-20212L
#define		SQL_ERR_SQLSVR		-20213L
#define		SQL_ERR_SERVICE		-20214L
#define		SQL_ERR_INVHOST		-20215L
#define		SQL_ERR_INVDB		-20216L
#define		SQL_ERR_NWERR		-20217L
#define		SQL_ERR_INVPROTO	-20218L

#define		SQL_ERR_INVCONNAME	-20219L
#define		SQL_ERR_DUPCONNAME	-20220L
#define		SQL_ERR_NOACTIVECONN	-20221L
#define		SQL_ERR_NOENVDEFDB	-20222L
#define		SQL_ERR_MULTILOCALCON	-20223L
#define		SQL_ERR_INVPROTOCOL	-20224L
#define		SQL_ERR_EXCEEDEDMAXCON	-20225L
#define		SQL_ERR_BADDBHDL	-20226L
#define		SQL_ERR_INVHOSTNAME	-20227L
#define		SQL_ERR_BADAUTH		-20228L

#define		SQL_ERR_INVDATE		-20229L
#define		SQL_ERR_INVDATESTR	-20230L
#define		SQL_ERR_INVNUMBER	-20231L
#define		SQL_ERR_INVNUMSTR	-20232L
#define		SQL_ERR_INVTIME		-20233L
#define		SQL_ERR_INVTIMESTR	-20234L
#define		SQL_ERR_INVTSSTR	-20235L
#define		SQL_ERR_DIVBYZERO	-20236L
#define         SQL_ERR_BADISCAN        -20237L
#define         SQL_ERR_INVFORMAT       -20238L
#define         SQL_ERR_INV_CHARSET     -20239L /* DC091 */
#define         SQL_ERR_INV_COLLATE     -20240L
#define         SQL_ERR_SERVICE_INUSE   -20241L /* DC129 */

#define		SQL_ERR_NO_INDVAR	-20114L

/* Progress defined sql errors which do not require error classification or
 * error analysis or value substitution (as provided by pro_error_mgr.hxx, etc.).
 * Range - 20300..20999
 */
#define         SQL_ERR_SORT_FLDREF_SELDIST   -20300
#define         SQL_ERR_ALIAS_REF_EXPR        -20301
#define         SQL_ERR_BAD_TOP_CLAUSE        -20302
#define         SQL_ERR_EMPTY_COL_TBL         -20303
#define         SQL_ERR_BAD_ACTIVE_IDX        -20304
#define         SQL_ERR_NOSETISOLVL_INTRANS   -20305
#define         SQL_ERR_NOSETISOLVL_OPNCUR    -20306
#define         SQL_ERR_NOSETISOLVL_JTATRANS  -20307
#define         SQL_ERR_INVALID_ISOLVL        -20308
#define         SQL_ERR_LG_KEY_BAD_BS         -20309
#define         SQL_ERR_LG_KEY_ENABLED        -20310
#define         SQL_ERR_64BIT_SEQ_ENABLED     -20311
#define         SQL_ERR_64BIT_SEQ_IN_PROGRESS -20312
#define         SQL_ERR_CAT_IN_USE            -20313
#define         SQL_ERR_CAT_NOT_FOUND         -20314
#define         SQL_ERR_DB_ALREADY_CONNECTED  -20315
#define         SQL_ERR_NO_DISCONNECT_PRIMARY -20316
#define         SQL_ERR_NO_CONNECT_GTM_ACTIVE -20317
#define         SQL_ERR_SP_NO_RESULTSET       -20318
#define         SQL_ERR_NO_SUBSELECT_LOBS     -20319
#define         SQL_ERR_WIDTH_ATTR_TOO_SMALL  -20320
#define         SQL_ERR_OVER_MAXKCOMP         -20321
#define         SQL_ERR_REC_WIDTH_OVER_MAX    -20322
#define         SQL_ERR_TTBL_BUF_OVERFLOW     -20323
#define         SQL_ERR_NO_SA_PRIV            -20324
#define         SQL_ERR_NO_ENCRYPT            -20325
#define         SQL_ERR_INVALID_ENCRYPT       -20326
#define         SQL_ERR_ENCRYPT_OVERFLOW      -20327
#define         SQL_ERR_ENCRYPT_INVALID_AREA  -20328
#define         SQL_ERR_ENCRYPT_INVALID_COL   -20329
#define         SQL_ERR_ENCRYPT_SCHEMA_TBL    -20330
#define         SQL_ERR_BUFFER_POOL_INVALID_COL     -20331
#define         SQL_ERR_BUFFER_POOL_INVALID_AREA    -20332
#define         SQL_ERR_CNST_PRIMKEY_NULL_COL       -20333
#define         SQL_ERR_STMT_EXCEEDS_MAX_SZ         -20334 /* non-view statements */
#define         SQL_ERR_INSECURE_CONF_CONNECT       -20335
#define         SQL_ERR_ENCRYPT_FAIL_REKEY          -20336
#define         SQL_ERR_DECRYPT_FAIL                -20337
#define         SQL_ERR_NEXTVAL_INVALID_ISOLVL      -20338
#define         SQL_ERR_JAVA_CLASSCASTEXCEPTION     -20339


/* ODBC SDK specific errors */
#define         SQL_ERR_INVTBLID        -23000L
#define         SQL_ERR_INVIDXID        -23001L

/* ODBC integrator error codes.  Sub-range of RDS     */

#define		SQL_ERR_VLDONATCHT	    	-25001L
#define		SQL_ERR_INVLDONATCHT		-25002L
#define         ITG_COPY_OBJECT_EXISTS   	-25003L
#define 	ITG_NO_COPY_OBJECT       	-25004L		
#define 	ITG_TBL_DROP_FAILED		-25005L
#define 	ITG_BAD_COPY_SQL_STMT           -25006L
#define 	ITG_UNKNOWN_DATA_TYPE           -25007L
#define 	ITG_BAD_INSERT_STMT		-25008L
#define 	ITG_FETCH_FAILED		-25009L
#define 	ITG_INSERT_FAILED               -25010L
#define 	ITG_OPERATION_NOT_STARTED       -25011L
#define 	ITG_MARKED_FOR_ABORT		-25012L
#define 	ITG_COMMIT_FAILED               -25013L
#define 	ITG_CREATE_TBL_FAILED           -25014L
#define 	ITG_BAD_SYNC_SQL_STMT           -25015L
#define 	ITG_SYNC_OBJECT_EXISTS		-25016L
#define 	ITG_CREATE_SYNC_OBJECT_FAILED   -25017L
#define 	ITG_CREATE_COPY_OBJECT_FAILED   -25018L
#define 	ITG_NO_SYNC_OBJECT		-25019L
#define 	ITG_ILLEGAL_COLUMN_NAME         -25020L	
#define 	ITG_DUPLICATE_COLUMN_NAME	-25021L
#define 	ITG_INSTALL_FAILURE		-25022L
#define 	ITG_UNKNOWN_SYNC_MODE           -25023L
#define 	ITG_DWNLD_OR_SS_TABLE_MISSING	-25024L
#define 	ITG_UPLD_TABLE_MISSING          -25025L
#define 	ITG_UPDATE_FAILED               -25026L
#define 	ITG_DELETE_FAILED		-25027L
#define 	ITG_CLOSE_CURSOR_FAILED         -25028L
#define 	ITG_NO_PRIMARY_KEY              -25029L
#define 	ITG_MISSING_ROW                 -25030L 
#define 	ITG_BAD_PRIMARY_KEY             -25031L
#define 	ITG_UPDATE_CONTENTION		-25032L
#define 	ITG_ATTACH_TABLE_FAILED         -25033L
#define 	ITG_DETACH_TABLE_FAILED        	-25034L
#define 	ITG_ATTACH_DATABASE_FAILED      -25035L
#define 	ITG_DETACH_DATABASE_FAILED      -25036L
#define     ITG_INTERNAL_ERROR                  -25037L
#define     ITG_OPERATION_ALREADY_STARTED       -25038L
#define     ITG_OPEN_COPY_SQL_STMT_FAILED       -25039L
#define     ITG_DROP_SYNC_OBJECT_FAILED         -25040L
#define     ITG_DROP_COPY_OBJECT_FAILED         -25041L
#define     ITG_CLOSING_COPY_SQL_STMT_FAILED    -25042L
#define     ITG_TIMESTAMP_UPDATE_FAILED         -25043L
#define 	ITG_BAD_ARG_SQL_STMT            -25044L

/* ODBC integrator error codes in the TPE-ODBC translation layer */

#define 	ITG_ALLOCENVFAIL      -25101L
#define 	ITG_ALLOCONNFAIL      -25102L
#define 	ITG_SQLCONNFAIL       -25103L
#define 	ITG_SQLGCOPTFAIL      -25104L
#define 	ITG_SQLSCOPTFAIL      -25105L
#define 	ITG_SQLDISCNFAIL      -25106L
#define 	ITG_STMTMAPFAIL       -25107L
#define 	ITG_DISCONNFAIL       -25108L
#define 	ITG_SQLEXECFAIL       -25109L
#define 	ITG_SQLRCNTFAIL       -25110L
#define 	ITG_SETPARMFAIL       -25111L
#define 	ITG_BINDCOLFAIL       -25112L
#define 	ITG_SQLPREPFAIL       -25113L
#define 	ITG_SQLRCOLFAIL       -25114L
#define 	ITG_DSCRCOLFAIL       -25115L
#define 	ITG_SQLFREEFAIL       -25116L
#define 	ITG_SQLFTCHFAIL       -25117L
#define 	ITG_SQLTRNSFAIL       -25118L
#define 	ITG_ALLOCSTMTFAIL     -25119L
#define 	ITG_SQLTBLSFAIL       -25120L
#define 	ITG_SQLCOLSFAIL       -25121L
#define 	ITG_SQLSTATFAIL       -25122L
#define         ITG_ODBCIFACEERR      -25123L
#define         ITG_ODBCLIMITERR      -25124L
#define 	ITG_SQLGINFOFAIL      -25125L
#define 	ITG_NOTONRONLYDB      -25126L
#define 	ITG_NOTONVWWCK        -25127L
#define         ITG_MAXREMROW_LMT     -25128L
#define         ITG_SQLPKEYFAIL       -25129L
#define         ITG_SQLFKEYFAIL       -25130L
#define        ITG_DWNLD_COLINFO_FAIL -25131L

#define         SQL_STMT_CANCELLED    -30001L

/*
 The next two values create potential bugs by over or under estimating
 the sizes of the 'rpc' buffers.
 */
#define MAXSIZE 8                 /* RPC size of double */
#undef MAX_STRING_LEN /* Visual Studio6 will complain if we try to define
			 MAX_STRING_LEN and there is no undef */
#define MAX_STRING_LEN 10000
#define MULTIPLE_OF_FOUR(x) (4*(((x) + 3)/4))


#define		DSN_MAXNAME_LEN		256
#define		DSN_MAXIFCNAME_LEN	32
#define		DSN_MAXTPNAME_LEN	256
#define		DSN_MAXHOSTNAME_LEN	256
#define		DSN_MAXPROC		100
#define		DSN_MAXBUF_SZ		32768
#define		DSN_MAX_STRSZ		1024
#define		DSN_MAXARG		5

#define		DSN_NBLOCK		0x2

#define		DH_DAEMON_PORT		1992

#define		MC_UNKNOWN		0
#define		MC_INTEL		1
#define		MC_MOTOROLA		2
#define		MC_SPARC		3
#define		MC_VAX			4
#define     MC_PA                   5
#define     MC_RS6000               6
#define		MC_ALPHA		7


#define 	SNW_CHAR_SZ 		4
#define 	SNW_UCHAR_SZ 		4
#define 	SNW_SHORT_SZ 		4
#define 	SNW_USHORT_SZ 		4
#define 	SNW_LONG_SZ 		4
#define 	SNW_ULONG_SZ 		4
#define 	SNW_FLOAT_SZ 		4
#define 	SNW_DOUBLE_SZ 		8

/*
 List of SQL NETWORK error codes
*/


#define		DSN_STATUS_OK 		0L
#define		DSN_NO_MEM		-30011L
#define		DSN_INV_HDL		-30002L
#define		DSN_INV_INTERFACE	-30003L
#define		DSN_INV_PROC		-30004L
#define		DSN_ALREADY_ATCHD	-30005L
#define		DSN_ENT_NOTFND		-30006L
#define		DSN_ENT_EXISTS		-30007L
#define		DSN_SIZE_MISMATCH	-30008L
#define		DSN_INV_SVRID		-30009L
#define		DSN_INV_REPLY		-30010L
#define		DSN_ERR_INV_PKT_SIZE	-30012L
#define     DSN_DEFAULT_PORT    -30020L

#define		DSN_XMIT_ERR		-30031L
#define		DSN_RECV_ERR		-30032L
#define		DSN_NO_DATA		-30033L
#define		DSN_ERR_NWERR		-30034L

#define		DSN_IN_PROCESS		-30051L

#define		DSN_DAEMON_ERR		-30061L
#define		DSN_ARGCNT_ERR		-30062L
#define		DSN_IFACE_NFND		-30063L
#define		DSN_INV_PROCID		-30064L
#define		DSN_SVR_NOTAVL		-30065L
#define		DSN_INV_CONFIG		-30066L
#define		DSN_IFACE_NSUP		-30067L
#define         DSN_SVR_ISSSL           -30068L
#define         DSN_ERR_SSLHAND         -30069L
#define         DSN_ERR_SSLPARM		-30070L
#define         DSN_ERR_SSLCONN		-30071L

#define		DSN_SERVICE_ERR		-30091L
#define		DSN_HOST_ERR		-30092L
#define		DSN_ACCEPT_ERR		-30093L
#define		DSN_CONNECT_ERR		-30094L
#define		DSN_BIND_ERR		-30095L
#define		DSN_SOC_ERR		-30096L
#define		DSN_HDLOPT_ERR		-30097L

#define 	DSN_ATTACH_TYPE_ERR	-30098L

#define		DSN_INTERRUPTED		-30101L

#define		DSN_ERR_NOTCOMPAT	-30102L
#define         DSN_TIMEOUT             -30103L

/* ENV Manager error codes */
#define		SQL_ERR_ENVOVFLOW	-40001L

/* New storage system ( DHRSS ) error code */
#define		DHRSS_ERROR_IMPRPR_CALL	-50000L

/*--------------------------------------------------*/
/* ESQLC converts all capital letters to lower case */

#if	defined(__cplusplus)
}
#endif

/* 90B SQL92 Engine I18N */
/* I18N or NLS error messages */
#define		PRO_ERR_OPENCONVMAP		-60000L
#define		PRO_ERR_CREATENLS		-60001L
#define		PRO_ERR_CREATENLSCONV	-60002L
#define		PRO_ERR_CONVERSION		-60003L
#define		PRO_ERR_INVALID_CLIENT_CHARSET	-60004L
/* Constants for SQL client-server charset conversion */
#define			TPE_MAX_DBOPTIONS		1500
#define			CHARSET_NAME_LENGTH		20
#define         LOCALE_STRING_LENGTH     500
#define         JDBC_CHARSET             "UTF-8"
#define         CLIENT_CHARSET_BEGIN     "CLIENT_CHARSET["
#define         CLIENT_CHARSET_END       "]CLIENT_CHARSET"
#define         CLIENT_LANGUAGE_BEGIN    "CLIENT_LANGUAGE["
#define         CLIENT_LANGUAGE_END      "]CLIENT_LANGUAGE"
#define			CLIENT_CHARSET_PROMSGS_BEGIN	"PROMSGS_CHARSET["
#define			CLIENT_CHARSET_PROMSGS_END		"]PROMSGS_CHARSET"
#define		CLOB_CHARSET_BEGIN "CLOB_CHARSET["
#define		CLOB_CHARSET_END "]CLOB_CHARSET"
/* 90B SQL92 Engine I18N */

/* 91a SQL92 Engine Progress error statuses */
/* Error codes are cross referenced with dherrors file */

#define PRO_ERR_schema_lock_connect      -210001
    /* Failure to acquire share schema lock during Connect */

#define PRO_ERR_NODLC                    -210002
    /* Failure in finding DLC environment variable*/

#define PRO_ERR_DLCDIRTOOLONG            -210003
    /* DLC environment variable value exceeds maximum size*/

#define PRO_ERR_CONVMAPOPEN             -210004 
    /* Error opening convmap.cp file*/

#define PRO_ERR_table_lock_fail         -210005
    /* Failure to acquire record lock */     

#define PRO_ERR_DB_LOG_connect          -210011 
    /* Error getting a handle on the db log  */

#define PRO_ERR_SQL_FAT_COLUMN          -210012 
    /* Column %s in table %s has value exceeding its max length or*/
    /* precision.  */                   

#define PRO_ERR_SQL_NOCONNECT           -210013
    /* Unable to complete connection */

#define PRO_ERR_KEY_TOO_BIG             -210014
    /* Column values too big to make key*/

#define PRO_ERR_record_lock_fail         -210015
    /* Failure to acquire record lock */

#define PRO_ERR_lock_table_full          -210016
    /* Lock table is full.  */                    

#define PRO_ERR_schema_lock_fail_ddl     -210017
    /* Failure to acquire exclusive schema lock for DDL operation.  */  

#define PRO_ERR_word_index_update        -210018
    /* SQL request required update of word index (insert/delete).  */
    /* Progress SQL cannot yet update word indexes.      */

#define PRO_ERR_word_index_read          -210019
    /* SQL request required scan of word index. Should not happen because  */
    /* word index is made to cost high. This is a fail-safe error.  */
    /* Progress SQL cannot yet read word indexes.  */     

#define PRO_ERR_drop_prime_index         -210020
    /* The first index created for a table may not be dropped.  */  

#define PRO_ERR_jdk_not_found            -210021
    /* Location of the Java compiler was not specified  */    

#define PRO_ERR_javalib_not_found        -210022
    /* Failed during dynamic load of Java dynamic library.  */ 

#define PRO_ERR_javasym_not_found        -210023
    /* Failed to find standard symbol (entry point) in Java dynamic library.  */

#define PRO_ERR_blob_not_found           -210024 
    /* Failed to find to find dbkey representing a blob  */

#define PRO_ERR_blob_buffer_toosmall     -210025
    /* Buffer supplied for blob is too small  */

#define PRO_ERR_record_buffer_exceeded   -210026
    /* ** Attempt to expand record beyond the maximum allowed size.  */

#define PRO_ERR_invalid_area_no           -210027
  /* Invalid area number specified. */

#define PRO_ERR_object_create_error       -210028
  /* Error during object creation. */

#define PRO_ERR_too_many_columns          -210029
   /* Table contains more than the maximum columns currently supported. */

#define PRO_ERR_sqlda_is_null             -210030
   /* NULL sqlda provided to sql descriptor accessor function. */

#define PRO_ERR_sqlda_invalid_col_num     -210031
   /* Invalid column number provided to sql descriptor accessor function. */

#define PRO_ERR_sqlda_bad_datatype        -210032
   /* Data type used by sql descriptor accessor function is not valid. */

#define PRO_ERR_sqlda_invalid_da_attr     -210033
   /* DA attribute used by sql descriptor accessor function is not valid. */

#define PRO_ERR_sqlda_bad_value           -210034
   /* Data value used by sql descriptor accessor function is not valid. */

#define PRO_ERR_sqlda_is_readonly         -210035
   /* DA attribute used by sql descriptor accessor function is read only. */

#define PRO_ERR_sqlda_invalid_col_attr    -210036
   /* Column attribute used by sql descriptor accessor function is not valid. */

#define PRO_ERR_sqlda_value_toobig        -210037
   /* Data value used by sql descriptor accessor function is too large. */

#define PRO_ERR_sqlda_invalid_data_type   -210038
   /* Sqlda validation detected an invalid data type being used.  */

#define PRO_ERR_sqlda_invalid_odbc_flag   -210039
    /* Sqlda validation detected an invalid odbc flag being used.  */
    
#define PRO_ERR_sqlda_invalid_searchability_param  -210040
    /* Sqlda validation detected an invalid searchability parameter. */

#define PRO_ERR_sqlda_invalid_updatability_param   -210041
    /* Sqlda validation detected an invalid updatable parameter. */

#define PRO_ERR_sqlda_invalid_parameter_flag       -210042
    /* Sqlda validation detected an invalid parameter flag. */

#define PRO_ERR_no_long_on_derived_tables          -210043

#define PRO_ERR_recompile_stored_procedure         -210044
    /* Due to changes in datatypes we need to recompile stored procedures */

#define PRO_ERR_recompile_trigger                  -210045
    /* Due to changes in datatypes we need to recompile triggers */

#define PRO_ERR_update_statistics_oversize         -210047
    /* Update Statistics detected an oversized 4GL character column. */

#define PRO_ERR_stmt_cache_overflow                -210048
    /* Statement Mgr statement cache overflowed. */

#define PRO_ERR_sequence_corrupt                    -210049
    /* Sequence record was determined to be corrupt */
        
#define PRO_ERR_sequence_not_cycled                 -210050
    /* The sequence was unable to cycle */
        
#define PRO_ERR_sequence_not_found                  -210051
    /* The sequence referenced does not exist */
        
#define PRO_ERR_sequence_table_full                 -210052
    /* The maximum number of sequence definitions exist in the database */
        
#define PRO_ERR_sequence_exists                     -210053
    /* An attempt was made to create a sequence which already exists */
        
#define PRO_ERR_sequence_out_of_range               -210054
    /* A value was referenced outside of the defined value range */

#define PRO_ERR_database_is_readonly		   -210055
    /* Database is read only mode */

#define PRO_ERR_procedure_too_many_params          -210064
    /* Procedure contains more than the maximum parameters currently supported */

#define PRO_ERR_dumpname_not_unique                -210068
    /* dump-name supplied for CREATE TABLE is not unique */

#define PRO_ERR_inv_id_schema_pub                  -210069
    /* Identifier in schema PUB contains invalid characters. */

#define PRO_ERR_bad_col_attr                       -210070
    /* Invalid column attribute specified.  */

#define PRO_ERR_unknown_catalog                    -210071
    /* Specified catalog name not found in set of known catalogs. */

#define PRO_ERR_col_ambig_error                    -210072
    /*  Column reference "<column name>" is ambiguous. */

#define PRO_ERR_expr_alias_where                   -210073
    /*  Column alias "<column name>" references a select list expression  */
    /*  and so cannot be used in the WHERE clause or in an ON clause.  */

#define PRO_ERR_col_not_found                      -210074
    /* Column "<column name>" cannot be found or not specified for query. */

#define PRO_ERR_auxdb_charset_incompat             -210075
    /*  Character set for auxiliary db ("code page name") must be same  */
    /*  as character set for primary db ("code page name").             */

#define PRO_ERR_auxdb_collate_incompat             -210076
    /*  Collation for auxiliary db ("code page name") must be same     */
    /*  as collation for primary db ("code page name").                */



#define PRO_ERR_schemamod4GL_ddl          -211013
    /* SQL92 cannot alter/drop table created by 4GL/SQL89. */

#define PRO_ERR_viewowner_ddl              -211014
   /* Owner of a view cannot be PUB or _FOREIGN.  */

#define PRO_ERR_syspro_owner_ddl           -211015
  /* Db object owned by sysprogress: no create/drop/alter.  */

#define PRO_ERR_schema_table_ddl           -211016
  /* Db schema table owned by PUB: no create/drop/alter.  */

#define PRO_ERR_schema_table_dml           -211017
  /* Attempt to insert, update or delete a row in a schema table  */

#define PRO_ERR_array_ref_error            -211018
  /* Array data caused error  */  

#define PRO_ERR_no_sql_schema              -211019
  /* No SQL schema found in database ( run mkschema )  */  

#define PRO_ERR_inv_connection_property    -211021
  /* An invalid connection property was specified in the connect URL  */  

#define PRO_ERR_schemaread_ddl             -219902
  /*  Error reading schema on DDL stmt.  */ 

#define PRO_ERR_inconsistent_metadata      -219903
  /* Inconsistent metadata  */

#define PRO_ERR_bad_clob_charset           -219904
/* Bad character set for clob column */


#endif		/* sql_lib_included */
