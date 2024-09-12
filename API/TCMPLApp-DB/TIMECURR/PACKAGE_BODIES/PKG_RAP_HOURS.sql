Create Or Replace Package Body timecurr.pkg_rap_hours As

    Function fn_rap_hours_list(
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
                        yymm,
                        work_days,
                        weekend,
                        holidays,
                        leave,
                        tot_days,
                        working_hr,
                        Row_Number() Over(Order By yymm desc) As row_number,
                        Count(*) Over()                  As total_row
                    From
                        raphours
                    Where
                        yymm Like '%' || upper(Trim(p_generic_search)) || '%'
                    
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_rap_hours_list;

    Procedure sp_rap_hours_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,

        p_work_days    Out Number,
        p_weekend      Out Number,
        p_holidays     Out Number,
        p_leave        Out Number,
        p_tot_days     Out Number,
        p_working_hr   Out Number,

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
            raphours
        Where
            yymm = p_yymm;

        If v_exists = 1 Then
            Select
                work_days,
                weekend,
                holidays,
                leave,
                tot_days,
                working_hr
            Into
                p_work_days,
                p_weekend,
                p_holidays,
                p_leave,
                p_tot_days,
                p_working_hr
            From
                raphours
            Where
                yymm = p_yymm;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Year/Month exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_rap_hours_details;

    Procedure sp_add_rap_hour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_work_days        Number Default Null,
        p_weekend          Number Default Null,
        p_holidays         Number Default Null,
        p_leave            Number Default Null,
        p_tot_days         Number Default Null,
        p_working_hr       Number Default Null,

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
            raphours
        Where
            yymm = p_yymm;

        If v_exists = 0 Then
            Insert Into raphours (
                yymm, work_days, weekend, holidays, leave, tot_days, working_hr
            )
            Values(
                p_yymm, p_work_days, p_weekend, p_holidays, p_leave, p_tot_days, p_working_hr
            );
            p_message_type := ok;
            p_message_text := 'Rap hours added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Rap hours already exists';
        End If;
        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_rap_hour;

    Procedure sp_update_rap_hour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_work_days        Number Default Null,
        p_weekend          Number Default Null,
        p_holidays         Number Default Null,
        p_leave            Number Default Null,
        p_tot_days         Number Default Null,
        p_working_hr       Number Default Null,

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
            raphours
        Set
            yymm = p_yymm,
            work_days = p_work_days,
            weekend = p_weekend,
            holidays = p_holidays,
            leave = p_leave,
            tot_days = p_tot_days,
            working_hr = p_working_hr
        Where
            yymm = p_yymm;

        p_message_type := ok;
        p_message_text := 'Rap hours updated successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_rap_hour;

End pkg_rap_hours;
