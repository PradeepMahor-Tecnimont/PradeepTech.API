Create Or Replace Package Body timecurr.pkg_movemast As

    Function frc_get_last_month(p_costcode Varchar2) Return Varchar2 Is
        v_return_val Varchar2(6) := 'NA';
    Begin
        Select
            yymm
        Into
            v_return_val
        From
            movemast
        Where
            costcode   = p_costcode
            And Rownum = 1
        Order By
            yymm Desc;

        Return v_return_val;

    Exception
        When no_data_found Then
            v_return_val := 'NA';
            Return v_return_val;
    End;

    Function fn_movemast_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_costcode       Varchar2 Default Null,
        p_yymm           Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_lockedmnth         Varchar2(6);
        v_pros_month         Varchar2(6);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            lockedmnth, pros_month
        Into
            v_lockedmnth, v_pros_month
        From
            tsconfig;

        Open c For
            Select
                *
            From
                (
                    Select
                        a.costcode                          As costcode,
                        a.yymm                              As yymm,
                        To_Number(a.movement)               As movement,
                        To_Number(a.movetotcm)              As movetotcm,
                        To_Number(a.movetosite)             As movetosite,
                        To_Number(a.movetoothers)           As movetoothers,
                        To_Number(a.ext_subcontract)        As ext_subcontract,
                        To_Number(a.fut_recruit)            As fut_recruit,
                        To_Number(a.int_dept)               As int_dept,
                        To_Number(a.hrs_subcont)            As hrs_subcont,
                        Case
                            When a.yymm >= v_lockedmnth Then
                                1
                            Else
                                0
                        End                                 As can_edit,
                        Case
                            When a.yymm > v_pros_month Then
                                1
                            Else
                                0
                        End                                 As can_delete,
                        Row_Number() Over (Order By a.yymm) row_number,
                        Count(*) Over ()                    total_row
                    From
                        movemast a
                    Where
                        a.costcode = Trim(p_costcode)
                        And a.yymm >= v_pros_month
                        And (a.costcode Like '%' || Trim(p_generic_search) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_movemast_list;

    Procedure sp_movemast_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_costcode            Varchar2,
        p_yymm                Varchar2 Default Null,

        p_movement        Out Number,
        p_movetotcm       Out Number,
        p_movetosite      Out Number,
        p_movetoothers    Out Number,
        p_ext_subcontract Out Number,
        p_fut_recruit     Out Number,
        p_int_dept        Out Number,
        p_hrs_subcont     Out Number,
        p_last_yymm       Out Varchar2,
        p_locked_month    Out Varchar2,
        p_pros_month      Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno     := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        p_last_yymm := pkg_movemast.frc_get_last_month(p_costcode);

        Select
            lockedmnth, pros_month
        Into
            p_locked_month, p_pros_month
        From
            tsconfig;

        Select
            Count(*)
        Into
            v_exists
        From
            movemast
        Where
            Trim(costcode) = Trim(p_costcode);

        If v_exists > 1 Then
            Select
                movement,
                movetotcm,
                movetosite,
                movetoothers,
                ext_subcontract,
                fut_recruit,
                int_dept,
                hrs_subcont
            Into
                p_movement,
                p_movetotcm,
                p_movetosite,
                p_movetoothers,
                p_ext_subcontract,
                p_fut_recruit,
                p_int_dept,
                p_hrs_subcont
            From
                movemast

            Where
                Trim(upper(yymm))  = Trim(upper(p_yymm))
                And Trim(costcode) = Trim(p_costcode);
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Movement exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_movemast_details;

    Procedure sp_add_movemast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_yymm             Varchar2,
        p_movement         Number,
        p_movetotcm        Number,
        p_movetosite       Number,
        p_movetoothers     Number,
        p_ext_subcontract  Number,
        p_fut_recruit      Number,
        p_int_dept         Number,
        p_hrs_subcont      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(4);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_keyid := dbms_random.string('X', 4);

        Select
            Count(*)
        Into
            v_exists
        From
            movemast
        Where
            Trim(upper(yymm))  = Trim(upper(p_yymm))
            And Trim(costcode) = Trim(p_costcode);

        If v_exists = 0 Then
            Insert Into movemast
            (
                costcode,
                yymm,
                movement,
                movetotcm,
                movetosite,
                movetoothers,
                ext_subcontract,
                fut_recruit,
                int_dept,
                hrs_subcont
            )
            Values
            (
                Trim(upper(p_costcode)),
                Trim(p_yymm),
                p_movement,
                p_movetotcm,
                p_movetosite,
                p_movetoothers,
                p_ext_subcontract,
                p_fut_recruit,
                p_int_dept,
                p_hrs_subcont
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Movement added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Movement already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_movemast;

    Procedure sp_update_movemast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_yymm             Varchar2,
        p_movement         Number,
        p_movetotcm        Number,
        p_movetosite       Number,
        p_movetoothers     Number,
        p_ext_subcontract  Number,
        p_fut_recruit      Number,
        p_int_dept         Number,
        p_hrs_subcont      Number,

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
            movemast
        Where
            Trim(upper(yymm))  = Trim(upper(p_yymm))
            And Trim(costcode) = Trim(p_costcode);

        If v_exists = 1 Then

            Update
                movemast
            Set
                movement = p_movement,
                movetotcm = p_movetotcm,
                movetosite = p_movetosite,
                movetoothers = p_movetoothers,
                ext_subcontract = p_ext_subcontract,
                fut_recruit = p_fut_recruit,
                int_dept = p_int_dept,
                hrs_subcont = p_hrs_subcont
            Where
                Trim(upper(yymm))  = Trim(upper(p_yymm))
                And Trim(costcode) = Trim(p_costcode);

            Commit;

            p_message_type := ok;
            p_message_text := 'Movement updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Movement exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Movement already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_movemast;

    Procedure sp_delete_movemast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From movemast
        Where
            Trim(upper(yymm))  = Trim(upper(p_yymm))
            And Trim(costcode) = Trim(p_costcode);

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

    End sp_delete_movemast;

    Function fn_movemast_list_for_template(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_costcode       Varchar2 Default Null,
        p_yymm           Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_lockedmnth         Varchar2(6);
        v_pros_month         Varchar2(6);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            lockedmnth, pros_month
        Into
            v_lockedmnth, v_pros_month
        From
            tsconfig;

        Open c For
            Select
                *
            From
                (
                    Select
                        a.costcode                          As costcode,
                        a.yymm                              As yymm,
                        To_Number(a.movement)               As movement,
                        To_Number(a.movetotcm)              As movetotcm,
                        To_Number(a.movetosite)             As movetosite,
                        To_Number(a.movetoothers)           As movetoothers,
                        To_Number(a.ext_subcontract)        As ext_subcontract,
                        To_Number(a.fut_recruit)            As fut_recruit,
                        To_Number(a.int_dept)               As int_dept,
                        To_Number(a.hrs_subcont)            As hrs_subcont
                    From
                        movemast a
                    Where
                        a.costcode = Trim(p_costcode)
                        And a.yymm >= v_pros_month
                        
                );
        Return c;

    End fn_movemast_list_for_template;
End pkg_movemast;