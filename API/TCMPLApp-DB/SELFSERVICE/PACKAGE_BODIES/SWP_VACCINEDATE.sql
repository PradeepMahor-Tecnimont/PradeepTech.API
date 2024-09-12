Create Or Replace Package Body selfservice.swp_vaccinedate As

    Procedure sendmail(
        param_empno Varchar2
    ) As

        v_email         ss_emplmast.email%Type;
        v_name          ss_emplmast.name%Type;
        v_email_body    Varchar2(4000);
        v_email_subject Varchar2(200);
        v_success       Varchar2(10);
        v_message       Varchar2(1000);
    Begin
        Select
            name,
            email
        Into
            v_name,
            v_email
        From
            ss_emplmast
        Where
            empno = param_empno;

        v_email_subject := 'Vaccine Date deletion.';
        v_email_body    := 'Dear User,

Your input in Employee Vaccine Dates has been deleted as it was for a future date.

Please input your actual 1st vaccine date after taking the 1st jab and follow the same for the 2nd vaccine date.';
        v_email_body    := v_email_body || chr(13) || chr(10) || chr(13) || chr(10);

        v_email_body    := v_email_body || 'Thanks,' || chr(13) || chr(10);

        v_email_body    := v_email_body || 'This is an automated TCMPL Mail.';
        If v_email Is Not Null Then
            send_mail_from_api(
                p_mail_to      => v_email,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_email_subject,
                p_mail_body    => v_email_body,
                p_mail_profile => 'SELFSERVICE',
                p_mail_format  => 'Text',
                p_success      => v_success,
                p_message      => v_message
            );
        End If;

    End sendmail;

    Procedure add_new(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_first_jab    Date,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            modified_on,
            modified_by
        )
        Values (
            v_empno,
            param_vaccine_type,
            param_first_jab,
            'KO',
            param_second_jab,
            'KO',
            sysdate,
            v_empno
        );

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_new;

    Procedure add_emp_vaccine_dates(
        param_win_uid          Varchar2,
        param_vaccine_type     Varchar2,
        param_for_empno        Varchar2,
        param_first_jab_date   Date,
        param_second_jab_date  Date Default Null,
        param_booster_jab_date Date Default Null,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As
        v_empno                Char(5);
        v_second_jab_by_office Varchar2(2);
    Begin
        v_empno                := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;
        v_second_jab_by_office := Case
                                      When param_second_jab_date Is Null Then
                                          Null
                                      Else
                                          'KO'
                                  End;
        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            booster_jab_date,
            modified_on,
            modified_by
        )
        Values (
            param_for_empno,
            param_vaccine_type,
            param_first_jab_date,
            'KO',
            param_second_jab_date,
            'KO',
            param_booster_jab_date,
            sysdate,
            v_empno
        );

        Commit;
        param_success          := 'OK';
        param_message          := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_emp_vaccine_dates;

    Procedure update_emp_second_jab(
        param_win_uid         Varchar2,
        param_for_empno       Varchar2,
        param_second_jab_date Date,

        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        by_empno Char(5);
    Begin
        by_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            is_jab2_by_office = 'KO',

            modified_on = sysdate,
            modified_by = by_empno
        Where
            empno = param_for_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_emp_second_jab;

    Procedure update_emp_jab(
        param_win_uid          Varchar2,
        param_for_empno        Varchar2,
        param_second_jab_date  Date,
        param_booster_jab_date Date,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As
        by_empno Char(5);
    Begin
        by_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            booster_jab_date = param_booster_jab_date,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = by_empno
        Where
            empno = param_for_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_emp_jab;

    Procedure update_self_jab(
        param_win_uid          Varchar2,

        param_second_jab_date  Date,
        param_booster_jab_date Date,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            booster_jab_date = param_booster_jab_date,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = v_empno
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_self_jab;

    Procedure update_second_jab(
        param_win_uid     Varchar2,
        param_second_jab  Date,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = v_empno
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_second_jab;

    Procedure update_vaccine_type(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            vaccine_type = param_vaccine_type,
            jab2_date = param_second_jab,
            modified_on = sysdate
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_vaccine_type;

    Procedure delete_emp_vaccine_dates(
        param_empno       Varchar2,
        param_hr_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        --v_empno          Char(5);
        v_hr_empno Char(5);
        v_count    Number;
    Begin
        v_hr_empno    := swp_users.get_empno_from_win_uid(param_win_uid => param_hr_win_uid);
        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving HR EMP Detials';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno      = param_empno
            And status = 1;

        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Select Employee details not found.';
            Return;
        End If;

        Delete
            From swp_vaccine_dates
        Where
            empno = param_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Jab info could not be updated.';
            Return;
        End If;

        Commit;
        sendmail(param_empno);
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End delete_emp_vaccine_dates;

End swp_vaccinedate;