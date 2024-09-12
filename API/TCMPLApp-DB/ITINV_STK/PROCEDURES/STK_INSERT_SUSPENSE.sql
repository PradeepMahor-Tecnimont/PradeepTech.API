--------------------------------------------------------
--  DDL for Procedure STK_INSERT_SUSPENSE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_INSERT_SUSPENSE" (param_request IN VARCHAR2,
param_itemtype IN VARCHAR2,
param_subiyem IN VARCHAR2,
param_qty IN number,
param_modified_by IN VARCHAR2,
param_modified_date IN varchar2,param_msg_type out varchar2,param_msgText out varchar2)
is
begin
    insert into STK_SUSPENSE_TABLE values(DBMS_RANDOM.STRING('X',5), TO_DATE(param_request,'YYYY-MM-DD'),upper(param_itemtype ),upper(param_subiyem),param_qty ,upper(param_modified_by),TO_DATE(param_modified_date,'YYYY-MM-DD'));
    
     if( SQL%ROWCOUNT > 0 ) THEN
    
    param_msg_type:='SUCCESS';
    
    else
     param_msg_type:='FAIL';
     END IF;
    
 
  exception 
  when others then
  param_msg_type:= 'FAILURE';
     
  param_msgText:='Error - ' || SQLCODE||' -- '||SQLERRM;
end STK_INSERT_Suspense;

/
