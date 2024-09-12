--------------------------------------------------------
--  DDL for Package Body IOT_DESK_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_DESK_DETAILS" As
    Procedure employee_desk_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_desk_id         Out Varchar2,
        p_comp_name       Out Varchar2,
        p_computer        Out Varchar2,
        p_pc_model        Out Varchar2,
        p_monitor1        Out Varchar2,
        p_monitor1_model  Out Varchar2,
        p_monitor2        Out Varchar2,
        p_monitor2_model  Out Varchar2,
        p_telephone       Out Varchar2,
        p_telephone_model Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Select
            a.deskid,
            a.compname,
            a.computer,
            a.pcmodel,
            a.monitor1,
            a.monmodel1,
            a.monitor2,
            a.monmodel2,
            a.telephone,
            a.telmodel
        Into
            p_desk_id,
            p_comp_name,
            p_computer,
            p_pc_model,
            p_monitor1,
            p_monitor1_model,
            p_monitor2,
            p_monitor2_model,
            p_telephone,
            p_telephone_model
        From
            dms.desmas_allocation_all a
        Where
            a.empno1 = v_empno;
        p_message_type := 'OK';
    Exception
        When no_data_found Then
            p_message_type := not_ok;

            p_message_text := 'Err - Data not found.';
        When Others Then

            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;
End;

/
