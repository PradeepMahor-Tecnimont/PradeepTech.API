--------------------------------------------------------
--  DDL for View DM_PC_MOVEMENT_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_PC_MOVEMENT_LOG" ("DESKID", "BARCODE", "FLAG", "LOG_DATE", "ROW_ID") AS 
  SELECT 'Scrap' deskid, trim(A.BARCODE) barcode,
  'S' flag,
  A.NU_SCRAP_DATE log_date, a.rowid row_id
FROM dm_asset_out_of_use_log A
where nvl(a.nu_scrap_val,0) = 1 and A.NU_SCRAP_DATE is not null
union all

SELECT 'UnScrap' deskid, trim(b.BARCODE),
  'U' flag,
  b.NU_SCRAP_DATE log_date, b.rowid  row_id
FROM dm_asset_out_of_use_log b
where nvl(b.old_scrap_val,0) = 1 and b.old_SCRAP_DATE is not null 
and (nvl(b.nu_scrap_val,0) = 0 or b.nu_SCRAP_DATE is null)

union all
select 'NoUse' deskid, trim(c.barcode),'O' flag, c.log_date,c.rowid  row_id from DM_ASSET_OUT_OF_USE_LOG c
where (nvl(c.nu_scrap_val,0) = 0 or c.NU_SCRAP_DATE is null) and nvl(c.nu_out_of_srv,0) = 1
union all
select 'ReUse' deskid, trim(d.barcode) barcode,'R' flag, d.log_date,d.rowid  row_id from DM_ASSET_OUT_OF_USE_LOG d
where (nvl(d.nu_scrap_val,0) = 0 or d.NU_SCRAP_DATE is null) and nvl(d.nu_out_of_srv,0) = 0 
and nvl(d.old_out_of_srv,0)=1
Union all
select 'Home' deskid, trim(barcode), 'D' Flag, nvl(nvl(PODATE,scrap_date-1),'7-JUL-2014') log_date,rowid row_id from 
dm_assetcode where ASSETTYPE = 'PC'
union all
select deskid, trim(assetid),flag,log_date,rowid row_id from DM_DESKALLOCATION_LOG
  where ASSET_TYPE='PC'
;
