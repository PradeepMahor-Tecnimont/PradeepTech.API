--------------------------------------------------------
--  DDL for Package Body SWP_OFFICE_VACCINE_BATCH_2
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_OFFICE_VACCINE_BATCH_2" As

    Procedure add_registration (
        param_win_uid          Varchar2,
        param_vaccine_for      Varchar2,
        param_preferred_date   Date,
        jab_number             Varchar2,
        param_success          Out                    Varchar2,
        param_message          Out                    Varchar2
    ) As
        v_empno   Varchar2(5);
        v_name    Varchar2(100);
        v_yob     Varchar2(4);
    Begin
        v_empno         := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        Insert Into swp_vaccination_office_batch_2 (
            empno,
            vaccination_for,
            preferred_date,
            jab_number,
            modified_on
        ) Values (
            v_empno,
            param_vaccine_for,
            param_preferred_date,
            jab_number,
            Sysdate
        );

        If Upper(param_vaccine_for) Like '%SELF%' Then
            Select
                name,
                To_Char(dob, 'yyyy')
            Into
                v_name,
                v_yob
            From
                ss_emplmast
            Where
                empno = v_empno;

            add_family_member(
                param_win_uid              => param_win_uid,
                param_family_member_name   => v_name,
                param_relation             => 'SELF',
                param_year_of_birth        => v_yob,
                param_success              => param_success,
                param_message              => param_message
            );

        End If;

        Commit;
        param_success   := 'OK';
        param_message   := 'Procedure executed';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End add_registration;

    Procedure add_family_member (
        param_win_uid              Varchar2,
        param_family_member_name   Varchar2,
        param_relation             Varchar2,
        param_year_of_birth        Number,
        param_success              Out                        Varchar2,
        param_message              Out                        Varchar2
    ) As
        v_empno    Varchar2(5);
        v_key_id   Varchar2(8);
    Begin
        v_empno         := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        v_key_id        := dbms_random.string('X', 8);
        Insert Into swp_vaccination_office_family (
            empno,
            family_member_name,
            relation,
            year_of_birth,
            modified_on,
            key_id
        ) Values (
            v_empno,
            Upper(param_family_member_name),
            Upper(param_relation),
            param_year_of_birth,
            Sysdate,
            v_key_id
        );

        Commit;
        param_success   := 'OK';
        param_message   := 'Procedure executed';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End add_family_member;

    Procedure remove_family_member (
        param_win_uid   Varchar2,
        param_keyid     Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        Delete From swp_vaccination_office_family
        Where
            key_id = param_keyid
            And empno = v_empno;

        If Sql%rowcount <> 0 Then
            param_success   := 'OK';
            param_message   := 'Procedure executed successfully';
            Commit;
        Else
            param_success   := 'KO';
            param_message   := 'Family member not found.';
        End If;

    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End remove_family_member;

    Procedure reset_registration (
        param_win_uid   Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        Delete From swp_vaccination_office_family
        Where
            empno = v_empno;

        Delete From swp_vaccination_office_batch_2
        Where
            empno = v_empno;

        If Sql%rowcount <> 0 Then
            param_success   := 'OK';
            param_message   := 'Procedure executed successfully';
            Commit;
        Else
            param_success   := 'KO';
            param_message   := 'Employee data not found.';
        End If;

    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End reset_registration;

End swp_office_vaccine_batch_2;


/

  GRANT EXECUTE ON "SELFSERVICE"."SWP_OFFICE_VACCINE_BATCH_2" TO "TCMPL_APP_CONFIG";
