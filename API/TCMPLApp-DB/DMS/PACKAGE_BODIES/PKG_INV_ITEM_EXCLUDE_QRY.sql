Create Or Replace Package Body dms.pkg_inv_item_exclude_qry As

    Function fn_item_exclude_list(
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
        Open c For Select action_trans_id,
                   asset_id,
                   action_type,
                   action_type_text,
                   remarks,
                   action_date,
                   action_by,
                   source_emp,
                   assetid_old,
                   row_number,
                   total_row
                     From (
                       Select a.actiontransid                                As action_trans_id,
                              a.assetid                                      As asset_id,
                              a.action_type                                  As action_type,
                              b.description                                  As action_type_text,
                              a.remarks                                      As remarks,
                              a.action_date                                  As action_date,
                              a.action_by                                    As action_by,
                              a.source_emp                                   As source_emp,
                              a.assetid_old                                  As assetid_old,
                              Row_Number() Over(Order By a.action_date Desc) As row_number,
                              Count(*) Over()                                As total_row
                         From dm_action_trans a, dm_action_type b
                        Where a.action_type = b.typeid 
                   )
                    Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_item_exclude_list;

End pkg_inv_item_exclude_qry;
/

  Grant Execute On dms.pkg_inv_item_exclude_qry To tcmpl_app_config;