--------------------------------------------------------
--  DDL for View DM_VU_ASSET_DESK_20130101
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_ASSET_DESK_20130101" ("ASSETID", "FLAG", "DESKID", "TRANS_DATE") AS 
  select assetid ,
decode(flag,'T','I','D') flag ,
deskid ,
trans_date  from (
SELECT DISTINCT assetid ,
flag ,
deskid ,
trans_date  FROM (
select assetid,
  last_value(desk_flag) over (partition by assetid order by history_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) flag,
  last_value(deskid) over (partition by assetid order by history_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) deskid,
  last_value(history_date) over (partition by assetid order by history_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) trans_date
           FROM DM_VU_PC_MOVE_HIST
           where history_date < '1-JAN-2013'))
;
