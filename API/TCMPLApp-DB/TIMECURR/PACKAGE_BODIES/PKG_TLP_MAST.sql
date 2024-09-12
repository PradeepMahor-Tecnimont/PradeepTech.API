Create Or Replace Package Body timecurr.pkg_tlp_mast As

    Function fn_tlp_list(
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
                        tlpcode,
                        name,
                        Row_Number() Over(Order By costcode Asc) As row_number,
                        Count(*) Over()                          As total_row
                    From
                        tlp_mast
                    Where
                        costcode Like '%' || upper(Trim(p_generic_search)) || '%'

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_tlp_list;

    Procedure sp_tlp_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_tlpcode          Varchar2,

        p_name         Out Varchar2,

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
            tlp_mast
        Where
            costcode = p_costcode
            And tlpcode = p_tlpcode;

        If v_exists = 1 Then
            Select
                name
            Into
                p_name
            From
                tlp_mast
            Where
                costcode = p_costcode
                And tlpcode = p_tlpcode;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching costcode or tlp code exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_tlp_details;

    Procedure sp_add_tlp(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_tlpcode          Varchar2,
        p_name             Varchar2,

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
            tlp_mast
        Where
            costcode = p_costcode
            And tlpcode = p_tlpcode;

        If v_exists = 0 Then
            Insert Into tlp_mast (
                costcode,
                tlpcode,
                name
            )
            Values(
                p_costcode,
                p_tlpcode,
                p_name
            );
            p_message_type := ok;
            p_message_text := 'Tlpcode added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Tlpcode already exists';
        End If;
        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_tlp;

    Procedure sp_update_tlp(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_tlpcode          Varchar2,
        p_name             Varchar2,

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
            tlp_mast
        Set
            costcode = p_costcode,
            tlpcode = p_tlpcode,
            name = p_name
        Where
            costcode = p_costcode
            And tlpcode = p_tlpcode;

        p_message_type := ok;
        p_message_text := 'Tlpcode updated successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_tlp;

End pkg_tlp_mast;