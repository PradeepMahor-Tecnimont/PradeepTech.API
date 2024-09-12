--------------------------------------------------------
--  DDL for Package Body PKG_DG_SELECT_QRY
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."PKG_DG_SELECT_QRY" As

    Function fn_dg_site_master_select_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                a.key_id                                data_value_field,
                a.site_name || ' - ' || a.site_location data_text_field
            From
                dg_site_master a
            Where
                a.is_active = 1
            Order By
                a.site_name;
        Return c;
    End fn_dg_site_master_select_list;

    Function fn_dg_jobgroup_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                job_group_code data_value_field,
                job_group      data_text_field
            From
                vu_hr_jobgroup_master
            Order By
                job_group;
        Return c;
    End fn_dg_jobgroup_list;

    Function fn_dg_jobdiscipline_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                jobdiscipline_code data_value_field,
                jobdiscipline      data_text_field
            From
                vu_hr_jobdiscipline_master
            Order By
                jobdiscipline;
        Return c;
    End fn_dg_jobdiscipline_list;

    Function fn_dg_jobtitle_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                jobtitle_code data_value_field,
                jobtitle      data_text_field
            From
                vu_hr_jobtitle_master
            Order By
                jobtitle;
        Return c;
    End fn_dg_jobtitle_list;


Function fn_hr_annual_eval_pending_dept_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        v_start_from_date Date := To_Date ( '2023-01-01', 'yyyy-MM-dd' );
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                costcode                  As data_value_field,
                costcode || ' - ' || name As data_text_field
              From
                vu_costmast
             Where
                costcode In (
                    Select Distinct
                        a.assign
                      From
                        vu_emplmast        a
                          Left Outer Join dg_annu_evaluation b
                        On a.empno = b.empno
                     Where
                            a.status = 1
                            And a.emptype = 'R'
                            And nvl(b.hr_approval,'not_ok') = 'not_ok'
                           And ( a.doj >= v_start_from_date and (add_months(
                                     a.doj,
                                     10
                                  ) + 15) <= trunc(sysdate) )
                           And a.grade In (
                            Select grade From dg_mid_evaluation_grade c
                        )
                )
             Order By
                costcode;
        Return c;
    End fn_hr_annual_eval_pending_dept_list;
End pkg_dg_select_qry;