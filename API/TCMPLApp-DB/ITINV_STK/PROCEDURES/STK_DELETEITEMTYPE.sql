--------------------------------------------------------
--  DDL for Procedure STK_DELETEITEMTYPE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_DELETEITEMTYPE" (
    param_ITEM IN VARCHAR2 ,
    param_msg_type OUT VARCHAR2 ,
    param_msgTExt OUT VARCHAR2 )
AS
  item_count  NUMBER;
  sitem_count NUMBER;
  itm         VARCHAR(2000);
BEGIN
  SELECT KEY_ID
  INTO itm
  FROM STK_ITEM_TYPE_MASTER
  WHERE ITEMS_TYPE = param_ITEM ;
  SELECT COUNT (ITEM_TYPE)
  INTO item_count
  FROM STK_REQUEST p
  WHERE p.ITEM_TYPE = itm ;
  SELECT COUNT (ITEM_TYPE)
  INTO sitem_count
  FROM STK_SUB_ITEM_TYPE p
  WHERE p.ITEM_TYPE = itm ;
  IF( item_count    =0 AND sitem_count =0) THEN
    DELETE FROM STK_ITEM_TYPE_MASTER WHERE ITEMS_TYPE = param_ITEM ;
    IF( SQL%ROWCOUNT > 0 ) THEN
      param_msg_type:='SUCCESS';
    ELSE
      param_msg_type:='FAIL';
    END IF;
  ELSE
    param_msg_type:= 'FAIL';
  END IF;
EXCEPTION
WHEN OTHERS THEN
  param_msg_type:= 'FAILURE';
  param_msgTExt :='Error - ' || SQLCODE||' -- '||SQLERRM;
END STK_DELETEITEMTYPE;

/
