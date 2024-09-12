create or replace Package Body "TIMECURR"."IOT_JOBS_REPORTS" AS

  Function fn_jobs_list_report(
        p_person_id      Varchar2,
        p_meta_id        Varchar2        
    ) Return Sys_Refcursor as
    c                    Sys_Refcursor;
    v_empno              Varchar2(5);
    e_employee_not_found Exception;
    Pragma exception_init(e_employee_not_found, -20001);
  begin
    v_empno := get_empno_from_meta_id(p_meta_id);
    If v_empno = 'ERRRR' Then
        Raise e_employee_not_found;
        Return Null;
    End If;
    
    Open c For
        select 
            projno,
            tcmno,
            short_desc,
            initcap(hr_pkg_common.get_employee_name(pm_empno))                      AS "Pm_name",
            initcap(hr_pkg_common.get_employee_name(dirvp_empno))                   AS "Js_name",	
            to_char(form_date,'dd-Mon-yyyy')                                        AS "Form_date",	
            to_char(job_open_date, 'dd-Mon-yyyy')                                   AS "Job_open_date",
            to_char(closing_date_rev1, 'dd-Mon-yyyy')                               AS "Closing_date_rev",
            to_char(actual_closing_date, 'dd-Mon-yyyy')                             AS "Actual_closing_date",
            iot_jobs_general.get_job_type_name(type_of_job)                         AS "Type_of_job",	
            iot_jobs_general.get_job_status_name(job_mode_status)                   AS "Job_mode_status",	
            iot_jobs_general.get_plant_type_name(plant_type)                        AS "Plant_type",
            iot_jobs_general.get_business_line_name(business_line)                  AS "Business_line",	
            iot_jobs_general.get_sub_business_line_name(sub_business_line)          AS "Sub_business_line",	
            iot_jobs_general.get_scope_of_work_name(scope_of_work)                  AS "Scope_of_work",
            iot_jobs_general.get_contract_name(contract_type)                       AS "Contract_type",	
            iot_jobs_general.get_country_name(country)                              AS "Country",	
            client_name                                                             AS "Client_name",	
            iot_jobs_general.get_invoicing_grp_name2(nvl(invoicing_grp_company, '')) AS "Invoicing_grp_company",	
            nvl(approved_vpdir, '')                                                 AS "Job_sponsor",	
            nvl(approved_dirop, '')                                                 AS "Cmd",	
            nvl(approved_amfi, '')                                                  AS "Afc"
        from 
            jobmaster
        --where 
        --    iot_jobs_qry.fn_get_proj_status(projno) = 1
        order by 
            projno;
    Return c;
  end fn_jobs_list_report;

END IOT_JOBS_REPORTS;

/
Grant Execute On "TIMECURR"."IOT_JOBS_GENERAL" To "TCMPL_APP_CONFIG";