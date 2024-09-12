--------------------------------------------------------
--  DDL for Procedure STK_INSERT_REQUEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_INSERT_REQUEST" 
(param_ticked IN VARCHAR2,
param_itemtype IN VARCHAR2,
param_subiyem IN VARCHAR2,
param_remark IN VARCHAR2,
param_request_by IN VARCHAR2,
param_request_date IN varchar2,
param_issued IN VARCHAR2 default 'PENDING',
param_issued_by IN VARCHAR2 default 'Null',
param_issued_date IN varchar2 default 'Null', param_ISSER_REMARK in varchar2 default 'Null',
param_qty in number,param_Reftype in varchar2,param_counter in number default 'Null',
    param_msg_type out VARCHAR2,param_msgText out VARCHAR2 )
is
begin

    insert into STK_REQUEST values(upper(param_ticked),upper(param_itemtype ),upper(param_subiyem),param_remark ,upper(param_request_by),TO_DATE(param_request_date,'YYYY-MM-DD'),upper(param_issued) ,UPPER(param_issued_by ),TO_DATE(param_issued_date,'YYYY-MM-DD'), param_ISSER_REMARK,param_qty,upper(param_Reftype),param_counter);
    if( SQL%ROWCOUNT > 0 ) THEN
    
    param_msg_type:='SUCCESS';
    
    else
     param_msg_type:='FAIL';
     END IF;
    
exception 
  when others then
   param_msg_type:= 'FAILURE';
     
  param_msgText:='Error - ' || SQLCODE||' -- '||SQLERRM;
end;

/
