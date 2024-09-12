--------------------------------------------------------
--  DDL for Package Body IOT_GUEST_MEET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_GUEST_MEET" AS

    Procedure sp_add_meet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

		P_guest_name       Varchar2,
		P_guest_company    Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_date             Date,
        P_office           Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno         Varchar2(5);
        v_emp_name      Varchar2(60);
        v_count         Number;
        v_lead_approval Number := 0;
        v_hod_approval  Number := 0;
        v_desc          Varchar2(60);
        v_message_type  Number := 0;
    Begin
        v_empno    := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_emp_name := get_emp_name(v_empno);

        meet.add_meet(
            param_host_name		=> v_emp_name,
            param_guest_name	=> P_guest_name,
            param_guest_co		=> P_guest_company,
            param_meet_date		=> to_char(p_date, 'dd/mm/yyyy'),
            param_meet_hh		=> to_number(Trim(p_hh1)),
            param_meet_mn		=> to_number(Trim(p_mi1)),
            param_meet_off		=> Trim(P_office),
            param_remarks		=> p_reason,
            param_modified_by	=> v_empno,
            param_success		=> v_message_type,
            param_msg			=> p_message_text
        );

        If v_message_type = ss.failure Then
             p_message_type := 'KO';
         Else
             p_message_type := 'OK';
         End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_meet;

    Procedure sp_delete_meet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count        := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_guest_register
        Where
            Trim(app_no) = Trim(p_application_id)
            And modified_by    = v_empno;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;

        meet.del_meet(paramappno   => p_application_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_meet;

END iot_guest_meet;

/

  GRANT EXECUTE ON "SELFSERVICE"."IOT_GUEST_MEET" TO "TCMPL_APP_CONFIG";
