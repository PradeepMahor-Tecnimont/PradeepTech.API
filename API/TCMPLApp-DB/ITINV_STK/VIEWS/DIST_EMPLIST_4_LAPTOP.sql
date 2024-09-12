--------------------------------------------------------
--  DDL for View DIST_EMPLIST_4_LAPTOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_EMPLIST_4_LAPTOP" ("EMPNO", "EMP_NAME", "PARENT", "ASSIGN", "GRADE", "SW_REQUIRED", "LAPTOP_REQUEST", "IT_ACTION_DESC", "IT_ACTION_CODE", "LAPTOP_NOW_ISSUED", "DESKID", "COMPNAME", "COMPUTER", "PC_RAM", "LAPTOP_PREV_ISSUED") AS 
  Select
    a.empno,
    a.empno || ' - ' || name      emp_name,
    parent,
    assign,
    grade,
    b.sw_required,
    Case
        When b.empno Is Null Then
            'No'
        Else
            'Yes'
    End laptop_request,
    DIST_request.get_action_desc(b.it_action_code)  it_action_desc,
    b.it_action_code,
    b.laptop_ams_id               laptop_now_issued,
    c.deskid,
    c.compname,
    c.computer,
    c.pc_ram,
    d.laptop_ams_id               laptop_prev_issued
From
    stk_empmaster                 a,
    DIST_laptop_request         b,
    DIST_desmas_allocation      c,
    DIST_laptop_already_issued  d,
    DIST_req_status_mast        e
Where
        a.empno = b.empno (+)
    And a.empno             = c.empno (+)
    And a.empno             = d.empno (+)
    And b.it_action_code    = e.status_code(+)
    And a.grade Not In (
        'X1',
        'X2',
        'X3',
        'A1'
    )
    And a.status            = 1
    And emptype In (
        'R',
        'C',
        'S',
        'F'
    )
;
