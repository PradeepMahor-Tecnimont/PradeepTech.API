Create Or Replace Package Body tcmpl_hr.pkg_ofb_mail As
    c_module_id Constant Char(3) := 'M02';
    Procedure send_mail_to_ofb_user(p_empno Varchar2) As
        v_email    Varchar2(100);
        v_msg_body Varchar2(1000);
        v_emp_name Varchar2(100);
        v_success  Varchar2(100);
        v_message  Varchar2(2000);
    Begin

        Select
            name,
            email
        Into
            v_emp_name,
            v_email
        From
            ofb_vu_emplmast
        Where
            empno = p_empno;

        v_msg_body := c_mail_body_to_emp;
        v_msg_body := replace(v_msg_body, '[EMPNAME]', v_emp_name);

        send_mail_from_api(
            p_mail_to      => Null,
            p_mail_cc      => Null,
            p_mail_bcc     => v_email,
            p_mail_subject => 'OFF-Boarding : Employee Off-Boarding (Exit) process initiated ',
            p_mail_body    => v_msg_body,
            p_mail_profile => 'SELFSERVICE',
            p_mail_format  => 'HTML',
            p_success      => v_success,
            p_message      => v_message
        );

        Insert Into ofb_mail_log (
            mail_to,
            mail_from,
            mail_bcc,
            mail_success,
            mail_success_message,
            mail_date
        )
        Values (
            Null,
            Null,
            v_email,
            v_success,
            v_message,
            sysdate
        );

        Commit;

    End;

    Procedure send_mail_new_ofb(
        p_empno Varchar2
    ) As
        c_hod_apprl_action Constant Varchar2(4) := 'A174';
        Cursor cur_email_csv Is
            Select
                group_id,
                Listagg(email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        empno,
                        name,
                        assign,
                        email,
                        ceil((Row_Number() Over(Order By empno)) / 100) group_id
                    From
                        ofb_vu_emplmast
                    Where
                        status = 1
                        And email Is Not Null
                        And empno Not In ('04132', '04600')
                        And empno In (
                            Select
                                empno
                            From
                                ofb_vu_module_user_role_actions
                            Where
                                action_id In (
                                    Select
                                        apprl_action_id
                                    From
                                        ofb_emp_exit_approvals
                                    Where
                                        empno = p_empno
                                )
                                And action_id <> c_hod_apprl_action
                                And module_id = c_module_id
                            Union
                            Select
                                hod
                            From
                                ofb_vu_costmast
                            Where
                                costcode = (
                                    Select
                                        parent
                                    From
                                        ofb_vu_emplmast
                                    Where
                                        empno = p_empno
                                )
                        )
                )
            Group By
                group_id;

        v_mail_csv         Varchar2(2000);
        v_msg_body         Varchar2(2000);
        v_success          Varchar2(20);
        v_message          Varchar2(2000);
        v_emp_name         Varchar2(100);
        v_end_by_date      Date;
        v_relieving_date   Date;
        v_parent           Char(4);
        v_parent_name      Varchar2(100);
        v_hod_email        Varchar2(100);
    Begin
        Select
            parent,
            pkg_common.fn_get_dept_name(parent)    parent_name,
            pkg_common.fn_get_employee_name(empno) emp_name,
            end_by_date,
            relieving_date
        Into
            v_parent,
            v_parent_name,
            v_emp_name,
            v_end_by_date,
            v_relieving_date

        From
            ofb_emp_exits
        Where
            empno = p_empno;

        v_msg_body := replace(
                          c_mail_body_nu_exit,
                          '[NAME]',
                          p_empno || '-' || v_emp_name
                      );
        v_msg_body := replace(
                          v_msg_body,
                          '[DEPARTMENT]',
                          v_parent || '-' || v_parent_name
                      );
        v_msg_body := replace(
                          v_msg_body,
                          '[RELIEVING_DATE]',
                          to_char(v_relieving_date, 'dd-Mon-yyyy')
                      );
        v_msg_body := replace(
                          v_msg_body,
                          '[LASTDATE]',
                          to_char(v_end_by_date, 'dd-Mon-yyyy')
                      );
        v_msg_body := replace(
                          v_msg_body,
                          '[PRIORDATE]',
                          to_char(v_end_by_date - 1, 'dd-Mon-yyyy')
                      );

        For email_csv_row In cur_email_csv
        Loop

            v_mail_csv := email_csv_row.email_csv_list;

            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => 'OFF-Boarding : Employee Off-Boarding (Exit) process initiated ',
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

            Insert Into ofb_mail_log (
                mail_to,
                mail_from,
                mail_bcc,
                mail_success,
                mail_success_message,
                mail_date
            )
            Values (
                Null,
                Null,
                v_mail_csv,
                v_success,
                v_message,
                sysdate
            );

            Commit;
        End Loop;
        send_mail_to_ofb_user(p_empno);

    End send_mail_new_ofb;

    Procedure send_mail_reminder As
        v_mail_csv            Varchar2(3000);
        v_msg_body            Varchar2(1000);
        v_success             Varchar2(100);
        v_message             Varchar2(2000);
        v_hod_apprl_action_id Varchar2(4) := 'A174';

    Begin
        Select
            Listagg(email, ';') Within
                Group (Order By
                    empno)
        Into
            v_mail_csv
        From
            (

                Select
                    empno, name, email
                From
                    vu_emplmast
                Where
                    empno Not In ('04132', '04600')
                    And empno In (
                        Select
                            empno
                        From
                            ofb_vu_module_user_role_actions
                        Where
                            action_id In (
                                Select
                                    --empno,
                                    apprl_action_id
                                From
                                    (
                                        Select
                                            a.empno,
                                            apprl_action_id,
                                            pkg_ofb_approval.fn_is_approval_due(a.empno, a.apprl_action_id) approval_due
                                        From
                                            ofb_emp_exit_approvals a

                                        Where
                                            apprl_action_id <> v_hod_apprl_action_id
                                            And nvl(is_approved, not_ok) = not_ok

                                    )
                                Where
                                    approval_due = ok
                            )
                    )
                Union
                Select
                    empno, name, email
                From
                    vu_emplmast e
                Where
                    empno Not In ('04132', '04600')
                    And empno In
                    (

                        Select
                            hod
                        From
                            vu_emplmast                e, vu_costmast c
                        Where
                            e.parent = c.costcode
                            And e.empno In
                            (
                                Select
                                    empno
                                From
                                    (
                                        Select
                                            a.empno,
                                            apprl_action_id,
                                            pkg_ofb_approval.fn_is_approval_due(a.empno, a.apprl_action_id) approval_due
                                        From
                                            ofb_emp_exit_approvals a

                                        Where
                                            apprl_action_id              = v_hod_apprl_action_id
                                            And nvl(is_approved, not_ok) = not_ok
                                    )
                                Where
                                    approval_due = ok
                            )
                    )

            );

        v_msg_body := c_mail_body_reminder;
                send_mail_from_api(
                    p_mail_to      => Null,
                    p_mail_cc      => Null,
                    p_mail_bcc     => v_mail_csv,
                    p_mail_subject => 'OFF-Boarding : Employee Off-Boarding (Exit) reminder',
                    p_mail_body    => v_msg_body,
                    p_mail_profile => 'SELFSERVICE',
                    p_mail_format  => 'HTML',
                    p_success      => v_success,
                    p_message      => v_message
                );
        Insert Into ofb_mail_log (
            mail_to,
            mail_from,
            mail_bcc,
            mail_success,
            mail_success_message,
            mail_date
        )
        Values (
            Null,
            Null,
            v_mail_csv,
            v_success,
            v_message,
            sysdate
        );

        Commit;

    End send_mail_reminder;

End pkg_ofb_mail;
/