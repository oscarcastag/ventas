/***************************************************************************\
*****************************************************************************
**
**     Program: delord.p
**    Descript:
**
*****************************************************************************
\***************************************************************************/

TRIGGER PROCEDURE FOR Delete OF Order.

/* When Orders are deleted, associated Order detail lines (Order-Line) 
 * are also deleted.
 */

MESSAGE "Deleting Order" Order-Num VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
FOR EACH Order-Line OF Order:
   DELETE Order-Line.
END.










