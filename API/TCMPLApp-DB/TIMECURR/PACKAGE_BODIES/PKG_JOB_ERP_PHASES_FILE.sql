--------------------------------------------------------
--  DDL for Package Body PKG_JOB_ERP_PHASES_FILE 
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."PKG_JOB_ERP_PHASES_FILE" As

    Procedure sp_add_erp_phases_file(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_job_no           Varchar2,
        p_clint_file_name  Varchar2,
        p_server_file_name Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_erp_phases_file
        Where
            Trim(upper(job_no)) = Trim(upper(p_job_no));

        If v_exists = 0 Then
            Insert Into job_erp_phases_file
                (job_no, clint_file_name, server_file_name, modified_by, modified_on)
            Values
                (Trim(upper(p_job_no)), Trim(p_clint_file_name), Trim(p_server_file_name), v_empno, sysdate);
            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
         
            pkg_job_erp_phases_file.sp_update_erp_phases_file(
                p_person_id        => p_person_id,
                p_meta_id          => p_meta_id,
                p_job_no           => p_job_no,
                p_clint_file_name  => p_clint_file_name,
                p_server_file_name => p_server_file_name,
                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );
            
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_erp_phases_file;

    Procedure sp_update_erp_phases_file(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_job_no           Varchar2,
        p_clint_file_name  Varchar2,
        p_server_file_name Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_erp_phases_file
        Where
            job_no = p_job_no;

        If v_exists = 1 Then

            Update
                job_erp_phases_file
            Set
                clint_file_name = p_clint_file_name,
                server_file_name = p_server_file_name,
                modified_by = v_empno,
                modified_on = sysdate

            Where
                job_no = p_job_no;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching ERP phases file exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_erp_phases_file;

End pkg_job_erp_phases_file;
/
  Grant Execute On "TIMECURR"."PKG_JOB_ERP_PHASES_FILE" To "TCMPL_APP_CONFIG";