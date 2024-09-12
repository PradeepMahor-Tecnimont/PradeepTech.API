--------------------------------------------------------
--  DDL for View OFB_VU_EMP_EXIT_APPROVALS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_HR"."OFB_VU_EMP_EXIT_APPROVALS" ("EMPNO", "EMP_NAME", "ACTION_ID", "ACTION_DESC", "ROLE_ID", "REMARKS", "IS_APPROVED", "IS_APPROVED_DESC", "APPROVAL_DATE", "APPROVED_BY", "APPROVER_NAME", "GROUP_NAME", "GROUP_DESC", "CHECKER_ACTION_ID", "SORT_ORDER") AS 
  Select
    a.empno,
    ofb_user.get_name_from_empno(p_empno => empno) emp_name,
    a.action_id,
    ra.action_desc,
    a.role_id,
    a.remarks,
    is_approved,
    Case is_approved
        When 'OK' Then
            'Approved'
        When 'OO' Then
            'On Hold'
        Else
            'Pending'
    End is_approved_desc,
    approval_date,
    approved_by,
    ofb_user.get_name_from_empno(p_empno => approved_by) approver_name,
    group_name,
    group_desc,
    ra.checker_action_id,
    ra.sort_order
From
    ofb_emp_exit_approvals   a,
    ofb_role_actions         ra
Where
    a.action_id = ra.action_id
    order by a.empno, ra.sort_order
;
  GRANT SELECT ON "TCMPL_HR"."OFB_VU_EMP_EXIT_APPROVALS" TO "TCMPL_APP_CONFIG";
