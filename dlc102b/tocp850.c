/*********************************************************/
/**							**/
/**	tocp850 - converts a file containing code page	**/
/**	850 data into a file containing iso-latin1 data	**/
/**							**/
/**	The data can be an arbitrary text file		**/
/**							**/
/**	The tocp850 command format is:			**/
/**	  tocp850 filename				**/
/**							**/
/** 	On VMS, the format is				**/
/**							**/
/**	pro/tools=tocp850/filename=<file-name>"		**/
/**							**/
/**	If no filename is specified, the standard	**/
/**	input is used.					**/
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
#define MAXINPSIZ	4096
#define FAST		register

/* GLOBAL VARAIBLES */
#if OPSYS==VMS
FILE	*pfin;
FILE   *pfout;
#else
FILE	*pfin;	/* file pointer of input file */
#endif

/* definition of the UPSCII (IBM CodePage 850) accented letters */
#define CP850_AgraveU   183   /* A (Upper case) with grave accent "\" */
#define CP850_AgraveL   133   /* a (Lower case) with grave accent "\" */
#define CP850_AacuteU   181   /* A (Upper case) with acute accent "/" */
#define CP850_AacuteL   160   /* a (Lower case) with acute accent "/" */
#define CP850_AhatU     182   /* A (Upper case) with hat accent "^" */
#define CP850_AhatL     131   /* a (Lower case) with hat accent "^" */
#define CP850_AtildeU   199   /* A (Upper case) with tilde  "~" */
#define CP850_AtildeL   198   /* a (Lower case) with tilde  "~" */
#define CP850_AumlautU  142   /* A (Upper case) with umlaut ".." */
#define CP850_AumlautL  132   /* a (Lower case) with umlaut ".." */
#define CP850_AringU    143   /* A (Upper case) with ring above */
#define CP850_AringL    134   /* a (Lower case) with ring above */
#define CP850_AE_U      146   /* AE (Upper case) lingature */
#define CP850_AE_L      145   /* ae (Lower case) lingature */
#define CP850_CedillaU  128   /* C (Upper case) with cedilla */
#define CP850_CedillaL  135   /* C (LOwer case) with cedilla */
#define CP850_EgraveU   212   /* E (Upper case) with grave accent "\" */
#define CP850_EgraveL   138   /* e (Lower case) with grave accent "\" */
#define CP850_EacuteU   144   /* E (Upper case) with acute accent "/" */
#define CP850_EacuteL   130   /* e (Lower case) with acute accent "/" */
#define CP850_EhatU     210   /* E (Upper case) with hat accent "^" */
#define CP850_EhatL     136   /* e (Lower case) with hat accent "^" */
#define CP850_EumlautU  211   /* E (Upper case) with umlaut ".." */
#define CP850_EumlautL  137   /* e (Lower case) with umlaut ".." */
#define CP850_IgraveU   222   /* I (Upper case) with grave accent "\" */
#define CP850_IgraveL   141   /* i (Lower case) with grave accent "\" */
#define CP850_IacuteU   214   /* I (Upper case) with acute accent "/" */
#define CP850_IacuteL   161   /* i (Lower case) with acute accent "/" */
#define CP850_IhatU     215   /* I (Upper case) with hat accent "^" */
#define CP850_IhatL     140   /* i (Lower case) with hat accent "^" */
#define CP850_IumlautU  216   /* I (Upper case) with umlaut ".." */
#define CP850_IumlautL  139   /* i (Lower case) with umlaut ".." */
#define CP850_EthU	209   /* D (Upper case) with bar; letter "eth" */
#define CP850_EthL	208   /* D (lower case) with bar; letter "eth" */
#define CP850_NtildeU   165   /* N (Upper case) with tilde "~" */
#define CP850_NtildeL   164   /* n (Lower case) with tilde "~" */
#define CP850_OgraveU   227   /* O (Upper case) with grave accent "\" */
#define CP850_OgraveL   149   /* o (Lower case) with grave accent "\" */
#define CP850_OacuteU   224   /* O (Upper case) with acute accent "/" */
#define CP850_OacuteL   162   /* o (Lower case) with acute accent "/" */
#define CP850_OhatU     226   /* O (Upper case) with hat accent "^" */
#define CP850_OhatL     147   /* o (Lower case) with hat accent "^" */
#define CP850_OtildeU   229   /* O (Upper case) with tilde  "~" */
#define CP850_OtildeL   228   /* o (Lower case) with tilde  "~" */
#define CP850_OumlautU  153   /* O (Upper case) with umlaut ".." */
#define CP850_OumlautL  148   /* o (Lower case) with umlaut ".." */
#define CP850_OobliqU   157   /* O (Upper case) with oblique
				 stroke "/" inside */
#define CP850_OobliqL   155   /* o (Lower case) with oblique
				 stroke "/" inside */
#define CP850_Ssharp    225   /* ss German sharp s (double s)
				 looks like beta */
#define CP850_UgraveU   235   /* U (Upper case) with grave accent "\" */
#define CP850_UgraveL   151   /* u (Lower case) with grave accent "\" */
#define CP850_UacuteU   233   /* U (Upper case) with acute accent "/" */
#define CP850_UacuteL   163   /* u (Lower case) with acute accent "/" */
#define CP850_UhatU     234   /* U (Upper case) with hat accent "^" */
#define CP850_UhatL     150   /* u (Lower case) with hat accent "^" */
#define CP850_UumlautU  154   /* U (Upper case) with umlaut ".." */
#define CP850_UumlautL  129   /* u (Lower case) with umlaut ".." */
#define CP850_YacuteU   237   /* Y (Upper case) with acute accent "/" */
#define CP850_YacuteL   236   /* y (Lower case) with acute accent "/" */
#define CP850_ThornL    231   /* Lower-case 'thorn' */
#define CP850_ThornU    232   /* Upper-case 'thorn' */
#define CP850_YumlautU    ?   /* Y (Upper case) with umlaut ".." */
#define CP850_YumlautL  152   /* y (Lower case) with umlaut ".." */

#define CP850_Pound	156   /* British pound sign */
#define CP850_Mult      158   /* multiplication sign */
#define CP850_Florin    159   /* Dutch florin symbol */
#define CP850_FemOrd    166   /* Spanish feminine ordinal indicator */
#define CP850_MascOrd   167   /* Spanish masculine ordinal indicator */
#define CP850_InvHook   168   /* Inverted question mark */
#define CP850_RegTM     169   /* Registered trademark sign */
#define CP850_Not	170   /* Logical 'not' sign */
#define CP850_Half      171   /* one-half symbol */
#define CP850_Quarter   172   /* one-quarter symbol */
#define CP850_InvBang   173   /* Inverted exclamation point */
#define CP850_LDblAngle 174   /* Left double angle */
#define CP850_RDblAngle 175   /* Right double angle */
#define CP850_Copyright 184   /* Copyright symbol */
#define CP850_Cent      189   /* Cent sign */
#define CP850_Yen	190   /* Yen sign */
#define CP850_Currency  207   /* Currency sign */
#define CP850_BBar      221   /* Broken vertical bar */
#define CP850_Mu        230   /* Greek lower-case mu */
#define CP850_Acute     239   /* Acute accent */
#define CP850_PlusMinus 241   /* Plus/minus symbol */
#define CP850_Overline  238   /** Overline */
#define CP850_SylHyph   240   /* Syllable hyphen */
#define CP850_3Quarter  243   /* Three-quarter symbol */
#define CP850_Para	244   /* Paragraph symbol */
#define CP850_Section   245   /* Section symbol */
#define CP850_Division  246   /* Division symbol */
#define CP850_Cedilla   247   /* Cedilla symbol (without a "C") */
#define CP850_Degree    248   /* Degree symbol */
#define CP850_Umlaut    249   /* Umlaut diacritical mark */
#define CP850_MidDot    250   /* A centered middle dot */
#define CP850_Super1    251   /* Superscript 1 */
#define CP850_Super3    252   /* Superscript 3 */
#define CP850_Super2    253   /* Superscript 2 */
#define CP850_ReqSpace  255   /* Required space */

#define CP850_Block1	176     /* 25% grey block */
#define CP850_Block2    177	/* 50% grey block */
#define CP850_Block3    178     /* 75% grey block */
#define CP850_VertSgl   179     /* Single vertical border line */
#define CP850_VertSglL  180     /* Single vertical border
				   w/left intersection */
#define CP850_VertDblL  185     /* Double vertical broder w/left
				   intersection */
#define CP850_VertDbl   186     /* Double vertical border line */
#define CP850_URCDbl    187     /* Upper right corner, double line */
#define CP850_LRCDbl    188	/* Lower right corder, double line */
#define CP850_URCSgl    191     /* Upper right corner, single line */
#define CP850_LLCSgl    192	/* Lower left corner, single line */
#define CP850_BTSgl     193	/* Bottom 'T', single line */
#define CP850_UTSgl	194     /* Top 'T', single line */
#define CP850_VertSglR  195	/* Single vertical border, with
				   right intersection */
#define CP850_HorizSgl  196     /* Single horizontal border line */
#define CP850_InterSgl  197   	/* Single line intersection */
#define CP850_LLCDbl    200     /* Lower left corner, double line */
#define CP850_ULCDbl    201     /* Upper left corner, double line */
#define CP850_BTDbl     202     /* Bottom 'T', double line */
#define CP850_UTDbl     203     /* Top 'T', double line */
#define CP850_VertDblR  204     /* Double vertical border w/ right
				   intersection */
#define CP850_HorizDbl  205	/* Double horizontal border line */
#define CP850_InterDbl  206     /* Double line intersection */
#define CP850_DotlessI  213     /* Dotless small i */
#define CP850_LRCSgl    217     /* Lower right corner, single line */
#define CP850_ULCSgl    218    	/* Upper left corner, single line */
#define CP850_SolidBlk  219     /* Solid block */
#define CP850_LowerBlk  220	/* Lower half of a solid block */
#define CP850_UpperBlk  223	/* Upper half of a solid block */
#define CP850_DblUnder  242     /* Double Underscore */
#define CP850_MidBox    254     /* Centered solid box */

/* 
 * Note: the mapping of ISOL1 values 128-159 are 'control' codes.  
 * When mapping these to CP850, we map them to CP850 line-drawing 
 * characters in order to provide a one-to-one mapping between 
 * between CP850 and ISOL1.
 */
unsigned char
ISOL1_to_CP850[] =
{
  /*   0 */   0,   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
  /*  16 */   16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
  /*  32 */   32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
  /*  48 */   48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
  /*  64 */   64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
  /*  80 */   80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
  /*  96 */   96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111,
  /* 112 */  112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,
  /* 128 */  CP850_Block1,   CP850_Block2,    CP850_Block3,   CP850_VertSgl,
  /* 132 */  CP850_VertSglL, CP850_VertDblL,  CP850_VertDbl,  CP850_URCDbl,
  /* 136 */  CP850_LRCDbl,   CP850_URCSgl,    CP850_LLCSgl,   CP850_BTSgl,
  /* 140 */  CP850_UTSgl,    CP850_VertSglR,  CP850_HorizSgl, CP850_InterSgl,
  /* 144 */  CP850_LLCDbl,   CP850_ULCDbl,    CP850_BTDbl,    CP850_UTDbl,
  /* 148 */  CP850_VertDblR, CP850_HorizDbl,  CP850_InterDbl, CP850_DotlessI,
  /* 152 */  CP850_LRCSgl,   CP850_ULCSgl,    CP850_SolidBlk, CP850_LowerBlk,
  /* 156 */  CP850_UpperBlk, CP850_DblUnder,  CP850_MidBox,   CP850_Florin,
  /* 160 */  CP850_ReqSpace, CP850_InvBang,   CP850_Cent,     CP850_Pound,
  /* 164 */  CP850_Currency, CP850_Yen,       CP850_BBar,     CP850_Section,
  /* 168 */  CP850_Umlaut,   CP850_Copyright, CP850_FemOrd,   CP850_LDblAngle,
  /* 172 */  CP850_Not,      CP850_SylHyph,   CP850_RegTM,    CP850_Overline,
  /* 176 */  CP850_Degree,   CP850_PlusMinus, CP850_Super2,   CP850_Super3,
  /* 180 */  CP850_Acute,    CP850_Mu,        CP850_Para,     CP850_MidDot,
  /* 184 */  CP850_Cedilla,  CP850_Super1,    CP850_MascOrd,  CP850_RDblAngle,
  /* 188 */  CP850_Quarter,  CP850_Half,      CP850_3Quarter, CP850_InvHook,
  /* 192 */  CP850_AgraveU,  CP850_AacuteU,   CP850_AhatU,    CP850_AtildeU,
  /* 196 */  CP850_AumlautU, CP850_AringU,    CP850_AE_U,     CP850_CedillaU,
  /* 200 */  CP850_EgraveU,  CP850_EacuteU,   CP850_EhatU,    CP850_EumlautU,
  /* 204 */  CP850_IgraveU,  CP850_IacuteU,   CP850_IhatU,    CP850_IumlautU,
  /* 208 */  CP850_EthU,     CP850_NtildeU,   CP850_OgraveU,  CP850_OacuteU,
  /* 212 */  CP850_OhatU,    CP850_OtildeU,   CP850_OumlautU, CP850_Mult,
  /* 216 */  CP850_OobliqU,  CP850_UgraveU,   CP850_UacuteU,  CP850_UhatU,
  /* 220 */  CP850_UumlautU, CP850_YacuteU,   CP850_ThornU,   CP850_Ssharp,
  /* 224 */  CP850_AgraveL,  CP850_AacuteL,   CP850_AhatL,    CP850_AtildeL,
  /* 228 */  CP850_AumlautL, CP850_AringL,    CP850_AE_L,     CP850_CedillaL,
  /* 232 */  CP850_EgraveL,  CP850_EacuteL,   CP850_EhatL,    CP850_EumlautL,
  /* 236 */  CP850_IgraveL,  CP850_IacuteL,   CP850_IhatL,    CP850_IumlautL,
  /* 240 */  CP850_EthL,     CP850_NtildeL,   CP850_OgraveL,  CP850_OacuteL,
  /* 244 */  CP850_OhatL,    CP850_OtildeL,   CP850_OumlautL, CP850_Division,
  /* 248 */  CP850_OobliqL,  CP850_UgraveL,   CP850_UacuteL,  CP850_UhatL,
  /* 252 */  CP850_UumlautL, CP850_YacuteL,   CP850_ThornL,   CP850_YumlautL
} /* end ISOL1_to_CP850 */;

main ( argc, argv )

	int	 argc;
	char	*argv[];
{
    pfin=stdin;
    if (!parseargs(argv)) exit(-1);

    tocp850();

    fclose (pfin);	/* close input file */
#if OPSYS==VMS
    exit(1);
#else
    exit(0);
#endif
}
/**/
/*********************************************************/
/** tocp850 - process the input file line by line	**/
/*********************************************************/

tocp850 ()

{
FAST	int	left;		/* bytes left to convert */
FAST	unsigned char	*p;		/* temp pointer to the output buffer */
	int	len;		/* bytes read		 */

	unsigned char	buffer[MAXINPSIZ];

    while( len = fread(buffer, 1, MAXINPSIZ, pfin))
    {
	/* convert the data */
	for(p=buffer, left=len; left>0; p++, left--)
	    *p = ISOL1_to_CP850[*p];
	
	/* write the data */
	for(p=buffer, left=len; left>0; left-=len, p+=len)
	{
	    len = fwrite(p, 1, left, stdout);
	    if (len <= 0)
	    {   perror("tocp850");
		exit(2);
	    }
	}
	
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
	if (pfin != stdin)		/* already have specified a file */
	{
	    printf("tocp850 only accepts one input file\n");
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
    return 1;
#endif /* end of Unix/DOS section */
}
