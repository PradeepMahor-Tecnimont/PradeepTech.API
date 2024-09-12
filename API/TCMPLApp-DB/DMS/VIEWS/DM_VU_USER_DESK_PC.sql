--------------------------------------------------------
--  DDL for View DM_VU_USER_DESK_PC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_USER_DESK_PC" ("DESKID", "ASSETID", "ASSET_TYPE", "DESCRIPTION", "EMPNO", "COMPNAME") AS 
  SELECT a.DESKID,
  a.ASSETID,
  b.ASSET_TYPE,
  b.DESCRIPTION,
  d.EMPNO,
  c.compname
FROM dm_deskallocation a,
  dm_assettype b,
  dm_assetcode c,
  DM_USERMASTER d
WHERE trim(a.ASSETID) = trim(c.BARCODE)
AND c.ASSETTYPE       = b.ASSET_TYPE
AND a.DESKID          = d.DESKID
AND c.ASSETTYPE      IN ('NB', 'PC')
;
