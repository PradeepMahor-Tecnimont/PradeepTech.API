--------------------------------------------------------
--  DDL for Procedure STK_INSERT_CLOSING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_INSERT_CLOSING" (
    PARAM_ITEM    IN VARCHAR2 ,
    PARAM_SUBITEM IN VARCHAR2 )
AS
  TOTAL_issued   NUMBER:=0;
  TOTAL_STOCK_IN NUMBER:=0;
  main_reult     NUMBER:=0;
  TOTAL_BALANCE  NUMBER:=0;
  maxdate date;
BEGIN

select  max (STK_CLOSING.ON_DATE) into maxdate from STK_CLOSING 
  WHERE STK_CLOSING.ITEM =upper(PARAM_ITEM)
  AND STK_CLOSING.SUBITEM=upper(PARAM_SUBITEM);

  SELECT SUM(STK_CLOSING.BALANCE)
  INTO TOTAL_BALANCE
  FROM STK_CLOSING where ON_DATE=maxdate and 
  STK_CLOSING.ITEM =upper(PARAM_ITEM)
  AND STK_CLOSING.SUBITEM=upper(PARAM_SUBITEM);
  
  SELECT SUM(STK_REQUEST.QUANTITY)
  INTO TOTAL_issued
  FROM STK_REQUEST
  WHERE STK_REQUEST.ISSUED     ='ISSUED'
  AND STK_REQUEST.ITEM_TYPE    =upper(PARAM_ITEM)
  AND STK_REQUEST.SUB_ITEM_TYPE=upper(PARAM_SUBITEM) and ISSUED_DATE >maxdate ;  
  
  SELECT SUM(STK_STOCK_IN.QUANTITY)
  INTO TOTAL_STOCK_IN
  FROM STK_STOCK_IN
  WHERE ITEM_TYPE   =upper(PARAM_ITEM)
  AND SUB_ITEM_TYPE =upper(PARAM_SUBITEM);
  
   if(TOTAL_STOCK_IN is  null) then
  TOTAL_STOCK_IN:=0;
  end if;

   if(TOTAL_issued is  null) then
  TOTAL_issued:=0;
  end if;
  
  
  IF( TOTAL_BALANCE IS NOT NULL) THEN
  
    main_reult  :=(TOTAL_BALANCE) - (TOTAL_issued) ;
  ELSE
    IF( TOTAL_STOCK_IN is not null )THEN
    
      IF( TOTAL_issued  >0 ) THEN
        main_reult     :=(TOTAL_STOCK_IN)-( TOTAL_issued) ;
      ELSE
        main_reult :=(TOTAL_STOCK_IN);
      END IF;
    ELSE
    if(TOTAL_issued is null) then
    
      main_reult :=0;
      else 
      main_reult:=-(TOTAL_issued);
      end if;
    END IF;
  END IF;
  
  INSERT
  INTO STK_CLOSING VALUES
    (
      TO_DATE(SYSDATE,'YYYY-MM-DD'),
      PARAM_ITEM,
      PARAM_SUBITEM,
      main_reult
    );
END STK_Insert_CLOSING;

/
