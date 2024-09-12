Create Or Replace Package Body tcmpl_hr.mis_resigned_emp_qry As

    Function fn_all_emp_list_hr(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

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

        Open c For
            Select
                *
            From
                (
                    Select
                        r.key_id,
                        r.empno || ' - ' || pkg_common.fn_get_employee_name(r.empno) As employee_name,
                        a.doj,
                        a.grade,
                        (
                            Select
                                d.desg
                            From
                                vu_desgmast d
                            Where
                                d.desgcode = a.desgcode
                        )                                                            designation,
                        a.parent || ' - ' || (
                            Select
                                cc.name
                            From
                                vu_costmast cc
                            Where
                                cc.costcode = a.parent
                        )                                                            department,
                        r.emp_resign_date,
                        r.hr_receipt_date,
                        r.date_of_relieving,
                        r.emp_resign_reason,
                        r.primary_reason,
                        r.additional_feedback,
                        r.exit_interview_complete,
                        To_Number(Trim(to_char(r.percent_increase)))                 percent_increas,
                        r.resign_status_code || ' - ' || s.resign_status_desc        resign_st,
                        Row_Number() Over (Order By r.date_of_relieving Desc)        row_number,
                        Count(*) Over ()                                             total_row
                    From
                        vu_emplmast            a,
                        mis_resigned_emp       r,
                        mis_mast_resign_status s
                    Where
                        a.empno                  = r.empno(+)
                        And r.resign_status_code = s.resign_status_code                        
                        And 
                         (
                            upper(r.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                         )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Function fn_emp_list_dept(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

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

        Open c For
            Select
                *
            From
                (
                    Select
                        key_id,
                        empno,
                        emp_resign_date,
                        hr_receipt_date,
                        date_of_relieving,
                        emp_resign_reason,
                        primary_reason,
                        additional_feedback,
                        exit_interview_complete,
                        percent_increase,
                        resign_status_code,
                        Row_Number() Over (Order By empno) row_number,
                        Count(*) Over ()                   total_row
                    From
                        mis_resigned_emp
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Function fn_resigned_emp_hr_xl(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_invalid_date_range Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_invalid_date_range, -20002);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_start_date Is Null Or p_end_date Is Null Then
            raise_application_error(-20002, 'Invalid date range');
            Return Null;
        End If;
        If p_start_date > p_end_date Then
            raise_application_error(-20002, 'Invalid date range');
            Return Null;
        End If;

        Open c For
            With
                resign_reason As(
                    Select
                        resign_reason_type, resign_reason_desc
                    From
                        mis_mast_resign_reason_types
                )
            Select
                e.empno,
                e.name,
                e.parent                               dept,
                e.emptype,
                pkg_common.fn_get_dept_name(e.parent)  dept_name,
                e.grade,
                d.desg                                 designation,
                e.doj,
                r.emp_resign_date,
                r.hr_receipt_date,
                to_char(r.emp_resign_date, 'Mon-yyyy') resign_month,
                e.dol,
                r.date_of_relieving,
                r.emp_resign_reason,
                r.primary_reason,
                pr.resign_reason_desc                  primary_resign_desc,
                r.secondary_reason,
                sr.resign_reason_desc                  secondary_resign_desc,
                r.additional_feedback,
                To_Number(to_char(r.percent_increase)) percent_increase,
                r.moving_to_location,
                r.current_location,
                l.loc_desc                             curren_location_desc,
                Case r.exit_interview_complete
                    When ok Then
                        'Yes'
                    Else
                        'No'
                End                                    exit_interview_status,
                r.resign_status_code,
                rs.resign_status_desc,
                r.commitment_on_rollback,
                r.actual_last_date_in_office,
                g.discipline,
                g.group1,
                g.group2
            From
                vu_emplmast              e,
                vu_desgmast              d,
                mis_resigned_emp         r,
                resign_reason            pr,
                resign_reason            sr,
                mis_dept_groups          g,
                mis_mast_cur_emp_res_loc l,
                mis_mast_resign_status   rs
            Where
                e.empno                  = r.empno
                And e.desgcode           = d.desgcode
                And r.primary_reason     = pr.resign_reason_type
                And r.resign_status_code = rs.resign_status_code
                And r.secondary_reason   = sr.resign_reason_type(+)
                And r.current_location   = l.loc_id(+)
                And e.parent             = g.costcode(+)
                And r.date_of_relieving Between p_start_date And p_end_date;
        Return c;
    End;

End;