/* This program, listconv.p  lists all of the codepage conversions
   in convmap.cp */

def var i as int format ">>9".
def var j as int format ">>9".
def var k as int format ">>9".
def var cp as character format "X(20)".
def var conversion as char format "X(20)".
def var test as char.

/*Hold the results in a temp table so we can produce a sorted list at the end */

DEFINE TEMP-TABLE temp-item
   FIELD rec as integer format ">>9"
   FIELD cpno as integer format ">>9"
   FIELD conversionno as integer format ">>9"
   FIELD cpname like cp
   FIELD conversionname like conversion
   INDEX list IS PRIMARY cpname conversionname ASCENDING.
 
Do i = 1 to num-entries(get-codepages)with down frame fcp:
  cp = entry(i,get-codepages).
  if cp = "undefined" then next. /* undefined converts to everything */
  do j = 1 to num-entries(get-codepages):
    conversion = entry(j,get-codepages).
    if conversion = "undefined" or conversion = cp then next.
    
    /* OLD: The only trick. Pick an ascii character that is in all codepages
    and convert it, no-error. then see if it converted ok. If so, the conversion
    exists. 
       NEW: check num-messages. The test = "" does not work for utf-16/32 
    */
    
    assign test = chr(65 ,conversion,cp) no-error.
    if error-status:num-messages > 0 then do with down frame f-err:
       /* display cp conversion "error" skip.*/
        end.
    else do:
      k = k + 1.
      create temp-item.
      ASSIGN rec = k
        cpno = i
        conversionno = j
        cpname = cp
        conversionname = conversion.
    end.
  end.
end.

For each temp-item by cpname by conversionname:
   display cpname conversionname.
end.

