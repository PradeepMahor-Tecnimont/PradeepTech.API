--------------------------------------------------------
--  DDL for Procedure STK_INSERT_SUB_ITEMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_INSERT_SUB_ITEMS" (
    param_itemtype IN VARCHAR2,
    param_subiitem IN VARCHAR2,
    param_discrip  IN VARCHAR2,
    param_msg_type OUT VARCHAR2,
    param_msgText OUT VARCHAR2)
IS
  sitm NUMBER;
BEGIN
  SELECT COUNT( S_SUB_ITEM_TYPE)
  INTO sitm
  FROM STK_SUB_ITEM_TYPE
  WHERE S_SUB_ITEM_TYPE= param_subiitem
  AND ITEM_TYPE        =param_itemtype ;
  IF(sitm   = 0) THEN
    INSERT
    INTO STK_sub_item_type VALUES
      (
        DBMS_RANDOM.STRING('X',5) ,
        param_itemtype,
        param_subiitem,
        param_discrip
      );
       if( SQL%ROWCOUNT > 0 ) THEN
    
    param_msg_type:='SUCCESS';
    
    else
     param_msg_type:='FAIL';
     END IF;
    
  ELSE
    param_msg_type:='FAIL';
  END IF;
EXCEPTION
WHEN OTHERS THEN
param_msg_type:= 'FAILURE';
     
  param_msgText:='Error - ' || SQLCODE||' -- '||SQLERRM;
END;

/
