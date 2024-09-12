--------------------------------------------------------
--  DDL for Procedure STK_CLOSING_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_CLOSING_TEST" (
    PARAM_ITEM    IN VARCHAR2 ,
    PARAM_SUBITEM IN VARCHAR2 )
AS
  qty_request    NUMBER;
  TOTAL_issued   NUMBER:=0;
  TOTAL_STOCK_IN NUMBER:=0;
  main_reult     NUMBER:=0;
  SUB            VARCHAR2(2000);
  ITEM           VARCHAR2(2000);
BEGIN
  SELECT SUM(STK_REQUEST.QUANTITY)
  INTO TOTAL_issued
  FROM STK_REQUEST
  WHERE STK_REQUEST.ISSUED     ='ISSUED'
  AND STK_REQUEST.ITEM_TYPE    =upper(PARAM_ITEM)
  AND STK_REQUEST.SUB_ITEM_TYPE=upper(PARAM_SUBITEM) ;
  SELECT SUM(STK_STOCK_IN.QUANTITY)
  INTO TOTAL_STOCK_IN
  FROM STK_STOCK_IN
  WHERE ITEM_TYPE  =upper(PARAM_ITEM)
  AND SUB_ITEM_TYPE=upper(PARAM_SUBITEM);
  
  IF(TOTAL_issued != 0 AND TOTAL_STOCK_IN!= 0 ) THEN
    main_reult    :=TOTAL_STOCK_IN - TOTAL_issued ;
  ELSE
    main_reult:=TOTAL_STOCK_IN ;
  END IF;
  INSERT
  INTO STK_CLOSING VALUES
    (
      TO_DATE(SYSDATE,'YYYY-MM-DD'),
      PARAM_ITEM,
      PARAM_SUBITEM,
      main_reult
    );
END STK_CLOSING_TEST;

/
