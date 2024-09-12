-----------------------------------------------------
--  DDL for Package Body PKG_EXCLUDE_FROM_MOC5
-----------------------------------------------------

Create Or Replace Package Body dms.pkg_exclude_from_moc5 As

    Procedure sp_import_emp_json (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_parameter_json Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As

        v_count Number := 0;
        v_empno Varchar2(5);
        Cursor cur_json Is
        Select
            jt.*
          From
                Json_Table ( p_parameter_json Format Json, '$[*]'
                    Columns (
                        empno Varchar2 ( 5 ) Path '$.Empno'
                    )
                )
            As jt;

    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        For c1 In cur_json Loop
            Begin
                Select
                    Count(empno)
                  Into v_count
                  From
                    emp_exclude_from_moc5
                 Where
                    empno = Trim(upper(c1.empno));

                If v_count = 0 Then
                    Insert Into emp_exclude_from_moc5 (
                        empno,
                        modified_on,
                        modified_by
                    ) Values (
                        Trim(upper(c1.empno)),
                        sysdate,
                        v_empno
                    );

                End If;

            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        End Loop;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_import_emp_json;

    Procedure sp_delete_exclude_employee (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_empno        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From emp_exclude_from_moc5
         Where
            empno = p_empno;

        If ( Sql%rowcount > 0 ) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_exclude_employee;

    Procedure sp_batch_emp_insert As
        v_count Number := 0;
        v_empno Varchar2(5);
    Begin

        Delete From emp_exclude_from_moc5;

        Insert Into emp_exclude_from_moc5 (
            empno,
            modified_on,
            modified_by
        )
        (
            Select Distinct
                dm_usermaster.empno As empno,
                sysdate             As mod_in,
                'SYS'               As mod_by
              From
                dm_usermaster,
                dm_deskmaster
             Where
                    dm_deskmaster.office = 'MOC5'
                   And dm_deskmaster.deskid = dm_usermaster.deskid
        );

        Commit;
    End sp_batch_emp_insert;

End pkg_exclude_from_moc5;
/

Grant Execute On dms.pkg_exclude_from_moc5 To tcmpl_app_config;