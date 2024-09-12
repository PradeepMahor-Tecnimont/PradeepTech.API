Create Or Replace Package Body "TCMPL_HR"."PKG_VPP_CONFIG_QRY" As

    Function fn_vpp_config_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_start_date     Date Default Null,
        p_end_date       Date Default Null,
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
        Open c For Select
                                  key_id,
                                  start_date,
                                  end_date,
                                  is_display_premium_val,
                                  is_display_premium_text,
                                  is_draft_val,
                                  is_draft_text,
                                  emp_joining_date,
                                  is_initiate_config_val,
                                  is_initiate_config_text,
                                  is_applicable_to_all_val,
                                  is_applicable_to_all_text,
                                  created_by,
                                  created_on,
                                  modified_by,
                                  modified_on,
                                  pkg_vpp_config_qry.fun_action_status(
                                      key_id,
                                      'EDIT'
                                  ) As can_edit,
                                  pkg_vpp_config_qry.fun_action_status(
                                      key_id,
                                      'ACTIVATE'
                                  ) As can_activate,
                                  pkg_vpp_config_qry.fun_action_status(
                                      key_id,
                                      'DEACTIVATE'
                                  ) As can_deactivate,
                                  row_number,
                                  total_row
                                From
                                  (
                                      Select
                                          a.key_id               As key_id,
                                          a.start_date           As start_date,
                                          a.end_date             As end_date,
                                          a.is_display_premium   As is_display_premium_val,
                                          (
                                              Case a.is_display_premium
                                                  When 1 Then
                                                      'Yes'
                                                  Else
                                                      'No'
                                              End
                                          )                      As is_display_premium_text,
                                          a.is_draft             As is_draft_val,
                                          (
                                              Case a.is_draft
                                                  When 1 Then
                                                      'Yes'
                                                  Else
                                                      'No'
                                              End
                                          )                      As is_draft_text,
                                          a.emp_joining_date     As emp_joining_date,
                                          a.is_initiate_config   As is_initiate_config_val,
                                          (
                                              Case a.is_initiate_config
                                                  When 1 Then
                                                      'Yes'
                                                  Else
                                                      'No'
                                              End
                                          )                      As is_initiate_config_text,
                                          a.is_applicable_to_all As is_applicable_to_all_val,
                                          (
                                              Case a.is_applicable_to_all
                                                  When 1 Then
                                                      'Yes'
                                                  Else
                                                      'No'
                                              End
                                          )                      As is_applicable_to_all_text,
                                          a.created_by || ' ' || get_emp_name(
                                              a.created_by
                                          )                      As created_by,
                                          a.created_on           As created_on,
                                          a.modified_by || ' ' || get_emp_name(
                                              a.modified_by
                                          )                      As modified_by,
                                          a.modified_on          As modified_on,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.modified_on Desc
                                          )                      row_number,
                                          Count(*)
                                          Over()                 total_row
                                        From
                                          vpp_config a
                                       Where
                                          --a.start_date >= nvl( Trim(p_start_date), a.start_date ) And
                                          --  a.end_date <= nvl( Trim(p_end_date), a.end_date ) And
                                          ( upper(
                                              a.created_by
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%' Or
                                            upper(
                                                a.modified_by
                                            ) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' )
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
    End fn_vpp_config_list;

    Procedure sp_vpp_config_details (
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,
        p_key_id                    Varchar2,
        p_start_date                Out Date,
        p_end_date                  Out Date,
        p_emp_joining_date          Out Date,
        p_is_display_premium_val    Out Number,
        p_is_draft_val              Out Number,
        p_is_initiate_config_val    Out Number,
        p_is_display_premium_text   Out Varchar2,
        p_is_draft_text             Out Varchar2,
        p_is_applicable_to_all_val  Out Number,
        p_is_applicable_to_all_text Out Varchar2,
        p_is_initiate_config_text   Out Varchar2,
        p_created_by                Out Varchar2,
        p_created_on                Out Date,
        p_modified_by               Out Varchar2,
        p_modified_on               Out Date,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
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
            vpp_config
         Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Select
                start_date,
                end_date,
                emp_joining_date,
                is_display_premium,
                is_draft,
                is_initiate_config,
                is_applicable_to_all,
                (
                    Case is_display_premium
                        When 1 Then
                            'Yes'
                        Else
                            'No'
                    End
                ) As p_is_display_premium_text,
                (
                    Case is_draft
                        When 1 Then
                            'Yes'
                        Else
                            'No'
                    End
                ) As p_is_draft_text,
                (
                    Case is_initiate_config
                        When 1 Then
                            'Yes'
                        Else
                            'No'
                    End
                ) As is_initiate_config_text,
                (
                    Case is_applicable_to_all
                        When 1 Then
                            'Yes'
                        Else
                            'No'
                    End
                ) As is_applicable_to_all_text,
                created_by || ' : ' || get_emp_name(created_by),
                created_on,
                modified_by || ' : ' || get_emp_name(modified_by),
                modified_on
              Into
                p_start_date,
                p_end_date,
                p_emp_joining_date,
                p_is_display_premium_val,
                p_is_draft_val,
                p_is_initiate_config_val,
                p_is_applicable_to_all_val,
                p_is_display_premium_text,
                p_is_draft_text,
                p_is_initiate_config_text,
                p_is_applicable_to_all_text,
                p_created_by,
                p_created_on,
                p_modified_by,
                p_modified_on
              From
                vpp_config
             Where
                key_id = p_key_id;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Configuration exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_vpp_config_details;

    Function sp_vpp_config_xl_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_start_date     Date Default Null,
        p_end_date       Date Default Null
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
                                  a.key_id             As key_id,
                                  a.start_date         As start_date,
                                  a.end_date           As end_date,
                                  a.is_display_premium As is_display_premium_val,
                                  (
                                      Case a.is_display_premium
                                          When 1 Then
                                              'Yes'
                                          Else
                                              'No'
                                      End
                                  )                    As is_display_premium_text,
                                  a.is_draft           As is_draft_val,
                                  (
                                      Case a.is_draft
                                          When 1 Then
                                              'Yes'
                                          Else
                                              'No'
                                      End
                                  )                    As is_draft_text,
                                  a.emp_joining_date   As emp_joining_date,
                                  a.is_initiate_config As is_initiate_config_val,
                                  (
                                      Case a.is_initiate_config
                                          When 1 Then
                                              'Yes'
                                          Else
                                              'No'
                                      End
                                  )                    As is_initiate_config_text,
                                  a.created_by || ' ' || get_emp_name(
                                      a.created_by
                                  )                    As created_by,
                                  a.created_on         As created_on,
                                  a.modified_by || ' ' || get_emp_name(
                                      a.modified_by
                                  )                    As modified_by,
                                  a.modified_on        As modified_on,
                                  Row_Number()
                                  Over(
                                       Order By
                                          a.start_date Desc
                                  )                    row_number,
                                  Count(*)
                                  Over()               total_row
                                From
                                  vpp_config a
                    Where
                           a.start_date >= nvl(
                               Trim(p_start_date),
                               a.start_date
                           ) And
                       a.end_date <= nvl(
                           Trim(p_end_date),
                           a.end_date
                       ) And
                       ( upper(
                           a.created_by
                       ) Like '%' || upper(
                           Trim(p_generic_search)
                       ) || '%' Or
                         upper(
                             a.modified_by
                         ) Like '%' || upper(
                             Trim(p_generic_search)
                         ) || '%' );

        Return c;
    End sp_vpp_config_xl_list;


    Function fun_action_status (
        p_key_id    In Varchar2,
        p_check_for In Varchar2
    ) Return Number As
        v_retval Number := -1;
        v_count  Number := 0;
    Begin
        If p_check_for = 'EDIT' Then
            v_retval := 0;
            Select
                Count(key_id)
              Into v_count
              From
                vpp_config
             Where
                is_draft           = 0 And
                is_initiate_config = 0 And
                key_id             = p_key_id;

            If v_count = 0 Then
                Return 1;
            End If;
            
            -- For last record 
            Select
                Count(key_id)
              Into v_count
              From
                vpp_config
             Where
                is_draft       = 0 And
                is_initiate_config = 0 And
                key_id             = p_key_id And
                (
                    (sysdate Between start_date  and end_date)
                        or trunc(end_date) = trunc(sysdate) 
                );

            If v_count = 1 Then
                Return 1;
            End If;
            Return v_retval;
        End If;

        If p_check_for = 'ACTIVATE' Then
            v_retval := 0;
            Select
                Count(key_id)
              Into v_count
              From
                vpp_config
             Where
                is_draft           = 1 And
                is_initiate_config = 0 And
                key_id             = p_key_id And
                end_date > sysdate;
            If v_count > 0 Then
                Return 1;
            End If;
            
             -- For last record 
            Select
                Count(key_id)
              Into v_count
              From
                vpp_config
             Where
                is_draft       = 0 And
                is_initiate_config = 0 And
                key_id             = p_key_id And
                (
                    (sysdate Between start_date  and end_date)
                        or trunc(end_date) = trunc(sysdate) 
                );

            If v_count = 1 Then
                Return 1;
            End If;
            Return v_retval;
        End If;

        If p_check_for = 'DEACTIVATE' Then
            v_retval := 0;
            Select
                Count(key_id)
              Into v_count
              From
                vpp_config
             Where
                    is_draft           = 0 And
                is_initiate_config = 1 And
                key_id             = p_key_id;
                
            If v_count > 0 Then
                Return 1;
            End If;
            
            Return v_retval;
        End If;
        
        Return v_retval;
        
    Exception
        When Others Then
            Return v_retval;
    End fun_action_status;

    Function fn_vpp_config_premium_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_key_id      Varchar,
        p_row_number  Number,
        p_page_length Number
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
            *
        From
            (
                Select
                    a.insured_sum_id,
                    a.persons,
                    a.premium,
                    a.lacs,
                    a.gst_amt,
                    a.total_premium,
                    a.key_id,
                    a.config_key_id,
                    a.modified_on,
                    Row_Number() Over(Order By a.insured_sum_id, a.persons) row_number,
                    Count(*) Over()                                         total_row
                From
                    vpp_premium_master a
                Where
                    a.config_key_id = p_key_id
            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Return c;
        End fn_vpp_config_premium_list;  

End pkg_vpp_config_qry;
/

Grant Execute On "TCMPL_HR"."PKG_VPP_CONFIG_QRY" To "TCMPL_APP_CONFIG";