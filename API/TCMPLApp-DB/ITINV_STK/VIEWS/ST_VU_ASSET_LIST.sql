--------------------------------------------------------
--  DDL for View ST_VU_ASSET_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ST_VU_ASSET_LIST" ("ITEM_CODE", "ITEM_DESC", "ITEM_TYPE") AS 
  SELECT BARCODE ITEM_CODE, nvl(trim(BARCODE),'NA') || ' - ' || trim(mfg_sr_no) || ' - ' || MODEL ITEM_DESC,
CASE ASSETTYPE
WHEN 'PR' THEN 2 --Printer
WHEN 'MF' THEN 2 --Printer
WHEN 'PL' THEN 2 --Printer

WHEN 'PC' THEN 3 --Computer
WHEN 'NB' THEN 5 --LapTop

WHEN 'MO' THEN 6 --Monitor

WHEN 'IP' THEN 7 --Telephone
WHEN 'TL' THEN 7 --Telephone

ELSE 99 END ITEM_TYPE
FROM DM_VU_ASSET_LIST WHERE NVL(SCRAP,0)=0

union all

select ticb_bar_code item_code, nvl(trim(ticb_bar_code),'NA') || ' - ' || mfg_sr_no || ' - ' || Trim(cat_make) || ' ' || trim(cat_model) item_desc,
case type_id
when 'T001' then 2 --Printer
when 'T002' then 2 --Printer
when 'T003' then 2 --Printer
when 'T004' then 2 --Printer
else 99 end item_type
from inv_vu_assets_list 
union all
select trim(office) || '-'|| trim(deskid) item_code, 
trim(office) || '-'|| trim(deskid) || ' - ' || trim(FLOOR) || ' - ' || trim(wing) item_desc,
1 item_type
from dm_vu_desk_list
;
