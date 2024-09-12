Create Or Replace Package Body timecurr.iot_jobs_approvals_qry As

    Function fn_get_cmd_approvals_pending(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As

        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_isdate             Boolean              := false;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_count              Number;
        c_md_role_id         Constant Varchar2(3) := 'R10';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            job_responsible_roles_defaults
        Where
            empno In
            (
                Select
                    principal_empno
                From
                    tcmpl_app_config.sec_module_delegate smd
                Where
                    smd.on_behalf_empno = v_empno
                Union
                Select
                    v_empno
                From
                    dual
            )
            And job_responsible_role_id = c_md_role_id;
        If v_count = 0 Then
            Return Null;
        End If;
        --dbms_output.put_line(' ---> '||v_empno);
        Open c For
            Select
                *
            From
                (
                    Select
                        iot_jobs_general.get_job_status_name(job_mode_status)                           As form_mode,
                        projno,
                        short_desc,
                        client_name                                                                     As clientname,
                        location,
                        initcap(hr_pkg_common.get_employee_name(pm_empno)) || ' [ ' || pm_empno || ' ]' As pmempno,
                        revision,
                        iot_jobs_qry.fn_get_rev_close_date(projno)                                      As revclosedate,
                        actual_closing_date                                                             As actualclosedate,
                        iot_jobs_qry.fn_get_proj_status(projno)                                         As is_active,
                        Row_Number() Over (Order By projno)                                             row_number,
                        Count(*) Over ()                                                                total_row
                    From
                        jobmaster
                    Where
                        nvl(approved_vpdir, 0)     = 1
                        And nvl(approved_dirop, 0) = 0
                        And nvl(approved_amfi, 0)  = 0
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                projno;
        Return c;
    End fn_get_cmd_approvals_pending;

    Function fn_get_afc_approvals_pending(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As

        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_isdate             Boolean              := false;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_amfi_role_id       Constant Varchar2(3) := 'R11';
        v_count              Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            job_responsible_roles_defaults
        Where
            empno In
            (
                Select
                    principal_empno
                From
                    tcmpl_app_config.sec_module_delegate smd
                Where
                    smd.on_behalf_empno = v_empno
                Union
                Select
                    v_empno
                From
                    dual
            )
            And job_responsible_role_id = c_amfi_role_id;
        If v_count = 0 Then
            Return Null;
        End If;
        --dbms_output.put_line(' ---> '||v_empno);
        Open c For
            Select
                *
            From
                (
                    Select
                        iot_jobs_general.get_job_status_name(job_mode_status)                           As form_mode,
                        projno,
                        short_desc,
                        client_name                                                                     As clientname,
                        location,
                        initcap(hr_pkg_common.get_employee_name(pm_empno)) || ' [ ' || pm_empno || ' ]' As pmempno,
                        revision,
                        iot_jobs_qry.fn_get_rev_close_date(projno)                                      As revclosedate,
                        actual_closing_date                                                             As actualclosedate,
                        iot_jobs_qry.fn_get_proj_status(projno)                                         As is_active,
                        Row_Number() Over (Order By projno)                                             row_number,
                        Count(*) Over ()                                                                total_row
                    From
                        jobmaster
                    Where
                        nvl(approved_vpdir, 0)     = 1
                        And nvl(approved_dirop, 0) = 1
                        And nvl(approved_amfi, 0)  = 0
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                projno;
        Return c;
    End fn_get_afc_approvals_pending;

    Function fn_get_js_approvals_pending(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As

        c                     Sys_Refcursor;
        v_empno               Varchar2(5);
        v_isdate              Boolean              := false;
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_job_sponsor_role_id Constant Varchar2(3) := 'R02';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;     

        --dbms_output.put_line(' ---> '||v_empno);
        Open c For
            Select
                *
            From
                (
                    Select
                        iot_jobs_general.get_job_status_name(job_mode_status)                           As form_mode,
                        projno,
                        short_desc,
                        client_name                                                                     As clientname,
                        location,
                        initcap(hr_pkg_common.get_employee_name(pm_empno)) || ' [ ' || pm_empno || ' ]' As pmempno,
                        revision,
                        iot_jobs_qry.fn_get_rev_close_date(projno)                                      As revclosedate,
                        actual_closing_date                                                             As actualclosedate,
                        iot_jobs_qry.fn_get_proj_status(projno)                                         As is_active,
                        Row_Number() Over (Order By projno)                                             row_number,
                        Count(*) Over ()                                                                total_row
                    From
                        jobmaster
                    Where
                        nvl(approved_vpdir, 0)     = 0
                        And nvl(approved_dirop, 0) = 0
                        And nvl(approved_amfi, 0)  = 0
                        And job_mode_status        In  (iot_jobs_mode_status.fn_approvals_pending_all, iot_jobs_mode_status.fn_closure_approvals_pending_all)
                        And projno In (
                            Select
                                jrr.projno5
                            From
                                job_responsible_roles jrr
                            Where
                                empno In
                                (
                                    Select
                                        principal_empno
                                    From
                                        tcmpl_app_config.sec_module_delegate smd
                                    Where
                                        smd.on_behalf_empno = v_empno
                                    Union
                                    Select
                                        v_empno
                                    From
                                        dual
                                )
                                And job_responsible_role_id = c_job_sponsor_role_id
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                projno;
        Return c;
    End;

    Function get_principal_empno_4_approval(
        p_projno                  Varchar2,
        p_job_responsible_role_id Varchar2
    ) Return Varchar2 As
        v_principal_empno job_responsible_roles.empno%Type;
    Begin
        Select
            empno
        Into
            v_principal_empno
        From
            (
                Select
                    empno
                From
                    job_responsible_roles
                Where
                    job_responsible_role_id = Trim(p_job_responsible_role_id)
                    And projno5             = Trim(p_projno)

                Union All

                Select
                    empno
                From
                    job_responsible_roles_defaults
                Where
                    job_responsible_role_id = Trim(p_job_responsible_role_id)
            );

        Return v_principal_empno;
    Exception
        When Others Then
            Return Null;

    End;

    Function get_pm_approval_date(
        p_projno Varchar2
    ) Return Date As
        v_approval_date job_approvals_log.approval_date%Type;
    Begin
        Select 
            approval_date
        Into
            v_approval_date
        From
            ( 
            Select
                nvl(jal.approval_date, jm.form_date) approval_date        
            From
                job_approvals_log jal,
                jobmaster         jm
            Where
                jal.job_responsible_role_id(+) = c_r01
                And jal.revision(+)            = jm.revision
                And jal.projno(+)              = jm.projno
                And jm.projno                  = Trim(p_projno)
            Order by 1 Desc
            )
        Where rownum = 1;

        Return v_approval_date;
    Exception
        When Others Then
            Return Null;
    End;

End;
/
Grant Execute On "TIMECURR"."IOT_JOBS_APPROVALS_QRY" To "TCMPL_APP_CONFIG";