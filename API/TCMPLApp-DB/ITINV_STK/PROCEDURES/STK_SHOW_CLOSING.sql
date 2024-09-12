--------------------------------------------------------
--  DDL for Procedure STK_SHOW_CLOSING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_SHOW_CLOSING" AS 

ALLDATA STK_CLOSING%rowtype;
BEGIN

 SELECT STK_CLOSING.ON_DATE,
  STK_ITEM_TYPE_MASTER.ITEMS_TYPE,
  STK_SUB_ITEM_TYPE.S_SUB_ITEM_TYPE,
  STK_CLOSING.BALANCE  INTO ALLDATA 
FROM STK_CLOSING
INNER JOIN STK_ITEM_TYPE_MASTER
ON STK_CLOSING.ITEM = STK_ITEM_TYPE_MASTER.KEY_ID
INNER JOIN STK_SUB_ITEM_TYPE
ON STK_CLOSING.SUBITEM = STK_SUB_ITEM_TYPE.SKEY_ID;



END STK_SHOW_CLOSING;

/
