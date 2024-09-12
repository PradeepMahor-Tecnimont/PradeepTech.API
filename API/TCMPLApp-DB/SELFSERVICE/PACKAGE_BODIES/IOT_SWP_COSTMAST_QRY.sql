Create Or Replace Package Body selfservice.iot_swp_costmast_qry As

    Function fn_assign_costcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_empno              Varchar2(5);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                costcode assign, name assign_desc
            From
                ss_costmast
            Where
                costcode In (
                    Select
                        assign
                    From
                        ss_emplmast
                    Where
                        status = 1
                        And emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype

                        )
                )
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                );
        Return c;
    End;

End iot_swp_costmast_qry;