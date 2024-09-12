--------------------------------------------------------
--  DDL for Package Body IOT_GUEST_MEET_QRY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_GUEST_MEET_QRY" As

    Function get_guest_attendance(
        p_empno       Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(ss_guest_register.modified_on, 'dd-Mon-yyyy')           As applied_on,
                        ss_guest_register.app_no                                        As app_no,
                        to_char(ss_guest_register.meet_date, 'dd-Mon-yyyy')             As meeting_date,
                        to_char(ss_guest_register.meet_date, 'hh:mi AM')                As meeting_time,
                        ss_guest_register.host_name                                     As host_name,
                        ss_guest_register.guest_name                                    As guest_name,
                        ss_guest_register.guest_co                                      As guest_company,
                        ss_guest_register.meet_off                                      As meeting_place,
                        ss_guest_register.remarks                                       As remarks,
                        Case
                            When trunc(ss_guest_register.meet_date) > trunc(sysdate) Then
                                1
                            Else
                                0
                        End                                                             delete_allowed,
                        Row_Number() Over (Order By ss_guest_register.modified_on Desc) row_number,
                        Count(*) Over ()                                                total_row
                    From
                        ss_guest_register
                    Where
                        ss_guest_register.modified_by = nvl(p_empno, modified_by)
                        And trunc(ss_guest_register.meet_date) >= nvl(p_start_date, trunc(sysdate))
                        And trunc(ss_guest_register.meet_date) <= nvl(p_end_date, trunc(ss_guest_register.meet_date))
                    Order By ss_guest_register.meet_date, ss_guest_register.modified_on
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function fn_guest_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
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
        c       := get_guest_attendance(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_guest_attendance;

    Function fn_guest_attendance_admin(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
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
        c       := get_guest_attendance(
                       p_empno       => Null,
                       p_start_date  => p_start_date,
                       p_end_date    => p_end_date,
                       p_row_number  => p_row_number,
                       p_page_length => p_page_length
                   );
        Return c;
    End fn_guest_attendance_admin;

End iot_guest_meet_qry;
/

Grant Execute On "SELFSERVICE"."IOT_GUEST_MEET_QRY" To "TCMPL_APP_CONFIG";