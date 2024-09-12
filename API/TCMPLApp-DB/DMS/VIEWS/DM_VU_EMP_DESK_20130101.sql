--------------------------------------------------------
--  DDL for View DM_VU_EMP_DESK_20130101
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_EMP_DESK_20130101" ("EMPNO", "DESKID", "FLAG", "TRANS_DATE", "ROW_ID") AS 
  select empno ,
deskid ,
decode(flag,'T','I','D') flag ,
trans_date,
'1' as Row_id  from (
SELECT DISTINCT empno ,
flag ,
deskid ,
trans_date
FROM (
select empno,
  last_value(desk_flag) over (partition by empno order by history_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) flag,
  last_value(deskid) over (partition by empno order by history_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) deskid,
  last_value(history_date) over (partition by empno order by history_date, row_id RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) trans_date
           FROM DM_VU_PC_MOVE_HIST
           where history_date < '1-JAN-2013'))
;
