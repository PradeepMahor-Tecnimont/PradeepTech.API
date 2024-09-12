Create Or Replace Package Body timecurr.pkg_update_no_of_employees As

    Procedure sp_no_of_employees_details(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_costcode          Varchar2,

        p_noofemps      Out Number,
        p_changed_nemps Out Number,

        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno         := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        p_noofemps      := 0;
        p_changed_nemps := 0;

        Select
            Count(*)
        Into
            v_exists
        From
            costmast a
        Where
            trim(a.costcode) = trim(p_costcode);

        If v_exists > 0 Then
            Select
                
                to_number(a.noofemps),
                to_number(a.changed_nemps)
            Into
                p_noofemps,
                p_changed_nemps
            From
                costmast a
            Where
                a.costcode = p_costcode;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching record exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_update_no_of_employees(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_changed_nemps    Number,

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
            costmast a
        Where
            a.costcode = p_costcode;

        If v_exists = 1 Then

            Update
                costmast
            Set
                changed_nemps = p_changed_nemps
            Where
                costcode = p_costcode;

            Commit;

            p_message_type := ok;
            p_message_text := 'No of employees updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching No of employees exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Movement already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

End pkg_update_no_of_employees;