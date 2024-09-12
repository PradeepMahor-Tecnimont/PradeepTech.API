Create Or Replace Package Body timecurr.pkg_ot_mast As

    Function fn_ot_mast_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_costcode       Varchar2,
        p_yymm           Varchar2,

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
                        yymm,
                        ot,
                        Row_Number() Over(Order By yymm Asc) As row_number,
                        Count(*) Over()                      As total_row
                    From
                        otmast
                    Where
                        costcode = p_costcode
                        And yymm > p_yymm
                        And yymm Like '%' || upper(Trim(p_generic_search)) || '%'

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_ot_mast_list;

    Procedure sp_ot_mast_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_costcode         Varchar2,

        p_ot           Out Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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
            otmast
        Where
            yymm = p_yymm
            And costcode = p_costcode;

        If v_exists = 1 Then
            Select
                ot
            Into
                p_ot
            From
                otmast
            Where
                yymm = p_yymm
                And costcode = p_costcode;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching data exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_ot_mast_details;

    Procedure sp_add_ot_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_costcode         Varchar2,
        p_ot               Number Default Null,

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
            otmast
        Where
            yymm = p_yymm
            And costcode = p_costcode;

        If v_exists = 0 Then
            Insert Into otmast (
                costcode,
                yymm,
                ot
            )
            Values(
                p_costcode,
                p_yymm,
                p_ot
            );
            p_message_type := ok;
            p_message_text := 'Overtime added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Overtime already exists';
        End If;
        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_ot_mast;

    Procedure sp_update_ot_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_costcode         Varchar2,
        p_ot               Number Default Null,

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
            otmast
        Set
            yymm = p_yymm,
            costcode = p_costcode,
            ot = p_ot
        Where
            yymm = p_yymm
            And costcode = p_costcode;

        p_message_type := ok;
        p_message_text := 'Overtime updated successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_ot_mast;

    Procedure sp_delete_ot_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_costcode         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
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

        Delete
            From otmast
        Where
            costcode = p_costcode
            And yymm = p_yymm;

        If (Sql%rowcount > 0) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_ot_mast;
End pkg_ot_mast;