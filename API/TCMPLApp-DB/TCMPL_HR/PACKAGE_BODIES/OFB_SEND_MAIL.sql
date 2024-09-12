--------------------------------------------------------
--  DDL for Package Body OFB_SEND_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_HR"."OFB_SEND_MAIL" As
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

    Procedure send_mail_nu_ofb(
        p_empno Varchar2
    ) As

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
                        And empno In (
                            Select
                                empno
                            From
                                ofb_vu_user_roles_actions
                            Where
                                action_id In (
                                    Select
                                        action_id
                                    From
                                        ofb_emp_exit_approvals
                                    Where
                                        empno = p_empno
                                )
                                And action_id Not In (
                                    ofb.actionid_hod_of_emp
                                )
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

        v_mail_csv       Varchar2(2000);
        v_msg_body       Varchar2(2000);
        v_success        Varchar2(20);
        v_message        Varchar2(2000);
        v_emp_name       Varchar2(100);
        v_end_by_date    Date;
        v_relieving_date Date;
        v_parent         Char(4);
        v_parent_name    Varchar2(100);
        v_hod_email      Varchar2(100);
    Begin
        Select
            parent,
            ofb.get_costcode_name(parent)       parent_name,
            ofb_user.get_name_from_empno(empno) emp_name,
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

            v_mail_csv  := email_csv_row.email_csv_list ;

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

    End send_mail_nu_ofb;

    Procedure send_mail_reminder As
        v_mail_csv Varchar2(3000);
        v_msg_body Varchar2(1000);
        v_success  Varchar2(100);
        v_message  Varchar2(2000);
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
                    ra.empno, ra.action_id, e.name, e.email
                From
                    ofb_vu_user_roles_actions                     ra, ofb_vu_emplmast e
                Where
                    ra.empno = e.empno
                    And ra.action_id In (

                        Select
                        Distinct action_id
                        From
                            ofb_vu_emp_exit_approvals
                        Where
                            nvl(is_approved, '--') <> 'OK'
                            And action_id Not In (ofb.actionid_hr_mngr, ofb.actionid_hod_of_emp)
                    )
                Order By ra.action_id
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

End ofb_send_mail;

/

  GRANT EXECUTE ON "TCMPL_HR"."OFB_SEND_MAIL" TO "TCMPL_APP_CONFIG";
