--------------------------------------------------------
--  DDL for View DM_PC_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_PC_STATUS" ("BARCODE", "FLAG", "DESKID", "TRANS_DATE", "ISSUED", "IT_POOL", "SCRAP", "OUT_OF_SERVICE") AS 
  select distinct barcode,flag,deskid,trans_date,
decode(flag,'I',1,0) Issued,
decode(flag,'D',1,0) IT_Pool,
decode(flag,'S',1,0) Scrap,
decode(flag,'O',1,0) Out_of_service from
(
select barcode,
  last_value(flag) over (partition by barcode order by log_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) flag,
  last_value(deskid) over (partition by barcode order by log_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) deskid,
  last_value(log_date) over (partition by barcode order by log_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) trans_date
from DM_PC_MOVEMENT_LOG ) 
order by barcode
;
