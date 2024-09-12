--------------------------------------------------------
--  File created - Tuesday-April-26-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list_for_smart(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_desk_list_for_office(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date Default Null,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_dept_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_grade_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4desk_plan(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4wp_details(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_swp_type_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor;

   Function fn_emp_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

End iot_swp_select_list_qry;
/
---------------------------
--Changed PACKAGE BODY
--SWP_VACCINEDATE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_VACCINEDATE" As

    Procedure sendmail(
        param_empno Varchar2
    ) As

        v_email         ss_emplmast.email%Type;
        v_name          ss_emplmast.name%Type;
        v_email_body    Varchar2(4000);
        v_email_subject Varchar2(200);
        v_success       Varchar2(10);
        v_message       Varchar2(1000);
    Begin
        Select
            name,
            email
        Into
            v_name,
            v_email
        From
            ss_emplmast
        Where
            empno = param_empno;

        v_email_subject := 'Vaccine Date deletion.';
        v_email_body    := 'Dear User,

Your input in Employee Vaccine Dates has been deleted as it was for a future date.

Please input your actual 1st vaccine date after taking the 1st jab and follow the same for the 2nd vaccine date.';
        v_email_body    := v_email_body || chr(13) || chr(10) || chr(13) || chr(10);

        v_email_body    := v_email_body || 'Thanks,' || chr(13) || chr(10);

        v_email_body    := v_email_body || 'This is an automated TCMPL Mail.';
        If v_email Is Not Null Then
            send_mail_from_api(
                p_mail_to      => v_email,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_email_subject,
                p_mail_body    => v_email_body,
                p_mail_profile => 'SELFSERVICE',
                p_mail_format  => 'Text',
                p_success      => v_success,
                p_message      => v_message
            );
        End If;

    End sendmail;

    Procedure add_new(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_first_jab    Date,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            modified_on,
            modified_by
        )
        Values (
            v_empno,
            param_vaccine_type,
            param_first_jab,
            'KO',
            param_second_jab,
            'KO',
            sysdate,
            v_empno
        );

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_new;

    Procedure add_emp_vaccine_dates(
        param_win_uid          Varchar2,
        param_vaccine_type     Varchar2,
        param_for_empno        Varchar2,
        param_first_jab_date   Date,
        param_second_jab_date  Date Default Null,
        param_booster_jab_date Date Default Null,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As
        v_empno                Char(5);
        v_second_jab_by_office Varchar2(2);
    Begin
        v_empno                := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;
        v_second_jab_by_office := Case
                                      When param_second_jab_date Is Null Then
                                          Null
                                      Else
                                          'KO'
                                  End;
        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            booster_jab_date,
            modified_on,
            modified_by
        )
        Values (
            param_for_empno,
            param_vaccine_type,
            param_first_jab_date,
            'KO',
            param_second_jab_date,
            'KO',
            param_booster_jab_date,
            sysdate,
            v_empno
        );

        Commit;
        param_success          := 'OK';
        param_message          := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_emp_vaccine_dates;

    Procedure update_emp_second_jab(
        param_win_uid         Varchar2,
        param_for_empno       Varchar2,
        param_second_jab_date Date,

        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        by_empno Char(5);
    Begin
        by_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            is_jab2_by_office = 'KO',

            modified_on = sysdate,
            modified_by = by_empno
        Where
            empno = param_for_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_emp_second_jab;

    Procedure update_emp_jab(
        param_win_uid          Varchar2,
        param_for_empno        Varchar2,
        param_second_jab_date  Date,
        param_booster_jab_date Date,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As
        by_empno Char(5);
    Begin
        by_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            booster_jab_date = param_booster_jab_date,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = by_empno
        Where
            empno = param_for_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_emp_jab;

    Procedure update_self_jab(
        param_win_uid          Varchar2,

        param_second_jab_date  Date,
        param_booster_jab_date Date,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            booster_jab_date = param_booster_jab_date,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = v_empno
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_self_jab;

    Procedure update_second_jab(
        param_win_uid     Varchar2,
        param_second_jab  Date,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = v_empno
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_second_jab;

    Procedure update_vaccine_type(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            vaccine_type = param_vaccine_type,
            jab2_date = param_second_jab,
            modified_on = sysdate
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_vaccine_type;

    Procedure delete_emp_vaccine_dates(
        param_empno       Varchar2,
        param_hr_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        --v_empno          Char(5);
        v_hr_empno Char(5);
        v_count    Number;
    Begin
        v_hr_empno    := swp_users.get_empno_from_win_uid(param_win_uid => param_hr_win_uid);
        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving HR EMP Detials';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno      = param_empno
            And status = 1;

        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Select Employee details not found.';
            Return;
        End If;

        Delete
            From swp_vaccine_dates
        Where
            empno = param_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Jab info could not be updated.';
            Return;
        End If;

        Commit;
        sendmail(param_empno);
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End delete_emp_vaccine_dates;

End swp_vaccinedate;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list_for_smart(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
        c_permanent_desk  Constant Number := 1;
    Begin
        --v_empno := get_empno_from_meta_id(p_meta_id);
        Open c For
            Select
                deskid                             data_value_field,
                rpad(deskid, 7, ' ') || ' | ' ||
                rpad(office, 5, ' ') || ' | ' ||
                rpad(nvl(floor, ' '), 6, ' ') || ' | ' ||
                rpad(nvl(wing, ' '), 5, ' ') || ' | ' ||
                rpad(nvl(bay, ' '), 9, ' ') || ' | ' ||
                rpad(nvl(work_area, ' '), 15, ' ') As data_text_field
            From
                dm_vu_desk_list
            Where
                office Not Like 'Home%'
                And office Like 'MOC1%'
                And nvl(cabin, 'X') <> 'C'
                --and nvl(desk_share_type,-10) = c_permanent_desk --Permanent
                And Trim(deskid) Not In (
                    Select
                        deskid
                    From
                        swp_smart_attendance_plan
                    Where
                        trunc(attendance_date) = trunc(p_date)
                        And empno != Trim(p_empno)
                    Union
                    Select
                        deskid
                    From
                        dm_vu_emp_desk_map_swp_plan
                )
            Order By
                office;

        Return c;
    End fn_desk_list_for_smart;

    Function fn_desk_list_for_office(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date Default Null,
        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        c_permanent_desk  Constant Number := 1;
        timesheet_allowed Number;
    Begin
        Open c For

            Select
                deskid                             data_value_field,
                rpad(deskid, 7, ' ') || ' | ' ||
                rpad(office, 5, ' ') || ' | ' ||
                rpad(nvl(floor, ' '), 6, ' ') || ' | ' ||
                rpad(nvl(wing, ' '), 5, ' ') || ' | ' ||
                rpad(nvl(bay, ' '), 9, ' ') || ' | ' ||
                rpad(nvl(work_area, ' '), 15, ' ') As data_text_field
            From
                dms.dm_deskmaster dms
            Where
                office Not Like 'Home%'
                And nvl(cabin, 'X') <> 'C'
                --and nvl(desk_share_type,-10) = c_permanent_desk --Permanent
                And dms.deskid Not In
                (
                    Select
                    Distinct dmst.deskid
                    From
                        dm_vu_emp_desk_map_swp_plan dmst
                )
                And dms.deskid Not In
                (
                    Select
                    Distinct swp_wfm.deskid
                    From
                        swp_smart_attendance_plan swp_wfm
                    Where
                        trunc(swp_wfm.attendance_date) >= trunc(sysdate)
                )
            Order By
                office,
                deskid;

        Return c;
    End fn_desk_list_for_office;

    Function fn_employee_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status = 1
                And assign In (
                    Select
                        parent
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_empno
                    Union
                    Select
                        costcode
                    From
                        ss_costmast
                    Where
                        hod = v_empno
                )
                And assign Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_emp_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status = 1
                And assign In (
                    Select
                        parent
                    From
                        ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                    Where
                        empno        = v_empno
                        And a.parent = b.assign
                    Union
                    Select
                        costcode
                    From
                        ss_costmast                                   a, swp_include_assign_4_seat_plan b
                    Where
                        hod            = v_empno
                        And a.costcode = b.assign
                )
                And assign Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode In (
                    Select
                        parent
                    From
                        ss_user_dept_rights a
                    Where
                        empno = v_empno
                    Union
                    Select
                        costcode
                    From
                        ss_costmast a
                    Where
                        hod = v_empno
                )
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                --And noofemps > 0
            Order By
                costcode;

        Return c;
    End;

    Function fn_dept_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode In (
                    Select
                        parent
                    From
                        ss_user_dept_rights            a,
                        swp_include_assign_4_seat_plan b
                    Where
                        empno        = v_empno
                        And a.parent = b.assign
                    Union
                    Select
                        costcode
                    From
                        ss_costmast                    a,
                        swp_include_assign_4_seat_plan b
                    Where
                        hod            = v_empno
                        And a.costcode = b.assign
                )
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                --And noofemps > 0
            Order By
                costcode;

        Return c;
    End;

    Function fn_employee_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                a.emptype                     data_value_field,
                a.emptype || ' - ' || empdesc data_text_field
            From
                ss_vu_emptypes      a,
                swp_include_emptype b
            Where
                a.emptype = b.emptype
            Order By
                empdesc;
        Return c;
    End;

    Function fn_grade_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                grade_id   data_value_field,
                grade_desc data_text_field
            From
                ss_vu_grades
            Where
                grade_id <> '-'
            Order By
                grade_desc;
        -- select grade_id data_value_field, grade_desc data_text_field 
        -- from timecurr.hr_grade_master order by grade_desc;
        Return c;
    End;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
            Distinct
                proj_no                  data_value_field,
                proj_no || ' - ' || name data_text_field
            From
                ss_projmast
            Where
                active = 1
            Order By
                proj_no;

        Return c;
    End;

    Function fn_costcode_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
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
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                --And noofemps > 0
            Order By
                costcode;
        Return c;
    End;

    Function fn_emp_list4desk_plan(
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
                ss_emplmast
            Where
                status = 1
                And emptype In(
                    Select
                        emptype
                    From
                        swp_include_emptype
                )
                And assign Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                );
        Return c;
    End;

    Function fn_emp_list4wp_details(
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
                ss_emplmast
            Where
                status = 1
                And assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                )
            Order By
                empno;
        Return c;
    End;

    Function fn_swp_type_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                  Sys_Refcursor;
        v_exclude_swp_type Number;
    Begin
        If p_exclude_sws_type = 'OK' Then
            v_exclude_swp_type := 2;
        Else
            v_exclude_swp_type := -1;
        End If;
        Open c For
            Select
                to_char(type_code) data_value_field,
                type_desc data_text_field
            From
                swp_primary_workspace_types
            Where
                type_code <> v_exclude_swp_type;
        Return c;
    End;

      Function fn_emp_list_4_admin(
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
                ss_emplmast
            Where
                status = 1
            order by empno    ;
        Return c;
    End;

End iot_swp_select_list_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_MAIL
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_MAIL" As
    c_ows_code Constant Number := 1;
    c_sws_code Constant Number := 2;

    Function fn_get_prev_working_day Return Date As
        v_date  Date := sysdate;
        v_count Number;
    Begin
        Loop
            v_date := v_date - 1;
            Select
                Count(*)
            Into
                v_count
            From
                ss_holidays
            Where
                holiday = v_date;
            If v_count = 0 Then
                Exit;
            End If;
        End Loop;
        Return v_date;
    End;

    Procedure sp_send_to_ows_absent_emp As

        Cursor cur_ows_absent_emp(cp_date Date) Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        empno,
                        name                                           employee_name,
                        replace(email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                a.empno,
                                e.name,
                                e.email,
                                iot_swp_common.fn_is_present_4_swp(a.empno, cp_date) is_swp_present
                            From
                                swp_primary_workspace       a,
                                ss_emplmast                 e,
                                swp_primary_workspace_types wt,
                                swp_include_emptype         et
                            Where
                                trunc(a.start_date)     = (
                                        Select
                                            Max(trunc(start_date))
                                        From
                                            swp_primary_workspace b
                                        Where
                                            b.empno = a.empno
                                            And b.start_date <= sysdate
                                    )
                                And a.empno             = e.empno
                                And e.emptype           = et.emptype
                                And status              = 1
                                And a.primary_workspace = wt.type_code
                                And a.primary_workspace = c_ows_code
                                And e.email Is Not Null
                                And e.empno Not In ('04132', '04600', '04484')
                                And e.grade <> 'X1'
                                And e.doj <= cp_date
                        )
                    Where
                        is_swp_present = 0
                    Order By empno
                )
            Group By
                group_id;

        --
        Type typ_tab_ows_absent_emp Is
            Table Of cur_ows_absent_emp%rowtype;
        tab_ows_abent_emp typ_tab_ows_absent_emp;

        v_count           Number;
        v_mail_csv        Varchar2(2000);
        v_subject         Varchar2(1000);
        v_msg_body        Varchar2(2000);
        v_success         Varchar2(1000);
        v_message         Varchar2(500);
        v_absent_date     Date;
    Begin

        v_absent_date := trunc(sysdate - 1);

        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = v_absent_date;

        If v_count > 0 Then
            Return;
        End If;

        v_msg_body    := v_mail_body_ows_absent;
        v_subject     := 'SWP : Office Workspace allocated but not reporting to office';
        For email_csv_row In cur_ows_absent_emp(v_absent_date)
        Loop
            v_mail_csv := email_csv_row.email_csv_list;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'SWP',
                p_message_type => v_success,
                p_message_text => v_message
            );

            /*
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );
            */
        End Loop;
    End;

End;
/
