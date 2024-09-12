Create Or Replace Package Body "TCMPL_HR"."PKG_DG_SITE_MASTER_QRY" As

    Function fn_dg_site_master_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For  
                    Select
                                  key_id,          
                                  site_name,          
                                  site_location,          
                                  is_active as is_active_val,         
                                  ( case is_active when 1 then 'Active' else 'De-Active' end ) as is_active_text, 
                                   modified_by ||' - '|| get_emp_name(modified_by)  As modified_by,
                                   modified_on,         
                                   row_number,
                                   total_row 
                                From
                                  (
                                      Select
                                          a.key_id        As key_id,          
                                          a.site_name     As site_name,          
                                          a.site_location As site_location,          
                                          a.is_active     As is_active,          
                                          a.modified_by ||' - '|| get_emp_name(a.modified_by)  As modified_by,
                                          a.modified_on   As modified_on,         
                                          Row_Number()
                                          Over( Order By a.site_name)               row_number,
                                          Count(*) Over()          total_row 
                                          From
                                          dg_site_master a
                                       Where                                              
                                          ( upper( a.site_name ) Like '%' || upper( Trim(p_generic_search) ) || '%' Or
                                            upper( a.site_location ) Like '%' || upper( Trim(p_generic_search) ) || '%' 
                                          )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length );
        Return c;
    End fn_dg_site_master_list;


    Procedure sp_dg_site_master_details (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_key_id        Varchar2,
        p_site_name     Out Varchar2,
        p_site_location Out Varchar2,
        P_is_active_val     Out Number,
        p_is_active_text     Out Varchar2,
        p_modified_by   Out Varchar2,
        p_modified_on   Out Date,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dg_site_master
         Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Select
                site_name,
                site_location,
                is_active     As is_active_val,
                    (
                        Case is_active
                            When 1 Then
                                'Active'
                            Else
                                'De-Active'
                        End
                    )                 As is_active_text,                          
                modified_by || ' - ' || get_emp_name(modified_by) As modified_by,                
                modified_on
              Into
                p_site_name,
                p_site_location,
                p_is_active_val,
                p_is_active_text,
                p_modified_by,
                p_modified_on
              From
                dg_site_master
             Where
                key_id = p_key_id;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Dg site master exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_dg_site_master_details;


    Function fn_dg_site_master_xl_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                          a.key_id        As key_id,
                          a.site_name     As site_name,
                          a.site_location As site_location,
                          a.is_active     As is_active_val,
                        (
                            Case a.is_active
                                When 1 Then
                                    'Active'
                                Else
                                    'De-Active'
                            End
                        )                 As is_active_text,                          
                          a.modified_by || ' - ' || get_emp_name(a.modified_by) As modified_by,
                          a.modified_on   As modified_on
                        From
                          dg_site_master a
                    Where                                              
                          ( upper( a.site_name ) Like '%' || upper( Trim(p_generic_search) ) || '%' Or
                            upper( a.site_location ) Like '%' || upper( Trim(p_generic_search) ) || '%' 
                          );


        Return c;
    End fn_dg_site_master_xl_list;

End pkg_dg_site_master_qry; 