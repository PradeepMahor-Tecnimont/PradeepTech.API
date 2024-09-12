create or replace Package Body "DMS"."PKG_DMS_SELECT_LIST_QRY" As
       
    Function fn_source_desk_list (
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_session_id       Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        /*Open c For
            Select Distinct
              trim(da.deskid)                               As data_value_field,
              trim(da.deskid) || ' - ' ||
                nvl(du.empno,'NA') || ' - ' ||
                nvl(initcap(e.name),'NA') || ' [ ' ||
                nvl(du.costcode,'NA') || ' ]'               As data_text_field
            From
              dm_deskallocation da,
              dm_usermaster     du,
              ss_emplmast        e
            Where
              da.deskid = du.deskid
              And du.empno = e.empno
              And da.deskid Not In (
                   Select
                       deskid
                     From
                       dm_sourcedesk
                    Where
                       sid = p_session_id
                   )
              And da.deskid Not In (
                   Select
                       deskid
                     From
                       dm_deskmaster
                     Where
                       isblocked = 1
                    )
            Order By
               data_value_field;*/
               
        Open c For
            Select Distinct
              trim(du.deskid)                               As data_value_field,
              trim(du.deskid) || ' - ' ||
                nvl(du.empno,'NA') || ' - ' ||
                nvl(initcap(e.name),'NA') || ' [ ' ||
                nvl(du.costcode,'NA') || ' ]'               As data_text_field
            From
              dm_usermaster     du,
              ss_emplmast        e
            Where
              du.empno = e.empno
              And du.deskid Not In (
                   Select
                       deskid
                     From
                       dm_sourcedesk
                    Where
                       sid = p_session_id
                   )
              And du.deskid Not In (
                   Select
                       deskid
                     From
                       dm_deskmaster
                     Where
                       isblocked = 1
                    )
            Order By
               data_value_field;
        Return c;
    End fn_source_desk_list;

    Function fn_target_desk_list (
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_session_id Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        /*Open c For
            Select Distinct
              trim(dm.deskid)                                           As data_value_field,
              trim(dm.deskid) || ' - ' ||
              nvl(pkg_dms_general.get_desk_employee(dm.deskid), '(no user)')    As data_text_field              
            From              
              dm_deskmaster     dm 
            Where                  
                  dm.deskid Not In (
                       Select Distinct
                           deskid
                         From
                           dm_sourcedesk
                        Where
                           trim(sid) = trim(p_session_id)
                       )
                  And dm.deskid Not In (
                       Select Distinct
                           deskid
                         From
                           dm_targetdesk
                        Where
                           trim(sid) = trim(p_session_id)
                       )
                  And Trim(dm.deskid) Not In (
                       Select Distinct
                           Trim(deskid)
                         From
                           dm_deskmaster
                         Where
                           isblocked = 1
                        )
                  And dm.deskid Is Not Null
            Order By
               data_value_field;*/
        Open c For
           Select Distinct
              trim(dm.deskid)                                           As data_value_field,
              trim(dm.deskid) || ' - ' ||
              nvl(pkg_dms_general.get_desk_employee(dm.deskid), '(no user)')    As data_text_field              
            From
              dm_deskmaster     dm              
            Where                  
                  dm.deskid Not In (
                       Select Distinct
                           deskid
                         From
                           dm_sourcedesk
                        Where
                           trim(sid) = trim(p_session_id)
                       )
                  And dm.deskid Not In (
                       Select Distinct
                           deskid
                         From
                           dm_targetdesk
                        Where
                           trim(sid) = trim(p_session_id)
                       )
                  And Trim(dm.deskid) Not In (
                       Select Distinct
                           Trim(deskid)
                         From
                           dm_deskmaster
                         Where
                           isblocked = 1
                        )
                   And Trim(dm.deskid) Not In (
                       Select Distinct
                           Trim(deskid)
                         From
                           dm_usermaster                         
                        )
                  And Trim(dm.deskid) Not In (
                       Select Distinct
                           Trim(deskid)
                         From
                           dm_desklock                           
                        )
                  And dm.deskid Is Not Null
            Order By
               data_value_field;
        Return c;
    End fn_target_desk_list;

    Function fn_target_assignment_desk_list(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_session_id    Varchar2,
        p_movetype      Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

            If p_movetype = 'A' Then
                Open c For
                    Select
                        trim(deskid)        As data_value_field,
                        trim(deskid)        As data_text_field
                    From
                        (Select Distinct
                           deskid
                        From
                           dm_sourcedesk
                        Where
                           trim(sid) = trim(p_session_id)
                        Union
                        Select Distinct
                           deskid
                        From
                           dm_targetdesk
                        Where
                           trim(sid) = trim(p_session_id))
                    Where trim(deskid) not in (select
                                                    trim(targetdesk)
                                               from
                                                    dm_assetmove_tran
                                               where
                                                    trim(movereqnum) = trim(p_session_id)
                                             )
                    Order by deskid;
            Else
                Open c For
                    Select
                        trim(deskid)        As data_value_field,
                        trim(deskid)        As data_text_field
                    From
                        (Select Distinct
                           deskid
                        From
                           dm_sourcedesk
                        Where
                           trim(sid) = trim(p_session_id)
                        Union
                        Select Distinct
                           deskid
                        From
                           dm_targetdesk
                        Where
                           trim(sid) = trim(p_session_id))
                    Order by deskid;
            End If;
        Return c;
    End fn_target_assignment_desk_list;

    Function fn_desk_block_reason_list (
        p_person_id         Varchar2,
        p_meta_id           Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                to_char(reasoncode)     As data_value_field,
                description             As data_text_field
            From
                dm_desklock_reason
            Order by
                description;
        Return c;
    End fn_desk_block_reason_list;

    
End pkg_dms_select_list_qry;

/

Grant Execute On "DMS"."PKG_DMS_SELECT_LIST_QRY" To "TCMPL_APP_CONFIG";