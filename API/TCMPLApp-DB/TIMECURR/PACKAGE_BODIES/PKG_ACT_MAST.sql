Create Or Replace Package Body timecurr.pkg_act_mast As

    Function fn_activity_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        costcode,
                        activity,
                        name                                 As name,
                        tlpcode,
                        activity_type,
                        Case active
                            When 1 Then
                                'OK'
                            When 0 Then
                                'KO'
                        End                                  As active,
                        Row_Number() Over(Order By costcode) As row_number,
                        Count(*) Over()                      As total_row
                    From
                        act_mast
                    Where
                        costcode Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order By costcode Asc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_activity_list;

    Procedure sp_activity_details(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_costcode          Varchar2,
        p_activity          Varchar2,
        
        p_name          Out Varchar2,
        p_tlpcode       Out Varchar2,
        p_activity_type Out Varchar2,
        p_is_active     Out Number,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            act_mast
        Where
            costcode = p_costcode
            And activity = p_activity;

        If v_exists = 1 Then
            Select
                name,
                tlpcode,
                activity_type,
                active
            Into
                p_name,
                p_tlpcode,
                p_activity_type,
                p_is_active
            From
                act_mast
            Where
                costcode = p_costcode
                And activity = p_activity;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Activity exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_activity_details;
    
    Procedure sp_add_activity(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode        Varchar2,
        p_activity         Varchar2,
        p_name             Varchar2 Default Null,
        p_tlpcode          Varchar2 Default Null,
        p_activity_type    Varchar2 Default Null,
        p_is_active        Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number := 0;
        v_empno  Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            act_mast
        Where
            costcode = p_costcode
            And activity = p_activity;

        If v_exists = 0 Then
            Insert Into act_mast (
                costcode, activity, name, tlpcode, activity_type, active
            )
            Values(
                p_costcode, p_activity, p_name, p_tlpcode, p_activity_type, p_is_active
            );
            p_message_type := ok;
            p_message_text := 'Activity added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Activity already exists';
        End If;
        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_activity;

    Procedure sp_update_activity(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode        Varchar2,
        p_activity         Varchar2,
        p_name             Varchar2 Default Null,
        p_tlpcode          Varchar2 Default Null,
        p_activity_type    Varchar2 Default Null,
        p_is_active        Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            act_mast
        Set
            costcode = p_costcode,
            activity = p_activity,
            name = p_name,
            tlpcode = p_tlpcode,
            activity_type = p_activity_type,
            active = p_is_active
        Where
            costcode = p_costcode
            And activity = p_activity;

        p_message_type := ok;
        p_message_text := 'Activity updated successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_activity;

End pkg_act_mast;
