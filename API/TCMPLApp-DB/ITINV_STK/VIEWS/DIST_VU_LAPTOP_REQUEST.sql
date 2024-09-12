--------------------------------------------------------
--  DDL for View DIST_VU_LAPTOP_REQUEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_LAPTOP_REQUEST" ("EMPNO", "EMP_NAME", "PARENT", "ASSIGN", "GRADE", "SW_REQUIRED", "LAPTOP_REQUEST", "DESKID", "COMPNAME", "QR_CODE", "PC_RAM", "LAPTOP_PREV_ISSUED", "IT_ACTION_DESC", "IT_ACTION_CODE", "IT_REMARKS", "LAPTOP_NOW_ISSUED", "DOCKING_QRCODE", "HEADPHONE_QRCODE", "LAPTOP_ISSUE_DATE", "ISSUE_DATE", "REASON_4_NOPICKUP") AS 
  Select
    a.empno,
    a.empno || ' - ' || name                              emp_name,
    parent,
    assign,
    grade,
    b.sw_required,
    Case
        When b.empno Is Null Then
            'No'
        Else
            'Yes'
    End    laptop_request,
    c.deskid,
    c.compname,
    c.qr_code,
    c.pc_ram,
    d.laptop_ams_id laptop_prev_issued,
    e.status_desc it_action_desc,
    b.it_action_code,
    b.it_remarks,
    b.laptop_ams_id laptop_now_issued,
    b.docking_qrcode,
    b.headphone_qrcode,
    to_char(b.issue_date,'dd-Mon-yyyy') laptop_issue_date,
    b.issue_date,
    reason_4_nopickup
From
    stk_empmaster          a,
    DIST_laptop_request  b,
    DIST_desmas_allocation c,
    dist_vu_laptop_issued d,
    DIST_req_status_mast e
Where
    a.empno = b.empno(+)
    and a.empno = c.empno(+)
    and a.empno = d.empno(+)
    and a.grade not in ('X1','X2','X3','A1')
    and a.status = 1
    and emptype  In( 'R', 'C', 'S', 'F' )
    and b.it_action_code = e.status_code
;
