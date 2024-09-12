--------------------------------------------------------
--  DDL for Procedure STK_UPDATE_CLOSING_TABLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_UPDATE_CLOSING_TABLE" 
AS
  CURSOR MY_CURSOR
  IS
    SELECT STK_ITEM_TYPE_MASTER.KEY_ID,
      STK_SUB_ITEM_TYPE.SKEY_ID
    FROM STK_ITEM_TYPE_MASTER
    INNER JOIN STK_SUB_ITEM_TYPE
    ON STK_ITEM_TYPE_MASTER.KEY_ID = STK_SUB_ITEM_TYPE.ITEM_TYPE;
  closing_items MY_CURSOR%ROWTYPE;
BEGIN
  OPEN my_cursor;
  LOOP
    FETCH my_cursor INTO closing_items;
    STK_Insert_CLOSING(closing_items.KEY_ID,closing_items.skey_id);
    EXIT
  WHEN my_cursor%notfound;
  END LOOP;
  CLOSE my_cursor;
END STK_update_Closing_Table;

/
