Create Or Replace Package Body "SELFSERVICE"."IOT_SWP_DMS_REP_QRY" As
    e_employee_not_found Exception;
    Pragma exception_init(e_employee_not_found, -20001);

    Function fn_non_sws_emp_athome(
        p_hod_sec_empno Varchar2,
        p_is_admin      Boolean,
        p_row_number    Number,
        p_page_length   Number
    ) Return Sys_Refcursor As
        v_query Varchar2(6500);
        c       Sys_Refcursor;
    Begin
        v_query := c_query_non_sws_emp_home;
        If p_is_admin Then
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', '');
        Else
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', c_assign_sub_query);
        End If;
        Open c For v_query Using p_hod_sec_empno, p_row_number, p_page_length;
        Return c;
    End;

    Function fn_non_sws_emp_athome_4hodsec(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c               Sys_Refcursor;
        v_hod_sec_empno Varchar2(5);
    Begin

        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        c               := fn_non_sws_emp_athome(
                               p_hod_sec_empno => v_hod_sec_empno,
                               p_is_admin      => false,
                               p_row_number    => p_row_number,
                               p_page_length   => p_page_length
                           );
        /*
                Open c For
                    Select
                        *
                    From
                        (
                            Select
                                a.empno                                   As empno,
                                a.name                                    As employee_name,
                                a.parent                                  As parent,
                                a.emptype                                 As emptype,
                                a.grade                                   As emp_grade,
                                a.is_swp_eligible                         As is_swp_eligible,
                                a.is_laptop_user                          As is_laptop_user,
                                a.email                                   As emp_email,
                                iot_swp_common.get_desk_from_dms(a.empno) As deskid,
                                a.present_count                           As present_count,
                                Row_Number() Over (Order By parent)       As row_number,
                                Count(*) Over ()                          As total_row
                            From
                                (

                                    Select
                                        *
                                    From
                                        (
                                            Select
                                                empno,
                                                name,
                                                parent,
                                                grade,
                                                emptype,
                                                is_swp_eligible,
                                                is_laptop_user,
                                                email,
                                                Sum(is_present) present_count
                                            From
                                                (
                                                    With
                                                        dates As (
                                                            Select
                                                                d_date
                                                            From
                                                                (
                                                                    Select
                                                                        dd.*
                                                                    From
                                                                        ss_days_details dd
                                                                    Where
                                                                        dd.d_date Between sysdate - 14 And sysdate
                                                                        And dd.d_date Not In (
                                                                            Select
                                                                                holiday
                                                                            From
                                                                                ss_holidays
                                                                            Where
                                                                                holiday Between sysdate - 14 And sysdate
                                                                        )
                                                                    Order By d_date Desc
                                                                )
                                                            Where
                                                                Rownum < 7

                                                        )
                                                    Select
                                                        a.*, iot_swp_common.fn_is_present_4_swp(empno, dates.d_date) is_present
                                                    From
                                                        (
                                                            Select
                                                                *
                                                            From
                                                                (

                                                                    Select
                                                                        e.empno,
                                                                        e.name,
                                                                        e.parent,
                                                                        e.grade,
                                                                        e.emptype,
                                                                        iot_swp_common.is_emp_eligible_for_swp(e.empno) is_swp_eligible,
                                                                        iot_swp_common.is_emp_laptop_user(e.empno)      is_laptop_user,
                                                                        e.email
                                                                    From
                                                                        ss_emplmast e
                                                                    Where
                                                                        e.status = 1
                                                                        And e.assign In (
                                                                            Select
                                                                                parent
                                                                            From
                                                                                ss_user_dept_rights
                                                                            Where
                                                                                empno = v_hod_sec_empno
                                                                            Union

                                                                            Select
                                                                                costcode
                                                                            From
                                                                                ss_costmast
                                                                            Where
                                                                                hod = v_hod_sec_empno
                                                                        )

                                                                )
                                                            Where
                                                                (
                                                                    is_swp_eligible != 'OK'
                                                                    Or is_laptop_user = 0
                                                                    Or emptype In ('S')
                                                                )
                                                                And emptype Not In ('O')
                                                        ) a, dates
                                                )
                                            Group By empno, name, parent, grade, emptype, is_swp_eligible, is_laptop_user, email
                                            Order By parent
                                        )
                                    Where
                                        present_count < 3

                                ) a
                        )
                    Where
                        row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                        */
        Return c;
    End;

    Function fn_non_sws_emp_athome_4admin(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c             Sys_Refcursor;
        v_admin_empno Varchar2(5);
    Begin

        v_admin_empno := get_empno_from_meta_id(p_meta_id);
        If v_admin_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        c             := fn_non_sws_emp_athome(
                             p_hod_sec_empno => Null,
                             p_is_admin      => true,
                             p_row_number    => p_row_number,
                             p_page_length   => p_page_length
                         );

        Return c;
    End;

    Function fn_deskallocation_swp(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;

    Begin
        Open c For
            Select
                deskid,
                office,
                floor,
                wing,
                cabin,
                empno1,
                initcap(name1)                                              As name1,
                userid1,
                dept1,
                grade1,
                desg1,
                shift1,
                email1,
                empno2,
                initcap(name2)                                              As name2,
                userid2,
                dept2,
                grade2,
                desg2,
                shift2,
                email2,
                compname,
                computer,
                pcmodel                                                     As pc_model,
                monitor1,
                monmodel1                                                   As monitor1_model,
                monitor2,
                monmodel2                                                   As monitor2_model,
                telephone,
                telmodel                                                    As tel_model,
                printer,
                printmodel                                                  As printer_model,
                docstn                                                      As docking_station,
                docstnmodel                                                 As docking_station_model,
                dms.dmsv2.get_ram(computer)                                 As pc_ram,
                nvl(dms.dmsv2.get_gcard(computer), '-')                     As graphic_card,

                iot_swp_common.fn_get_emp_pws_planning(empno1)              As emp1_pws,
                iot_swp_common.get_emp_is_eligible_4swp(empno1)             As emp1_is_swp_eligible,

                selfservice.iot_swp_common.fn_get_emp_pws_planning(empno2)  As emp2_pws,
                selfservice.iot_swp_common.get_emp_is_eligible_4swp(empno2) As emp2_is_swp_eligible,

                selfservice.iot_swp_common.get_emp_projno_desc(empno1)      As emp1_project,
                selfservice.iot_swp_common.get_emp_projno_desc(empno2)      As emp2_project

            From
                desmas_allocation
            Order By
                deskid;
        Return c;
    End;

End iot_swp_dms_rep_qry;