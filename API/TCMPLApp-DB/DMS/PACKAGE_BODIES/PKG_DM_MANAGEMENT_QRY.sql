Create Or Replace Package Body dms.pkg_dm_management_qry As

    Function fn_airoli_emp_in_dm_master_list(
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
                empno,
                get_emp_name(empno)         As emp_name,
                deskid,
                costcode,
                get_costcode_name(costcode) As costcode_name,
                to_char(dep_flag)           As dep_flag,
                row_number,
                total_row
            From
                (
                    Select
                        empno,
                        get_emp_name(empno)               As emp_name,
                        deskid,
                        costcode,
                        get_costcode_name(costcode)       As costcode_name,
                        dep_flag,
                        Row_Number() Over(Order By empno) As row_number,
                        Count(*) Over()                   As total_row
                    From
                        dm_usermaster
                    Where
                        dm_usermaster.empno In (
                            With
                                emp_location As (
                                    Select
                                        empno, tcmpl_hr.pkg_common.fn_get_emp_office_location(a.empno) As office_location_code
                                    From
                                        ss_emplmast a
                                    Where
                                        a.status = 1
                                        And a.empno Not In (
                                            Select
                                                empno
                                            From
                                                emp_exclude_from_moc5
                                        )
                                )
                            Select
                                --el.*, e.name, du.deskid, dm.office
                                el.empno
                            From
                                emp_location                 el, ss_emplmast e, dm_usermaster du,
                                dm_deskmaster dm
                            Where
                                office_location_code = '02'
                                And el.empno         = e.empno
                                And el.empno         = du.empno
                                And e.status         = 1
                                And du.deskid        = dm.deskid
                                And dm.office        = 'MOC4'
                                And dm.work_area != 'A55'
                        )
                        And deskid In (
                            Select
                                dd.deskid
                            From
                                dms.dm_deskallocation dd,
                                dms.dm_assetcode      da
                            Where
                                da.barcode       = dd.assetid
                                And da.assettype = 'PC'
                        )
                        And empno Not In (
                            Select
                                empno
                            From
                                desk_book.db_map_emp_location
                        )
                        And (upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(costcode) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(deskid) Like '%' || upper(Trim(p_generic_search))
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_airoli_emp_in_dm_master_list;

End pkg_dm_management_qry;