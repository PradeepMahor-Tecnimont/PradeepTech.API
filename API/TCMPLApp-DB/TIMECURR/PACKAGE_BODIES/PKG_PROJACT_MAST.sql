Create Or Replace Package Body timecurr.pkg_projact_mast As

    Function fn_projact_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_projno         Varchar2,
        p_costcode       Varchar2,

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
                        projno,
                        costcode,
                        activity,
                        budghrs                              As budghrs,
                        noofdocs                             As noofdocs,
                        Row_Number() Over(Order By costcode) As row_number,
                        Count(*) Over()                      As total_row
                    From
                        projact_mast
                    Where
                        projno = p_projno
                        And costcode = p_costcode
                        And activity Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_projact_list;

    Procedure sp_projact_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_costcode         Varchar2,
        p_activity         Varchar2,

        p_budghrs      Out Number,
        p_no_of_docs   Out Number,

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
            projact_mast
        Where
        projno=p_projno And
            costcode = p_costcode
            And activity = p_activity;

        If v_exists = 1 Then
            Select
                budghrs,
                noofdocs
            Into
                p_budghrs,
                p_no_of_docs
            From
                projact_mast
            Where
                projno = p_projno
                And costcode = p_costcode
                And activity = p_activity;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching projact exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_projact_details;

    Procedure sp_add_projact(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_costcode         Varchar2,
        p_activity         Varchar2 Default Null,
        p_budghrs          Number   Default Null,
        p_no_of_docs       Number   Default Null,

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
            projact_mast
        Where
            projno = p_projno
            And costcode = p_costcode
            And activity = p_activity;

        If v_exists = 0 Then
            Insert Into projact_mast (
                projno, costcode, activity, budghrs, noofdocs
            )
            Values(
                p_projno, p_costcode, p_activity, p_budghrs, p_no_of_docs
            );
            p_message_type := ok;
            p_message_text := 'Projact added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Projact already exists';
        End If;
        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_projact;

    Procedure sp_update_projact(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_costcode         Varchar2,
        p_activity         Varchar2 Default Null,
        p_budghrs          Number   Default Null,
        p_no_of_docs       Number   Default Null,

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
            projact_mast
        Set
            projno = p_projno,
            costcode = p_costcode,
            activity = p_activity,
            budghrs = p_budghrs,
            noofdocs = p_no_of_docs
        Where
            projno = p_projno
            And costcode = p_costcode
            And activity = p_activity;

        p_message_type := ok;
        p_message_text := 'Projact updated successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_projact;

End pkg_projact_mast;