#include "hlc.h"

subvrd()
{
    int     ret, index, var, unknown, year, month, day;
    char    buffer[30];
    int     varlen = 30, actlen;
    int    longvar;
    char    message[80];

    index = unknown = 0;
    /* first, read g-boolean */
    if ((ret = prordl("g-boolean", index, &var, &unknown)) || unknown)
       {
	sprintf(message,"prordl fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"g-boolean should be yes, value is %d", var);
        promsgd(message);
       }

    /* Next, read g-integer */
    if ((ret = prordi("g-integer", index, &longvar, &unknown)) || unknown)
       {
	sprintf(message,"prordi fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"g-integer should be 10, value is %d", longvar);
        promsgd(message);
       }

    /* Next, read g-date */
    if ((ret = prordd("g-date", index, 
           &year, &month, &day, &unknown)) || unknown)
       {
	sprintf(message,"prordd fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"g-date should be 7/25/49, value is %d/%d/%d",
	     month, day, year);
        promsgd(message);
       }
    
    /* Next, read g-char */
    if ((ret = prordc("g-char", index, buffer,
		      &unknown, varlen, &actlen)) || unknown)
       {
	sprintf(message,"prordc fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"g-char should be hlctest, value is %s", buffer);
        promsgd(message);
       }
    
    /* Next, read g-decimal */
    if ((ret = prordn("g-decimal", index, buffer,
		      &unknown, varlen, &actlen)) || unknown)
       {
	sprintf(message,"prordn fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
    {
	buffer[actlen] = 0;  /* null terminate value */
	sprintf(message,"g-decimal should be 3.14, value is %s", buffer);
        promsgd(message);
    }
    
    /* Next, read g-recid */
    if ((ret = prordr("g-recid", index, &longvar, &unknown)) || unknown)
       {
	sprintf(message,"prordr fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"g-recid should be 7, value is %d", longvar);
        promsgd(message);
       }

    /* first, read s-boolean */
    if ((ret = prordl("s-boolean", index, &var, &unknown)) || unknown)
       {
	sprintf(message,"prordl fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"s-boolean should be yes, value is %d", var);
        promsgd(message);
       }

    /* Next, read s-integer */
    if ((ret = prordi("s-integer", index, &longvar, &unknown)) || unknown)
       {
	sprintf(message,"prordi fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"s-integer should be 10, value is %d", longvar);
        promsgd(message);
       }

    /* Next, read s-date */
    if ((ret = prordd("s-date", index, 
           &year, &month, &day, &unknown)) || unknown)
       {
	sprintf(message,"prordd fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"s-date should be 7/25/49, value is %d/%d/%d",
	     month, day, year);
        promsgd(message);
       }
    
    /* Next, read s-char */
    if ((ret = prordc("s-char", index, buffer,
		      &unknown, varlen, &actlen)) || unknown)
       {
	sprintf(message,"prordc fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"s-char should be hlctest, value is %s", buffer);
        promsgd(message);
       }
    
    /* Next, read s-decimal */
    if ((ret = prordn("s-decimal", index, buffer,
		      &unknown, varlen, &actlen)) || unknown)
       {
	sprintf(message,"prordn fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
    {
	buffer[actlen] = 0;  /* null terminate value */
	sprintf(message,"s-decimal should be 3.14, value is %s", buffer);
        promsgd(message);
    }
    
    /* Next, read s-recid */
    if ((ret = prordr("s-recid", index, &longvar, &unknown)) || unknown)
       {
	sprintf(message,"prordr fatal ret = %d unknown %d", ret, unknown);
        promsgd(message);
       }
    else
       {
	sprintf(message,"s-recid should be 7, value is %d", longvar);
        promsgd(message);
       }

    return 0;

}
