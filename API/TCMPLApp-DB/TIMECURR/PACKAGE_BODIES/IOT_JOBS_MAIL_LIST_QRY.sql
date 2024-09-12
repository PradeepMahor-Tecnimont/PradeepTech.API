--------------------------------------------------------
--  DDL for Package Body IOT_JOBS_MAIL_LIST_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.iot_jobs_mail_list_qry As

    Function fn_job_mail_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_projno      Varchar2,
        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As

        c       Sys_Refcursor;
        v_empno Char(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        projno                                            As projno,
                        costcode                                          As costcode,
                        cost_name                                         As cost_name,
                        empno                                             As empno,
                        employee_name                                     As employee_name,
                        can_delete                                        As can_delete,
                        Row_Number() Over (Order By can_delete, costcode) As row_number,
                        Count(*) Over ()                                  As total_row

                    From
                        (

                            Select
                                ml.projno                             As projno,
                                ml.costcode                           As costcode,
                                Trim(ml.costcode) || ' - ' || cm.name As cost_name,
                                e.empno                               As empno,
                                e.empno || ' - ' || e.name            As employee_name,
                                'OK'                                  As can_delete
                            From
                                job_mail_list_costcodes ml,
                                costmast                cm,
                                emplmast                e
                            Where
                                ml.projno       = p_projno
                                And ml.costcode = cm.costcode
                                And cm.hod      = e.empno(+)
                                And empno Not In (
                                    Select
                                        empno
                                    From
                                        job_responsible_roles_defaults
                                )
                            Union
                            Select
                                p_projno                      As projno,
                                c.costcode                    As costcode,
                                c.costcode || ' - ' || c.name As cost_name,
                                a.empno                       As empno,
                                a.empno || ' - ' || e.name    As employee_name,
                                'KO'                          As can_delete
                            From
                                job_responsible_roles_defaults a,
                                emplmast                       e,
                                costmast                       c
                            Where
                                a.empno      = e.empno
                                And e.parent = c.costcode
                        )
                    Order By can_delete,
                        costcode
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

End;