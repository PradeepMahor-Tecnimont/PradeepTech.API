--------------------------------------------------------
--  DDL for Package Body PKG_DB_EMP_PROJ_MAP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DESK_BOOK"."PKG_DB_EMP_PROJ_MAP" As

    Procedure sp_add_emp_proj (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_empno        Varchar2,
        p_projno       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno       Varchar2(5);
        v_user_tcp_ip Varchar2(5) := 'NA';
        v_key_id      Varchar2(10) := dbms_random.string(
                                                   'X',
                                                   10
                                 );
        v_count       Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_count
          From
            db_emp_proj_mapping
         Where
            empno = p_empno;

        If v_count > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Employee record already present';
            Return;
        End If;

        Insert Into db_emp_proj_mapping (
            key_id,
            empno,
            projno,
            modified_on,
            modified_by
        ) Values (
            v_key_id,
            p_empno,
            p_projno,
            sysdate,
            v_empno
        );

        If ( Sql%rowcount > 0 ) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_emp_proj;

    Procedure sp_update_emp_proj (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2,
        p_projno         Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno       Varchar2(5);
        v_user_tcp_ip Varchar2(5) := 'NA';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update db_emp_proj_mapping
           Set
            projno = p_projno,
            modified_on = sysdate,
            modified_by = v_empno
         Where
            key_id = p_application_id;

        If ( Sql%rowcount > 0 ) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_update_emp_proj;

    Procedure sp_delete_emp_proj (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From db_emp_proj_mapping
         Where
            key_id = p_application_id;

        If ( Sql%rowcount > 0 ) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_emp_proj;

End pkg_db_emp_proj_map;


/

  GRANT EXECUTE ON "DESK_BOOK"."PKG_DB_EMP_PROJ_MAP" TO "TCMPL_APP_CONFIG";
