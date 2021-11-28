/***************************************************************************\
*****************************************************************************
**
**     Program: writem.p
**    Descript:
**
*****************************************************************************
\***************************************************************************/

TRIGGER PROCEDURE FOR Write OF Item.

/* Monitor Re-Order value, if greater than On-Hand + Allocated, 
 * Signal User to reorder 
 */

IF Item.Re-Order >
   Item.On-Hand + Item.Allocated THEN DO:
   MESSAGE "Please place an order for" Item.Item-Name
           ". Item Number: " Item.Item-Num 
           "Re-Order: " Item.Re-Order "On Hand: " 
           Item.On-Hand "Allocated: " Item.Allocated "." 
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
