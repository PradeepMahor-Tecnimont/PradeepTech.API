--------------------------------------------------------
--  DDL for View DIST_VU_NB_LOTWISE_PENDING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_NB_LOTWISE_PENDING" ("AMS_ASSET_ID", "SAP_ASSET_CODE", "ASSET_NAME", "MFG_SR_NO", "LOT_KEY_ID", "LOT_DESC", "REMARKS", "ASSIGNED_TO_EMPNO", "EMP_NAME", "PARENT", "GRADE", "WIFI_MAC_ADDRESS", "PROBLEM_CODE", "PROBLEM_DESC", "EMP_ASSIGNED_DATE", "EXPECTED_DATE", "MODIFIED_ON", "CURRENT_STATUS", "STATUS_DESC") AS 
  With pending_lot As (
    Select
        b.key_id lot_key_id,
        b.ams_asset_id,
        b.sap_asset_code,
        c.asset_name,
        c.mfg_sr_no,
        lot_desc
    From
        dist_laptop_lot_mast      a,
        dist_laptop_lot_details   b,
        ams_asset_master c
    Where
        a.key_id = b.key_id and
        b.ams_asset_id = c.ams_asset_id
        And b.ams_asset_id Not In (
            Select
                laptop_ams_id
            From
                dist_laptop_already_issued
            union
                select assetid from dm_vu_deskallocaiton
        )
), laptop_status As (
    Select
        a.ams_asset_id,
        a.remarks,
        a.assigned_to_empno,
        a.assigned_to_empno || ' - ' || c.name emp_name,
        c.parent,
        c.grade,
        a.wifi_mac_address,
        a.problem,
        d.problem_desc,
        a.emp_assigned_date,
        a.expected_date,
        a.modified_on,
        a.current_status,
        b.status_desc
    From
        dist_laptop_status         a,
        dist_surface_status_mast   b,
        dist_surface_problems_mast d,
        stk_empmaster              c
    Where
        a.current_status = b.status_code
        And a.assigned_to_empno = c.empno (+)
        and a.problem = d.problem_code(+)
)
Select
    lot.ams_asset_id,
    lot.sap_asset_code,
    lot.asset_name,
    lot.mfg_sr_no,
    lot.lot_key_id,
    lot.lot_desc,
    bb.remarks,
    bb.assigned_to_empno,
    bb.emp_name,
    bb.parent,
    bb.grade,
    bb.wifi_mac_address,
    bb.problem problem_code,
    bb.problem_desc,
    bb.emp_assigned_date,
    bb.expected_date,
    bb.modified_on,
    bb.current_status,
    bb.status_desc
From
    pending_lot     lot,
    laptop_status   bb
Where
    lot.ams_asset_id = bb.ams_asset_id (+)
;
