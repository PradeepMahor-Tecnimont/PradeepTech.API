create or replace package body tcmpl_afc.pkg_bg_project_mast as

  procedure sp_add_project_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projnum          Varchar2,
        p_name             Varchar2,
        p_mngrname         Varchar2,
        p_mngremail        Varchar2,       
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) as
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        Insert Into bg_project_mast (projnum, name, mngrname, mngremail, modifiedby, modifiedon)
        Values (p_projnum, p_name, p_mngrname, p_mngremail, v_empno, sysdate);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_add_project_mast;

  procedure sp_update_project_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projnum          Varchar2,
        p_name             Varchar2,
        p_mngrname         Varchar2,
        p_mngremail        Varchar2, 
        p_isclosed        Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) as
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            bg_project_mast
        Set
            name = p_name, 
            mngrname = p_mngrname,
            mngremail = p_mngremail, 
            isclosed = p_isclosed, 
            modifiedby = v_empno,
            modifiedon = sysdate            
        Where
            projnum = p_projnum;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_update_project_mast;

end pkg_bg_project_mast;