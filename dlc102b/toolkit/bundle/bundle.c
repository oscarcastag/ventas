/* BUNDLE.C */

/* 
* Description:
*       Puts input files into a bundle-file.
*
* Usage: 
*       bundle bundle-file [-ascii | -binary] 
*               { {-file [selection-file]} | <input-file> }
* 
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>

#if ! defined( VMS ) && ! defined( MSDOS ) && ! defined( UNIX )
#define UNIX 1
#endif

#if defined( VMS )
#include <unixio.h>
#include <file.h>
#include <stat.h>
#endif

/*---------------------------------------*/
#if defined( MSDOS )
#include <io.h>
#include <fcntl.h>      /* For O_APPEND, O_RDONLY, etc. */
#include <sys\types.h>  /* For fstat(). */
#include <sys\stat.h>   /* For fstat(). */
#include <direct.h>     /* For getcwd(). */
#endif

#if defined( UNIX )
#include <sys/param.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#endif

#ifndef SEEK_END
#define SEEK_END 2
#endif
/*---------------------------------------*/

#define MY_VERSION '\0'

/*---------------------------------------*/
#ifdef VMS
#include <descrip.h>
#include <fscndef.h>

typedef struct dsc$descriptor vms_descrip_t;

#define VMS_DESCRIP_INIT( _d_, _strp_ ) \
    do { \
        _d_ dsc$b_dtype = DSC$K_DTYPE_T; \
        _d_ dsc$b_class = DSC$K_CLASS_S; \
        _d_ dsc$a_pointer = _strp_; \
        _d_ dsc$w_length = strlen( _d_ dsc$a_pointer ); \
    } while(0)
#endif /* VMS */
/*---------------------------------------*/

/*---------------------------------------*/
#if defined( MSDOS )
#define MY_SWITCH_CHAR '/'
#define MY_PATH_CHAR '\\'
#endif

#if defined( VMS )
#define MY_SWITCH_CHAR '/'
#define MY_PATH_CHAR ']'
#endif

#if defined( UNIX )
#define MY_SWITCH_CHAR '-'
#define MY_PATH_CHAR '/'
#endif
/*---------------------------------------*/

/*---------------------------------------*/
#if ! defined( NOPROTO ) && (defined( VMS ) || defined( __STDC__ ))
static int bundle_it(
    int             in_fd,
    int             out_fd,
    unsigned int    in_record_len,
    char            *in_file_name,
    char            *in_type
    );
static void my_error_exit(
    int     in_line_nbr,
    char    *in_message
    );
static char *just_file_name(
    char    *in_file_spec
    );
static void my_close_files(
    void
    );
static char *my_down_case(
    char    *in_string
    );
static char *my_up_case(
    char    *in_string
    );
static char *my_time_string(
    void
    );
#else
static int bundle_it();
static void my_error_exit();
static char *just_file_name();
static void my_close_files();
static char *my_down_case();
static char *my_up_case();
static char *my_time_string();
#endif
/*---------------------------------------*/

#define MY_SUCCESS 0
#define MY_FAILURE -1
#define MY_WARN 2

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

#define MY_TYPE_ASCII 'A'
#define MY_TYPE_BINARY 'B'
#define MY_TYPE_UNKNOWN '?'

#define MY_BUFF_SIZE (600 + 1)

/*---------------------------------------*/
#ifdef MAXPATHLEN
#define MY_FILE_NAME_SIZE (MAXPATHLEN + 30 + 1)
#else
#define MY_FILE_NAME_SIZE (500 + 1)
#endif
/*---------------------------------------*/

/*---------------------------------------*/
#if defined( VMS )
#define MY_REALPATH(_fname_, _fd_, _path_) (getname( _fd_, _path_ ))
#else
#if defined( REALPATH )
#define MY_REALPATH(_fname_, _fd_, _path_) (realpath( _fname_, _path_ ))
#else
#define MY_REALPATH(_fname_, _fd_, _path_) (NULL)
#endif
#endif
/*---------------------------------------*/

#define MY_ARG_MIN_LEN 1

static int      g_input_file_open = FALSE,
                g_output_file_open = FALSE,
                g_todo_file_open = FALSE;

static FILE     *g_todo_file = NULL;

static int      g_output_fd = -1,
                g_input_fd = -1;

static char     g_error_buff[ MY_BUFF_SIZE ];
static int      g_error_line = 0;

static char     g_input_line[ MY_BUFF_SIZE ];

static char     g_no_time[] = "Unknown Time\n";

static char     g_ascii_lit[] = "ascii",
                g_binary_lit[] = "binary",
                g_select_lit[] = "select",
                g_lower_lit[] = "lowercase",
                g_upper_lit[] = "uppercase";

static char     g_white_space[] = " \t\n\v\f";

static char     g_11_zeros[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

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

static char g_data_ind = MY_DATA_IND;

static char g_fs_prefix[]    = { MY_META_IND, MY_FS_REC,    MY_VERSION, ' ' },
            g_time_prefix[]  = { MY_META_IND, MY_TIME_REC,  MY_VERSION, ' ' },
            g_sof_prefix[]   = { MY_META_IND, MY_SOF_REC,   MY_VERSION, ' ' },
            g_eof_prefix[]   = { MY_META_IND, MY_EOF_REC,   MY_VERSION, ' ' },
            g_ftime_prefix[] = { MY_META_IND, MY_FTIME_REC, MY_VERSION, ' ' },
            g_fsize_prefix[] = { MY_META_IND, MY_FSIZE_REC, MY_VERSION, ' ' },
            g_cwd_prefix[]   = { MY_META_IND, MY_CWD_REC,   MY_VERSION, ' ' };

static int  g_prefix_size = sizeof( g_fs_prefix );

/* Timestamp record length is prefix plus sizeof ascii date minus its
* end-of-string character.  Ascii date is documented as always being size 26.
* A timestamp record is always written at the beginning of a bundle file and
* is used to verify that a file is indeed a bundle.
*/
#define MY_TIME_REC_LEN (sizeof( g_fs_prefix ) + 26 - 1)
/*---------------------------------------*/

/*
* PROGRAM: main
*/
main( argc, argv )
    int     argc;
    char    *argv[];
    {
    int             wk_status = MY_SUCCESS;
    unsigned int    wk_record_len = 0xf0;
    int             wk_input_pmode = 0;
    char            wk_def_type = MY_TYPE_UNKNOWN,
                    wk_cur_type;
    char            *wk_cp = NULL,
                    **wk_cpp = NULL;
    char            *wk_out_fname = NULL,
                    *wk_todo_fname = NULL,
                    *wk_cur_fname = NULL;
    int             wk_input_flags = O_RDONLY;
    int             wk_todo_file_present = FALSE;
    int             wk_done = FALSE;

#define MY_TO_CASE_NONE 0
#define MY_TO_CASE_UPPER 1
#define MY_TO_CASE_LOWER 2
    int             wk_to_case = MY_TO_CASE_NONE;

/*
* Set usage literal.
*/
#if defined( VMS ) || defined( MSDOS )
    static char     wk_usage_lit[] = 
  "bundle bundle-file [/ascii|/binary] [/lowercase|/uppercase]\n\
{ {/select [selection-file]}|in-file }";
#else
    static char     wk_usage_lit[] =
  "bundle bundle-file [-ascii|-binary] [-lowercase|-uppercase]\n\
{ {-select [selection-file]}|in-file }";
#endif

/*
* Set output flags.
*/
#if defined( MSDOS )
    int             wk_output_flags
                        = O_CREAT | O_RDWR | O_BINARY;
#endif
#if defined( VMS )
    int             wk_output_flags = O_CREAT | O_RDWR;
#endif
#if defined( UNIX )
    int             wk_output_flags = O_CREAT | O_RDWR;
#endif

/*
* Set output protection mode.
*/
#ifdef VMS
    int             wk_output_pmode = 0;    /* Use default protection. */
#else
    int             wk_output_pmode = 0644; /* Owner RW, all others R. */
#endif

    /*************************
    * Code section.
    **************************/
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
            else if ( 0 == strncmp( g_ascii_lit, 1 + wk_cp, wk_arg_len ) )
                wk_def_type = MY_TYPE_ASCII;
            else if ( 0 == strncmp( g_binary_lit, 1 + wk_cp, wk_arg_len ) )
                wk_def_type = MY_TYPE_BINARY;
            else if ( 0 == strncmp( g_select_lit, 1 + wk_cp, wk_arg_len ) )
                wk_todo_file_present = TRUE;
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
            if ( NULL == wk_out_fname )
                wk_out_fname = wk_cp;
            else if ( NULL == wk_todo_fname )
                wk_todo_fname = wk_cp;
            else
                g_error_line = __LINE__;
            break;
            } /*--switch--*/
        } /*--for--*/

    if ( 0 == g_error_line && NULL == wk_out_fname )
        {
        fprintf( stderr, "(Error %d) Output file missing.\n", __LINE__ );
        g_error_line = __LINE__;
        }
    if ( 0 == g_error_line 
    && ! wk_todo_file_present && NULL == wk_todo_fname )
        {
        fprintf( stderr, "(Error %d) Input file missing.\n", __LINE__ );
        g_error_line = __LINE__;
        }

    if ( 0 != g_error_line )
        {
        sprintf( 
            g_error_buff, "Usage:\n %s", wk_usage_lit );
        my_error_exit( g_error_line, g_error_buff );
        }

    /*
    * Open the output file.
    */
    g_output_fd =
#ifdef VMS
        open( 
            wk_out_fname, 
            wk_output_flags, 
            wk_output_pmode, 
            "ctx=bin", "ctx=stm", "mrs=512", "rfm=fix", "mbc=16" );
#else /* not VMS */
        open( wk_out_fname, wk_output_flags, wk_output_pmode );
#endif

    if ( 0 > g_output_fd )
        {
        sprintf( g_error_buff, 
            "Failed to open %s for output.", wk_out_fname );
        my_error_exit( __LINE__, g_error_buff );
        }
    g_output_file_open = TRUE;

    /*
    * Make sure that the output file is empty or, if not, that it's a bundle.
    */
    { /*--block--*/
    unsigned char       wk_byte;
    if ( 1 == read( g_output_fd, &wk_byte, 1 ) )
        /* It's not empty. */
        {
        if ( MY_TIME_REC_LEN != wk_byte
        || 1 != read( g_output_fd, &wk_byte, 1 )
        || MY_META_IND != wk_byte
        || 1 != read( g_output_fd, &wk_byte, 1 )
        || MY_TIME_REC != wk_byte )
            {
            sprintf( 
                g_error_buff,
                "File %s exists and does not look like a bundle.", 
                wk_out_fname );
            my_error_exit( __LINE__, g_error_buff );
            }
        else
            {
            fprintf( stderr,
                "(Info %d) Appending to existing bundle.\n", __LINE__ );
            }
        }
    else
        {
        fprintf( stderr,
                "(Info %d) Creating new bundle.\n", __LINE__ );
        }
            
    } /*--block--*/

    if ( ! ( wk_output_flags & O_APPEND ) )
        if ( 0 > lseek( g_output_fd, 0, SEEK_END ))
            {
            sprintf( g_error_buff, 
                "Failed to find end of file for %s.", wk_out_fname );
            my_error_exit( __LINE__, g_error_buff );
            }

    if ( wk_todo_file_present )
        /* Open the file of file names to be bundled. */
        {
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
        else /* Use stdin. */
            g_todo_file = stdin;
        }

    /* 
    * Write a timestamp to the bundle file.
    */
    { /*--block--*/
    char            *wk_time;
    int             wk_time_len;
    unsigned char   wk_len_byte;

    wk_time = my_time_string();
    wk_time_len = strlen( wk_time );
    /* NOTE: Time string includes a newline. */
    wk_len_byte = g_prefix_size + wk_time_len;
    if ( 1 != write( g_output_fd, &wk_len_byte, 1 )
    ||   g_prefix_size != write( g_output_fd, g_time_prefix, g_prefix_size )
    ||   wk_time_len != write( g_output_fd, wk_time, wk_time_len ) )
        my_error_exit( __LINE__, "Fatal write error on timestamp record." );
    } /*--block--*/

    /*
    * Write the current working directory.
    */
    { /*--block--*/
    char            wk_cwd[ MY_FILE_NAME_SIZE ];
    int             wk_cwd_len;
    unsigned char   wk_len_byte;

    if ( NULL != getcwd( wk_cwd, sizeof( wk_cwd ) ) )
        {
        wk_cwd[ sizeof( wk_cwd ) - 1 ] = '\0';
        wk_cwd_len = strlen( wk_cwd );
        wk_len_byte = g_prefix_size + wk_cwd_len + 1;
        if ( 1 != write( g_output_fd, &wk_len_byte, 1 )
        ||   g_prefix_size != write( g_output_fd, g_cwd_prefix, g_prefix_size )
        ||   wk_cwd_len != write( g_output_fd, wk_cwd, wk_cwd_len )
        ||   1 != write( g_output_fd, "\n", 1 ) )
            my_error_exit( __LINE__,
                "Fatal write error on current-directory record." );
        } /* if */
    } /*--block--*/

    /*
    * Bundle each of the files.
    */
    while ( ! wk_done )
        {
        if ( ! wk_todo_file_present )
            {
            wk_cur_fname = wk_todo_fname;
            wk_cur_type = wk_def_type;
            wk_done = TRUE;
            }
        else if
        ( ! fgets( g_input_line, sizeof( g_input_line ) - 1, g_todo_file ) )
            {
            wk_done = TRUE;
            break; /* while */
            }

        if ( wk_todo_file_present )
            {
            /* Get the file name. */
            wk_cur_fname = strtok( g_input_line, g_white_space );
            if ( NULL == wk_cur_fname )
                continue; /* while */

            /* Skip comment line. */
            if ( '#' == *wk_cur_fname || '!' == *wk_cur_fname )
                continue; /* while */

            /* And now the, possibly absent, type. */
            wk_cp = strtok( NULL, g_white_space );

            wk_cur_type = wk_def_type;
            if ( NULL != wk_cp && '#' != *wk_cp && '!' != *wk_cp )
                {
                int         wk_arg_len;
                if ( MY_SWITCH_CHAR == *wk_cp )
                    ++wk_cp;
                (void) my_down_case( wk_cp );
                wk_arg_len = strlen( wk_cp );
                if ( 0 == strncmp( g_ascii_lit, wk_cp, wk_arg_len ) )
                    wk_cur_type = MY_TYPE_ASCII;
                else if ( 0 == strncmp( g_binary_lit, wk_cp, wk_arg_len ) )
                    wk_cur_type = MY_TYPE_BINARY;
                else
                    fprintf( stderr, 
                        "(Warn %d) Invalid type: %s.  Using the default, %s.\n",
                        __LINE__,
                        wk_cp, 
                        (MY_TYPE_ASCII == wk_def_type) ? "ascii" : "binary" );
                } /*--if--*/
            } /* if wk_todo_file_present */

        switch ( wk_to_case )
        {
            case MY_TO_CASE_UPPER:
                (void) my_up_case( wk_cur_fname );
                break;
            case MY_TO_CASE_LOWER:
                (void) my_down_case( wk_cur_fname );
                break;
            case MY_TO_CASE_NONE:
                break;
        } /*--switch--*/

        /*
        * Open the input file to be bundled.
        */
        wk_input_flags = O_RDONLY;
#if defined( VMS )
        g_input_fd = ( MY_TYPE_ASCII == wk_cur_type )
            ? open( wk_cur_fname, wk_input_flags, wk_input_pmode,
                "mbc=16" )
            : open( wk_cur_fname, wk_input_flags, wk_input_pmode, 
                "mbc=16", "ctx=bin" );
#else 
#if defined( MSDOS )
        wk_input_flags |= 
            ( MY_TYPE_ASCII == wk_cur_type ) ? O_TEXT : O_BINARY;
#endif /* MSDOS */
        g_input_fd =
            open( wk_cur_fname, wk_input_flags, wk_input_pmode );
#endif /* VMS */

        if ( 0 > g_input_fd )
            {
            fprintf( stderr, "(Error %d) Failed to open %s for input.\n", 
                __LINE__, wk_cur_fname );
            continue; /* while */
            }
        g_input_file_open = TRUE;

        fprintf( stderr, "(Info %d) Bundling %s as %s file.\n",
            __LINE__, 
            wk_cur_fname, 
            (MY_TYPE_ASCII == wk_cur_type) ? "an ascii" : "a binary" );

        wk_status = bundle_it(
            g_input_fd,
            g_output_fd,
            wk_record_len,
            wk_cur_fname,
            &wk_cur_type );

        if ( MY_SUCCESS != wk_status )
            fprintf( stderr, "(Error %d) Bundle failed.\n", __LINE__ );

        close( g_input_fd );
        g_input_file_open = FALSE; 

        } /*--while--*/

    my_close_files();

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
* PROGRAM: bundle_it
*/
static int bundle_it( in_fd, out_fd, in_record_len, in_file_name, in_type )
    int             in_fd;
    int             out_fd;
    unsigned int    in_record_len;
    char            *in_file_name;
    char            *in_type;
    {
    int             read_len;
    unsigned char   write_len_byte,
                    wk_fname_len_byte;
    size_t          write_len;
    char            *wk_buff;
    int             wk_stat = MY_SUCCESS;
    int             file_name_len;
    char            *wk_file_name;

    wk_buff = (char *) malloc( in_record_len );
    if ( NULL == wk_buff )
        return MY_FAILURE;

    wk_file_name = just_file_name( in_file_name );
    if ( NULL == wk_file_name )
        {
        fprintf( stderr, "(Error %d) Failed to parse file-name from %s.", 
            __LINE__, in_file_name );
        return MY_WARN;
        }

    /*
    * Write start of file record.
    */
    file_name_len = strlen( wk_file_name );
    wk_fname_len_byte = g_prefix_size + 1 + 1 + file_name_len + 11 + 1;
    if ( 1 != write( out_fd, &wk_fname_len_byte, 1 )
    ||   g_prefix_size != write( out_fd, g_sof_prefix, g_prefix_size )
    ||   1 != write( out_fd, in_type, 1 )
    ||   1 != write( out_fd, " ", 1 )
    ||   file_name_len != write( out_fd, wk_file_name, file_name_len )
    ||   11 != write( out_fd, g_11_zeros, 11 )
    ||   1 != write( out_fd, "\n", 1 ) )
        my_error_exit( __LINE__, "Fatal write error on start-file record." );

    /*
    * Write the full file spec.
    */
    { /*--block--*/
    unsigned char       wk_len_byte = 0;
    int                 file_name_len = 0;
    char                wk_full_name[ MY_FILE_NAME_SIZE ],
                        *wk_full_name_p = wk_full_name;

    if ( 0 == MY_REALPATH( in_file_name, in_fd, wk_full_name ) )
        wk_full_name_p = in_file_name;

    file_name_len = strlen( wk_full_name_p );
    wk_len_byte = g_prefix_size + file_name_len + 1;
    if ( 1 != write( out_fd, &wk_len_byte, 1 )
    ||   g_prefix_size != write( out_fd, g_fs_prefix, g_prefix_size )
    ||   file_name_len != write( out_fd, wk_full_name_p, file_name_len )
    ||   1 != write( out_fd, "\n", 1 ) )
        my_error_exit( __LINE__, "Fatal write error on file-spec record." );
    } /*--block--*/

    /* Write some file statistics. */
    { /*--block--*/
    unsigned char   wk_len_byte = 0;
    struct stat     wk_fstat;
    char            *wk_time_string = NULL;
    char            wk_fsize_string[ 1 + sizeof( long ) ];

    if ( 0 == fstat( in_fd, &wk_fstat ) )
        {
        /* Write the file modification time record. */
        wk_time_string = ctime( &wk_fstat.st_mtime );
        if ( NULL != wk_time_string )
            {
            int         wk_time_len = strlen( wk_time_string );
            wk_len_byte = g_prefix_size + wk_time_len;
            if ( 1 != write( out_fd, &wk_len_byte, 1 )
            ||   g_prefix_size != write( out_fd, g_ftime_prefix, g_prefix_size )
            ||   wk_time_len != write( out_fd, wk_time_string, wk_time_len ) )
                my_error_exit( 
                    __LINE__, "Fatal write error on file-mtime record." );
            }

        /* Write the file size record. */
        if ( 0 != 
        sprintf( wk_fsize_string, "%u", (unsigned long) wk_fstat.st_size ) )
            {
            int         wk_fsize_len = strlen( wk_fsize_string );
            wk_len_byte = g_prefix_size + wk_fsize_len + 1;
            if ( 1 != write( out_fd, &wk_len_byte, 1 )
            ||   g_prefix_size != write( out_fd, g_fsize_prefix, g_prefix_size )
            ||   wk_fsize_len != write( out_fd, wk_fsize_string, wk_fsize_len )
            ||   1 != write( out_fd, "\n", 1 ) )
                my_error_exit( 
                    __LINE__, "Fatal write error on file-size record." );
            }
        } /* if fstat */
    } /*--block--*/

    /*
    * Write the file's contents.
    */
    while( 0 < ( read_len = read( in_fd, wk_buff, in_record_len ) ) )
        {
        if ( in_record_len < read_len )
            my_error_exit( __LINE__, "Fatal read error." );
        write_len_byte = 1 + read_len;
        if ( 1 != write( out_fd, &write_len_byte, 1 )
        ||   1 != write( out_fd, &g_data_ind, 1 )
        ||   read_len != ( write_len = write( out_fd, wk_buff, read_len ) ) )
            my_error_exit( __LINE__, "Fatal write error." );
        }

    /*
    * Write the end of file record.
    */
    if ( 1 != write( out_fd, &wk_fname_len_byte, 1 )
    ||   g_prefix_size != write( out_fd, g_eof_prefix, g_prefix_size )
    ||   1 != write( out_fd, in_type, 1 )
    ||   1 != write( out_fd, " ", 1 )
    ||   file_name_len != write( out_fd, wk_file_name, file_name_len )
    ||   11 != write( out_fd, g_11_zeros, 11 )
    ||   1 != write( out_fd, "\n", 1 ) )
        my_error_exit( __LINE__, "Fatal write error on end-file record." );

    if ( MY_SUCCESS == wk_stat
    && 0 != read_len )
        wk_stat == MY_FAILURE;

    free( wk_buff );

    return wk_stat;
    } /* BUNDLE_IT() */

/*
* PROGRAM:  just_file_name
*
* Input:    File specification.
* Output:   Filename and extension (type) from the input file specification.
*
* Examples:
*
* In                            Out
* ---------------------------   -------------------
* usr:[dev.src]whats_it.p;2     whats_it.p  [VMS]
* c:\usr\dev\src\whats_it.p     whats_it.p  [DOS]
* /usr/dev/src/whats_it.p       whats_it.p  [Unix]
* c:whats_it.p                  whats_it.p  [DOS]
*/
static char *just_file_name( in_file_spec )
    char    *in_file_spec;
    {
    char    *cp;
#ifdef VMS
    { /*--block--*/
    vms_descrip_t   source_string_d;
    struct
        {
        short       length;
        short       item_code;
        char        *pointer;
        } value_list[ 3 ];
    unsigned long           wk_stat;

    VMS_DESCRIP_INIT( source_string_d., in_file_spec );

    memset( value_list, 0, sizeof( value_list ) );
    value_list[ 0 ].item_code = FSCN$_NAME;
    value_list[ 1 ].item_code = FSCN$_TYPE;

    wk_stat = SYS$FILESCAN( &source_string_d, value_list, NULL ); 
    if ( 1 &  wk_stat )
        /* All's well. */
        {
        cp = value_list[ 0 ].pointer;
        cp[ value_list[ 0 ].length + value_list[ 1 ].length ] = '\0';
        }
    else
        /* Something's amiss. */
        cp = NULL;
    } /*--block--*/
#else /* not VMS */
    for ( cp = &in_file_spec[ strlen( in_file_spec ) - 1 ];
    ( in_file_spec != cp ) && ( MY_PATH_CHAR != *cp ) && ( ':' != *cp );
    --cp )
        /* do nothing */ ;
    cp = (cp == in_file_spec) ? cp : 1 + cp;
#endif /* VMS */

    return cp;
    } /* JUST_FILE_NAME() */

static void my_close_files()
    {
    if ( g_todo_file_open )
        {
        fclose( g_todo_file );
        g_todo_file_open = FALSE;
        }

    if ( g_input_file_open )
        {
        close( g_input_fd );
        g_input_file_open = FALSE;
        }

    if ( g_output_file_open )
        {
        close( g_output_fd );
        g_output_file_open = FALSE;
        }

    return;
    } /* MY_CLOSE_FILES() */

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

/*
* PROGRAM: my_time_string
*
* NOTE: Newline included at end of returned string.
*/
static char *my_time_string()
    {
    char        *wk_cp;
    time_t      wk_time;
    
    (void) time( &wk_time );
    wk_cp = ctime( &wk_time );
    if ( NULL == wk_cp )
        wk_cp = g_no_time;

    return wk_cp;
    } /* MY_TIME_STRING() */
