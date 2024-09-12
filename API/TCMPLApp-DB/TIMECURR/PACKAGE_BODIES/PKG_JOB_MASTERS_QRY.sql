--------------------------------------------------------
--  DDL for Package Body PKG_JOB_MASTERS_QRY
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."PKG_JOB_MASTERS_QRY" As

    Function fn_job_tmagroup_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.tmagroup                                   As tma_group,
                        a.subgroup                                   As sub_group,
                        a.tmagroupdesc                               As tma_group_desc,
                        0                                            As delete_allowed,
                        Row_Number() Over (Order By a.tmagroup Desc) row_number,
                        Count(*) Over ()                             total_row
                    From
                        job_tmagroup a
                    Where
                        (
                            upper(a.tmagroup) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.subgroup) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.tmagroupdesc) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_job_tmagroup_list;

    Function fn_xl_job_tmagroup(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.tmagroup     As tma_group,
                a.subgroup     As sub_group,
                a.tmagroupdesc As tma_group_desc
            From
                job_tmagroup a
            Where
                (
                    upper(a.tmagroup) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.subgroup) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.tmagroupdesc) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.tmagroup;
        Return c;
    End fn_xl_job_tmagroup;

    Procedure sp_job_tmagroup_details(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_tma_group          Varchar2,
        p_sub_group      Out Varchar2,
        p_tma_group_desc Out Varchar2,

        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.subgroup     As subgroup,
            a.tmagroupdesc As tmagroupdesc
        Into
            p_sub_group,
            p_tma_group_desc
        From
            job_tmagroup a
        Where
            a.tmagroup = p_tma_group;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_job_tmagroup_details;

    Function fn_business_line_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.code                                           As code,
                        a.description                                    As description,
                        a.short_description                              As short_description,
                        (
                            Select
                                Case
                                    When Count(business_line) > 0 Then
                                        1
                                    Else
                                        0
                                End As delete_allowed
                            From
                                jobmaster
                            Where
                                business_line = a.code
                        )                                                As delete_allowed,
                        Row_Number() Over (Order By a.short_description) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        business_line a
                    Where
                        (
                            upper(a.short_description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_business_line_list;

    Function fn_xl_business_line(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.code              As code,
                a.short_description As short_description,
                a.description       As description
            From
                business_line a
            Where
                (
                    upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.code;
        Return c;
    End fn_xl_business_line;

    Function fn_job_co_master_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.code                                   As code,
                        a.description                            As description,
                        0                                        As delete_allowed,
                        Row_Number() Over (Order By a.code Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        job_co_master a
                    Where
                        (
                            upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_job_co_master_list;

    Function fn_xl_job_co_master(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.code        As code,
                a.description As description
            From
                job_co_master a
            Where
                (
                    upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.code;
        Return c;
    End fn_xl_job_co_master;

    Procedure sp_job_co_master_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,
        p_description  Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.description As description
        Into
            p_description
        From
            job_co_master a
        Where
            a.code = p_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_job_co_master_details;

    Procedure sp_business_line_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_code                  Varchar2,
        p_short_description Out Varchar2,
        p_description       Out Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.description As description,
            a.short_description
        Into
            p_description,
            p_short_description
        From
            business_line a
        Where
            a.code = p_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_business_line_details;

    Function fn_sub_business_line_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.code                                           As code,
                        a.short_description                              As short_description,
                        a.description                                    As description,
                        (
                            Select
                                Case
                                    When Count(sub_business_line) > 0 Then
                                        1
                                    Else
                                        0
                                End As delete_allowed
                            From
                                jobmaster
                            Where
                                sub_business_line = a.code
                        )                                                As delete_allowed,
                        Row_Number() Over (Order By a.short_description) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        sub_business_line a
                    Where
                        (
                            upper(a.short_description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_sub_business_line_list;

    Function fn_xl_sub_business_line(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.code              As code,
                a.short_description As short_description,
                a.description       As description
            From
                sub_business_line a
            Where
                (
                    upper(a.short_description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.code;
        Return c;
    End fn_xl_sub_business_line;

    Procedure sp_sub_business_line_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_code                  Varchar2,
        p_short_description Out Varchar2,
        p_description       Out Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.short_description,
            a.description As description
        Into
            p_short_description,
            p_description
        From
            sub_business_line a
        Where
            a.code = p_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_sub_business_line_details;

    Function fn_segment_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.code                                   As code,
                        a.description                            As description,
                        0                                        As delete_allowed,
                        Row_Number() Over (Order By a.code Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        segment a
                    Where
                        (
                            upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_segment_list;

    Function fn_xl_segment(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.code        As code,
                a.description As description
            From
                segment a
            Where
                (
                    upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.code;
        Return c;
    End fn_xl_segment;

    Procedure sp_segment_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,
        p_description  Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.description As description
        Into
            p_description
        From
            segment a
        Where
            a.code = p_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_segment_details;

    Function fn_scope_of_work_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.code                                           As code,
                        a.short_description                              As short_description,
                        a.description                                    As description,
                        (
                            Select
                                Case
                                    When Count(scope_of_work) > 0 Then
                                        1
                                    Else
                                        0
                                End As delete_allowed
                            From
                                jobmaster
                            Where
                                scope_of_work = a.code
                        )                                                As delete_allowed,
                        Row_Number() Over (Order By a.short_description) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        scope_of_work a
                    Where
                        (
                            upper(a.short_description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_scope_of_work_list;

    Function fn_xl_scope_of_work(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.code              As code,
                a.short_description As short_description,
                a.description       As description
            From
                scope_of_work a
            Where
                (
                    upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.code;
        Return c;
    End fn_xl_scope_of_work;

    Procedure sp_scope_of_work_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_code                  Varchar2,
        p_short_description Out Varchar2,
        p_description       Out Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.short_description,
            a.description As description
        Into
            p_short_description,
            p_description
        From
            scope_of_work a
        Where
            a.code = p_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_scope_of_work_details;

    Function fn_plant_type_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.code                                           As code,
                        a.short_description                              As short_description,
                        a.description                                    As description,
                        (
                            Select
                                Case
                                    When Count(plant_type) > 0 Then
                                        1
                                    Else
                                        0
                                End As delete_allowed
                            From
                                jobmaster
                            Where
                                plant_type = a.code
                        )                                                As delete_allowed,
                        Row_Number() Over (Order By a.short_description) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        plant_type a
                    Where
                        (
                            upper(a.short_description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_plant_type_list;

    Function fn_xl_plant_type(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.code              As code,
                a.short_description As short_description,
                a.description       As description
            From
                plant_type a
            Where
                (
                    upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.code;
        Return c;
    End fn_xl_plant_type;

    Procedure sp_plant_type_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_code                  Varchar2,
        p_short_description Out Varchar2,
        p_description       Out Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.short_description,
            a.description As description
        Into
            p_short_description,
            p_description
        From
            plant_type a
        Where
            a.code = p_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_plant_type_details;

    Function fn_project_type_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.code                                           As code,
                        a.short_description                              As short_description,
                        a.description                                    As description,
                        (
                            Select
                                Case
                                    When Count(projtype) > 0 Then
                                        1
                                    Else
                                        0
                                End As delete_allowed
                            From
                                jobmaster
                            Where
                                projtype = a.code
                        )                                                As delete_allowed,
                        Row_Number() Over (Order By a.short_description) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        job_projtype a
                    Where
                        (
                            upper(a.short_description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_project_type_list;

    Function fn_xl_project_type(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.code              As code,
                a.short_description As short_description,
                a.description       As description
            From
                job_projtype a
            Where
                (
                    upper(a.code) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    upper(a.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                )

            Order By
                a.code;
        Return c;
    End fn_xl_project_type;

    Procedure sp_project_type_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_code                  Varchar2,
        p_short_description Out Varchar2,
        p_description       Out Varchar2,

        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            a.short_description,
            a.description As description
        Into
            p_short_description,
            p_description
        From
            job_projtype a
        Where
            a.code = p_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_project_type_details;

End pkg_job_masters_qry;
/
Grant Execute On "TIMECURR"."PKG_JOB_MASTERS_QRY" To "TCMPL_APP_CONFIG";