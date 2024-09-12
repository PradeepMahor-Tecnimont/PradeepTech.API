Create Or Replace Package Body timecurr.pkg_prjc_mast As
    c_schemaname Constant Varchar2(8) := 'TIMECURR';

    Function fn_prjc_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_costcode       Varchar2,
        p_startmonth     Varchar2,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_last_post_month    Varchar2(6);

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            lockedmnth
        Into
            v_last_post_month
        From
            tsconfig
        Where
            Trim(schemaname) = c_schemaname;

        Open c For
            Select
                *
            From
                (
                    Select
                        costcode,
                        projno,
                        name,
                        revcdate,
                        original                             As original_budg,
                        revised                              As revised_budg,
                        (nvl(open04, 0) + nvl(hours, 0))     As cummhours,
                        projections,
                        hours                                As curr_hours,
                        Row_Number() Over(Order By costcode) As row_number,
                        Count(*) Over()                      As total_row
                    From
                        (
                            Select
                                e.costcode,
                                a.projno,
                                a.name,
                                to_char(a.revcdate, 'yyyymm') revcdate,
                                b.original,
                                b.revised,
                                c.open01,
                                c.open04,
                                d.hours,
                                e.projections
                            From
                                projmast a, (
                                    Select
                                        costcode,
                                        projno,
                                        Sum(original) original,
                                        Sum(revised)  revised
                                    From
                                        budgmast
                                    Where
                                        costcode = p_costcode
                                    Group By costcode, projno
                                )        b, (
                                    Select
                                        projno,
                                        Sum(open01) open01,
                                        Sum(open04) open04
                                    From
                                        openmast
                                    Where
                                        costcode = p_costcode
                                    Group By projno
                                )        c, (
                                    Select
                                        projno,
                                        Sum(hours + othours) hours
                                    From
                                        timetran
                                    Where
                                        costcode = p_costcode
                                        And yymm >= p_startmonth
                                        And yymm <= v_last_post_month
                                    Group By projno
                                )        d, (
                                    Select
                                        projno,
                                        costcode,
                                        Sum(hours) projections
                                    From
                                        prjcmast
                                    Where
                                        costcode = p_costcode
                                        And yymm > v_last_post_month
                                    Group By projno, costcode
                                )        e
                            Where
                                a.projno = b.projno(+)
                                And a.projno = c.projno(+)
                                And a.projno = d.projno(+)
                                And a.projno = e.projno
                                And a.projno In (
                                    Select
                                    Distinct projno
                                    From
                                        prjcmast
                                    Where
                                        costcode = p_costcode
                                )
                                And a.active = 1
                                And to_char(a.revcdate, 'yyyymm') >= v_last_post_month
                                And substr(a.projno, 6, 2) = (
                                    Select
                                        nvl(phase, 'XX')
                                    From
                                        costmast
                                    Where
                                        costcode = p_costcode
                                )
                        )
                    Order By projno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_prjc_list;

    Function fn_prjc_details_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_costcode       Varchar2,
        p_projno         Varchar2,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_pros_month         Varchar2(6);

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig
        Where
            Trim(schemaname) = c_schemaname;

        Open c For
            Select
                *
            From
                (
                    Select
                        costcode,
                        projno,
                        yymm,
                        hours,
                        Row_Number() Over(Order By yymm Asc) As row_number,
                        Count(*) Over()                      As total_row
                    From
                        prjcmast
                    Where
                        projno = p_projno
                        And costcode = p_costcode
                        And Trim(v_pros_month) <= Trim(yymm)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_prjc_details_list;

    Procedure sp_add_prjcmast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,
        p_yymm             Varchar2,
        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_pros_month   Varchar2(6);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig
        Where
            Trim(schemaname) = c_schemaname;

        Select
            Count(*)
        Into
            v_exists
        From
            prjcmast
        Where
            costcode = p_costcode
            And projno = p_projno
            And yymm = v_pros_month;
            
        If v_exists = 0 Then
            Insert Into prjcmast
            (
                costcode,
                projno,
                yymm,
                hours
            )
            Values
            (
                Trim(p_costcode),
                Trim(p_projno),
                Trim(p_yymm),
                p_hours
            );
            p_message_type := ok;
            p_message_text := 'Project master added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Project already exists';
        End If;
        Commit;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_prjcmast;
    
    Procedure sp_add_prjcmast_job(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,
        p_yymm             Varchar2,
        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_pros_month   Varchar2(6);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

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
            prjcmast
        Where
            costcode = p_costcode
            And projno = p_projno
            And yymm = p_yymm;
            
        If v_exists = 0 Then
            Insert Into prjcmast
            (
                costcode,
                projno,
                yymm,
                hours
            )
            Values
            (
                Trim(p_costcode),
                Trim(p_projno),
                Trim(p_yymm),
                p_hours
            );
            p_message_type := ok;
            p_message_text := 'Project master job added successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Project job already exists';
        End If;
        Commit;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_prjcmast_job;
    
    Procedure sp_update_prjcmast_job(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,
        p_yymm             Varchar2,
        p_hours            Number,

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
            prjcmast
        Set
            costcode = p_costcode,
            projno = p_projno,
            yymm = p_yymm,
            hours= p_hours
        Where
            costcode = p_costcode
            And projno = p_projno
            And yymm = p_yymm;

        p_message_type := ok;
        p_message_text := 'Project master job Update successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_prjcmast_job;
    
    Procedure sp_delete_prjcmast_job(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_costcode         Varchar2,
        p_projno           Varchar2,
        p_yymm             Varchar2,
        
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
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
            From prjcmast
        Where
            costcode = p_costcode
            And projno = p_projno
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
    End sp_delete_prjcmast_job;
    
    Function fn_prjc_details_list_for_excel_template(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_costcode       Varchar2,
        p_projno         Varchar2,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_pros_month         Varchar2(6);

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig
        Where
            Trim(schemaname) = c_schemaname;

        Open c For
            Select
                *
            From
                (
                    Select
                        costcode,
                        projno,
                        yymm,
                        hours
                    From
                        prjcmast
                    Where
                        projno = p_projno
                        And costcode = p_costcode
                        And Trim(v_pros_month) <= Trim(yymm)
                )
            ;
        Return c;
    End fn_prjc_details_list_for_excel_template;
End pkg_prjc_mast;