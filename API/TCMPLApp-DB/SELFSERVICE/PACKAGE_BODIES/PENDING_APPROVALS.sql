--------------------------------------------------------
--  DDL for Package Body PENDING_APPROVALS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PENDING_APPROVALS" As

    Function list_of_leads_not_approving Return typ_tab_emp_email
        Pipelined
    As

        Cursor cur_lead Is
        Select
            substr(empno, 1, 5) emp_no,
            substr(name, 1, 100) emp_name,
            substr(email, 1,100) emp_email
          From
            ss_emplmast
         Where
            empno In (
                Select
                    a.lead_apprl_empno
                  From
                    ss_ondutyapp a
                 Where
                    nvl(lead_apprl, ss.ot_pending) = ss.ot_pending And to_number(To_Char(a.app_date, 'yyyymm')) >= to_number(To_Char
                    (add_months(Sysdate, - 3), 'YYYYMM'))
                Union
                Select
                    a.lead_apprl_empno
                  From
                    ss_leaveapp a
                 Where
                    nvl(lead_apprl, ss.ot_pending) = ss.ot_pending And to_number(To_Char(a.app_date, 'yyyymm')) >= to_number(To_Char
                    (add_months(Sysdate, - 3), 'YYYYMM'))
                Union
                Select
                    a.lead_apprl_empno
                  From
                    ss_otmaster a
                 Where
                    nvl(lead_apprl, ss.ot_pending) = ss.ot_pending And to_number(a.yyyy || a.mon) >= to_number(To_Char(add_months
                    (Sysdate, - 24), 'YYYYMM'))
            ) And status = 1 and empno not in ('04600', '04132') and email is not null;

        tab_lead typ_tab_emp_email;
    Begin
        Open cur_lead;
        Fetch cur_lead Bulk Collect Into tab_lead Limit 50;
        Loop
            For i In 1..tab_lead.count Loop Pipe Row ( tab_lead(i) );
            End Loop;

            Exit When cur_lead%notfound;
            tab_lead := Null;
            Fetch cur_lead Bulk Collect Into tab_lead Limit 50;
        End Loop;
        --Return Null;

    End list_of_leads_not_approving;

    Function list_of_hod_not_approving Return typ_tab_emp_email
        Pipelined
    As

        Cursor cur_hod Is
        Select
            substr(empno, 1, 5) emp_no,
            substr(name, 1, 100) emp_name,
            substr(email, 1, 100) emp_email
          From
            ss_emplmast
         Where
            empno In (
                Select
                    mngr As approver
                  From
                    ss_emplmast
                 Where
                    empno In (
                        Select
                            empno
                          From
                            ss_otmaster a
                         Where
                            nvl(lead_apprl, ss.ot_pending) <> ss.ot_pending And nvl(hod_apprl, ss.ot_pending) = ss.ot_pending
                             And to_number(a.yyyy || a.mon) >= to_number(To_Char(add_months (Sysdate, - 24), 'YYYYMM'))
                        Union
                        Select
                            empno
                          From
                            ss_ondutyapp a
                         Where
                            nvl(lead_apprl, ss.ot_pending) <> ss.ot_pending And nvl(hod_apprl, ss.ot_pending) = ss.ot_pending
                            And to_number(To_Char(a.app_date, 'yyyymm')) >= to_number(To_Char (add_months(Sysdate, - 3), 'YYYYMM'))
                        Union
                        Select
                            empno
                          From
                            ss_leaveapp a
                         Where
                            nvl(lead_apprl, ss.ot_pending) <> ss.ot_pending And nvl(hod_apprl, ss.ot_pending) = ss.ot_pending
                            And to_number(To_Char(a.app_date, 'yyyymm')) >= to_number(To_Char (add_months(Sysdate, - 3), 'YYYYMM'))
                    ) and empno not in ('04600', '04132') and status=1
            ) and empno not in ('04600', '04132') and email is not null;

        tab_hod typ_tab_emp_email;
    Begin
        Open cur_hod;
        Fetch cur_hod Bulk Collect Into tab_hod Limit 50;
        Loop
            For i In 1..tab_hod.count Loop Pipe Row ( tab_hod(i) );
            End Loop;

            Exit When cur_hod%notfound;
            tab_hod := Null;
            Fetch cur_hod Bulk Collect Into tab_hod Limit 50;
        End Loop;
        --Return Null;

    End list_of_hod_not_approving;

End pending_approvals;


/
