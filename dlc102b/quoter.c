/*********************************************************/
/**							**/
/**	quoter - formats data to be input to PROGRESS.	**/
/**	The data can be an arbitrary text file or a	**/
/**	file created with the dBASE COPY command in	**/
/**	SDF (System Data Format), with or without the	**/
/**	delimiter option.				**/
/**							**/
/**	The quoter command format is:			**/
/**	  quoter [-d <delim>] [filename]		**/
/**		 [-c <clist>]				**/
/**							**/
/**	The -d option specifies the field delimiter	**/
/**	from the dBASE copy command.			**/
/**							**/
/**	The -c option specifies columns to extract	**/
/**	from each line in the file.  The columns	**/
/**	are specified as a comma separated list of	**/
/**	ranges (e.g., 1-3,5-9).  If the end of a	**/
/**	range is not specified, it defaults to 1 less	**/
/**	than the next field, or if the last range,	**/
/**	the end of the record (line).			**/
/**							**/
/**	The -d and -c options are mutually exclusive.	**/
/**	If neither is entered, the entire line is	**/
/**	taken to be one input field.			**/
/**							**/
/** 	On VMS, the format is				**/
/**							**/
/**	pro/tools=quoter/delimiter="<delim-char"	**/
/**			/out=<file-name>"		**/
/**			or			 	**/
/**	pro/tools=quoter/column="range-definition"	**/
/**			/out=<fil-nam>"			**/
/**							**/
/**	/column and /delimiter are mutually exclusive   **/
/** 	Note that both delimiters and column qualifer	**/
/**	values should be enclosed by double quotes	**/
/**							**/
/**	If no filename is specified, the standard	**/
/**	input is used.					**/
/**	quoter places quotes around each field,		**/
/**	converting embedded quotes to two consecutive	**/
/**	quotes.  Null fields are replaced by " - ".	**/
/**							**/
/*********************************************************/
/**/
/* for VMS use, compile with /DEFINE=VMS=1		*/
#include <stdio.h>
#ifdef VMS
#define OPSYS VMS
#include <climsgdef.h>
#include <ssdef.h>
#include <descrip.h>
    	$DESCRIPTOR(p1,			"P1");
    	$DESCRIPTOR(output_file,	"OUTPUT_FILE");
    	$DESCRIPTOR(column_range,	"COLUMN_RANGE");
    	$DESCRIPTOR(delimiter,		"DELIMITER");
#else
#define OPSYS -1
#endif
#define MAXRNGES	100	/* maximum number of ranges in -c option */
#define MAXINPSIZ	4096
#define FAST		register

/* GLOBAL VARAIBLES */
#if OPSYS==VMS
FILE	*pfin;
FILE   *pfout;
#else
FILE    *pfin;  /* file pointer of input file */
#endif
char	 delim	= 0;		/* field delimiter character */
char	 cflag	= 0;		/* was the -c option used? */
int	 nxtarrs = 0;		/* next column of colinfo to store -c data*/

struct colarr	/* one column array is used for each range entered */
{
	short	 low;		/* lower boundary */
	short	 high;		/* upper boundary */
	char	*stptr;		/* start of dynamic memory for field */
	char	*nxtptr;	/* used to build and output the field */
				/* in the current record */
} colinfo[MAXRNGES+1];


main ( argc, argv )

	int	 argc;
	char	*argv[];
{
    pfin=stdin;
    if (!parseargs(argv)) exit(-1);

    if (cflag)	procols();
    else
    if (delim)	procdelims();
    else	proclines();

    fclose (pfin);	/* close input file */
#if OPSYS==VMS
    exit(1);
#else
    exit(0);
#endif
}
/**/
/*****************************************************************/
/** procols - process the input file using the column array	**/
/*****************************************************************/

procols()

{
FAST	struct	colarr  *arrptr;	/* pointer to column info */
FAST		int	c;		/* current input char */
FAST		int	colno = 0;	/* current col in record */

    /* loop thru input file */
    while ( (c = getc(pfin)) != EOF )
    {
	/* at the end of each record, output all stored strings and
	    reset current column number */
	if (c == '\n')
	{
	    flcolarr();
	    colno = 0;
	}
	else	/* have a character in the record */
	{
	    colno++;
	    /* store the char in the column array for each range that
	    contains the current column
	    */
	    for (arrptr = colinfo; arrptr->low; arrptr++)
		if (colno >= arrptr->low && colno <= arrptr->high)
		    *arrptr->nxtptr++ = c;
	}
    }
}
/**/
/*****************************************************************/
/** flcolarr -	flush the column arrary - output the columns	**/
/**		and reinitialize the column array		**/
/*****************************************************************/

flcolarr ()

{
FAST	struct	colarr	*arrptr = colinfo;
FAST		char	*curptr;

    /* for each range */
    while (arrptr->low)
    {
	if (arrptr != colinfo) putchar(' ');

	curptr = arrptr->stptr;

	/* if there aren't any characters, output " - " */
	if (curptr == arrptr->nxtptr) putchar('-');

	/* otherwise print string, replacing any quote with 2 quotes */
	else
	{
	    putchar ( '"' );	/* print leading " */
	    while (curptr < arrptr->nxtptr)
	    {
		if ( *curptr == '"' )
		    putchar ( '"' );
		putchar ( *curptr++ );
	    }
	    /* terminate field with a trailing quote */
	    putchar ( '"' );	/* print trailing " */
	}

	/* reinitialize array pointers and point to next array */
	arrptr->nxtptr = arrptr->stptr;
	arrptr++;
    }

    putchar ( '\n' );
}
/**/
/*****************************************************************/
/** procdelims - process the input file using the delimiter	**/
/*****************************************************************/

procdelims ()

{
FAST		int	 c;	/* current character */

SCAN:	/* scan for delimiter */
    for (;;)
	switch (c = getc(pfin))
	{case '"':	goto QTOK;
	 case EOF:	return 0;
	 case ' ':
	 case '\t':
	 case '\n':	putchar(c);	continue;
	 default:	if (c == delim) goto DELIM;
			goto NQTOK;
	}
QTOK:	/* found token already quoted */
    for (;;)
    {   putchar(c);
	switch (c = getc(pfin))
	{case EOF:
	 case '"':	putchar('"');	goto SCAN;
	}
    }
DELIM:	/* found a delimiter */
    for (;;)
    {   putchar(' ');
	switch (c = getc(pfin))
	{case '"':	goto QTOK;
	 case '\n':
	 case EOF:	putchar('\n');	goto SCAN;
	 default:	if (c == delim) putchar('-');
			else goto NQTOK;
	}
    }
NQTOK:	/* found a token not already quoted */
    putchar('"');
    for (;;)
    {   putchar(c);
	switch (c = getc(pfin))
	{case '\n':
	 case EOF:	putchar('"');	putchar('\n');	goto SCAN;
	 case '"':	putchar('"');	continue;
	 default:	if (c == delim)
			{   putchar('"');
			    goto DELIM;
			}
	}
    }
}
/**/
/*********************************************************/
/** proclines - process the input file line by line	**/
/*********************************************************/

proclines ()

{
FAST	int	c;		/* current input character */
FAST	int	leading = 1;	/* flag if leading or trailing delimiter */

    while ( (c = getc(pfin)) != EOF )
    {
	/* if start of a line, output a leading quote */
	if ( leading )
	{
	   leading = 0;
	   putchar ( '"' );
	}

	/* if newline seen, set leading quote switch and output
	   trailing quote
	   turn each quote character into two quote characters */
	switch (c)
	{case '\n':	leading = 1;
	 case '"':	putchar('"');
	}

	putchar(c);	/* pass character through */
    }
    if (!leading)
    {   putchar('"');
	putchar('\n');
    }
}
/**/
/*****************************************************************/
/** parseargs - parse the command line arguments and sets	**/
/**		global variables with inputs			**/
/**		returns 1 on success, 0 on error.		**/
/*****************************************************************/

parseargs (argv)

FAST	char	*argv[];
{
#if OPSYS==VMS

	/* define descriptor and scratch string buffer for use in 	*/ 
	/*  retrieving command line params				*/	
	/*  and qualifiers						*/
	
	char	 cli_string[256];
    	int status,arg_length;
	struct	dsc$descriptor_s cli_descrip;
				 cli_descrip.dsc$w_length = 256;
				 cli_descrip.dsc$b_dtype  = DSC$K_DTYPE_T;	
				 cli_descrip.dsc$b_class  = DSC$K_CLASS_S;	
				 cli_descrip.dsc$a_pointer= cli_string;
	status 	   = 0;
	arg_length = 0;
    
    	/* check to see if delimiter supplied */

    	status = cli$present(&delimiter);
	if ((status != SS$_NORMAL) &&
	    (status != CLI$_ABSENT)&&
  	    (status != CLI$_PRESENT))
		lib$signal(status);
	if (status == CLI$_PRESENT)		
    	{   
	status	= cli$get_value(&delimiter,&cli_descrip,&arg_length);
	if (status != SS$_NORMAL)
		lib$signal(status);
    	/* user provides delimiter in quotes, so take 2nd char. of string */
	delim = cli_string[1];
    	}

    	/* get column range */

    	status = cli$present(&column_range);
	if ((status != SS$_NORMAL) &&
	    (status != CLI$_ABSENT)&&
	    (status != CLI$_PRESENT))
		lib$signal(status);
	if (status == CLI$_PRESENT)	
    	{	
	status	= cli$get_value(&column_range,&cli_descrip,&arg_length);
    	if (status != SS$_NORMAL)
		lib$signal(status);
		if (!(arg_length))
		{
	 	printf("The /column option should give a list of column ");
		printf("ranges, separated by commas\n");
    		return 0;
		}
    	/* eliminate quotes provided by user by starting at 2nd char, and */
    	/* zeroing out trailing quote 					  */
    		*(cli_string + arg_length - 1)= '\0';
    		cflag = 1;
		if (!parserngs(&cli_string[1])) return 0;
    	}

    	/* get file name for input */
	status	= cli$get_value(&p1,&cli_descrip,&arg_length);
	if (status != SS$_NORMAL)
		lib$signal(status);	
    	*(cli_string + arg_length) = '\0';
	if ( (pfin = fopen(cli_string, "r")) == (FILE *) NULL)
	{
	    printf("Unable to read %s\n", cli_string);
	    return 0;
    	}
    	/* get output file name */
	status	= cli$get_value(&output_file,&cli_descrip,&arg_length);
    	if (status == CLI$_ABSENT)
    	{
		printf("you must supply an output file name\n"); 
		return 0; 
	}
	if (status != SS$_NORMAL)
		lib$signal(status);	
    	*(cli_string + arg_length) = '\0';
    	/* hook stdout out up to our output file */
	if ( (pfout = freopen(cli_string, "w",stdout)) == (FILE *) NULL)
	{
	    printf("Unable to open %s for output\n", cli_string);
	    return 0;
    	}
    	
    	return 1; /* successful completion */
#else
    while (*++argv)
    {
	if (**argv == '-')
	{
	    switch (argv[0][1])
	    {
		case 'D':
		case 'd':
		    if ( *++argv == 0 || strlen(*argv) != 1)
		    {
                        if(*argv != 0  && strlen(*argv) == 3 && **argv == '"')
                        {
                            delim = argv[0][1];
                            break;
                        }
			printf(
"The -d option should be followed by a space and then a single character\n");
			return 0;
		    }
		    delim = **argv;
		    break;

		case 'C':
		case 'c':
		    if (*++argv == 0 || !strlen(*argv))
		    {
			printf(
"The -c option should be followed by a space and then a list of column ranges,\nseparated by commas\n");
			return 0;
		    }
		    if (!parserngs(*argv)) return 0;
		    cflag++;
		    break;

		default:
		    printf("Unknown option: -%c\n", argv[0][1]);
		    return 0;
	    }
	}
/**/
	else
	{
	    if (pfin != stdin)		/* already have specified a file */
	    {
		printf("Quoter only accepts one input file\n");
		return 0;
	    }
	    else
	    {
		if ( (pfin = fopen(*argv, "r")) == (FILE *) NULL)
		{
		    printf("Unable to read %s\n", *argv);
		    return 0;
		}
	    }
	}
    }
    if (cflag && delim)
    {
	printf("Incompatible options: -c and -d\n");
	return 0;
    }

    return 1;
#endif /* end of Unix/DOS section */
}
/**/
/*****************************************************************/
/** parserngs - parse column ranges				**/
/**		returns 1 on success, 0 on error.		**/
/*****************************************************************/

parserngs (inpstr)

FAST		char	*inpstr;	/* user input */
{
FAST	struct	colarr	*arrptr = &colinfo[nxtarrs]; 
				/* store valid inputs here */
	int	 narrs;		/* number of filled arrays */
FAST	char	*startofrange;	/* ptr in inpstr to current range */
FAST	char	*endrngptr;	/* ptr to end of current range */
	char	*comma();	/* searches for a char in a string */
	char	*malloc();	/* allocates dynamic memory */

    narrs = nxtarrs;

    for (; *inpstr; ++arrptr)
    {
	/* a fixed size table is used for speed */
	if (++narrs >= MAXRNGES)
	{
	    printf("Too many ranges entered\n");
	    return 0;
	}

	/* save a ptr to start of this range, to be used in an error msg */
	startofrange = inpstr;

	/* initialize range values */
	arrptr->low	= 0;
	arrptr->high	= 0;

	/* set lower bound of range */
	while (utisdigit(*inpstr))
	    arrptr->low = arrptr->low * 10 + *inpstr++ - '0';

	/* if the user either entered a 0 or didn't enter any number */
	if (arrptr->low <= 0)
	{
		/* error message should contain only this range which is
		   terminated with a ","
		*/
		if (endrngptr = comma(startofrange))
		    *endrngptr = 0;
		printf("The starting column must be greater than 0: %s\n",
		    startofrange);
		return 0;
	}
/**/
	/* check out char following the low end of the range */
	switch (*inpstr)
	{
	    /* end of line - no upper bound, so set to lower bound */
	    case '\0':
		arrptr->high = arrptr->low;
		break;

	    /* end of this range - set upper bound and skip over comma */
	    case ',':
		arrptr->high = arrptr->low;
		inpstr++;
		break;

	    case '-':
		/* parse upper bound */
		while (utisdigit(*++inpstr))
		    arrptr->high = arrptr->high * 10 + *inpstr - '0';

		/* only comma or end of argument should follow upper */
		switch (*inpstr)
		{
		 case ',':	inpstr++;
		 case '\0':	break;

		 default:	if (endrngptr = comma(startofrange))
				    *endrngptr = 0;
				printf("Invalid range: %s\n",
				    startofrange);
				return 0;
		}
		break;

	    /* none of the above - error */
	    default:
		if (endrngptr = comma(startofrange))
		    *endrngptr = 0;
		printf("Invalid range: %s\n", startofrange);
		return 0;
	}
    }
/**/
    /* set up the ending entry */
    arrptr->low = 0;
    arrptr->high = 0;

    /* for each entry ... */
    for (arrptr = colinfo; arrptr->low; arrptr++)
    {
	/* if the range ended with the hyphen, the upper bound becomes 1
	   less than the next field, or if this is the last range,
	   an arbitrary constant (MAXINPSIZ) is added to the lower limit
	*/
	if (arrptr->high == 0)
	{
	    if ((arrptr + 1)->low)
		arrptr->high = (arrptr + 1)->low - 1;
	    else
		arrptr->high = arrptr->low + MAXINPSIZ;
	}

	/* the lower boundary must be less than the upper boundary */
	if (arrptr->low > arrptr->high)
	{
	    printf("Invalid range: %d-%d\n", arrptr->low, arrptr->high);
	    return 0;
	}

	/* allocate space to store one of these fields */
	if ((arrptr->stptr = malloc(arrptr->high - arrptr->low + 2)) == 0)
	{
	    printf(
	"Unable to store a record in memory - please shorten range(s)\n");
	    return 0;
	}

	/* set up both the starting and next available space pointers
	   into the allocated space
	*/
	arrptr->nxtptr = arrptr->stptr;
    }
    nxtarrs = narrs;
    return 1;
}
/**/
/*****************************************************************/
/** comma -	search for a comma in a string			**/
/**		returns a pointer to the comma on success,	**/
/**		0 on error.					**/
/*****************************************************************/

char *
comma (s)

FAST	char	*s;
{
    while (*s)		/* while there are chars in the string */
	if (*s++ == ',')	/* if this is the matching char */
	    return --s;	/* return a pointer to it */
    return 0;		/* couldn't find the char */
}


/**********************************************************/
/** utisdigit -	verify that a character is a digit (0-9) **/
/**********************************************************/

int
utisdigit (c)

	char	 c;
{
    return c >= '0' && c <= '9';
}
