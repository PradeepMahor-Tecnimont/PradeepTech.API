--------------------------------------------------------
--  DDL for Procedure STK_DELETESUBITEM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_DELETESUBITEM" (param_ITEM in VARCHAR2,
    param_subitem IN VARCHAR2 ,
    param_msgtype OUT VARCHAR2,
    param_msgText OUT VARCHAR2)
IS
BEGIN
  DECLARE
    item_count NUMBER;
    subitm        VARCHAR(2000);
     itm        VARCHAR(2000);
  BEGIN
  
  SELECT KEY_ID
  INTO itm
  FROM STK_ITEM_TYPE_MASTER
  WHERE ITEMS_TYPE = param_ITEM ;
  
    SELECT SKEY_ID
    INTO subitm
    FROM STK_SUB_ITEM_TYPE
    WHERE S_SUB_ITEM_TYPE= param_subitem and ITEM_TYPE = itm;
    
     
    
    SELECT COUNT (SUB_ITEM_TYPE)
    INTO item_count
    FROM STK_REQUEST p
    WHERE p.SUB_ITEM_TYPE = subitm and p.ITEM_TYPE=itm ;
    
    IF(item_count  =0) THEN
    
      DELETE FROM STK_SUB_ITEM_TYPE WHERE SKEY_ID = subitm  ;
      param_msgtype:='SUCCESS';
    ELSE
      param_msgtype:='FAIL';
     
    END IF;
  END;
EXCEPTION
WHEN OTHERS THEN
   param_msgtype:= 'FAILURE';
  param_msgText:='Error - ' || SQLCODE||' -- '||SQLERRM;
END STK_DELETESUBITEM;

/
