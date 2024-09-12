--------------------------------------------------------
--  DDL for Package Body IOT_PRINT_LOG_QRY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_PRINT_LOG_QRY" As

    Function fn_past_7days_4_self_old(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return typ_self_7day_summary
        Pipelined
    Is

        tab_self_7day_summary typ_self_7day_summary;
        v_empno               Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        Open cur_self_7day_summary(v_empno);
        Loop
            Fetch cur_self_7day_summary Bulk Collect Into tab_self_7day_summary Limit 10;
            For i In 1..tab_self_7day_summary.count
            Loop
                Pipe Row(tab_self_7day_summary(i));
            End Loop;
            Exit When cur_self_7day_summary%notfound;
        End Loop;
        Close cur_self_7day_summary;
        Return;

    End;


    Function fn_past_7days_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    

        tab_self_7day_summary typ_self_7day_summary;
        v_empno               Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return null;
        End If;

        Open c for Select
            a.d_date,
            to_char(a.d_date, 'dd Mon') print_date,
            nvl(b.page_count, 0)        page_count
        From
            ss_days_details a,
            (
                Select
                    print_date,
                    Sum(pagecount) page_count
                From
                    ss_vu_print_log_pivot
                Where
                    empno = v_empno
                    And print_date Between sysdate - 8 And sysdate - 1
                Group By print_date
            )               b
        Where
            a.d_date = b.print_date(+)
            And a.d_date Between trunc(sysdate - 8) And trunc(sysdate - 1)
        Order By
            d_date Desc;
        return c;
    End;



    Function get_print_log_detailed_list(
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
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
                        empno                                   As emp_no,
                        to_char(print_date, 'dd-Mon-yyyy')      As print_date,
                        time                                    As print_time,
                        que_name                                As que_name,
                        file_name                               As file_name,
                        nvl(pagecount, 0)                       As page_count,
                        color                                   As color,
                        Row_Number() Over (Order By empno Desc) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_vu_print_log_pivot
                    Where
                        empno = p_empno
                        And print_date >= nvl(p_start_date, trunc(sysdate - 15))
                        And print_date <= nvl(p_end_date, trunc(sysdate + 1))
                    Order By print_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function fn_detailed_list_self(
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
        c       := get_print_log_detailed_list(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_detailed_list_self;

    Function fn_detailed_list_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_self_empno         Varchar2(5);
        v_req_for_self       Varchar2(2);
        v_for_empno          Varchar2(5);
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_self_empno := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            empno
        Into
            v_for_empno
        From
            ss_emplmast
        Where
            empno      = p_empno
            And status = 1;
        c            := get_print_log_detailed_list(v_for_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_detailed_list_other;

    Function fn_past_7days_hod_sum(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_pivot_column_csv Varchar2(2000);
    Begin
        Select
            Listagg(Chr(39) || initcap(d_mon) || ' ' || d_dd || Chr(39) || ' as ' || Chr(34) || initcap(d_mon) || ' ' || d_dd ||
            Chr(34), ', ') Within
                Group (Order By
                    d_date) csv
        Into
            v_pivot_column_csv
        From
            ss_days_details
        Where
            d_date Between (sysdate - 8) And (sysdate - 1)
        Order By
            d_date;
    End;

End iot_print_log_qry;

/

  GRANT EXECUTE ON "SELFSERVICE"."IOT_PRINT_LOG_QRY" TO "TCMPL_APP_CONFIG";
