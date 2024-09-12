--------------------------------------------------------
--  DDL for View DM_VU_PC_MOVE_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_PC_MOVE_LOG" ("DESKID", "BARCODE", "FLAG", "LOG_DATE", "REMARKS") AS 
  SELECT trim(deskid) "DESKID",
  trim(barcode) "BARCODE",
  "FLAG",
  "LOG_DATE",
  "REMARKS"
FROM
  (SELECT deskid,
    assetid BARCODE,
    flag,
    HISTORY_DATE LOG_DATE ,
    remarks
  FROM
    (SELECT empno,
      deskid,
      assetid,
      DECODE(DESK_FLAG ,'T','I','C','D') flag,
      history_date,
      'Trans' remarks
    FROM dm_vu_pc_move_hist
    WHERE history_date > '31-dec-2012'
    and history_date < '8-JULY-2014'
    order by history_date, row_id
    )
  UNION ALL
  SELECT deskid,
    assetid,
    flag,
    trans_date,
    'Open'
  FROM dm_vu_asset_desk_20130101
  UNION ALL
  SELECT 'Scrap' deskid,
    trim(A.BARCODE) barcode,
    'S' flag,
    A.NU_SCRAP_DATE log_date,
    'Scrap' Remarks
  FROM dm_asset_out_of_use_log A
  WHERE NVL(a.nu_scrap_val,0) = 1
  AND A.NU_SCRAP_DATE        IS NOT NULL
  UNION ALL
  SELECT 'UnScrap' deskid,
    trim(b.BARCODE),
    'U' flag,
    b.NU_SCRAP_DATE log_date,
    'UnScrap'
  FROM dm_asset_out_of_use_log b
  WHERE NVL(b.old_scrap_val,0) = 1
  AND b.old_SCRAP_DATE        IS NOT NULL
  AND (NVL(b.nu_scrap_val,0)   = 0
  OR b.nu_SCRAP_DATE          IS NULL)
  UNION ALL
  SELECT 'NoUse' deskid,
    trim(c.barcode),
    'O' flag,
    c.log_date,
    'OutOfUse'
  FROM DM_ASSET_OUT_OF_USE_LOG c
  WHERE (NVL(c.nu_scrap_val,0) = 0
  OR c.NU_SCRAP_DATE          IS NULL)
  AND NVL(c.nu_out_of_srv,0)   = 1
  UNION ALL
  SELECT 'ReUse' deskid,
    trim(d.barcode) barcode,
    'R' flag,
    d.log_date,
    'ReUse'
  FROM DM_ASSET_OUT_OF_USE_LOG d
  WHERE (NVL(d.nu_scrap_val,0) = 0
  OR d.NU_SCRAP_DATE          IS NULL)
  AND NVL(d.nu_out_of_srv,0)   = 0
  AND NVL(d.old_out_of_srv,0)  =1
  UNION ALL
  SELECT 'Home' deskid,
    trim(barcode),
    'D' Flag,
    NVL(NVL(PODATE,scrap_date-1),'1-JAN-2013') log_date,
    'New' Remarks
  FROM dm_assetcode
  WHERE ASSETTYPE = 'PC'
  ) 

union all 
select trim(deskid) DESKID,
  trim(assetid) BARCODE,
  FLAG,
  LOG_DATE,
  REMARK from dm_deskallocation_log where log_date >= '8-JULY-2014' and asset_type = 'PC'
;
