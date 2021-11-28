#include "hlc.h"

subfwt()
{
    int     ret, index, var, unknown, year, month, day;
    char    buffer[30];
    int     varlen = 30, actlen;
    long    longvar;
    char    message[80];

    index = 0;

    /* first, set monthly.tf_print to unknown */
    unknown = 1;
    var = 0;
    if (ret = prowtbl("monthbuf", profldix("monthbuf", "tf_print"),
		       index, var, unknown)) 
        {    
	sprintf(message,"prowtbl fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
        }
    else
        {    
	sprintf(message,"setting tf_print to unknown");
        promsgd(message);
        }

    /* Next, set cust.cust-num to 1000 */
    unknown = 0;
    longvar = 1000L;
    if (ret = prowtbi("custbuf", profldix("custbuf", "cust-num"),
		       index, longvar, unknown)) 
        {    
	sprintf(message,"prowtbi fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
        }
    else
        {    
	sprintf(message,"setting custnum to 1000");
        promsgd(message);
        }

    /* Next, set agedar.ar_invdat to 5/5/45 */
    month = 5; day = 5; year = 1945;
    if (ret = prowtbd("agebuf", profldix("agebuf", "ar_invdat"), 
	index, year, month, day, unknown))
        {    
	sprintf(message,"prowtbd fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
        }
    else
        {    
	sprintf(message,"setting date to 5/5/45");
        promsgd(message);
        }
    
    /* Next, set cust.name to 'one thousand' */
    p_stcopy(buffer, "one thousand");
    if (ret = prowtbc("custbuf", profldix("custbuf","name"), 
			index, buffer,
		        unknown))
        {    
	sprintf(message,"prowtbc fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
        }
    else
        {    
	sprintf(message,"setting name to one thousand");
        promsgd(message);
        }
    
    /* Next, set cust.max-credit to 1234 */
    p_stcopy(buffer, "1234");
    if ((ret = prowtbn("custbuf", profldix("custbuf", "max-credit"), 
		  index, buffer,
		  unknown)) || unknown)
        {    
	sprintf(message,"prowtbn fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
        }
    else
        {    
	sprintf(message,"setting max-credit to 1234");
        promsgd(message);
        }
    
    return 0;
}
