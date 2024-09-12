Create Or Replace Package Body "SELFSERVICE"."SWP_VACCINE_REMINDER" As

    Procedure remind_booster_jab(p_sysdate Date)
    As
        Cursor cur_booster_pending Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (

                    Select
                        d.*,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        (
                            Select
                                empno, jab1_date, jab2_date, add_months(jab2_date, 9) booster_due_date, vaccine_type
                            From
                                swp_vaccine_dates
                            Where
                                jab2_date Is Not Null
                                And booster_jab_date Is Null
                                And vaccine_type In ('COVISHIELD', 'COVAXIN')

                        )           d,
                        ss_emplmast e
                    Where
                        d.empno      = e.empno
                        And e.empno Not In ('04132', '04600')
                        And e.parent <> '0187'
                        And e.status = 1
                        And e.email Is Not Null
                        And booster_due_date <= p_sysdate
                )
            Group By
                group_id;

        v_subject  Varchar2(1000);
        v_msg_body Varchar2(2000);
        v_mail_csv Varchar2(2000);
        v_success  Varchar2(100);
        v_message  Varchar2(500);
    Begin
        If to_char(p_sysdate, 'DY') <> 'MON' Then
            Return;
        End If;
        v_msg_body := v_mail_body_pend_booster;
        v_subject  := 'SELFSERVICE : Vaccine booster jab due';

        For email_csv_row In cur_booster_pending
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_vaccine_type_not_update As

        Cursor cur_vaccine_type_null Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast       e,
                        swp_vaccine_dates v
                    Where
                        e.empno      = v.empno
                        And e.status = 1
                        And e.parent <> '0187'
                        And v.vaccine_type Is Null
                        And e.email Is Not Null
                        And e.empno Not In ('04132', '04600')
                    Order By e.empno
                )
            Group By
                group_id;

        Type typ_tab_vaccine_type_null Is
            Table Of cur_vaccine_type_null%rowtype;
        tab_vaccine_type_null typ_tab_vaccine_type_null;
        v_count               Number;
        v_mail_csv            Varchar2(2000);
        v_subject             Varchar2(1000);
        v_msg_body            Varchar2(2000);
        v_success             Varchar2(100);
        v_message             Varchar2(500);
    Begin
        v_msg_body := v_mail_body_vaccine_type;
        v_subject  := 'SELFSERVICE : Vaccine type not updated';
        For email_csv_row In cur_vaccine_type_null
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_vaccine_not_done As

        Cursor cur_vaccine_not_done(
            p_date_for_calc Date
        ) Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast e
                    Where
                        e.status = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And e.empno Not In ('04132', '04600')
                        And e.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_dates
                        )
                        And e.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_covid_emp
                            Group By empno
                            Having
                                ceil(trunc(p_date_for_calc) - trunc(Max(covid_start_date))) < 90
                            Union
                            Select
                                empno
                            From
                                swp_vaccine_pregnent_emp
                        -- Exclude Covid Infected  & Pergnent Employees
                        )
                        And emptype In (
                            'R', 'S', 'C', 'F'
                        )
                    Order By e.empno
                )
            Group By
                group_id;

        v_count         Number;
        v_mail_csv      Varchar2(2000);
        v_subject       Varchar2(500);
        v_msg_body      Varchar2(2000);
        v_success       Varchar2(100);
        v_message       Varchar2(1000);
        v_date_for_calc Date := to_date('5-Sep-2021');
    Begin
        v_msg_body := v_mail_body_no_vaccine_regn;
        v_subject  := 'Vaccine second jab due';
        If trunc(sysdate) > v_date_for_calc Then
            v_msg_body      := v_mail_body_without_vaccine;
            v_date_for_calc := sysdate;
        End If;

        v_subject  := 'SELFSERVICE : Get yourself vaccinated';
        For email_csv_row In cur_vaccine_not_done(v_date_for_calc)
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_covishield_second_jab As

        Cursor cur_vaccine2_pending(
            p_date_for_calc Date
        ) Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast       e,
                        swp_vaccine_dates v
                    Where
                        e.empno            = v.empno
                        And e.empno Not In ('04132', '04600')
                        And e.status       = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And v.vaccine_type = 'COVISHIELD'
                        And (trunc((p_date_for_calc)) - trunc(v.jab1_date)) >= 84
                        And v.jab2_date Is Null
                        And v.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_covid_emp
                            Group By empno
                            Having
                                (trunc((p_date_for_calc)) - trunc(Max(covid_start_date))) < 90
                            Union
                            Select
                                empno
                            From
                                swp_vaccine_pregnent_emp

                        -- Exclude Covid Infected  & Pergnent Employees
                        )
                        And v.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccination_office
                            Where
                                trunc((p_date_for_calc)) != trunc(sysdate)
                        -- Exclude registered
                        )
                    Order By e.empno
                )
            Group By
                group_id;

        v_count         Number;
        v_mail_csv      Varchar2(2000);
        v_subject       Varchar2(1000);
        v_msg_body      Varchar2(2000);
        v_success       Varchar2(100);
        v_message       Varchar2(500);
        v_date_for_calc Date := to_date('5-Sep-2021');
    Begin
        v_msg_body := v_mail_body_second_jab_regn;
        v_subject  := 'SELFSERVICE : Vaccine second jab due';
        If trunc(sysdate) > v_date_for_calc Then
            v_date_for_calc := sysdate;
            v_msg_body      := v_mail_body_second_jab;
        End If;

        For email_csv_row In cur_vaccine2_pending(v_date_for_calc)
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_covaxin_second_jab As

        Cursor cur_vaccine_type_null Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast       e,
                        swp_vaccine_dates v
                    Where
                        e.empno            = v.empno
                        And e.empno Not In ('04132', '04600')
                        And e.status       = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And v.vaccine_type = 'COVAXIN'
                        And (trunc(sysdate) - trunc(v.jab1_date)) >= 28
                        And v.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_covid_emp
                            Group By empno
                            Having
                                ceil(trunc(sysdate) - trunc(Max(covid_start_date))) < 90
                            Union
                            Select
                                empno
                            From
                                swp_vaccine_pregnent_emp

                        -- Exclude Covid Infected  & Pergnent Employees
                        )
                        And v.jab2_date Is Null
                    Order By e.empno
                )
            Group By
                group_id;

        Type typ_tab_vaccine_type_null Is
            Table Of cur_vaccine_type_null%rowtype;
        tab_vaccine_type_null typ_tab_vaccine_type_null;
        v_count               Number;
        v_mail_csv            Varchar2(2000);
        v_subject             Varchar2(500);
        v_msg_body            Varchar2(2000);
        v_success             Varchar2(100);
        v_message             Varchar2(1000);
    Begin
        v_msg_body := v_mail_body_second_jab;
        v_subject  := 'SELFSERVICE : Vaccine second jab due';
        For email_csv_row In cur_vaccine_type_null
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_training_pending As

        Cursor cur_pending_trainings Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast      e,
                        swp_emp_training t
                    Where
                        e.empno      = t.empno(+)
                        And e.empno Not In ('04132', '04600')
                        And e.status = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And 0 In (nvl(t.security,0), nvl(t.sharepoint16,0), nvl(t.onedrive365,0), nvl(t.teams,0), nvl(t.planner,0))
                        And emptype in ('R','S','C','F')
                )
            Group By
                group_id;

        v_count    Number;
        v_mail_csv Varchar2(2000);
        v_subject  Varchar2(500);
        v_msg_body Varchar2(2000);
        v_success  Varchar2(100);
        v_message  Varchar2(1000);
    Begin
        v_msg_body := v_mail_body_pend_train;
        v_subject  := 'SELFSERVICE : Smart Working Policy - Mandatory Courses Pending';
        For email_csv_row In cur_pending_trainings
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );
        End Loop;

    End;

    Procedure send_mail As
        v_sysdate Date;
    Begin
        v_sysdate := trunc(sysdate);

        remind_vaccine_type_not_update;
        remind_vaccine_not_done;
        remind_covishield_second_jab;
        remind_covaxin_second_jab;

        --remind_training_pending;

        If to_char(v_sysdate, 'DY') = 'MON' Then
            remind_booster_jab(v_sysdate);
        End If;

    End send_mail;

End swp_vaccine_reminder;
/