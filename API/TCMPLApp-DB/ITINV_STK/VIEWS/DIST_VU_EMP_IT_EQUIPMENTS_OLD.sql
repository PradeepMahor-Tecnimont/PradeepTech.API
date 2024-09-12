--------------------------------------------------------
--  DDL for View DIST_VU_EMP_IT_EQUIPMENTS_OLD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_EMP_IT_EQUIPMENTS_OLD" ("EMPNO", "NAME", "PARENT", "ASSIGN", "GRADE", "HEADSET", "DOCKING_STN", "LAPTOP_CHARGER", "DISPLAY_CONVERTER", "PROJECTOR_CONVERTER", "TRAVEL_BAG", "DOCUMENT_NO", "LAPTOP_NOW_ASSIGNED", "CURRENT_STATUS", "EXPECTED_DATE", "DESKID", "COMPNAME", "PC_RAM", "LAPTOP_ALREADY_ISSUED", "IS_ISSUED", "ISSUE_DATE") AS 
  Select
    a.empno,
    a.name,
    a.parent,
    a.assign,
    a.grade,
    b.headset,
    b.docking_stn,
    b.laptop_charger,
    b.display_converter,
    b.projector_converter,
    b.travel_bag,
    b.document_no,
    c.sap_asset_code    laptop_now_assigned,
    c.current_status,
    c.expected_date,
    d.deskid,
    d.compname,
    d.pc_ram,
    e.laptop_ams_id     laptop_already_issued,
    is_issued,
    issue_date
From
    vu_emplmast                 a,
    dist_emp_it_equip           b,
    dist_surface_laptop_mast    c,
    dist_desmas_allocation      d,
    dist_laptop_already_issued  e
Where
    status = 1
    And emptype In (
        'R',
        'S',
        'C',
        'F'
    )
    And a.grade Not In (
        'X1',
        'X2',
        'X3',
        'A1'
    )
    And a.empno    = b.empno (+)
    And a.empno    = c.assigned_to_empno (+)
    And a.empno    = d.empno (+)
    And a.empno    = e.empno (+)
;
