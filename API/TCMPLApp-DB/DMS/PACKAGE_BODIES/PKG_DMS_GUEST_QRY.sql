Create Or Replace Package Body "DMS"."PKG_DMS_GUEST_QRY" As

    Function fn_dm_adm_guests(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_start_date     Date     Default Null,
        p_end_date       Date     Default Null,
        p_costcode       Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                     
                        a.gnum                                   guest_empno,
                        a.gname                                  guest_name,
                        a.gcostcode                              costcode,
                        a.gprojnum                               projno7,
                        (
                            Select
                              b.name
                            From
                                ss_projmast b
                            Where
                                a.gprojnum = b.projno
                        )                                        As proj_name,
                        a.gfromdate                              from_date,
                        a.gtodate                                to_date,
                        a.targetdesk                             target_desk,
                        a.gdate                                  entry_date,
                        a.gmoddate                               modified_on,
                        a.gmodby                                 modified_by,
                        Row_Number() Over (Order By a.gnum Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        dm_guestmaster                  a, dm_usermaster b
                    Where
                        a.gnum           = b.empno
                        And a.targetdesk = b.deskid
                        And
                        (
                            upper(a.gnum) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.targetdesk) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.gname) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                        And gcostcode    = nvl(p_costcode, a.gcostcode)
                        And
                        (
                            a.gfromdate >= nvl(p_start_date, (a.gfromdate))
                            And a.gtodate <= nvl(p_end_date, a.gtodate)
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;

    Function fn_xl_dm_adm_guests(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_start_date     Date     Default Null,
        p_end_date       Date     Default Null,
        p_costcode       Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.gnum                                   guest_empno,
                        a.gname                                  guest_name,
                        a.gcostcode                              costcode,
                        a.gprojnum                               projno7,
                        (
                            Select
                              b.name
                            From
                                ss_projmast b
                            Where
                                a.gprojnum = b.projno
                        )                                        As proj_name,
                        a.gfromdate                              from_date,
                        a.gtodate                                to_date,
                        a.targetdesk                             target_desk,
                        a.gdate                                  entry_date,
                        a.gmoddate                               modified_on,
                        c.empno ||' - '|| c.name                                 modified_by,
                        Row_Number() Over (Order By a.gnum Desc) row_number,
                        Count(*) Over ()                         total_row
                     From
                        dm_guestmaster                  a, dm_usermaster b , ss_emplmast c
                    Where
                        a.gnum           = b.empno
                        and a.gmodby = c.empno
                        And a.targetdesk = b.deskid
                        And
                        (
                            upper(a.gnum) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.targetdesk) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.gname) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                        And gcostcode    = nvl(p_costcode, a.gcostcode)
                        And
                        (
                            a.gfromdate >= nvl(p_start_date, (a.gfromdate))
                            And a.gtodate <= nvl(p_end_date, a.gtodate)
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;

    Function fn_dm_adm_guests_log(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_start_date     Date     Default Null,
        p_end_date       Date     Default Null,
        p_costcode       Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select     
                        a.gnum                                   guest_empno,
                        a.gname                                  guest_name,
                        a.gcostcode                              costcode,
                        a.gprojnum                               projno7,
                        (
                            Select
                              b.name
                            From
                                ss_projmast b
                            Where
                                a.gprojnum = b.projno
                        )                                        As proj_name,
                        a.gfromdate                              from_date,
                        a.gtodate                                to_date,
                        a.targetdesk                             target_desk_null,
                        a.deskloc                                target_desk,
                        a.gdate                                  entry_date,
                        a.gmoddate                               modified_on,
                        a.gmodby                                 modified_by,
                        Row_Number() Over (Order By a.gnum Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        dm_guestmaster                  a 
                    Where
                        a.gnum not in (select   b.empno from dm_usermaster b )                         
                        and a.gfromdate  Between (add_months(sysdate, (-1) * 12)) and (add_months(sysdate, (+1) * 12))
                        And
                        (
                            upper(a.gnum) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.targetdesk) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.gname) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                        And gcostcode = nvl(p_costcode, a.gcostcode)
                        And
                        (
                            a.gfromdate >= nvl(p_start_date, (a.gfromdate))
                            And a.gtodate <= nvl(p_end_date, a.gtodate)
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;

End;