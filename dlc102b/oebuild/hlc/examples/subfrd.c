#include "hlc.h"

subfrd()
{
    int     ret, index, var, unknown, year, month, day;
    char    buffer[30];
    int     varlen = 30, actlen;
    int     longvar;
    char    message[80];

    index = unknown = 0;

    /* first, read monthly.tf_print */
    if ((ret = prordbl("monthbuf", 
			profldix("monthbuf","tf_print"),
		       index, &var, &unknown)) || unknown)
       {
	sprintf(message,"%gprordbl fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"tf_print should be no, value is %d", var);
        promsgd(message);
       }

    /* Next, read cust.cust-num */
    if ((ret = prordbi("custbuf", profldix("custbuf","cust-num"),
		   index, &longvar, &unknown)) || unknown)
       {
	sprintf(message,"%gprordbi fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"custnum should be 1, value is %d", longvar);
        promsgd(message);
       }

    /* Next, read agedar.ar_invdat */
    if ((ret = prordbd("agebuf", profldix("agebuf","ar_invdat"), 
	 index, &year, &month, &day, &unknown)) || unknown)
       {
	sprintf(message,"%gprordbd fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"date should be 8/31/87, value is %d/%d/%d",
	     month, day, year);
        promsgd(message);
       }
    
    /* Next, read cust.name */
    if ((ret = prordbc("custbuf", profldix("custbuf","name"), 
		index, buffer,
		      &unknown, varlen, &actlen)) || unknown)
       {
	sprintf(message,"%gprordbc fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"s.b. 2nd Skin Skuba, value is %s", buffer);
        promsgd(message);
       }
    
    /* Next, read cust.max-credit */
    if ((ret = prordbn("custbuf", profldix("custbuf","max-credit"), 
			index, buffer,
		      &unknown, varlen, &actlen)) || unknown)
       {
	sprintf(message,"%gprordbn fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
    {
	buffer[actlen] = 0;  /* null terminate value */
	sprintf(message,"maxcred should be 1500, value is %s", buffer);
        promsgd(message);
    }
    return 0;
    
}
