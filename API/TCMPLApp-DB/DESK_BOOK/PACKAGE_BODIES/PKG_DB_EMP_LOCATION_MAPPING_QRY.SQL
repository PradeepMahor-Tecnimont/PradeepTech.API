--------------------------------------------------------
--  DDL for Package Body PKG_DB_EMP_PROJ_MAP_QRY
--------------------------------------------------------

Create Or Replace Editionable Package Body desk_book.pkg_db_emp_location_mapping_qry As

    Function fn_emp_location_mapping_list(
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

        Open c For Select *
                     From (
                       Select a.key_id                                                                As key_id,
                              a.empno                                                                 As empno,
                              get_emp_name(a.empno)                                                   As name,
                              b.emptype                                                               As emptype,
                              b.parent                                                                As costcode,
                              c.name                                                                  As costcode_name,
                              tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                  tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                      a.empno, sysdate
                                  )
                              )                                                                       As base_location,
                              a.office_location_code                                                  As office_location_code,
                              tcmpl_hr.pkg_common.fn_get_office_location_desc(a.office_location_code) As office_location_code_desc,
                              a.modified_by || ' - ' || get_emp_name(a.modified_by)                   As modified_by,
                              a.modified_on                                                           As modified_on,
                              Row_Number() Over (Order By a.empno Desc)                               row_number,
                              Count(*) Over ()                                                        total_row
                         From db_map_emp_location a, vu_emplmast b, vu_costmast c
                        Where a.empno = b.empno
                          And b.parent = c.costcode
                          And
                              (upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%')
                   )
                    Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_emp_location_mapping_list;

    Function fn_emp_location_mapping_xl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
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
        Open c For Select *
                     From (
                       Select a.key_id                                                                As key_id,
                              a.empno                                                                 As empno,
                              get_emp_name(a.empno)                                                   As name,
                              b.emptype                                                               As emptype,
                              b.parent                                                                As costcode,
                              c.name                                                                  As costcode_name,
                              tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                  tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                      a.empno, sysdate
                                  )
                              )                                                                       As base_location,
                              a.office_location_code                                                  As office_location_code,
                              tcmpl_hr.pkg_common.fn_get_office_location_desc(a.office_location_code) As office_location_code_desc,
                              a.modified_by || ' - ' || get_emp_name(a.modified_by)                   As modified_by,
                              a.modified_on                                                           As modified_on,
                              Row_Number() Over (Order By a.empno Desc)                               row_number,
                              Count(*) Over ()                                                        total_row
                         From db_map_emp_location a, vu_emplmast b, vu_costmast c
                        Where a.empno = b.empno
                          And b.parent = c.costcode
                          And
                              (upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%')
                   );

        Return c;
    End fn_emp_location_mapping_xl_list;
End pkg_db_emp_location_mapping_qry;
/

  Grant Execute On desk_book.pkg_db_emp_location_mapping_qry To tcmpl_app_config;