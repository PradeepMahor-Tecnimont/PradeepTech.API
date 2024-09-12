--------------------------------------------------------
--  DDL for Package Body IOT_SWP_SELECT_LIST_QRY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
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
                And nvl(cabin, 'X') <> 'C'
                And Trim(deskid) Not In (
                    Select
                        deskid
                    From
                        swp_wfh_weekatnd
                    Where
                        trunc(atnd_date) = trunc(p_date)
                        And empno != Trim(p_empno)
                    Union
                    Select
                        deskid
                    From
                        dms.dm_emp_desk_temp
                )
            Order By
                office;

        Return c;
    End fn_desk_list;

End iot_swp_select_list_qry;

/
