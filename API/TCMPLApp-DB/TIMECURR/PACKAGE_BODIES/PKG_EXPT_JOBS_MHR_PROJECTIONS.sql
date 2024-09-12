Create Or Replace Package Body "TIMECURR"."PKG_EXPT_JOBS_MHR_PROJECTIONS" As

    -- region Query

    Function fn_expt_jobs_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_costcode       Varchar2,
        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_costcode Is Null Then
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        ej.projno,
                        ej.name,
                        ej.active,
                        Case nvl(ej.active, 0)
                            When 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                    As active_desc,
                        ej.activefuture,
                        Case nvl(ej.activefuture, 0)
                            When 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                    As activefuture_desc,
                        ej.proj_type,
                        (
                            Select
                                Sum(nvl(ep_1.hours, 0)) hours
                            From
                                exptprjc ep_1
                            Where
                                ep_1.costcode   = p_costcode
                                And ep_1.yymm >= t.pros_month
                                And ep_1.projno = ej.projno
                            Group By ep_1.projno
                        )                                      hours,
                        Row_Number() Over (Order By ej.projno) row_number,
                        Count(*) Over ()                       total_row
                    From
                        exptjobs ej,
                        tsconfig t
                    Where
                        (nvl(ej.active, 0)             = 1
                            Or nvl(ej.activefuture, 0) = 1)
                        And ej.projno In (
                            Select
                                projno
                            From
                                exptprjc ep
                            Where
                                ep.costcode = p_costcode
                                And ep.yymm >= t.pros_month
                        )
                        And (
                            ej.projno Like '%' || Trim(p_generic_search) || '%'
                            Or
                            ej.name Like '%' || Trim(p_generic_search) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

    Function fn_expt_prjc_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_costcode    Varchar2,
        p_projno      Varchar2,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_costcode Is Null Or p_projno Is Null Then
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        ep.projno,
                        ep.costcode,
                        ep.yymm,
                        ep.hours,
                        Row_Number() Over (Order By ep.yymm) row_number,
                        Count(*) Over ()                     total_row
                    From
                        exptjobs ej,
                        exptprjc ep,
                        tsconfig t
                    Where
                        (nvl(ej.active, 0)             = 1
                            Or nvl(ej.activefuture, 0) = 1)
                        And ej.projno                  = ep.projno
                        And ep.projno                  = p_projno
                        And ep.costcode                = p_costcode
                        And ep.yymm >= t.pros_month
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

    Function fn_expt_prjc_all_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
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
                        ep.projno,
                        ep.costcode,
                        ep.yymm,
                        ep.hours,
                        Row_Number() Over (Order By ep.projno, ep.costcode, ep.yymm) row_number,
                        Count(*) Over ()                                             total_row
                    From
                        exptjobs ej,
                        exptprjc ep,
                        tsconfig t
                    Where
                        (nvl(ej.active, 0)             = 1
                            Or nvl(ej.activefuture, 0) = 1)
                        And ej.projno                  = ep.projno
                        And ep.yymm >= t.pros_month
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

    Procedure sp_expt_prjc_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,
        p_yymm             Varchar2,

        p_hours        Out Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_hours        := Null;
            p_message_type := not_ok;
            p_message_text := 'Employee not found !!!';
            Return;
        End If;

        Select
            hours
        Into
            p_hours
        From
            exptprjc
        Where
            yymm         = p_yymm
            And projno   = p_projno
            And costcode = p_costcode;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;
    
    -- endregion Query

    --region crud

    Procedure sp_add_job(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_yymm  tsconfig.pros_month%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            pros_month
        Into
            v_yymm
        From
            tsconfig;

        Insert Into exptprjc(costcode, projno, yymm, hours)
        Values(
            p_costcode, p_projno, v_yymm, 0);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Project and Costcode is already present !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_projection(
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
        v_yymm  tsconfig.pros_month%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_hours < 0 Then
            p_message_type := not_ok;
            p_message_text := 'Hours cannot be less than 0';
            Return;
        End If;

        Select
            pros_month
        Into
            v_yymm
        From
            tsconfig;

        If v_yymm > p_yymm Then
            p_message_type := not_ok;
            p_message_text := 'Month cannot be earlier than Processing month';
            Return;
        End If;

        Insert Into exptprjc(costcode, projno, yymm, hours)
        Values(
            p_costcode, p_projno, p_yymm, p_hours);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Project and Costcode is already present !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_edit_projection(
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
        v_yymm  tsconfig.pros_month%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_hours < 0 Then
            p_message_type := not_ok;
            p_message_text := 'Hours cannot be less than 0';
            Return;
        End If;

        Select
            pros_month
        Into
            v_yymm
        From
            tsconfig;

        If v_yymm > p_yymm Then
            p_message_type := not_ok;
            p_message_text := 'Month cannot be earlier than Processing month';
            Return;
        End If;

        Update
            exptprjc
        Set
            hours = p_hours
        Where
            yymm         = p_yymm
            And costcode = p_costcode
            And projno   = p_projno;

        If Sql%found Then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Project / Costcode / Month not found';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Project and Costcode is already present !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_projection(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,
        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_yymm  tsconfig.pros_month%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            pros_month
        Into
            v_yymm
        From
            tsconfig;

        If v_yymm > p_yymm Then
            p_message_type := not_ok;
            p_message_text := 'Month cannot be earlier than Processing month';
            Return;
        End If;

        Delete exptprjc
        Where
            yymm         = p_yymm
            And costcode = p_costcode
            And projno   = p_projno;

        If Sql%found Then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Project / Costcode / Month not found';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Project and Costcode is already present !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_projection_bulk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_projno           Varchar2,
        p_number_of_months Number,
        p_hours            Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_pros_month tsconfig.pros_month%Type;
        v_yymm       Date;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_number_of_months <= 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid months';
            Return;
        End If;

        If p_hours < 0 Then
            p_message_type := not_ok;
            p_message_text := 'Hours cannot be less than 0';
            Return;
        End If;

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig;

        Begin
            Select
                add_months(To_Date(yymm || '01', 'YYYYMMDD'), 1)
            Into
                v_yymm
            From
                (
                    Select
                        yymm
                    From
                        exptprjc
                    Where
                        costcode   = p_costcode
                        And projno = p_projno
                    Order By yymm Desc
                )
            Where
                Rownum = 1;

            If v_yymm < To_Date(v_pros_month || '01', 'YYYYMMDD') Then
                v_yymm := To_Date(v_pros_month || '01', 'YYYYMMDD');
            End If;

        Exception
            When no_data_found Then
                v_yymm := To_Date(v_pros_month || '01', 'YYYYMMDD');
        End;

        For i In 0..p_number_of_months - 1
        Loop
            Insert Into exptprjc(costcode, projno, yymm, hours)
            Values(
                p_costcode, p_projno, to_char(add_months(v_yymm, i), 'YYYYMM'), p_hours);
        End Loop;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Project and Costcode is already present !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;
    
    --endregion crud

End pkg_expt_jobs_mhr_projections;