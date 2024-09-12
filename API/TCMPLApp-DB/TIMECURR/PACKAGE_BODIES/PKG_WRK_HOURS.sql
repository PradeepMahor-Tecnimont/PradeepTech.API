Create Or Replace Package Body timecurr.pkg_wrk_hours As

    Function fn_wrk_hours_list(
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
                        office,
                        working_hrs,
                        apprby,
                        postby,
                        remarks,
                        Row_Number() Over(Order By yymm Desc) As row_number,
                        Count(*) Over()                       As total_row
                    From
                        wrkhours
                    Where
                        yymm Like '%' || upper(Trim(p_generic_search)) || '%'

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_wrk_hours_list;

    Procedure sp_wrk_hours_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_office           Varchar2,

        p_working_hrs  Out Number,
        p_apprby       Out Date,
        p_postby       Out Date,
        p_remarks      Out Varchar2,

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
            wrkhours
        Where
            yymm = p_yymm
            And office = p_office;

        If v_exists = 1 Then
            Select
                working_hrs,
                apprby,
                postby,
                remarks
            Into
                p_working_hrs,
                p_apprby,
                p_postby,
                p_remarks
            From
                wrkhours
            Where
                yymm = p_yymm
                And office = p_office;

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
    End sp_wrk_hours_details;

    Procedure sp_add_wrk_hour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_office           Varchar2,
        p_working_hr       Number   Default Null,
        p_apprby           Date     Default Null,
        p_postby           Date     Default Null,
        p_remarks          Varchar2 Default Null,

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
            wrkhours
        Where
            yymm = p_yymm
            And office = p_office;

        If v_exists = 0 Then
            Insert Into wrkhours (
                yymm,
                office,
                working_hrs,
                apprby,
                postby,
                remarks
            )
            Values(
                p_yymm,
                p_office,
                p_working_hr,
                p_apprby,
                p_postby,
                p_remarks
            );
            p_message_type := ok;
            p_message_text := 'Work hours added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Work hours already exists';
        End If;
        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_wrk_hour;

    Procedure sp_update_wrk_hour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,
        p_office           Varchar2,
        p_working_hr       Number   Default Null,
        p_apprby           Date     Default Null,
        p_postby           Date     Default Null,
        p_remarks          Varchar2 Default Null,

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
            wrkhours
        Set
            yymm = p_yymm,
            office = p_office,
            working_hrs = p_working_hr,
            apprby = p_apprby,
            postby = p_postby,
            remarks = p_remarks
        Where
            yymm = p_yymm
            And office = p_office;

        p_message_type := ok;
        p_message_text := 'work hours updated successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_wrk_hour;

End pkg_wrk_hours;