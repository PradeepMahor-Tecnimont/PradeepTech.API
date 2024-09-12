--------------------------------------------------------
--  DDL for View DM_VU_EMP_MOVE_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_MOVE_LOG" ("EMPNO", "DESKID", "FLAG", "HISTORY_DATE", "REMARKS", "ROW_ID", "MOVEREQNUM") AS 
  SELECT empno,
  deskid,
  DECODE(DESK_FLAG ,'T','I','C','D') flag,
  history_date,
  'Trans' remarks,  row_id,MOVEREQNUM
FROM dm_vu_pc_move_hist
WHERE history_date > '31-dec-2012'
and history_date < '8-JULY-2014'
union all
select trim(empno) empno,
  trim(deskid) deskid,
  FLAG,
  LOG_DATE history_date,
  REMARK, rowid,'' from dm_usermaster_log where log_date > '8-JULY-2014'
  Union all
select empno, deskid, flag, trans_date, 'AsOn20130101',null, '' from dm_vu_emp_desk_20130101
;
