--------------------------------------------------------
--  File created - Monday-October-04-2021   
--------------------------------------------------------
---------------------------
--Changed TYPE
--TYP_ROW_PUNCH_DATA
---------------------------
drop type TYP_ROW_PUNCH_DATA force;
CREATE OR REPLACE TYPE "TYP_ROW_PUNCH_DATA" As Object(
    empno                    Char(5),
    dd                       Varchar2(2),
    ddd                      Varchar2(3),
    punch_date               Date,
    shift_code               Varchar2(2),
    wk_of_year               Varchar2(2),
    first_punch              Varchar2(10),
    last_punch               Varchar2(10),
    penalty_hrs              Number,
    is_odd_punch             Number,
    is_ldt                   Number,
    is_sunday                Number,
    is_lwd                   Number,
    is_lc_app                Number,
    is_sleave_app            Number,
    is_absent                Number,
    sl_app_cntr              Number,
    ego                      Number,
    wrk_hrs                  Number,
    delta_hrs                Number,
    extra_hrs                Number,
    comp_off                 Number,
    last_day_cfwd_dhrs       Number,
    wk_sum_work_hrs          Number,
    wk_sum_delta_hrs         Number,
    wk_sum_extra_hrs         Number,
    wk_sum_comp_off          Number,
    wk_bfwd_delta_hrs        Number,
    wk_cfwd_delta_hrs        Number,
    wk_penalty_leave_hrs     Number,
    day_punch_count          Number,
    remarks                  Varchar2(100),
    str_wrk_hrs              Varchar2(6),
    str_delta_hrs            Varchar2(6),
    str_extra_hrs            Varchar2(6),
    str_wk_sum_work_hrs      Varchar2(6),
    str_wk_sum_delta_hrs     Varchar2(6),
    str_wk_bfwd_delta_hrs    Varchar2(6),
    str_wk_cfwd_delta_hrs    Varchar2(6),
    str_wk_penalty_leave_hrs Varchar2(6)
);
/
---------------------------
--Changed PACKAGE
--IOT_EMPLMAST
---------------------------
CREATE OR REPLACE PACKAGE "IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor);

    Procedure employee_details(p_empno        Varchar2,
                               p_name     Out Varchar2,
                               p_parent   Out Varchar2,
                               p_metaid   Out Varchar2,
                               p_personid Out Varchar2,
                               p_success  Out Varchar2,
                               p_message  Out Varchar2
    );
    Procedure employee_details_ref_cur(p_empno               Varchar2,
                                       p_out_emp_details Out Sys_Refcursor);

    Function fn_employee_details(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 default null
    ) Return Sys_Refcursor;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor;
End iot_emplmast;
/
---------------------------
--Changed PACKAGE
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_onduty_types_list_4_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor;

    Function fn_onduty_types_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_mngr(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

End iot_select_list_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_EMPLMAST
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor) As
    Begin

        Open p_out_emp_list For
            Select
                empno, name, parent, assign
            From
                ss_emplmast
            Where
                status     = 1
                And parent = p_dept;
    End employee_list_dept;

    Procedure employee_details(p_empno        Varchar2,
                               p_name     Out Varchar2,
                               p_parent   Out Varchar2,
                               p_metaid   Out Varchar2,
                               p_personid Out Varchar2,
                               p_success  Out Varchar2,
                               p_message  Out Varchar2
    ) As
    Begin
        Select
            name, parent, metaid, personid
        Into
            p_name, p_parent, p_metaid, p_personid
        From
            ss_emplmast
        Where
            empno = p_empno;
        p_success := 'OK';
        p_message := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End employee_details;

    Procedure employee_details_ref_cur(p_empno               Varchar2,
                                       p_out_emp_details Out Sys_Refcursor) As
    Begin
        Open p_out_emp_details For
            Select
                name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = p_empno;
    End;
    /*
        Function fn_employee_details_ref(p_empno         Varchar2,
                                         p_rownum In Out Number) Return Sys_Refcursor
        As
            c Sys_Refcursor;
        Begin
            Open c For
                Select
                    name, parent, metaid, personid, p_rownum
                From
                    ss_emplmast
                Where
                    empno = p_empno;
            p_rownum := -1;
            Return c;
        End;
    */
    Function fn_employee_details(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor
    As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_empno              Varchar2(5);
    Begin

        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_person_id(p_person_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

        End If;
        Open c For
            Select
                empno, name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = v_empno;

        Return c;
    End;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor
    As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno, name, parent, metaid, personid
            From
                ss_emplmast
            Where
                status = 1;
        --parent     = p_dept
        --And status = 1;
        --p_rownum := -1;
        Return c;
    End;
End iot_emplmast;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                leavetype   data_value_field,
                description data_text_field
            From
                ss_leavetype
            Where
                is_active = 1;
        Return c;
    End fn_leave_type_list;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'None'          data_value_field,
                'Head Of Dept.' data_text_field
            From
                dual
            Union
            Select
                a.empno data_value_field,
                b.name  data_text_field
            From
                ss_lead_approver a,
                ss_emplmast      b
            Where
                a.empno      = b.empno
                And a.parent In
                (
                    Select
                        e.assign
                    From
                        ss_emplmast e
                    Where
                        e.personid = p_person_id
                )
                And b.status = 1;
        Return c;
    End;

    Function fn_onduty_types_list_4_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                type        data_value_field,
                description data_text_field
            From
                ss_ondutymast
            Where
                is_active    = 1
                And group_no = p_group_no
            Order By
                sort_order;

        Return c;
    End;
    Function fn_onduty_types_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                type        data_value_field,
                description data_text_field
            From
                ss_ondutymast
            Where
                group_no = p_group_no
            Order By
                sort_order;

        Return c;
    End;

    Function fn_employee_list_4_hr(
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
            Order By
                empno;

        Return c;
    End;

    Function fn_employee_list_4_mngr(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_mngr_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_mngr_empno := get_empno_from_person_id(p_person_id);
        If v_mngr_empno = 'ERRRR' Then
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
                status   = 1
                And mngr = v_mngr_empno
            Order By
                empno;

        Return c;
    End;

End iot_select_list_qry;
/
---------------------------
--Changed FUNCTION
--TO_HRS
---------------------------
CREATE OR REPLACE FUNCTION "TO_HRS" (v_min In Number) Return Varchar2 Is
    v_retval  Varchar2(10);
    v_minutes Number;
Begin
    If nvl(v_min, 0) = 0 Then
        Return '';
    End If;

    If v_min < 0 Then
        v_minutes := v_min * -1;
    Else
        v_minutes := v_min;
    End If;
    v_retval := to_char(floor(nvl(v_minutes, 0) / 60));
    If length(v_retval) < 2 Then
        v_retval := lpad(v_retval, 2, '0');
    End If;
    v_retval := v_retval || ':' || lpad(to_char(Mod(nvl(v_minutes, 0), 60)), 2, '0');
    if v_min < 0 then
        v_retval := '-' || v_retval;
    end if;
    Return v_retval;
End;
/
