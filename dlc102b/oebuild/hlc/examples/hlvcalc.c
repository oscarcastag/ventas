/*
 * --------------HLC Example C Program ----------------
 *
 * hlvcalc -
 *
 *    Obtains the height, radius and oil level for the tank
 *    from the shared buffer "tankbuf".
 *    
 *    Calculates the remaining available volume
 *
 *    Update the avail field in the shared buffer "tankbuf" with the
 *    number calculated.
 */

#define  BUFLEN   100
#include <math.h>
#include "hlc.h"

/* NOTE: M_PI_2 is pi/2 constant which may be defined in math.h */
#ifndef M_PI_2
#define M_PI_2   1.570796327
#endif

char *fieldnm[] = { "tlength", "depth", "radius" }; 
char  message[80];

int
hlvcalc()

{
   char     buffer[BUFLEN];
   int      unknown = 0, index = 0, varlen = BUFLEN, actlen;
   int      ret;
   double   length, depth, radius, avail;
   int      i;
   int	    fldpos;
   double   temp1, temp2;  /* used to simplify calculation */

   
   /* first, obtain the length, depth and radius from */
   /* the shared buffer "tankbuf".                    */

   for (i = 0; i < 3; ++i)
   {
      fldpos = profldix("tankbuf", fieldnm[i]);
      if (fldpos < 0) 
      {
	sprintf(message, "profldix failed on %s for field %s",
		"tankbuf", fieldnm[i]);
	promsgd(message);
	return 1;
      }

	    
      ret = prordbn("tankbuf", fldpos, index, 
                      buffer, &unknown, varlen, &actlen);
      if (ret)
      {
	 sprintf(message, "prordbn failed accessing %s . %s",
                  "tankbuf", fieldnm[i]);
         promsgd(message);
         return 1;
      }

      /* if one of the fields is unknown, set avail field */
      /* to the unknown value                             */
      if (unknown)
      {
	 fldpos = profldix("tankbuf", "tavail");
	 if (fldpos < 0) 
	 {
	    sprintf(message, "profldix failed on %s for field %s",
		    "tankbuf", "tavail");
	    promsgd(message);
	    return 1;
	 }

         ret = prowtbn("tankbuf", fldpos, index, buffer, unknown);
         if (ret)
         {
            sprintf(message, "prowtbn failed, ret = %d", ret);
	    promsgd(message);
            return 1;
         }
         return 0;
      }

      /* convert the character string obtained from */
      /* PROGRESS into a decimal number             */

      buffer[actlen] = '\0';
      switch (i)
      {
         case 0: 
                  length = atof(buffer); break;
         case 1:
                  depth  = atof(buffer); break;
         case 2: 
                  radius = atof(buffer); break;
         
         default:
                  break;
      }         
      
   }  /* end of for loop */

   

   /* Now, calculate the available volume             */

   temp1 = 1.0 - depth/radius;

   temp2 = temp1 * sqrt(1.0 - temp1 * temp1) + asin(temp1);

   avail = length * radius * radius *
         
            (temp2 + M_PI_2);

   

   /* Now, put this value in the tavail field in the */
   /* "tankbuf" shared buffer                        */

   /* get the double into character format */
   sprintf(buffer, "%.2f", avail);
   fldpos = profldix("tankbuf", "tavail");
   if (fldpos < 0) 
   {
      sprintf(message, "profldix failed on %s for field %s",
	    "tankbuf", fieldnm[i]);
      promsgd(message);
      return 1;
   }
   ret = prowtbn("tankbuf", fldpos, index, buffer, unknown);
   if (ret)
      {
	 sprintf(message, "prowtbn failed, ret = %d", ret);
	 promsgd(message);
         return 1;
      }
   return 0;

}   
