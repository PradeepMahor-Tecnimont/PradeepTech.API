Create Or Replace Package Body timecurr.rap_process_queue As

    err_text Varchar2(4000);

    Procedure sp_process_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_user             Varchar2,
        p_module_id        Varchar2,
        p_process_id       Varchar2,
        p_process_desc     Varchar2,
        p_parameter_json   Varchar2,
        p_mail_to          Varchar2 Default Null,
        p_mail_cc          Varchar2 Default Null,
        p_key_id       Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_email selfservice.userids.email%Type;
        v_empno selfservice.userids.empno%Type;
    Begin
        Select
            email, empno
        Into
            v_email, v_empno
        From
            selfservice.userids 
        Where
            userid = Trim(p_user);

        tcmpl_app_config.pkg_app_process_queue.sp_process_add(p_person_id      => p_person_id,
                                                              p_meta_id        => p_meta_id,
                                                              p_empno          => v_empno,
                                                              p_module_id      => p_module_id,
                                                              p_process_id     => p_process_id,
                                                              p_process_desc   => p_process_desc,
                                                              p_parameter_json => p_parameter_json,
                                                              p_mail_to        => v_email,
                                                              p_mail_cc        => p_mail_cc,
                                                              p_key_id         => p_key_id,
                                                              p_message_type   => p_message_type,
                                                              p_message_text   => p_message_text);

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            p_message_type := 'KO';
            p_message_text := err_text;
    End sp_process_add;

End rap_process_queue;