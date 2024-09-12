--------------------------------------------------------
--  DDL for View SWP_VU_EMP_RESPONSE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SWP_VU_EMP_RESPONSE" ("EMPNO", "NAME", "PARENT", "ABBR", "PARENT_NAME", "GRADE", "EMPTYPE", "IS_POLICY_ACCEPTED", "IS_HOD_APPROVED", "IS_HR_APPROVED", "HOD_APPROVE_VISIBLE", "HR_APPROVE_VISIBLE", "HOD_REJECT_VISIBLE", "HR_REJECT_VISIBLE", "IS_ACCEPTED", "HOD_APPRL", "HR_APPRL") AS 
  Select
    r.empno,
    e.name,
    e.parent,
    c.abbr,
    c.name parent_name,
    e.grade,
    e.emptype,
    Case is_accepted
        When 'OK'  Then
            'Yes'
        When 'KO'  Then
            'No'
        Else
            Null
    End As is_policy_accepted,
    Case
        When is_accepted = 'KO' Then
            'N.A.'
        Else
            Case hod_apprl
                When 'OK'  Then
                    'Approved'
                When 'KO'  Then
                    'Rejected'
                Else
                    'Pending'
            End
    End As is_hod_approved,
    Case
        When is_accepted = 'KO'
             Or hod_apprl = 'KO' Then
            'N.A.'
        Else
            Case hr_apprl
                When 'OK'  Then
                    'Approved'
                When 'KO'  Then
                    'Rejected'
                Else
                    'Pending'
            End
    End As is_hr_approved,
    Case is_accepted
        When 'OK' Then
            Case hod_apprl
                When 'OK' Then
                    'No'
                Else
                    'Yes'
            End
        Else
            'No'
    End hod_approve_visible,
    Case hod_apprl
        When 'OK' Then
            Case hr_apprl
                When 'OK' Then
                    'No'
                Else
                    'Yes'
            End
        Else
            'No'
    End hr_approve_visible,
    Case hod_apprl
        When 'OK' Then
            Case hr_apprl
                When 'OK' Then
                    'No'
                Else
                    'Yes'
            End
        Else
            'No'
    End hod_reject_visible,
    Case hr_apprl
        When 'OK' Then
            'Yes'
        Else
            'No'
    End hr_reject_visible,
    is_accepted,
    hod_apprl,
    hr_apprl
From
    swp_emp_response  r,
    ss_emplmast       e,
    ss_costmast       c
Where
        r.empno = e.empno
    And e.parent = c.costcode
    And e.status = 1
;
  GRANT SELECT ON "SELFSERVICE"."SWP_VU_EMP_RESPONSE" TO "TCMPL_APP_CONFIG";
