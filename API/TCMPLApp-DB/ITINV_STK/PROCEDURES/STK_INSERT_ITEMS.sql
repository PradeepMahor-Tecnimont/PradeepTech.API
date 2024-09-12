--------------------------------------------------------
--  DDL for Procedure STK_INSERT_ITEMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_INSERT_ITEMS" (
    param_itemname        IN VARCHAR2,
    param_itemdiscription IN VARCHAR2,
    param_Reftype         IN VARCHAR2,
    param_msg_type OUT VARCHAR2,
    param_msgText OUT VARCHAR2)
IS
  sitm NUMBER;
BEGIN
  SELECT COUNT(ITEMS_TYPE)
  INTO sitm
  FROM STK_ITEM_TYPE_MASTER
  WHERE ITEMS_TYPE= param_itemname;
  IF(sitm         = 0) THEN
    INSERT
    INTO STK_ITEM_TYPE_MASTER VALUES
      (
        DBMS_RANDOM.STRING('X',5),
        upper(param_itemname ),
        param_itemdiscription,
        upper(param_Reftype)
      );
    IF( SQL%ROWCOUNT > 0 ) THEN
      param_msg_type:='SUCCESS';
    ELSE
      param_msg_type:='FAIL';
    END IF;
  ELSE
    param_msg_type:='FAIL';
  END IF;
EXCEPTION
WHEN OTHERS THEN
  param_msg_type:= 'FAILURE';
  param_msgText :='Error - ' || SQLCODE||' -- '||SQLERRM;
END;

/
