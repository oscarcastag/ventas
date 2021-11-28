#include "hlc.h"

subfix()
{
    int     ret, index, var, unknown;
    char    buffer[30];
    int     varlen = 30, actlen;
    char    message[80];
    char    mnth_sales[14];

    p_stcopy(buffer, "0001.34");
#ifdef ORADBIM
    p_stcopy(mnth_sales,"Mnth-sales#");
#else
    p_stcopy(mnth_sales,"mnth-sales");
#endif
    unknown = 0;

    for (index = 1; index <= 12; ++index)
    {
	if (index < 10)
	{
#ifdef ORADBIM
	    mnth_sales[11] = '0' + (char) index;
	    mnth_sales[12] = '\0';
#endif
	    buffer[0] = '0' + (char) index;
	}
	else
	{
#ifdef ORADBIM
	    mnth_sales[11] = '1';
	    mnth_sales[12] = '0' + (char) (index - 10);
	    mnth_sales[13] = '\0';
#endif
	    buffer[0] = '1';
	    buffer[1] = '0' + (char) (index - 10);
	}
	if (ret = prowtbn("custbuf",
		      profldix("custbuf",mnth_sales), index,
			  buffer, unknown))
	{
	    sprintf(message,"%%gprowtbn fatal ret %i", ret);
	    promsgd(message);
	}
    }
    return 0;
}
