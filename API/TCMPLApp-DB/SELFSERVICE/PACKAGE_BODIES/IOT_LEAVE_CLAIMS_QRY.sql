--------------------------------------------------------
--  DDL for Package Body IOT_LEAVE_CLAIMS_QRY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE_CLAIMS_QRY" As

    Function fn_leave_claims(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,

        p_empno       Varchar2 Default Null,
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
                        la.empno,
                        get_emp_name(la.empno)                                As employee_name,
                        e.parent,
                        la.adj_no                                             As application_id,
                        la.leavetype                                          As leave_type,
                        la.db_cr,
                        la.adj_dt                                             As application_date,
                        la.bdate                                              As start_date,
                        la.edate                                              As end_date,
                        to_days(la.leaveperiod)                               As leave_period,
                        la.med_cert_file_name                                 As med_cert_file_name,
                        --la.entry_date                                         As application_date,
                        Row_Number() Over (Order By la.adj_dt Desc, la.adj_no) As row_number,
                        Count(*) Over ()                                      As total_row
                    From
                        ss_leave_adj la,
                        ss_emplmast  e
                    Where
                        la.empno        = e.empno
                        And la.adj_type in ('LC','SW') --'LC'
                        And la.db_cr    = 'D'
                        And la.bdate >= add_months(sysdate, - 24)
                        And trunc(la.adj_dt) Between nvl(p_start_date, trunc(la.adj_dt)) And nvl(p_end_date, trunc(la.adj_dt))
                        And la.empno    = nvl(p_empno, la.empno)
                        And leavetype   = nvl(p_leave_type, leavetype)

                    Order By adj_dt Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

End iot_leave_claims_qry;

/

  GRANT EXECUTE ON "SELFSERVICE"."IOT_LEAVE_CLAIMS_QRY" TO "TCMPL_APP_CONFIG";
