/* This program, list-cp.p  lists all of the 
   codepages and collations in convmap.cp */

def var i as int format ">>9".
def var j as int format ">>9".
def var k as int format ">>9".
def var cp as character format "X(20)".
def var coll as char format "X(20)".
def var db as char.

DEFINE TEMP-TABLE temp-item
   FIELD rec as integer format ">>9"
   FIELD cpno as integer format ">>9"
   FIELD collno as integer format ">>9"
   FIELD cpname like cp
   FIELD Collname like coll
   INDEX list IS PRIMARY cpname collname ASCENDING.
 
Do i = 1 to num-entries(get-codepages)with down frame fcp:
  cp = entry(i,get-codepages).
  do j = 1 to num-entries(get-collations(cp)):
    coll = entry(j,get-collations(cp)).
    k = k + 1.
    create temp-item.
    ASSIGN rec = k
    cpno = i
    collno = j
    cpname = cp
    collname = coll.
  end.
end.

For each temp-item by cpname by collname:
display cpname collname.
end.

