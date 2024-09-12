--------------------------------------------------------
--  DDL for View DIST_VU_EMP_IT_EQUIPMENTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_EMP_IT_EQUIPMENTS" ("EMPNO", "NAME", "PARENT", "ASSIGN", "GRADE", "HEADSET", "DOCKING_STN", "LAPTOP_CHARGER", "DISPLAY_CONVERTER", "PROJECTOR_CONVERTER", "TRAVEL_BAG", "DOCUMENT_NO", "LAPTOP_NOW_ASSIGNED", "LAPTOP_NOW_ASSIGNED_SAPCODE", "CURRENT_STATUS", "EXPECTED_DATE", "DESKID", "COMPNAME", "PC_RAM", "MONMODEL1", "LAPTOP_ALREADY_ISSUED", "IS_ISSUED", "ISSUE_DATE", "SW_REQUIRED", "IS_HOD_REQ", "REASON_4_NOPICKUP") AS 
  With t As (
    Select
        assign,
        '-EX' exclude
    From
        dist_exclude_assign
), laptop_issued As (
    Select
        assigned_to_empno,
        ams_asset_id,
        sap_asset_code,
        current_status,
        expected_date
    From
        dist_vu_surface_laptop
    Union
    Select
        empno,
        laptop_ams_id,
        Null,
        11,
        Null
    From
        dist_other_laptop_now_issued
    Where
        empno Not In (
            Select
                assigned_to_empno
            From
                dist_vu_surface_laptop
            Where
                assigned_to_empno Is Not Null
        )
)
Select
    a.empno,
    a.name,
    a.parent,
    a.assign || g.exclude assign,
    a.grade,
    b.headset,
    b.docking_stn,
    b.laptop_charger,
    b.display_converter,
    b.projector_converter,
    b.travel_bag,
    b.document_no,
    c.ams_asset_id     laptop_now_assigned,
    c.sap_asset_code   laptop_now_assigned_sapcode,
    c.current_status,
    c.expected_date,
    d.deskid,
    d.compname,
    d.pc_ram,
    d.monmodel1,
    Case e.permanent_issued
        When 'OK' Then
            Trim(e.laptop_ams_id) || '-EX'
        Else
            Trim(e.laptop_ams_id)
    End laptop_already_issued,
    b.is_issued,
    b.issue_date,
    f.sw_required,
    Nvl(f.is_requested, 'KO') is_hod_req,
    reason_4_nopickup
From
    vu_emplmast                  a,
    dist_emp_it_equip            b,
    laptop_issued                c,
    dist_desmas_allocation       d,
    dist_laptop_already_issued   e,
    dist_laptop_request          f,
    t                            g
Where
    status = 1
    And emptype In (
        Select
            emptype
        From
            Table ( dist.get_emp_type_list() )
    )
    And ( a.grade Not In (
        Select
            grade
        From
            Table ( dist.get_exclude_grade_list() )
    )
          Or a.empno In (
        Select
            assigned_to_empno
        From
            dist_surface_laptop_mast
    ) )
    And a.empno   = b.empno (+)
    And a.empno   = c.assigned_to_empno (+)
    And a.empno   = d.empno (+)
    And a.empno   = e.empno (+)
    And a.empno   = f.empno (+)
    And a.assign  = g.assign (+)
;
