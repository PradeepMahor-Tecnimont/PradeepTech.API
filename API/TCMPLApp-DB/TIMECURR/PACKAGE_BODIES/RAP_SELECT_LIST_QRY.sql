--------------------------------------------------------
--  DDL for Package Body RAP_SELECT_LIST_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.rap_select_list_qry As

    Function fn_year_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                ts_yyyy data_value_field,
                ts_yyyy data_text_field
            From
                timecurr.ngts_year_mast
            Where
                ts_isactive = 1
            Order By
                ts_yyyy Desc;

        Return c;
    End;

    Function fn_yearmode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'A'             data_value_field,
                'April - March' data_text_field
            From
                dual
            Union All
            Select
                'J'                  data_value_field,
                'January - December' data_text_field
            From
                dual;

        Return c;
    End;

    Function fn_yearmonth_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyy      Varchar2,
        p_yearmode  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                value data_value_field,
                text  data_text_field
            From
                (
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 0), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 0), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 1), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 1), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 2), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 2), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 3), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 3), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 4), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 4), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 5), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 5), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 6), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 6), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 7), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 7), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 8), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 8), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 9), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 9), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 10), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 10), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 11), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 11), 'Mon Yyyy') text
                    From
                        dual
                )
            Where
                To_Number(value) <= (
                    Select
                        To_Number(pros_month)
                    From
                        tsconfig
                )
            Order By
                value Desc;

        Return c;
    End;

    Function fn_costcode_list_proco(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                costmast
            Where
                active = 1
                And costcode In (
                    Select
                        costcode
                    From
                        deptphase
                    Where
                        isprimary = 1
                )
            Order By
                costcode;

        Return c;
    End;

    Function fn_costcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c          Sys_Refcursor;
        v_empno    Varchar2(5);
        n_costcode Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                costmast
            Where
                active = 1
                And costcode In (
                    Select
                        costcode
                    From
                        deptphase
                    Where
                        isprimary = 1
                )
                And costcode In
                (
                    Select
                        costcode
                    From
                        costmast
                    Start
                    With
                        hod = v_empno
                    Connect By
                    Nocycle
                    Prior costcode = parent_costcode
                    Union All
                    Select
                        costcode
                    From
                        rap_dyhod
                    Where
                        empno = v_empno
                    Union All
                    Select
                        costcode
                    From
                        rap_hod
                    Where
                        empno = v_empno
                    Union All
                    Select
                        costcode
                    From
                        rap_secretary
                    Where
                        empno = v_empno
                )
            Order By
                costcode;

        Return c;
    End;

    Function fn_projno_list_proco(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                projmast
            Where
                active = 1
                And
                substr(projno, 1, 5) In (
                    Select
                        projno
                    From
                        jobmaster
                    Where
                        actual_closing_date Is Null
                )
            Order By
                projno;

        Return c;
    End;

    Function fn_projno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c        Sys_Refcursor;
        v_empno  Varchar2(5);
        n_projno Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                projmast
            Where
                active = 1
                And (prjmngr = v_empno
                    Or
                    prjdymngr = v_empno
                    Or
                    prjoper = v_empno)
                And
                substr(projno, 1, 5) In (
                    Select
                        projno
                    From
                        jobmaster
                    Where
                        actual_closing_date Is Null
                )
            Order By
                projno;

        Return c;
    End;

    Function fn_empno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                emplmast
            Where
                status = 1
            Order By
                empno;

        Return c;
    End;

    Function fn_simulation_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'A' data_value_field,
                'A' data_text_field
            From
                dual
            Union All
            Select
                'B' data_value_field,
                'B' data_text_field
            From
                dual
            Union All
            Select
                'C' data_value_field,
                'C' data_text_field
            From
                dual;

        Return c;
    End;

    Function fn_expt_projno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                exptjobs
            Where
                nvl(active, 0) = 1
                Or nvl(activefuture, 0) = 1
            Order By
                projno;

        Return c;
    End;

    Function fn_job_tmagroup_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                tmagroup                          data_value_field,
                tmagroup || ' - ' || tmagroupdesc data_text_field
            From
                job_tmagroup
            Order By
                tmagroup;
        Return c;
    End;

    Function fn_tlpcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                tlpcode                  data_value_field,
                tlpcode || ' - ' || name data_text_field
            From
                tlp_mast
            Where
                costcode = p_costcode
            Order By
                tlpcode;
        Return c;
    End fn_tlpcode_list;

    Function fn_activity_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                activity                  data_value_field,
                activity || ' - ' || name data_text_field
            From
                act_mast
            Where
                costcode = p_costcode
            Order By
                activity;
        Return c;
    End fn_activity_list;

    Function fn_costcode_grp_costcode_list(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_costcode_group_id Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                tcg.costcode_group_name, tcgc.costcode
            From
                ts_costcode_group                                 tcg, ts_costcode_group_costcode tcgc
            Where
                tcg.costcode_group_id = tcgc.costcode_group_id
                And tcg.costcode_group_id = Trim(p_costcode_group_id)
            Order By
                tcgc.costcode;
        Return c;
    End;

    Function fn_socd_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
            Distinct
                b.oscm_id                                                             data_value_field,
                b.projno5 || ' : ' ||
                (
                    Select
                    Distinct
                        a.name
                    From
                        projmast a
                    Where
                        substr(a.projno, 1, 5) = b.projno5
                ) || ' - ' || oscm_vendor || ' - ' || oscm_type || ' - ' || po_number data_text_field
            From
                rap_osc_master b;
        Return c;
    End fn_socd_list;

    Function fn_projno5_list_proco(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
            Distinct
                substr(projno, 1, 5)                  data_value_field,
                substr(projno, 1, 5) || ' - ' || name data_text_field
            From
                projmast
            Where
                active = 1
                And
                substr(projno, 1, 5) In (
                    Select
                        projno
                    From
                        jobmaster
                    Where
                        actual_closing_date Is Null
                )
            Order By
                substr(projno, 1, 5);

        Return c;
    End;

    Function fn_projno5_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c        Sys_Refcursor;
        v_empno  Varchar2(5);
        n_projno Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
            Distinct
                substr(projno, 1, 5)                  data_value_field,
                substr(projno, 1, 5) || ' - ' || name data_text_field
            From
                projmast
            Where
                active = 1
                And (prjmngr = v_empno
                    Or
                    prjdymngr = v_empno
                    Or
                    prjoper = v_empno)
                And
                substr(projno, 1, 5) In (
                    Select
                        projno
                    From
                        jobmaster
                    Where
                        actual_closing_date Is Null
                )
            Order By
                substr(projno, 1, 5);

        Return c;
    End;

    Function fn_subcontractor_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                subcontract                         data_value_field,
                subcontract || ' - ' || description data_text_field
            From
                subcontractmast
            Order By
                description;

        Return c;
    End;

    Function fn_osc_hours_yyyymm_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscd_id   Varchar2
    ) Return Sys_Refcursor As
        p_rec     Sys_Refcursor;
        v_projno5 Char(5);
    Begin

        Select
            projno5
        Into
            v_projno5
        From
            rap_osc_master
        Where
            oscm_id = (
                Select
                    oscm_id
                From
                    rap_osc_detail
                Where
                    oscd_id = Trim(p_oscd_id)
            );

        Open p_rec For
            Select
                ry.yyyy || rm.mm data_value_field,
                ry.yyyy || rm.mm data_text_field
            From
                rap_years                ry, rap_months rm
            Where
                Not Exists
                (
                    Select
                        yyyymm
                    From
                        rap_osc_hours
                    Where
                        oscd_id = p_oscd_id
                        And yyyymm = ry.yyyy || rm.mm
                )
                And ry.yyyy || rm.mm >= (
                    Select
                        pros_month
                    From
                        tsconfig
                )
                And ry.yyyy || rm.mm <= (
                    Select
                        to_char(Max(revcdate), 'yyyymm')
                    From
                        projmast
                    Where
                        substr(proj_no, 1, 5) = Trim(v_projno5)
                )
            Order By
                1;
        Return p_rec;
    End fn_osc_hours_yyyymm_list;

    Function fn_costcode_list_proco_bal(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscm_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                costmast
            Where
                active = 1
                And costcode In (
                    Select
                        costcode
                    From
                        deptphase
                    Where
                        isprimary = 1
                )
                And costcode Not In (
                    Select
                        costcode
                    From
                        rap_osc_detail
                    Where
                        oscm_id = Trim(p_oscm_id)
                )
            Order By
                costcode;

        Return c;
    End;

    Function fn_costcode_list_bal(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscm_id   Varchar2
    ) Return Sys_Refcursor As
        c          Sys_Refcursor;
        v_empno    Varchar2(5);
        n_costcode Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                costmast
            Where
                active = 1
                And costcode In (
                    Select
                        costcode
                    From
                        deptphase
                    Where
                        isprimary = 1
                )
                And costcode In
                (
                    Select
                        costcode
                    From
                        costmast
                    Where
                        hod = v_empno
                    Union All
                    Select
                        costcode
                    From
                        rap_dyhod
                    Where
                        empno = v_empno
                    Union All
                    Select
                        costcode
                    From
                        rap_hod
                    Where
                        empno = v_empno
                    Union All
                    Select
                        costcode
                    From
                        rap_secretary
                    Where
                        empno = v_empno
                )
                And costcode Not In (
                    Select
                        costcode
                    From
                        rap_osc_detail
                    Where
                        oscm_id = Trim(p_oscm_id)
                )
            Order By
                costcode;

        Return c;
    End;

    Function fn_scope_work_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                oscsw_id        data_value_field,
                scope_work_desc data_text_field
            From
                rap_osc_scope_work_mst
            Where
                is_active = 1
            Order By
                scope_work_desc;

        Return c;
    End;

    Function fn_projno_list_proco_closed(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                projmast
            Where
                active = 0
                And
                substr(projno, 1, 5) In (
                    Select
                        projno
                    From
                        jobmaster
                    Where
                        actual_closing_date Is Not Null
                )
            Order By
                projno;

        Return c;
    End;

    Function fn_projno_list_closed(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c        Sys_Refcursor;
        v_empno  Varchar2(5);
        n_projno Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                projmast
            Where
                active = 0
                And (prjmngr = v_empno
                    Or
                    prjdymngr = v_empno
                    Or
                    prjoper = v_empno)
                And
                substr(projno, 1, 5) In (
                    Select
                        projno
                    From
                        jobmaster
                    Where
                        actual_closing_date Is Not Null
                )
            Order By
                projno;

        Return c;
    End;

    Procedure fn_get_process_month(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_schemaname          Varchar2,

        p_proc_month      Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        c        Sys_Refcursor;
        v_empno  Varchar2(5);
        v_exists Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        Select
            Count(*)
        Into
            v_exists
        From
            tsconfig
        Where
            Trim(schemaname) = p_schemaname;

        If v_exists = 1 Then
            Select
                pros_month
            Into
                p_proc_month
            From
                tsconfig
            Where
                Trim(schemaname) = p_schemaname;

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
    End fn_get_process_month;
End rap_select_list_qry;