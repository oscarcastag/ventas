/* UNBUNDLE.C */

/*
* Description:
*       Extracts a table of contents or files from a bundle.
*
* Usage:
* unbundle [-toc|-fulltoc|-select|-all|-date] [-lowercase|-uppercase] 
*   bundle-file [files-to-select]
*
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <errno.h>

#if ! defined( VMS ) && ! defined( MSDOS ) && ! defined( UNIX )
#define UNIX 1
#endif

/*---------------------------------------*/
#if defined( VMS )
#include <unixio.h>
#include <file.h>
#include <rmsdef.h>
#include <fab.h>
#endif

#if defined( MSDOS )
#include <io.h>
#include <fcntl.h>
#endif

#if defined( UNIX )
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#endif
/*---------------------------------------*/

#ifdef VMS
#include <stat.h>
#include <fab.h>
#endif /* VMS */

#define MY_VERSION '\0'

#define MY_TYPE_ASCII 'A'
#define MY_TYPE_BINARY 'B'
#define MY_TYPE_UNKNOWN '?'

#define MY_ARG_MIN_LEN 1

#define MY_SUCCESS 0
#define MY_FAILURE -1
#define MY_NOT_OPEN 1

#ifndef FALSE
#define FALSE (1==0)
#define TRUE (1==1)
#endif

/*---------------------------------------*/
#if defined( VMS )

#if ! defined( __ALPHA )
#define EXIT_SUCCESS 0x10000001
#define EXIT_FAILURE 0x10000000
#endif

#else

#ifndef EXIT_SUCCESS
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1
#endif

#endif
/*---------------------------------------*/

/*---------------------------------------*/
#if defined( VMS ) || defined( MSDOS )
#define MY_SWITCH_CHAR '/'
#else
#define MY_SWITCH_CHAR '-'
#endif
/*---------------------------------------*/

#define MY_TOC_OP 'T'
#define MY_FULLTOC_OP 'F'
#define MY_SELECT_OP 'E'
#define MY_ALL_OP 'A'
#define MY_TIMESTAMP_OP 'S'
#define MY_UNKNOWN_OP '?'

/*---------------------------------------*/
typedef struct todo_item
    {
    struct todo_item    *next;
    int                 times_used;
    char                *file_name;
    char                *destination;
    } todo_item_t;

typedef struct todo_list
    {
    todo_item_t     *first;
    int             duplicates;
    } todo_list_t;
/*---------------------------------------*/

#if ! defined( NOPROTO ) && (defined( VMS ) || defined( __STDC__ ))
static int unbundle_it(
    int         in_input_fd,
    char        *in_operation,
    todo_list_t *in_todo_list,
    int         in_to_case
    );
static void my_error_exit(
    int     in_line_nbr,
    char    *in_message
    );
static int my_open_output(
    void
    );
static int my_close_output(
    void
    );
static void my_close_files(
    void
    );
static todo_item_t *my_todo_find(
    todo_list_t     *in_todo_list,
    char            *in_string
    );
static char *my_down_case(
    char    *in_string
    );
static char *my_up_case(
    char    *in_string
    );
#else
static int unbundle_it();
static void my_error_exit();
static int my_open_output();
static int my_close_output();
static void my_close_files();
static todo_item_t *my_todo_find();
static char *my_down_case();
static char *my_up_case();
#endif

#ifdef VMS
static void my_put_message(
    unsigned long       in_msg_number
    );
#endif /* VMS */

#ifdef VMS
#include <descrip.h>

typedef struct dsc$descriptor vms_descrip_t;

#define VMS_DESCRIP_INIT( _d_, _strp_ ) \
    do { \
        _d_ dsc$b_dtype = DSC$K_DTYPE_T; \
        _d_ dsc$b_class = DSC$K_CLASS_S; \
        _d_ dsc$a_pointer = _strp_; \
        _d_ dsc$w_length = strlen( _d_ dsc$a_pointer ); \
    } while(0)
#endif /* VMS */

#define MY_BUFF_SIZE (600 + 1)
#define MY_FILE_NAME_SIZE (500 + 1)

static int      g_bundle_file_open = FALSE,
                g_output_file_open = FALSE,
                g_todo_file_open = FALSE;

static FILE     *g_todo_file = NULL;

static int      g_bundle_fd = -1,
                g_output_fd = -1;

static int      g_output_flags = O_WRONLY;

#if defined( UNIX ) || defined( MSDOS )
static int      g_output_pmode = 0644; /* Owner RW, all others R. */
#else
static int      g_output_pmode = 0;
#endif

static char     g_output_file_name[ MY_FILE_NAME_SIZE ] = "";

static char     g_error_buff[ MY_BUFF_SIZE ] = "";
static int      g_error_line = 0;

static char     g_input_line[ MY_BUFF_SIZE ] = "";

static char     g_type = MY_TYPE_UNKNOWN;

static char     g_toc_lit[] = "toc",
                g_fulltoc_lit[] = "fulltoc",
                g_select_lit[] = "select",
                g_timestamp_lit[] = "date",
                g_all_lit[] = "all",
                g_lower_lit[] = "lowercase",
                g_upper_lit[] = "uppercase";

static char     g_white_space[] = " \t\n\v\f";

static char     g_usage_lit[] =
#if defined( VMS ) || defined( MSDOS )
  "unbundle [/toc|/fulltoc|/date|/all] [/lowercase|/uppercase] bundle-file\n\
[/select [selection-file]]";
#else
  "unbundle [-toc|-fulltoc|-date|-all] [-lowercase|-uppercase] bundle-file\n\
[-select [selection-file]]";
#endif

/*---------------------------------------*/
#define MY_DATA_IND '\n'        /* Data from the file. */
#define MY_META_IND '#'         /* Metadata about the file, etc. */
#define MY_FS_REC 'f'           /* File specification metadata. */
#define MY_SOF_REC '{'          /* Start of file metadata. */
#define MY_EOF_REC '}'          /* End of file metadata. */
#define MY_TIME_REC 't'         /* Timestamp metadata. */
#define MY_FTIME_REC 'm'        /* File modification time metadata. */
#define MY_FSIZE_REC 's'        /* File size metadata. */
#define MY_CWD_REC 'd'          /* Current working directory metadata. */
/*---------------------------------------*/

/*
* PROGRAM: main
*/
main( argc, argv )
    int     argc;
    char    *argv[];
    {
    int             wk_status = MY_SUCCESS;
    int             wk_pmode = 0;
    char            *wk_cp = NULL,
                    **wk_cpp = NULL;
    char            wk_operation = MY_UNKNOWN_OP;
    char            *wk_bundle_fname = NULL,
                    *wk_todo_fname = NULL;
    todo_list_t     wk_todo_list,
                    *wk_todo_list_p = NULL;
    todo_item_t     *wk_todo_cur = NULL;

#define MY_TO_CASE_NONE 0
#define MY_TO_CASE_UPPER 1
#define MY_TO_CASE_LOWER 2
static int      wk_to_case = MY_TO_CASE_NONE;

#ifdef MSDOS
    int         wk_input_flags = O_RDONLY | O_BINARY;
#else /* not MSDOS */
    int         wk_input_flags = O_RDONLY;
#endif

    /*************************
    * Code section.
    **************************/
    /*
    * Initialize some variables.
    */
    wk_todo_list.first = NULL;
    wk_todo_list.duplicates = FALSE;

    /*
    * Parse input arguments.
    */
    for ( wk_cpp = argv, wk_cp = *++wk_cpp;
    NULL != wk_cp && 0 == g_error_line;
    wk_cp = *++wk_cpp )
        {
        switch( *wk_cp )
            {
        case MY_SWITCH_CHAR:
            /* It's a switch. */
            { /*--block--*/
            int     wk_arg_len;

            (void) my_down_case( 1 + wk_cp );
            wk_arg_len = strlen( 1 + wk_cp );
            if ( MY_ARG_MIN_LEN > wk_arg_len )
                {
                fprintf( stderr, 
                    "(Error %d) \"%s\" is too short. Minimum length is %d.\n",
                    __LINE__, wk_cp, MY_ARG_MIN_LEN );
                g_error_line = __LINE__;
                }
            else if ( 0 == strncmp( g_toc_lit, 1 + wk_cp, wk_arg_len ) )
                wk_operation = MY_TOC_OP;
            else if ( 0 == strncmp( g_fulltoc_lit, 1 + wk_cp, wk_arg_len ) )
                wk_operation = MY_FULLTOC_OP;
            else if ( 0 == strncmp( g_select_lit, 1 + wk_cp, wk_arg_len ) )
                wk_todo_list_p = &wk_todo_list;
            else if ( 0 == strncmp( g_all_lit, 1 + wk_cp, wk_arg_len ) )
                wk_operation = MY_ALL_OP;
            else if ( 0 == strncmp( g_timestamp_lit, 1 + wk_cp, wk_arg_len ) )
                wk_operation = MY_TIMESTAMP_OP;
            else if ( 0 == strncmp( g_lower_lit, 1 + wk_cp, wk_arg_len ) )
                wk_to_case = MY_TO_CASE_LOWER;
            else if ( 0 == strncmp( g_upper_lit, 1 + wk_cp, wk_arg_len ) )
                wk_to_case = MY_TO_CASE_UPPER;
            else
                {
                fprintf( stderr, 
                    "(Error %d) Invalid parameter \"%s\" specified.\n",
                    __LINE__, wk_cp );
                g_error_line = __LINE__;
                }
            break;
            } /*--block--*/
        default:
            if ( NULL == wk_bundle_fname )
                wk_bundle_fname = wk_cp;
            else if ( NULL == wk_todo_fname )
                wk_todo_fname = wk_cp;
            else
                g_error_line = __LINE__;
            break;
            } /*--switch--*/
        } /*--for--*/

    if ( MY_UNKNOWN_OP == wk_operation )
        if ( NULL != wk_todo_list_p )
            wk_operation = MY_SELECT_OP;
        else
            wk_operation = MY_TOC_OP;

    if ( 0 == g_error_line && NULL == wk_bundle_fname )
        {
        fprintf( stderr, "(Error %d) Input file missing.\n", __LINE__ );
        g_error_line = __LINE__;
        }

    if ( 0 != g_error_line )
        {
        sprintf(
            g_error_buff, "Usage:\n %s", g_usage_lit );
        my_error_exit( g_error_line, g_error_buff );
        }

    if ( NULL != wk_todo_fname && NULL == wk_todo_list_p ) 
        {
        sprintf( g_error_buff, "Extraneous file: %s.", wk_todo_fname );
        my_error_exit( __LINE__, g_error_buff );
        }

    switch ( wk_operation )
        {
        case MY_SELECT_OP:
        case MY_ALL_OP:
            break;
        default:
            if ( NULL != wk_todo_list_p )
                break;
            if ( MY_TO_CASE_NONE != wk_to_case )
                printf( "(Info %d) Ignoring \"%s\" parameter.\n",
                    __LINE__, 
                    ( MY_TO_CASE_UPPER == wk_to_case ) 
                        ? g_upper_lit
                        : g_lower_lit );
            break;
        } /*--select--*/

    if ( NULL != wk_todo_list_p )
        {
        switch ( wk_operation )
            {
        case MY_SELECT_OP:
        case MY_FULLTOC_OP:
        case MY_TOC_OP:
            break;
        default:
            wk_todo_list_p = NULL;
            my_error_exit( __LINE__, "Selection list not applicable." );
            break;
            }
        }

    g_bundle_fd =
#ifdef VMS
        open( wk_bundle_fname, wk_input_flags, wk_pmode, 
            "mbc=16", "ctx=bin" );
#else /* not VMS */
        open( wk_bundle_fname, wk_input_flags, wk_pmode );
#endif
    if ( 0 > g_bundle_fd )
        {
        sprintf( g_error_buff,
            "Failed to open file %s for input.", wk_bundle_fname );
        my_error_exit( __LINE__, g_error_buff );
        }
    g_bundle_file_open = TRUE;

    /* Create todo (a.k.a. selection) list. */
    if ( NULL != wk_todo_list_p )
        {
        if ( MY_SELECT_OP == wk_operation )
            wk_todo_list_p->duplicates = TRUE;
        else
            wk_todo_list_p->duplicates = FALSE;

        if ( NULL != wk_todo_fname )
            {
            g_todo_file = fopen( wk_todo_fname, "r" );
            if ( NULL == g_todo_file )
                {
                sprintf( g_error_buff,
                    "Failed to open %s for input.", wk_todo_fname );
                my_error_exit( __LINE__, g_error_buff );
                }
            g_todo_file_open = TRUE;
            }
        else
            g_todo_file = stdin;

        while ( fgets( g_input_line, sizeof( g_input_line ) - 1, g_todo_file ))
            {
            todo_item_t     *tmp_item = NULL;
            int             tmp_len;
            char            *wk_cp;

            if ( '(' == *g_input_line )
                /* Skip our own messages written to stderr. */
                continue; /* while */
            wk_cp = strtok( g_input_line, g_white_space );
            if ( NULL == wk_cp || '#' == *wk_cp || '!' == *wk_cp )
                continue; /* while */

            if ( wk_todo_list_p->duplicates
            || ( ! wk_todo_list_p->duplicates
            && NULL == my_todo_find( wk_todo_list_p, wk_cp )))
                {
                tmp_item = (todo_item_t *) malloc( sizeof( todo_item_t ) );
                if ( NULL == tmp_item )
                    my_error_exit( __LINE__,
                        "Failed to get memory for select list." );

                tmp_len = strlen( wk_cp );
                tmp_item->file_name = (char *) malloc( 1 + tmp_len );
                if ( NULL == tmp_item )
                    my_error_exit( __LINE__,
                        "Failed to get memory for todo file name." );
                memcpy( tmp_item->file_name, wk_cp, 1 + tmp_len );

                wk_cp = strtok( NULL, g_white_space );
                if ( NULL == wk_cp || '#' == *wk_cp || '!' == *wk_cp )
                    tmp_item->destination = NULL;
                else
                    {
                    tmp_len = strlen( wk_cp );
                    tmp_item->destination = (char *) malloc( 1 + tmp_len );
                    if ( NULL == tmp_item )
                        my_error_exit( __LINE__,
                            "Failed to get memory for todo destination." );
                    memcpy( tmp_item->destination, wk_cp, 1 + tmp_len );
                    }

                if ( NULL == tmp_item->destination 
                && MY_TO_CASE_NONE != wk_to_case )
                    {
                    tmp_item->destination = (char *) malloc( 1 + tmp_len );
                    if ( NULL == tmp_item )
                        my_error_exit( __LINE__,
                            "Failed to get memory for todo file destination." );
                    memcpy(
                        tmp_item->destination,
                        tmp_item->file_name,
                        1 + tmp_len );
                    switch ( wk_to_case )
                        {
                    case MY_TO_CASE_UPPER:
                        (void) my_up_case( tmp_item->destination );
                        break;
                    case MY_TO_CASE_LOWER:
                        (void) my_down_case( tmp_item->destination );
                        break;
                        } /*--switch--*/
                    } /*--if--*/

                tmp_item->times_used = 0;
                tmp_item->next = NULL;
                } /*--if--*/

            if ( NULL == wk_todo_cur )
                wk_todo_list_p->first = tmp_item;
            else
                wk_todo_cur->next = tmp_item;
            wk_todo_cur = tmp_item;
            } /*--while--*/
        } /*--if MY_SELECT_OP--*/

    if ( g_todo_file_open )
        {
        fclose( g_todo_file );
        g_todo_file_open = FALSE;
        }

    wk_status = unbundle_it(
        g_bundle_fd, &wk_operation, wk_todo_list_p, wk_to_case );
    if ( MY_SUCCESS !=  wk_status )
        my_error_exit( __LINE__, "Unbundle failed." );

    for ( wk_todo_cur = wk_todo_list.first;
    NULL != wk_todo_cur;
    wk_todo_cur = wk_todo_cur->next )
        if ( 0 == wk_todo_cur->times_used )
            {
            if ( MY_SELECT_OP == wk_operation )
                fprintf( stderr, 
                    "(Warn %d) File %s (destination %s) not found.\n",
                    __LINE__, 
                    wk_todo_cur->file_name,
                    (NULL == wk_todo_cur->destination)
                        ? wk_todo_cur->file_name
                        : wk_todo_cur->destination );
            else
                fprintf( stderr, "(Warn %d) File %s not found.\n",
                    __LINE__, wk_todo_cur->file_name );
            }

    exit( EXIT_SUCCESS );
    } /* MAIN() */

/*
* PROGRAM: my_error_exit
*/
static void my_error_exit( in_line_nbr, in_message )
    int     in_line_nbr;
    char    *in_message;
    {
    fprintf( stderr, "(Error %d) %s\n", in_line_nbr, in_message );
    my_close_files();
    exit( EXIT_FAILURE );
    } /* MY_ERROR_EXIT() */

/*
* PROGRAM: unbundle_it
*/
static int unbundle_it( in_fd, in_operation, in_todo_list, in_to_case )
    int         in_fd;
    char        *in_operation;
    todo_list_t *in_todo_list;
    int         in_to_case;
    {
    unsigned char   len_byte;
    int             read_len;
    static char     wk_buff[ 600 + 1 ];
    char            *wk_buff_ptr;
    int             in_a_file = FALSE;
    int             skip_file = FALSE;
    int             file_error = FALSE;
    int             close_status = MY_SUCCESS;
    int             bytes_left = 0;
    todo_item_t     *wk_todo_item = NULL;
    int             wk_version = -1;
    int             first_time = TRUE;

    if ( MY_SELECT_OP == *in_operation && NULL == in_todo_list )
        {
        fprintf( stderr, "(Warn %d) Nothing in select list.\n", __LINE__ );
        return MY_SUCCESS;
        }

    while ( 1 == read( in_fd, &len_byte, 1 ))
        {
        if ( 0 == len_byte )
            /* We're in a zero-filled gap. Skip over it. */
            {
            int     wk_gap_size = 1;
            int     wk_bytes_read = 0;
            while ( 1 == (wk_bytes_read = read( in_fd, &len_byte, 1 )) 
            && 0 == len_byte )
                ++wk_gap_size;
            fprintf( stderr, 
                "(Info %d) Skipped unused area. Number of bytes: %d.\n",
                __LINE__, wk_gap_size );
            if ( 0 == wk_bytes_read )
                break; /* while */
            }

        for ( wk_buff_ptr = wk_buff, bytes_left = len_byte;
        0 < bytes_left;
        wk_buff_ptr += read_len )
            {
            read_len = read( in_fd, wk_buff_ptr, bytes_left );
            if ( 0 == read_len && ! in_a_file )
                /* End of file. */
                break; /* while */
            if ( 0 >= read_len || read_len > bytes_left )
                my_error_exit( __LINE__, "Fatal read error." );
            bytes_left -= read_len;
            }

        if ( first_time )
            {
            if ( MY_META_IND != wk_buff[ 0 ] 
            || MY_TIME_REC != wk_buff[ 1 ] )
                my_error_exit( __LINE__, 
                    "Input file does not look like a bundle." );
            }
        first_time = FALSE;

        if ( MY_META_IND == wk_buff[ 0 ] )
            {
            unsigned long   wk_len;

            wk_buff[ len_byte ] = '\0'; /* Put in end-of-string. */
            switch ( wk_buff[ 1 ] )
                {
            case MY_SOF_REC: /* Start of file. */
                if ( in_a_file )
                    my_error_exit( __LINE__,
                        "Input file corrupt. Bad start-file indicator." );
                in_a_file = TRUE;

                wk_version = (unsigned char) wk_buff[ 2 ];
                if ( MY_VERSION != wk_version )
                    fprintf( stderr,
                        "(Error %d) Expecting version %d. Found version %u.\n",
                        __LINE__, MY_VERSION, wk_version );
                if ( '\n' == wk_buff[ len_byte - 1 ] )
                    wk_buff[ len_byte - 1 ] = '\0';
                else
                    my_error_exit( __LINE__,
                        "Input file corrupt. Bad file-name record." );

                g_type = wk_buff[ 4 ];
                strncpy( g_output_file_name, &wk_buff[ 6 ], 
                    MY_FILE_NAME_SIZE - 1 );

                if ( MY_TIMESTAMP_OP == *in_operation )
                    skip_file = TRUE;
                else if ( MY_TOC_OP == *in_operation 
                || MY_FULLTOC_OP == *in_operation )
                    {
                    int     tab_cnt = 0;

                    skip_file = TRUE;
                    if ( NULL != in_todo_list )
                        {
                        if ( NULL == ( wk_todo_item
                        = my_todo_find( in_todo_list, g_output_file_name ) ) )
                            break; /* switch */
                        else
                            ++wk_todo_item->times_used;
                        }
                    tab_cnt = 4 - (1 + strlen( g_output_file_name )) / 8;
                    if ( 0 >= tab_cnt )
                        tab_cnt = 1;
                    printf( " %s%*.*s#%s\n",
                        g_output_file_name,
                        tab_cnt, tab_cnt, "\t\t\t\t",
                        (MY_TYPE_ASCII == g_type) ? "ascii" : "binary" );
                    }
                else if ( MY_SELECT_OP == *in_operation )
                    {
                    if ( NULL == ( wk_todo_item
                    = my_todo_find( in_todo_list, g_output_file_name ) ) )
                        skip_file = TRUE;
                    else
                        {
                        ++wk_todo_item->times_used;
                        if ( NULL != wk_todo_item->destination )
                            strncpy( 
                                g_output_file_name,
                                wk_todo_item->destination,
                                MY_FILE_NAME_SIZE );
                        }
                    }
                else if ( MY_ALL_OP == *in_operation )
                    {
                    switch ( in_to_case )
                        {
                    case MY_TO_CASE_UPPER:
                        (void) my_up_case( g_output_file_name );
                        break;
                    case MY_TO_CASE_LOWER:
                        (void) my_down_case( g_output_file_name );
                        break;
                    case MY_TO_CASE_NONE:
                        break;
                        } /*--switch--*/
                    }

                if ( ! skip_file )
                    {
                    fprintf( stderr, "(Info %d) Unbundling %s as %s file.\n",
                        __LINE__, g_output_file_name,
                        (MY_TYPE_ASCII == g_type) ? "an ascii" : "a binary" );
                    if ( MY_SUCCESS == my_open_output() )
                        skip_file = FALSE;
                    else
                        {
                        file_error = TRUE;
                        skip_file = TRUE;
                        }
                    }
                break; /* switch */
            case MY_EOF_REC: /* End of file. */
                if ( ! in_a_file )
                    /* The input file is corrupted so bail out. */
                    my_error_exit( __LINE__,
                        "Input file corrupt. Bad end-file indicator." );
                close_status = my_close_output();
                if ( file_error )
                    {
                    fprintf( stderr, "(Error %d) Unbundle error in file %s.\n",
                        __LINE__, g_output_file_name );
                    if ( MY_SUCCESS == close_status )
                        if ( 0 == remove( g_output_file_name ) )
                            fprintf( stderr, "(Info %d) Deleted file %s.\n",
                                __LINE__, g_output_file_name );
                        else
                            fprintf( stderr, 
                                "(Info %d) Unable to delete file %s.\n",
                                __LINE__, g_output_file_name );
                    }
                in_a_file = FALSE;
                skip_file = FALSE;
                file_error = FALSE;
                break; /* switch */
            case MY_CWD_REC:    /* Current working directory. */
                wk_version = (unsigned char) wk_buff[ 2 ];
                if ( MY_FULLTOC_OP == *in_operation )
                    printf( "# V%u Current-directory: %s",
                        wk_version, 4 + wk_buff );
                break; /* switch */
            case MY_FS_REC:     /* File spec. */
            case MY_FTIME_REC:  /* File modify time. */
            case MY_FSIZE_REC:  /* File size. */
                wk_version = (unsigned char) wk_buff[ 2 ];
                if ( MY_FULLTOC_OP == *in_operation
                && ( NULL == in_todo_list
                ||   NULL != wk_todo_item ))
                    {
                    char        *wk_lit = NULL;
                    switch ( wk_buff[ 1 ] )
                        {
                    case MY_FS_REC:     /* File spec. */
                        wk_lit = "Input-file";
                        break;
                    case MY_FTIME_REC:  /* File modify time. */
                        wk_lit = "File-modify-time";
                        break;
                    case MY_FSIZE_REC:  /* File size. */
                        wk_lit = "File-size";
                        break;
                        } /* switch */
                    printf( "# V%u %s: %s", wk_version, wk_lit, 4 + wk_buff );
                    } /* if */
                break; /* switch */
            case MY_TIME_REC:   /* Timestamp. */
                wk_version = (unsigned char) wk_buff[ 2 ];
                if ( MY_FULLTOC_OP == *in_operation
                ||   MY_TIMESTAMP_OP == *in_operation )
                    printf( "# V%u Time-stamp: %s", wk_version, 4 + wk_buff );
                break; /* switch */
            default: /* Anything else is a comment. */
                if ( MY_FULLTOC_OP == *in_operation )
                    printf( "# %s", 4 + wk_buff );
                break; /* switch */
                } /*--switch--*/
            continue; /* while */
            } /*--if MY_META_IND --*/
        if ( skip_file )
            continue;
        if ( '\n' != wk_buff[ 0 ] )
            {
            file_error = TRUE;
            skip_file = TRUE;
            continue;
            }
        if ( len_byte - 1
        != write( g_output_fd, wk_buff + 1, (int) len_byte - 1 ) )
            my_error_exit( __LINE__, "Fatal write error." );
    } /*--while--*/

    return MY_SUCCESS;
    } /* UNBUNDLE_IT() */

/*
* PROGRAM: my_open_output
*/
static int my_open_output()
    {
#if defined( VMS )
    int             wk_tries;
    unsigned long   wk_status;
    struct FAB      wk_fab;

    if ( 0 == strchr( g_output_file_name, '.' ) )
        strcat( g_output_file_name, "." );
#endif

#if defined( VMS )
    g_output_flags = O_WRONLY | O_CREAT | O_EXCL;
    for( wk_tries = 0; ; ) /* Try at most twice to open the file. */
        {
        /* First time we fail if the file already exists.  Second time
        * we open the file we created with RMS and that should succeed.
        * We do this because the VAXC RTL always copies file attributes
        * from an earlier version if it exists, and we want to specify
        * these attributes ourselves.
        */
        if ( MY_TYPE_ASCII == g_type )
            g_output_fd = open(
                g_output_file_name,
                g_output_flags,
                g_output_pmode,
                "mbc=16", "rfm=stmlf" );
        else /* 'B' (binary) or something else */
            g_output_fd = open(
                g_output_file_name,
                g_output_flags,
                g_output_pmode,
                "mbc=16", "mrs=80", "rfm=var", "ctx=bin", "ctx=nocvt" );
        if ( 0 < g_output_fd ) /* If success. */
            break;

        ++wk_tries;
        if ( 2 <= wk_tries ) /* Only try this twice. */
            break; /* for */

        /* If that fails, create the file with RMS. */
        wk_fab              = cc$rms_fab;
        wk_fab.fab$l_fna    = g_output_file_name;
        wk_fab.fab$b_fns    = strlen( g_output_file_name );
        wk_fab.fab$l_fop    = FAB$M_MXV;
        if ( MY_TYPE_ASCII == g_type )
            wk_fab.fab$b_rfm    = FAB$C_STMLF;
        else /* 'B' (binary) or something else. */
            {
            wk_fab.fab$b_rfm    = FAB$C_VAR;
            wk_fab.fab$w_mrs    = 80;
            }

        wk_status = sys$create( &wk_fab );
        if ( ! ( 1 & wk_status ) )
            {
            (void) sys$close( &wk_fab );
            break; /* for */
            }
        if ( RMS$_FILEPURGED == wk_status )
            printf( "(Warn %d) Oldest version of file purged.\n", __LINE__ );

        wk_status = sys$close( &wk_fab );
        if ( ! ( 1 & wk_status ) )
            break; /* for */

        g_output_flags = O_WRONLY;
        } /*--for--*/
#else /* Not VMS. */
    g_output_flags = O_WRONLY | O_CREAT | O_EXCL;
#if defined( MSDOS )
    g_output_flags |= (MY_TYPE_ASCII == g_type ) ? O_TEXT : O_BINARY;
#endif
    errno = 0;
    g_output_fd = open(
        g_output_file_name,
        g_output_flags,
        g_output_pmode );
    if ( 0 > g_output_fd ) /* If error. */
        {
        int     wk_errno = errno;

        g_output_flags = O_WRONLY | O_CREAT | O_TRUNC;
#if defined( MSDOS )
        g_output_flags |= (MY_TYPE_ASCII == g_type ) ? O_TEXT : O_BINARY;
#endif
        g_output_fd = open(
            g_output_file_name,
            g_output_flags,
            g_output_pmode );
        if ( 0 < g_output_fd /* If success. */
        && EEXIST == wk_errno )
            printf( "(Warn %d) Existing file overwritten.\n", __LINE__ );
        }
#endif

    if ( 0 > g_output_fd )  /* If error. */
        {
        fprintf( stderr, "(Error %d) Failed to open file %s.\n",
            __LINE__, g_output_file_name );
        g_output_file_open = FALSE;
        return MY_FAILURE;
        }
    g_output_file_open = TRUE;

    return MY_SUCCESS;
    } /* MY_OPEN_OUTPUT() */

/*
* PROGRAM: my_close_output
*/
static int my_close_output()
    {
    int         wk_status;

    if ( ! g_output_file_open )
        return MY_NOT_OPEN;

    wk_status = close( g_output_fd );
    if ( EOF == wk_status )
        {
        fprintf( stderr, "(Error %d) Failed to close file %s.\n",
            __LINE__, g_output_file_name );
        return MY_FAILURE;
        }
    g_output_file_open = FALSE;

    return MY_SUCCESS;
    } /* MY_CLOSE_OUTPUT() */

/*
* PROGRAM: my_close_files
*/
static void my_close_files()
    {
    if ( g_todo_file_open )
        {
        fclose( g_todo_file );
        g_todo_file_open = FALSE;
        }

    if ( g_bundle_file_open )
        {
        close( g_bundle_fd );
        g_bundle_file_open = FALSE;
        }

    my_close_output();

    return;
    } /* MY_CLOSE_FILES() */

static todo_item_t *my_todo_find( in_todo_list, in_string )
    todo_list_t     *in_todo_list;
    char            *in_string;
    {
    todo_item_t     *wk_todo_cur = NULL;

    for ( wk_todo_cur = in_todo_list->first;
    NULL != wk_todo_cur;
    wk_todo_cur = wk_todo_cur->next )
        if ( ( ! in_todo_list->duplicates || 0 == wk_todo_cur->times_used )
        && 0 == strcmp( wk_todo_cur->file_name, in_string ) )
            break;

    return wk_todo_cur;
    } /* MY_TODO_FIND() */

/*
* PROGRAM: my_down_case
*/
static char *my_down_case( in_string )
    char    *in_string;
    {
    char    *wk_cp;

    for ( wk_cp = in_string; '\0' != *wk_cp; ++wk_cp )
        *wk_cp = tolower( *wk_cp );

    return in_string;
    } /* MY_DOWN_CASE() */

/*
* PROGRAM: my_up_case
*/
static char *my_up_case( in_string )
    char    *in_string;
    {
    char    *wk_cp;

    for ( wk_cp = in_string; '\0' != *wk_cp; ++wk_cp )
        *wk_cp = toupper( *wk_cp );

    return in_string;
    } /* MY_UP_CASE() */

#ifdef VMS
/*
* PROGRAM: my_put_message
*/
static void my_put_message(
    unsigned long       in_msg_number
    )
    {
    unsigned long       wk_msg_vec[] = { 0x00fe0001, in_msg_number, 0 };

    (void) SYS$PUTMSG( wk_msg_vec, NULL, NULL, 0 );

    return;
    } /* MY_PUT_MESSAGE() */
#endif /* VMS */
