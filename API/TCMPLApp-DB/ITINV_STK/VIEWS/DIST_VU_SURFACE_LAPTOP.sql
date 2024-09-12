--------------------------------------------------------
--  DDL for View DIST_VU_SURFACE_LAPTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_SURFACE_LAPTOP" ("SAP_ASSET_CODE", "CURRENT_STATUS", "EXPECTED_DATE", "REMARKS", "ASSIGNED_TO_EMPNO", "PROBLEM", "WIFI_MAC_ADDRESS", "EMP_ASSIGNED_DATE", "MODIFIED_ON", "AMS_ASSET_ID", "MFG_SR_NO", "ASSET_NAME", "ASSET_MODEL", "EMP_NAME", "PARENT", "ASSIGN", "GRADE", "STATUS_DESC", "PROBLEM_DESC", "EXPECTED_DT") AS 
  Select
    a.sap_asset_code,
    a.current_status,
    a.expected_date,
    a.remarks,
    a.assigned_to_empno,
    a.problem,
    a.wifi_mac_address,
    a.emp_assigned_date,
    a.modified_on,
    b.ams_asset_id,
    b.mfg_sr_no,
    b.asset_name,
    b.asset_model,
    c.name emp_name,
    c.parent,
    c.assign,
    c.grade,
    d.status_desc,
    e.problem_desc,
    To_Char(a.expected_date, 'dd-Mon-yyyy') expected_dt
From
    dist_surface_laptop_mast    a,
    ams_asset_master            b,
    stk_empmaster               c,
    dist_surface_status_mast    d,
    dist_surface_problems_mast  e
Where
    a.sap_asset_code = b.sap_asset_code
    And a.assigned_to_empno    = c.empno (+)
    And a.current_status       = d.status_code (+)
    And a.problem              = e.problem_code (+)
;
