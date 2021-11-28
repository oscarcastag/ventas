/*********************************************************/
/**							**/
/**	toisol1 - converts a file containing code page	**/
/**	iso-latin1 data into a file containing code page**/
/**	850 data					**/
/**							**/
/**	The data can be an arbitrary text file		**/
/**							**/
/**	The toisol1 command format is:			**/
/**	  toisol1 filename				**/
/**							**/
/** 	On VMS, the format is				**/
/**							**/
/**	pro/tools=toisol1/filename=<file-name>"		**/
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

/* definition of the ISO-Latin-1 character set */
#define ISOL1_AgraveU   192   /* A (Upper case) with grave accent "\" */
#define ISOL1_AgraveL   224   /* a (Lower case) with grave accent "\" */
#define ISOL1_AacuteU   193   /* A (Upper case) with acute accent "/" */
#define ISOL1_AacuteL   225   /* a (Lower case) with acute accent "/" */
#define ISOL1_AhatU     194   /* A (Upper case) with hat accent "^" */
#define ISOL1_AhatL     226   /* a (Lower case) with hat accent "^" */
#define ISOL1_AtildeU   195   /* A (Upper case) with tilde  "~" */
#define ISOL1_AtildeL   227   /* a (Lower case) with tilde  "~" */
#define ISOL1_AumlautU  196   /* A (Upper case) with umlaut ".." */
#define ISOL1_AumlautL  228   /* a (Lower case) with umlaut ".." */
#define ISOL1_AringU    197   /* A (Upper case) with ring above */
#define ISOL1_AringL    229   /* a (Lower case) with ring above */
#define ISOL1_AE_U      198   /* AE (Upper case) lingature */
#define ISOL1_AE_L      230   /* ae (Lower case) lingature */
#define ISOL1_CedillaU  199   /* C (Upper case) with cedilla */
#define ISOL1_CedillaL  231   /* C (LOwer case) with cedilla */
#define ISOL1_EgraveU   200   /* E (Upper case) with grave accent "\" */
#define ISOL1_EgraveL   232   /* e (Lower case) with grave accent "\" */
#define ISOL1_EacuteU   201   /* E (Upper case) with acute accent "/" */
#define ISOL1_EacuteL   233   /* e (Lower case) with acute accent "/" */
#define ISOL1_EhatU     202   /* E (Upper case) with hat accent "^" */
#define ISOL1_EhatL     234   /* e (Lower case) with hat accent "^" */
#define ISOL1_EumlautU  203   /* E (Upper case) with umlaut ".." */
#define ISOL1_EumlautL  235   /* e (Lower case) with umlaut ".." */
#define ISOL1_IgraveU   204   /* I (Upper case) with grave accent "\" */
#define ISOL1_IgraveL   236   /* i (Lower case) with grave accent "\" */
#define ISOL1_IacuteU   205   /* I (Upper case) with acute accent "/" */
#define ISOL1_IacuteL   237   /* i (Lower case) with acute accent "/" */
#define ISOL1_IhatU     206   /* I (Upper case) with hat accent "^" */
#define ISOL1_IhatL     238   /* i (Lower case) with hat accent "^" */
#define ISOL1_IumlautU  207   /* I (Upper case) with umlaut ".." */
#define ISOL1_IumlautL  239   /* i (Lower case) with umlaut ".." */
#define ISOL1_EthU	208   /* D (Upper case) with bar; letter "eth" */
#define ISOL1_EthL	240   /* D (lower case) with bar; letter "eth" */
#define ISOL1_NtildeU   209   /* N (Upper case) with tilde "~" */
#define ISOL1_NtildeL   241   /* n (Lower case) with tilde "~" */
#define ISOL1_OgraveU   210   /* O (Upper case) with grave accent "\" */
#define ISOL1_OgraveL   242   /* o (Lower case) with grave accent "\" */
#define ISOL1_OacuteU   211   /* O (Upper case) with acute accent "/" */
#define ISOL1_OacuteL   243   /* o (Lower case) with acute accent "/" */
#define ISOL1_OhatU     212   /* O (Upper case) with hat accent "^" */
#define ISOL1_OhatL     244   /* o (Lower case) with hat accent "^" */
#define ISOL1_OtildeU   213   /* O (Upper case) with tilde  "~" */
#define ISOL1_OtildeL   245   /* o (Lower case) with tilde  "~" */
#define ISOL1_OumlautU  214   /* O (Upper case) with umlaut ".." */
#define ISOL1_OumlautL  246   /* o (Lower case) with umlaut ".." */
#define ISOL1_OobliqU   216   /* O (Upper case) with oblique
				 stroke "/" inside */
#define ISOL1_OobliqL   248   /* o (Lower case) with oblique
				 stroke "/" inside */
#define ISOL1_Ssharp    223   /* ss German sharp s (double s)
				 looks like beta */
#define ISOL1_UgraveU   217   /* U (Upper case) with grave accent "\" */
#define ISOL1_UgraveL   249   /* u (Lower case) with grave accent "\" */
#define ISOL1_UacuteU   218   /* U (Upper case) with acute accent "/" */
#define ISOL1_UacuteL   250   /* u (Lower case) with acute accent "/" */
#define ISOL1_UhatU     219   /* U (Upper case) with hat accent "^" */
#define ISOL1_UhatL     251   /* u (Lower case) with hat accent "^" */
#define ISOL1_UumlautU  220   /* U (Upper case) with umlaut ".." */
#define ISOL1_UumlautL  252   /* u (Lower case) with umlaut ".." */
#define ISOL1_YacuteU   221   /* Y (Upper case) with acute accent "/" */
#define ISOL1_YacuteL   253   /* y (Lower case) with acute accent "/" */
#define ISOL1_ThornU    222   /* Upper-case 'thorn' */
#define ISOL1_ThornL    254   /* Lower-case 'thorn' */
#define ISOL1_YumlautU    ?   /* Y (Upper case) with umlaut "..",
			       available in ISO-Latin-2, but not 1 */
#define ISOL1_YumlautL  255   /* y (Lower case) with umlaut ".." */

#define ISOL1_Pound     163   /* British pound sign */
#define ISOL1_Mult      215   /* Multiplication sign */
#define ISOL1_Florin    159   /* Dutch florin symbol */
#define ISOL1_FemOrd    170   /* Spanish feminine ordinal indicator */
#define ISOL1_MascOrd   186   /* Spanish masculine ordinal indicator */
#define ISOL1_InvHook   191   /* Inverted question mark */
#define ISOL1_RegTM     174   /* Registered trademark sign */
#define ISOL1_Not       172   /* Logical 'not' sign */
#define ISOL1_Half      189   /* one-half symbol */
#define ISOL1_Quarter   188   /* one-quarter symbol */
#define ISOL1_InvBang   161   /* Inverted exclamation point */
#define ISOL1_LDblAngle 171   /* Left double angle */
#define ISOL1_RDblAngle 187   /* Right double angle */
#define ISOL1_Copyright 169   /* Copyright symbol */
#define ISOL1_Cent      162   /* Cent sign */
#define ISOL1_Yen	165   /* Yen sign */
#define ISOL1_Currency  164   /* Currency sign */
#define ISOL1_BBar      166   /* Broken vertical bar */
#define ISOL1_Mu        181   /* Greek lower-case mu */
#define ISOL1_Acute     180   /* Acute accent */
#define ISOL1_PlusMinus 177   /* Plus/minus symbol */
#define ISOL1_Overline  175   /** Overline */
#define ISOL1_SylHyph   173   /* Syllable hyphen */
#define ISOL1_3Quarter  190   /* Three-quarter symbol */
#define ISOL1_Para	182   /* Paragraph symbol */
#define ISOL1_Section   167   /* Section symbol */
#define ISOL1_Division  247   /* Division symbol */
#define ISOL1_Cedilla   184   /* Cedilla symbol (without a "C") */
#define ISOL1_Degree    176   /* Degree symbol */
#define ISOL1_Umlaut    168   /* Umlaut diacritical mark */
#define ISOL1_MidDot    183   /* A centered middle dot */
#define ISOL1_Super1    185   /* Superscript 1 */
#define ISOL1_Super3    179   /* Superscript 3 */
#define ISOL1_Super2    178   /* Superscript 2 */
#define ISOL1_ReqSpace  160   /* Required space */

/* 
 * The following correspond to CP850 graphics characters.  They are 
 * mapped to unused areas of ISO-Latin-1, and will hopefully help keep 
 * the mapping close to one-to-one.
 */
#define ISOL1_Block1	128     /* 25% grey block */
#define ISOL1_Block2    129	/* 50% grey block */
#define ISOL1_Block3    130     /* 75% grey block */
#define ISOL1_VertSgl   131     /* Single vertical border line */
#define ISOL1_VertSglL  132     /* Single vertical border
				   w/left intersection */
#define ISOL1_VertDblL  133     /* Double vertical broder w/left
				   intersection */
#define ISOL1_VertDbl   134     /* Double vertical border line */
#define ISOL1_URCDbl    135     /* Upper right corner, double line */
#define ISOL1_LRCDbl    136	/* Lower right corder, double line */
#define ISOL1_URCSgl    137     /* Upper right corner, single line */
#define ISOL1_LLCSgl    138	/* Lower left corner, single line */
#define ISOL1_BTSgl     139	/* Bottom 'T', single line */
#define ISOL1_UTSgl	140     /* Top 'T', single line */
#define ISOL1_VertSglR  141	/* Single vertical border, with
				   right intersection */
#define ISOL1_HorizSgl  142     /* Single horizontal border line */
#define ISOL1_InterSgl  143   	/* Single line intersection */
#define ISOL1_LLCDbl    144     /* Lower left corner, double line */
#define ISOL1_ULCDbl    145     /* Upper left corner, double line */
#define ISOL1_BTDbl     146     /* Bottom 'T', double line */
#define ISOL1_UTDbl     147     /* Top 'T', double line */
#define ISOL1_VertDblR  148     /* Double vertical border w/ right
				   intersection */
#define ISOL1_HorizDbl  149	/* Double horizontal border line */
#define ISOL1_InterDbl  150     /* Double line intersection */
#define ISOL1_DotlessI  151     /* Dotless small i */
#define ISOL1_LRCSgl    152     /* Lower right corner, single line */
#define ISOL1_ULCSgl    153    	/* Upper left corner, single line */
#define ISOL1_SolidBlk  154     /* Solid block */
#define ISOL1_LowerBlk  155	/* Lower half of a solid block */
#define ISOL1_UpperBlk  156	/* Upper half of a solid block */
#define ISOL1_DblUnder  157     /* Double Underscore */
#define ISOL1_MidBox    158     /* Centered solid box */


/* Tables for a one-to-one mapping to/from Codepage 850/ISO-Latin-1  */
unsigned char CP850_to_ISOL1[] =
{
  /*   0 */   0,   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
  /*  16 */   16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
  /*  32 */   32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
  /*  48 */   48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
  /*  64 */   64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
  /*  80 */   80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
  /*  96 */   96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111,
  /* 112 */  112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,
  /* 128 */  ISOL1_CedillaU, ISOL1_UumlautL,  ISOL1_EacuteL,  ISOL1_AhatL,
  /* 132 */  ISOL1_AumlautL, ISOL1_AgraveL,   ISOL1_AringL,   ISOL1_CedillaL,
  /* 136 */  ISOL1_EhatL,    ISOL1_EumlautL,  ISOL1_EgraveL,  ISOL1_IumlautL,
  /* 140 */  ISOL1_IhatL,    ISOL1_IgraveL,   ISOL1_AumlautU, ISOL1_AringU,
  /* 144 */  ISOL1_EacuteU,  ISOL1_AE_L,      ISOL1_AE_U,     ISOL1_OhatL,
  /* 148 */  ISOL1_OumlautL, ISOL1_OgraveL,   ISOL1_UhatL,    ISOL1_UgraveL,
  /* 152 */  ISOL1_YumlautL, ISOL1_OumlautU,  ISOL1_UumlautU, ISOL1_OobliqL,
  /* 156 */  ISOL1_Pound,    ISOL1_OobliqU,   ISOL1_Mult,     ISOL1_Florin,
  /* 160 */  ISOL1_AacuteL,  ISOL1_IacuteL,   ISOL1_OacuteL,  ISOL1_UacuteL,
  /* 164 */  ISOL1_NtildeL,  ISOL1_NtildeU,   ISOL1_FemOrd,   ISOL1_MascOrd,
  /* 168 */  ISOL1_InvHook,  ISOL1_RegTM,     ISOL1_Not,      ISOL1_Half,
  /* 172 */  ISOL1_Quarter,  ISOL1_InvBang,   ISOL1_LDblAngle,ISOL1_RDblAngle,
  /* 176 */  ISOL1_Block1,   ISOL1_Block2,    ISOL1_Block3,   ISOL1_VertSgl,
  /* 180 */  ISOL1_VertSglL, ISOL1_AacuteU,   ISOL1_AhatU,    ISOL1_AgraveU,
  /* 184 */  ISOL1_Copyright,ISOL1_VertDblL,  ISOL1_VertDbl,  ISOL1_URCDbl,
  /* 188 */  ISOL1_LRCDbl,   ISOL1_Cent,      ISOL1_Yen,      ISOL1_URCSgl,
  /* 192 */  ISOL1_LLCSgl,   ISOL1_BTSgl,     ISOL1_UTSgl,    ISOL1_VertSglR,
  /* 196 */  ISOL1_HorizSgl, ISOL1_InterSgl,  ISOL1_AtildeL,  ISOL1_AtildeU,
  /* 200 */  ISOL1_LLCDbl,   ISOL1_ULCDbl,    ISOL1_BTDbl,    ISOL1_UTDbl,
  /* 204 */  ISOL1_VertDblR, ISOL1_HorizDbl,  ISOL1_InterDbl, ISOL1_Currency,
  /* 208 */  ISOL1_EthL,     ISOL1_EthU,      ISOL1_EhatU,    ISOL1_EumlautU,
  /* 212 */  ISOL1_EgraveU,  ISOL1_DotlessI,  ISOL1_IacuteU,  ISOL1_IhatU,
  /* 216 */  ISOL1_IumlautU, ISOL1_LRCSgl,    ISOL1_ULCSgl,   ISOL1_SolidBlk,
  /* 220 */  ISOL1_LowerBlk, ISOL1_BBar,      ISOL1_IgraveU,  ISOL1_UpperBlk,
  /* 224 */  ISOL1_OacuteU,  ISOL1_Ssharp,    ISOL1_OhatU,    ISOL1_OgraveU,
  /* 228 */  ISOL1_OtildeL,  ISOL1_OtildeU,   ISOL1_Mu,       ISOL1_ThornL,
  /* 232 */  ISOL1_ThornU,   ISOL1_UacuteU,   ISOL1_UhatU,    ISOL1_UgraveU,
  /* 236 */  ISOL1_YacuteL,  ISOL1_YacuteU,   ISOL1_Overline, ISOL1_Acute,
  /* 240 */  ISOL1_SylHyph,  ISOL1_PlusMinus, ISOL1_DblUnder, ISOL1_3Quarter,
  /* 244 */  ISOL1_Para,     ISOL1_Section,   ISOL1_Division, ISOL1_Cedilla,
  /* 248 */  ISOL1_Degree,   ISOL1_Umlaut,    ISOL1_MidDot,   ISOL1_Super1,
  /* 252 */  ISOL1_Super3,   ISOL1_Super2,    ISOL1_MidBox,   ISOL1_ReqSpace
} /* end CP850_to_ISOL1 */;

main ( argc, argv )

	int	 argc;
	char	*argv[];
{
    pfin=stdin;
    if (!parseargs(argv)) exit(-1);

    toisol1();

    fclose (pfin);	/* close input file */
#if OPSYS==VMS
    exit(1);
#else
    exit(0);
#endif
}
/**/
/*********************************************************/
/** toisol1 - process the input file line by line	**/
/*********************************************************/

toisol1 ()

{
FAST	int	left;		/* bytes left to convert */
FAST	unsigned char	*p;		/* temp pointer to the output buffer */
	int	len;		/* bytes read		 */

	unsigned char	buffer[MAXINPSIZ];

    while( len = fread(buffer, 1, MAXINPSIZ, pfin))
    {
	/* convert the data */
	for(p=buffer, left=len; left>0; p++, left--)
	    *p = CP850_to_ISOL1[*p];
	
	/* write the data */
	for(p=buffer, left=len; left>0; left-=len, p+=len)
	{
	    len = fwrite(p, 1, left, stdout);
	    if (len <= 0)
	    {   perror("toisol1");
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
	    printf("toisol1 only accepts one input file\n");
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
