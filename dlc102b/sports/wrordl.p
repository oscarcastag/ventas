/***************************************************************************\
*****************************************************************************
**
**     Program: wrordl.p
**    Descript: Order-Line write trigger.
**
*****************************************************************************
\***************************************************************************/

TRIGGER PROCEDURE FOR Write OF Order-Line.

/* Automatically calculate the Extended Price based on Price, Qty, Discount */

Extended-Price = Price * Qty * (1 - (Discount / 100)).


/* In some applications you may want to prohibit the change of a record 
 * based on the value of some field(s) in that record.  This is an example 
 * of what you might do if you want to prevent the change of an order-line 
 * record if a ship-date has already been entered for that record. 
 */
/*
FIND FIRST order OF order-line NO-ERROR.
IF AVAILABLE order THEN DO:
   IF order.ship-date <> ? THEN DO: 
      MESSAGE "Cannot change an order's detail information when a ship" 
              "date has been entered for that order." 
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN ERROR.
   END.
END.
*/
