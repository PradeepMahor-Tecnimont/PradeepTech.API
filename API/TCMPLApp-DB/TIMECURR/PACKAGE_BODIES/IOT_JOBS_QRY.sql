Create Or Replace Package Body "TIMECURR"."IOT_JOBS_QRY" As

    Function fn_get_rev_close_date(
        p_projno Varchar2
    ) Return Date As
        v_exp_date  Date;
        v_rev1_date Date;
        v_rev2_date Date;
        v_out_date  Date;
    Begin
        Select
            expected_closing_date, closing_date_rev1, closing_date_rev2
        Into
            v_exp_date, v_rev1_date, v_rev2_date
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno);

        If v_exp_date Is Not Null Then
            v_out_date := v_exp_date;
        End If;
        If v_rev1_date Is Not Null Then
            v_out_date := v_rev1_date;
        End If;
        If v_rev2_date Is Not Null Then
            v_out_date := v_rev2_date;
        End If;

        Return v_out_date;
    End fn_get_rev_close_date;

    Function fn_get_proj_status(
        p_projno Varchar2
    ) Return Number As
        v_actual_date   Date;
        v_approved_amfi Number;
        v_status        Number := 0;
    Begin
        Select
            actual_closing_date,
            nvl(approved_amfi, 0)
        Into
            v_actual_date,
            v_approved_amfi
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno);

        If v_actual_date Is Null Then
            v_status := 1;
        Else
            If v_approved_amfi = 1 Then
                v_status := 0;
            End If;
        End If;
        Return v_status;
    End fn_get_proj_status;

    Function fn_isdate(
        p_datestring Varchar2
    ) Return Number As
        v_date Date;
    Begin
        v_date := To_Date(p_datestring);
        Return 1;
    Exception
        When Others Then
            Return 0;
    End fn_isdate;

    Function fn_jobs_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_is_active      Number Default 1,
        p_generic_search Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_isdate             Boolean := false;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
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
                        tcmno,
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
                        iot_jobs_qry.fn_get_proj_status(projno) = p_is_active
                        And
                        (
                            upper(projno) Like upper('%' || p_generic_search || '%') Or
                            upper(pm_empno) Like upper('%' || p_generic_search || '%') Or
                            upper(short_desc) Like upper('%' || p_generic_search || '%') Or
                            upper(tcmno) Like upper('%' || p_generic_search || '%') Or
                            upper(iot_jobs_general.get_job_status_name(job_mode_status)) Like upper('%' || p_generic_search ||
                            '%') Or
                            upper(hr_pkg_common.get_employee_name(pm_empno)) Like upper('%' || p_generic_search || '%')
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                projno;
        Return c;
    End fn_jobs_list;

    Function fn_isbudget_attached(
        p_projno Varchar2
    ) Return Number As
        v_budget_attached Number;
    Begin
        Select
            nvl(budget_attached, 0)
        Into
            v_budget_attached
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno);

        Return v_budget_attached;
    Exception
        When Others Then
            Return 0;
    End fn_isbudget_attached;

    Function fn_get_opening_month(
        p_projno Varchar2
    ) Return Varchar2 As
        v_opening_month Varchar2(6);
    Begin
        Select
            --to_char(regexp_replace(opening_month,'[/ ]',''))
            to_char(To_Date(to_char(regexp_replace(opening_month, '[/ ]', '')), 'yyyymm'), 'Mon-yyyy')
        Into
            v_opening_month
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno);

        Return v_opening_month;
    Exception
        When Others Then
            Return Null;
    End fn_get_opening_month;

    Function fn_job_budget_api(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_projno        Varchar2,
        p_openingmonth  Varchar2,
        p_is_export      Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_revision           jobmaster.revision%Type;        
        v_empno              Varchar2(5);
        v_processingmonth    Varchar2(6);
        v_min_yymm           Varchar2(6);
        v_db_open_month      Varchar2(6);
        v_open_month         Varchar2(6);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        -- DB opening month 
        Select
            trim(to_char(regexp_replace(opening_month, '[/ ]', '')))
        Into
            v_db_open_month
        From   
            jobmaster 
        Where 
            Trim(projno) = Trim(p_projno);
        
        -- processing month 
        Select 
            pros_month
        Into
            v_processingmonth
        From 
            tsconfig         
        Where 
            upper(username) = 'TIMECURR';       
        
        -- min yymm in budget
        select 
            min(yymm)
        Into
            v_min_yymm
        From
            job_budgtran
        Where
            trim(projno) = trim(p_projno);
                        
        -- cal open month        
        If p_is_export = '1' then
            v_open_month := v_min_yymm;
        Else            
            v_open_month := v_processingmonth;
                
            Update 
                jobmaster 
            Set 
                opening_month = trim(p_openingmonth) 
            Where   
                trim(projno) = trim(p_projno);            
        End If;       
               
        Select 
            revision
        Into 
            v_revision
        From 
            jobmaster 
        Where 
            trim(projno) = trim(p_projno);
            
        If v_revision = 0 Then
            Update 
                jobmaster 
            Set 
                opening_month = p_openingmonth 
            Where   
                trim(projno) = trim(p_projno);
        End If;
        
            
        Open c For
            select 
                j.projno,
                d.phase, 
                m.yymm,
                d.costcode,
                null costcodename,
                iot_jobs_qry.fn_initial_budget(j.projno, d.phase, m.yymm, d.costcode) As initial_budget,
                iot_jobs_qry.fn_revise_budget(j.projno, d.phase, m.yymm, d.costcode) As new_budget
            from 
                deptphase d, 
                job_proj_phase j,
                (
                    with date_ranges as (
                        select trunc(to_date( v_open_month || '01', 'yyyymmdd' )) start_date, 
                               trunc(iot_jobs_qry.fn_get_rev_close_date( projno )) end_date,
                               months_between( trunc(iot_jobs_qry.fn_get_rev_close_date( p_projno ) ), trunc (to_date( v_open_month || '01', 'yyyymmdd' )) ) months
                        from jobmaster where trim(projno) = trim(p_projno)
                    )
                    select to_char(add_months( start_date, level - 1 ), 'yyyymm') yymm 
                    from date_ranges
                    connect by level <= (
                        months_between(trunc(end_date), trunc (start_date) ) + 1            
                    )
                ) m
            where 
                trim(d.phase) = trim(j.phase_select) and 
                trim(j.projno) = trim(p_projno) and 
                d.isprimary = 1 
            order by d.phase, d.costcode, m.yymm;
                
        Return c;
    End fn_job_budget_api;

    Function fn_job_budget_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_projno         Varchar2,
        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
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
                        phase,
                        yymm,
                        costcode,
                        initbudg                                         As initial_budget,
                        revbudg                                          As new_budget,
                        Row_Number() Over (Order By yymm, costcode Desc) row_number,
                        Count(*) Over ()                                 total_row
                    From
                        job_budgtran
                    Where
                        projno = p_projno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_job_budget_list;

    Function fn_job_phases_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_projno    Varchar2
    ) Return Sys_Refcursor As
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
                pp.projno,
                pp.phase_select          phase,
                ps.description,
                pp.tmagrp,
                nvl(pp.block_booking, 0) block_booking,
                nvl(pp.block_ot, 0)      block_ot,
                Row_Number() Over (Order By
                        pp.phase_select) row_number,
                Count(*) Over ()         total_row
            From
                job_proj_phase pp,
                job_phases     ps
            Where
                pp.phase_select     = ps.phase
                And Trim(pp.projno) = Trim(p_projno)
            Order By
                phase;
        Return c;
    End fn_job_phases_list;

    Function fn_get_industry_name(
        p_industry Varchar2
    ) Return Varchar2 As
        v_industry_name Varchar2(35);
    Begin
        Select
            name || ' [ ' || industry || ' ] '
        Into
            v_industry_name
        From
            job_industry
        Where
            Trim(industry) = Trim(p_industry);
        Return v_industry_name;
    End fn_get_industry_name;

    Function fn_get_project_type_name(
        p_projtype Varchar2
    ) Return Varchar2 As
        v_project_type_name Varchar2(40);
    Begin
        Select
            contract_type || ' - ' || descr
        Into
            v_project_type_name
        From
            job_contract
        Where
            Trim(contract_type) = Trim(p_projtype);
        Return v_project_type_name;
    End fn_get_project_type_name;
    
    Function fn_initial_budget(
        p_projno    Varchar2,        
        p_phase     Varchar2,
        p_yymm      Varchar2,
        p_costcode  Varchar2
    ) Return Number as
        v_initial_budget     job_budgtran.initbudg%Type := 0;
    Begin
        Select                
            initbudg 
        Into
            v_initial_budget      
        From
            job_budgtran
        Where
            trim(projno) = trim(p_projno) And           
            trim(phase) = trim(p_phase) And
            trim(yymm) = trim(p_yymm) And
            trim(costcode) = trim(p_costcode);
                
        Return v_initial_budget;
    End fn_initial_budget;
    
    Function fn_revise_budget(
        p_projno    Varchar2,        
        p_phase     Varchar2,
        p_yymm      Varchar2,
        p_costcode  Varchar2
    ) Return Number as
        v_revise_budget     job_budgtran.revbudg%Type := 0;
     Begin
        Select                
            revbudg 
        Into
            v_revise_budget        
        From
            job_budgtran
        Where
            trim(projno) = trim(p_projno) And           
            trim(phase) = trim(p_phase) And
            trim(yymm) = trim(p_yymm) And
            trim(costcode) = trim(p_costcode);
                
        Return v_revise_budget;
    End fn_revise_budget;
    
    Procedure sp_job_main_detail(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,
        p_projno                     Varchar2,
        p_job_mode_status        Out Varchar2,
        p_form_mode              Out Varchar2,
        p_revision               Out Varchar2,
        p_form_date              Out Date,
        p_plant_progress_no      Out Varchar2,
        p_short_desc             Out Varchar2,
        p_company                Out Varchar2,
        p_company_name           Out Varchar2,
        p_job_type               Out Varchar2,
        p_job_type_name          Out Varchar2,
        p_isconsortium           Out Number,
        p_tcmno                  Out Varchar2,
        p_place                  Out Varchar2,
        p_country                Out Varchar2,
        p_country_name           Out Varchar2,
        p_scope_of_work          Out Varchar2,
        p_scope_of_work_name     Out Varchar2,
        p_loc                    Out Varchar2,
        p_state_name             Out Varchar2,
        p_plant_type             Out Varchar2,
        p_plant_type_name        Out Varchar2,
        p_business_line          Out Varchar2,
        p_business_line_name     Out Varchar2,
        p_sub_business_line      Out Varchar2,
        p_sub_business_line_name Out Varchar2,
        p_projtype               Out Varchar2,
        p_project_type_name      Out Varchar2,
        p_invoice_to_grp         Out Varchar2,
        p_invoice_to_grp_name    Out Varchar2,
        p_client                 Out Varchar2,
        p_contract_number        Out Varchar2,
        p_contract_date          Out Date,
        p_start_date             Out Date,
        p_rev_close_date         Out Date,
        p_exp_close_date         Out Date,
        p_actual_close_date      Out Date,
        p_pm_name                Out Varchar2,
        p_incharge_name          Out Varchar2,
        p_budget_attached        Out Number,
        p_opening_month          Out Varchar2,
        p_jobstatus              Out Number,
        p_is_legacy              Out Number,
        p_client_code            Out Varchar2,
        p_client_code_name       Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Number := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            j.job_mode_status,
            iot_jobs_general.get_job_status_name(j.job_mode_status),
            j.revision,
            to_char(j.form_date, 'dd-Mon-yyyy'),
            j.plant_progress_no,
            j.co,
            iot_jobs_general.get_company_name(j.co),
            j.type_of_job,
            iot_jobs_general.get_job_type_name(j.type_of_job),
            j.consortium_group,
            j.tcmno,
            j.location,
            j.country,
            iot_jobs_general.get_country_name(j.country),
            j.scope_of_work,
            iot_jobs_general.get_scope_of_work_name(j.scope_of_work),
            j.loc,
            iot_jobs_general.get_state_name(j.loc),
            j.short_desc,
            j.plant_type,
            iot_jobs_general.get_plant_type_name(j.plant_type),
            j.business_line,
            iot_jobs_general.get_business_line_name(j.business_line),
            j.sub_business_line,
            iot_jobs_general.get_sub_business_line_name(j.sub_business_line),
            j.contract_type,
            iot_jobs_general.get_contract_name(j.contract_type),
            nvl(j.invoicing_grp_company, ''),
            iot_jobs_general.get_invoicing_grp_name2(nvl(j.invoicing_grp_company, '')),
            j.client_name,
            j.loi_contract_no,
            to_char(j.loi_contract_date, 'dd-Mon-yyyy'),
            to_char(j.job_open_date, 'dd-Mon-yyyy'),
            to_char(j.closing_date_rev1, 'dd-Mon-yyyy'),
            to_char(j.expected_closing_date, 'dd-Mon-yyyy'),
            to_char(j.actual_closing_date, 'dd-Mon-yyyy'),
            initcap(hr_pkg_common.get_employee_name(j.pm_empno)) || ' [ ' || j.pm_empno || ' ]',
            initcap(hr_pkg_common.get_employee_name(j.incharge)) || ' [ ' || j.incharge || ' ]',
            nvl(j.budget_attached, 0),
            to_char(To_Date(to_char(regexp_replace(j.opening_month, '[/ ]', '')), 'yyyymm'), 'MON-yyyy'),
            iot_jobs_qry.fn_get_proj_status(j.projno),
            j.is_legacy,
            c.client,
            c.name
        Into
            p_job_mode_status,
            p_form_mode,
            p_revision,
            p_form_date,
            p_plant_progress_no,
            p_company,
            p_company_name,
            p_job_type,
            p_job_type_name,
            p_isconsortium,
            p_tcmno,
            p_place,
            p_country,
            p_country_name,
            p_scope_of_work,
            p_scope_of_work_name,
            p_loc,
            p_state_name,
            p_short_desc,
            p_plant_type,
            p_plant_type_name,
            p_business_line,
            p_business_line_name,
            p_sub_business_line,
            p_sub_business_line_name,
            p_projtype,
            p_project_type_name,
            p_invoice_to_grp,
            p_invoice_to_grp_name,
            p_client,
            p_contract_number,
            p_contract_date,
            p_start_date,
            p_rev_close_date,
            p_exp_close_date,
            p_actual_close_date,
            p_pm_name,
            p_incharge_name,
            p_budget_attached,
            p_opening_month,
            p_jobstatus,
            p_is_legacy,
            p_client_code,
            p_client_code_name
        From
            jobmaster j, clntmast c
        Where
          c.client(+) = j.client and
            Trim(j.projno) = Trim(p_projno);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_job_main_detail;

End iot_jobs_qry;
/
Grant Execute On "TIMECURR"."IOT_JOBS_QRY" To "TCMPL_APP_CONFIG";