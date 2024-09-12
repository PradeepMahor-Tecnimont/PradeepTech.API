--------------------------------------------------------
--  DDL for View DM_VU_PC_MOVE_HIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_PC_MOVE_HIST" ("MOVEREQNUM", "EMPNO", "DESKID", "DESK_FLAG", "ASSETID", "HISTORY_DATE", "ASSETTYPE", "ROW_ID") AS 
  select MOVEREQNUM MOVEREQNUM,
EMPNO EMPNO,
DESKID DESKID,
DESK_FLAG DESK_FLAG,
AssetId ASSETID,
history_date HISTORY_DATE,
ASSETTYPE ASSETTYPE,
row_id ROW_ID from (SELECT B.MOVEREQNUM,
  B.EMPNO,
  B.DESKID,
  B.DESK_FLAG,
  B.AssetId,
  B.history_date,
  C.ASSETTYPE,
  B.ROWID AS row_id
FROM
  (SELECT A.MOVEREQNUM,
    A.EMPNO,
    A.DESKID,
    A.DESK_FLAG,
    RPad(Trim(A.ASSETID), 13, ' ') AssetId,
    NVL(A.HISTORYDATE, to_date(SUBSTR(A.MOVEREQNUM, 6, 6), 'ddmmyy')) history_date,
    A.ROWID
  FROM DM_ASSETMOVE_TRAN_HISTORY A
  ) B
LEFT JOIN DM_ASSETCODE C
ON B.AssetId         = C.BARCODE
WHERE B.history_date > '16-APRIL-2010'
AND C.ASSETTYPE      = 'PC'
union all
select movereqnum,empno, deskid, desk_flag, assetid, historydate, asset_type, ROWID from DM_TRAN_HIST_20100416)
order by history_date
;
