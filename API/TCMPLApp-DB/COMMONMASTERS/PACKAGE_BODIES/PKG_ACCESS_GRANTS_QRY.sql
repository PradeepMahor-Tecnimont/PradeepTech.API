Create Or Replace Package Body "PKG_ACCESS_GRANTS_QRY" As

    Function fn_get_grants_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

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
                        a.empno                                   As empno,
                        b.metaid                                  As emp_metaid,
                        c.ad_mngr_metaid                          As manager_metaid,
                        c.ad_mngr_name                            As manager_name,
                        ''                                        As userid,
                        b.name                                    As full_name,
                        'Startdate'                               As start_date,
                        'EndDate'                                 As end_date,
                        a.rolename                                As role_name,
                        'TCMPL'                                   As company,
                        a.roledesc                                As role_desc,
                        a.module                                  As system,
                        a.module                                  As module,
                        ''                                        As process_owner,
                        a.role_on_costcode                        As role_on_costcode,
                        a.role_on_projno                          As role_on_projno,
                        ''                                        As approver,
                        Row_Number() Over (Order By a.empno Desc) row_number,
                        Count(*) Over ()                          total_row
                    From
                        system_grants  a,
                        emplmast       b,
                        emp_ad_details c
                    Where
                        b.status     = 1
                        And a.empno  = b.empno
                        And b.metaid = c.ad_metaid(+)
                )
            --Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                empno;
        Return c;
    End fn_get_grants_list;

End pkg_access_grants_qry;
/
Grant Execute On "COMMONMASTERS"."PKG_ACCESS_GRANTS_QRY" To "TCMPL_APP_CONFIG" With Grant Option;