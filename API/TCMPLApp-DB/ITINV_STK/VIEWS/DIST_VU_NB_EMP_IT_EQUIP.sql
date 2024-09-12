--------------------------------------------------------
--  DDL for View DIST_VU_NB_EMP_IT_EQUIP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_NB_EMP_IT_EQUIP" ("EMPNO", "NAME", "PARENT", "ASSIGN", "GRADE", "DESG", "HEADSET", "DOCKING_STN", "LAPTOP_CHARGER", "DISPLAY_CONVERTER", "PROJECTOR_CONVERTER", "TRAVEL_BAG", "DOCUMENT_NO", "IS_ISSUED", "LAPTOP_NOW_ASSIGNED", "LAPTOP_NOW_ASSIGNED_SAPCODE", "CURRENT_STATUS", "EXPECTED_DATE", "DESKID", "COMPNAME", "PC_RAM", "MONMODEL1", "LAPTOP_ISSUED", "LAPTOP_ISSUED_PERMANENT", "ISSUE_DATE", "SW_REQUIRED", "IS_HOD_REQ", "REASON_4_NOPICKUP") AS 
  With
    cc As (
        Select
            assign,
            '-EX' exclude
        From
            dist_exclude_assign
    ), laptop_assigned As (
        Select
            assigned_to_empno,
            ams_asset_id,
            sap_asset_code,
            current_status,
            expected_date
        From
            dist_vu_nb_lotwise_pending
        Where
            assigned_to_empno Is Not Null
    )
Select
    a.empno,
    a.name,
    a.parent,
    a.assign || g.exclude                                assign,
    a.grade,
    desg.desg,
    b.headset,
    b.docking_stn,
    b.laptop_charger,
    b.display_converter,
    b.projector_converter,
    b.travel_bag,
    b.document_no,
    b.is_issued,
    c.ams_asset_id                                       laptop_now_assigned,
    c.sap_asset_code                                     laptop_now_assigned_sapcode,
    c.current_status,
    c.expected_date,
    d.deskid,
    d.compname,
    d.pc_ram,
    d.monmodel1,
    pkg_dist.get_emp_laptop_csv(a.empno)                 laptop_issued,
    pkg_dist.get_emp_laptop_csv(a.empno, 'IS_PERMANENT') laptop_issued_permanent,
    b.issue_date,
    f.sw_required,
    nvl(f.is_requested, 'KO')                            is_hod_req,
    reason_4_nopickup
From
    vu_emplmast            a,
    dist_emp_it_equip      b,
    laptop_assigned        c,
    dist_desmas_allocation d,
    dist_laptop_request    f,
    cc                     g,
    vu_desgmast            desg
Where
    status         = 1
    And (emptype In (
            Select
                emptype
            From
                Table (dist.get_emp_type_list())
        )
        Or a.empno In (
            Select
                empno
            From
                dist_vu_laptop_issued
        )
    )
    And (a.grade Not In (
            Select
                grade
            From
                Table (dist.get_exclude_grade_list())
        )
        Or a.empno In (
            Select
                empno
            From
                dist_vu_laptop_issued
        ))
    And a.empno    = b.empno (+)
    And a.empno    = c.assigned_to_empno (+)
    And a.empno    = d.empno (+)
    And a.empno    = f.empno (+)
    And a.assign   = g.assign (+)
    And a.desgcode = desg.desgcode (+)
;
