--------------------------------------------------------
--  DDL for View SS_VU_PHONE_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_PHONE_LOG" ("GLOBAL_CALL_ID", "CALL_ID", "CALL_START", "CALL_FROM", "USER_ID", "CALL_TO", "CALL_TO_FINAL", "CALL_CONNECT", "CALL_DIS_CONNECT", "LAST_REDIRECT_DN", "CALL_DURATION", "COMMENT_TEXT") AS 
  (
select GLOBAL_CALL_ID ,
CALL_ID ,
CALL_START ,
case 
when trim(call_from) like '6777____' then '104' || substr(trim(call_from),5,4) 
when trim(call_from) like '6694____' then '104' || substr(trim(call_from),5,4) 
else trim(call_from) end as call_from,
USER_ID ,
case 
when trim(call_to) like '6777____' then '104' || substr(trim(call_to),5,4) 
when trim(call_to) like '6694____' then '104' || substr(trim(call_to),5,4) 
else trim(call_to) end as call_to,
case
when trim(call_to_final) like '6777____' then '104' || substr(trim(call_to_final),5,4) 
when trim(call_to_final) like '6694____' then '104' || substr(trim(call_to_final),5,4) 
else trim(call_to_final) end as call_to_final,
CALL_CONNECT ,
CALL_DIS_CONNECT ,

case 
when trim(LAST_REDIRECT_DN) like '6777____' then '104' || substr(trim(LAST_REDIRECT_DN),5,4) 
when trim(LAST_REDIRECT_DN) like '6694____' then '104' || substr(trim(LAST_REDIRECT_DN),5,4) 
else trim(LAST_REDIRECT_DN) end as last_redirect_dn,
CALL_DURATION ,
COMMENT_TEXT  from ss_phone_call_log )
;
