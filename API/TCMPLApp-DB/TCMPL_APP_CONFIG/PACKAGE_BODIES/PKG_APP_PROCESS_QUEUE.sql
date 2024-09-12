Create Or Replace Package Body tcmpl_app_config.pkg_app_process_queue As

    c_process_error        Constant Number := -1;
    c_process_pending      Constant Number := 0;
    c_process_started      Constant Number := 1;
    c_process_finished     Constant Number := 2;

    const_log_type_info    Char(1)         := 'I';
    const_log_type_warning Char(1)         := 'W';
    const_log_type_error   Char(1)         := 'E';
    err_text               Varchar2(4000);

    Procedure sp_process_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_module_id        Varchar2,
        p_process_id       Varchar2,
        p_process_desc     Varchar2,
        p_parameter_json   Varchar2,
        p_mail_to          Varchar2 Default Null,
        p_mail_cc          Varchar2 Default Null,
        p_process_item_id  Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_email  vu_userids.email%Type;
        v_key_id Varchar2(8);
    Begin
        v_empno  := selfservice.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            --p_key_id := null;
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            email
        Into
            v_email
        From
            vu_userids
        Where
            empno = Trim(v_empno);

        v_key_id := dbms_random.string('X', 8);

        Delete
            From app_process_queue
        Where
            parameter_json      = Trim(p_parameter_json)
            And process_item_id = nvl(Trim(p_process_item_id), process_item_id)
            And process_id      = Trim(p_process_id)
            And module_id       = Trim(p_module_id)
            And empno           = Trim(v_empno);

        Delete
            From app_process_finished
        Where
            parameter_json      = Trim(p_parameter_json)
            And process_item_id = nvl(Trim(p_process_item_id), process_item_id)
            And process_id      = Trim(p_process_id)
            And module_id       = Trim(p_module_id)
            And empno           = Trim(v_empno);

        Insert Into app_process_queue(
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            created_on,
            status,
            mail_to,
            mail_cc,
            process_item_id
        )
        Values (
            v_key_id,
            Trim(v_empno),
            Trim(p_module_id),
            Trim(p_process_id),
            Trim(p_process_desc),
            Trim(p_parameter_json),
            sysdate,
            c_process_pending,
            v_email,
            p_mail_cc,
            Trim(p_process_item_id));

        sp_process_log_info(
            p_person_id,
            p_meta_id,
            v_key_id,
            'Process added',
            p_message_type,
            p_message_text
        );

        If p_message_type = ok Then
            p_message_text := 'Batch process scheduled successfully';
        End If;

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(
                p_person_id,
                p_meta_id,
                v_key_id,
                'Error in sp_add_process_queue - ' || err_text,
                p_message_type,
                p_message_text
            );
            p_message_type := 'KO';
            p_message_text := err_text;

    End sp_process_add;

    Procedure sp_process_add_planning(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_module_id          Varchar2,
        p_process_id         Varchar2,
        p_process_desc       Varchar2,
        p_parameter_json     Varchar2,
        p_planned_start_date Date,
        p_mail_to            Varchar2 Default Null,
        p_mail_cc            Varchar2 Default Null,
        p_process_item_id    Varchar2 Default Null,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) As
        v_empno  Varchar2(5);
        v_email  vu_emplmast.email%Type;
        v_key_id Varchar2(8);
    Begin
        v_empno  := selfservice.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            --p_key_id := null;
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            email
        Into
            v_email
        From
            vu_emplmast
        Where
            empno = Trim(v_empno);

        v_key_id := dbms_random.string('X', 8);

        Delete
            From app_process_queue_planned
        Where
            parameter_json      = Trim(p_parameter_json)
            And process_item_id = nvl(Trim(p_process_item_id), process_item_id)
            And process_id      = Trim(p_process_id)
            And module_id       = Trim(p_module_id)
            And empno           = Trim(v_empno);

        Delete
            From app_process_finished
        Where
            parameter_json      = Trim(p_parameter_json)
            And process_item_id = nvl(Trim(p_process_item_id), process_item_id)
            And process_id      = Trim(p_process_id)
            And module_id       = Trim(p_module_id)
            And empno           = Trim(v_empno);

        Insert Into app_process_queue_planned
        (
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            planned_start_date,
            created_on,
            mail_to,
            mail_cc,
            process_item_id
        )
        Values (
            v_key_id,
            Trim(v_empno),
            Trim(p_module_id),
            Trim(p_process_id),
            Trim(p_process_desc),
            Trim(p_parameter_json),
            p_planned_start_date,
            sysdate,
            v_email,
            p_mail_cc,
            Trim(p_process_item_id)
        );

        sp_process_log_info(
            p_person_id,
            p_meta_id,
            v_key_id,
            'Process added to planned queue',
            p_message_type,
            p_message_text
        );

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(
                p_person_id,
                p_meta_id,
                v_key_id,
                'Error in sp_add_process_queue - ' || err_text,
                p_message_type,
                p_message_text
            );
            p_message_type := 'KO';
            p_message_text := err_text;

    End sp_process_add_planning;

    Procedure sp_process_started(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_process_queue
        Set
            process_start_date = sysdate,
            status = c_process_started
        Where
            key_id = Trim(p_key_id);

        sp_process_log_info(
            p_person_id,
            p_meta_id,
            p_key_id,
            'Process started - ' || p_process_log,
            p_message_type,
            p_message_text
        );

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(
                p_person_id,
                p_meta_id,
                p_key_id,
                'Error in sp_start_process_queue - ' || err_text,
                p_message_type,
                p_message_text
            );
            p_message_type := 'KO';
            p_message_text := err_text;

    End sp_process_started;

    Procedure sp_process_stop_with_success(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_process_queue
        Set
            process_finish_date = sysdate,
            status = c_process_finished
        Where
            key_id = Trim(p_key_id);

        sp_process_log_info(
            p_person_id,
            p_meta_id,
            p_key_id,
            'Process finished - ' || p_process_log,
            p_message_type,
            p_message_text
        );

        Insert Into app_process_finished
        Select
            *
        From
            app_process_queue
        Where
            key_id = Trim(p_key_id);

        Delete
            From app_process_queue
        Where
            status In (c_process_finished, c_process_error);

        sp_process_log_info(
            p_person_id,
            p_meta_id,
            p_key_id,
            'Process archived',
            p_message_type,
            p_message_text
        );

    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(
                p_person_id,
                p_meta_id,
                p_key_id,
                'Error in sp_finish_process_queue - ' || err_text,
                p_message_type,
                p_message_text
            );
            p_message_type := 'KO';
            p_message_text := err_text;

    End sp_process_stop_with_success;

    Procedure sp_process_stop_with_error(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_process_queue
        Set
            status = c_process_error
        Where
            key_id = Trim(p_key_id);

        sp_process_log_error(
            p_person_id,
            p_meta_id,
            p_key_id,
            'Process error - ' || p_process_log,
            p_message_type,
            p_message_text
        );

        --send mail to IT ???

        Insert Into app_process_finished
        Select
            *
        From
            app_process_queue
        Where
            key_id = Trim(p_key_id);

        sp_process_log_info(
            p_person_id,
            p_meta_id,
            p_key_id,
            'Process archived',
            p_message_type,
            p_message_text
        );
    Exception
        When Others Then
            err_text       := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            sp_process_log_error(
                p_person_id,
                p_meta_id,
                p_key_id,
                'Error in sp_error_process_queue - ' || err_text,
                p_message_type,
                p_message_text
            );
            p_message_type := 'KO';
            p_message_text := err_text;

    End sp_process_stop_with_error;

    Procedure sp_add_process_queue_log(
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_process_log_type Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Insert Into app_process_queue_log(
            key_id,
            process_log,
            process_log_type,
            created_on
        )
        Values(
            p_key_id,
            p_process_log,
            p_process_log_type,
            sysdate
        );
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_process_queue_log;

    Procedure sp_process_log_info(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        sp_add_process_queue_log(
            p_key_id           => p_key_id,
            p_process_log      => p_process_log,
            p_process_log_type => const_log_type_info,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_log_info;

    Procedure sp_process_log_warning(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        sp_add_process_queue_log(
            p_key_id           => p_key_id,
            p_process_log      => p_process_log,
            p_process_log_type => const_log_type_warning,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_log_warning;

    Procedure sp_process_log_error(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_process_log      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        sp_add_process_queue_log(
            p_key_id           => p_key_id,
            p_process_log      => p_process_log,
            p_process_log_type => const_log_type_error,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_log_error;

    Function fn_get_emp_process_list(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,

        p_process_id      Varchar2 Default Null,
        p_process_item_id Varchar2 Default Null
    ) Return Sys_Refcursor Is
        p_rec   Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);

        Open p_rec For
            Select
                pq.key_id,
                pq.module_id,
                pq.process_id,
                pq.process_desc,
                pq.parameter_json,
                pq.process_start_date,
                pq.process_finish_date,
                pq.created_on,
                pq.status,
                ps.status_desc,
                fn_get_process_log(pq.key_id) process_log,
                pq.process_item_id
            From
                app_process_queue  pq,
                app_process_status ps
            Where
                pq.status = ps.status
                And Exists
                (
                    Select
                        Max(pq2.created_on), pq2.parameter_json, pq2.process_id, pq2.empno, pq2.process_item_id
                    From
                        app_process_queue pq2
                    Where
                        pq2.created_on          = pq.created_on
                        And pq2.parameter_json  = pq.parameter_json
                        And pq2.process_id      = pq.process_id
                        And pq2.process_item_id = pq.process_item_id
                        And pq2.empno           = pq.empno
                        And pq2.empno           = Trim(v_empno)
                        And pq2.process_item_id = nvl(Trim(p_process_item_id), pq2.process_item_id)
                        And pq2.process_id      = nvl(Trim(p_process_id), pq2.process_id)
                    Group By
                        pq2.parameter_json, pq2.process_id, pq2.empno, pq2.process_item_id
                )

            Union All

            Select
                pf.key_id,
                pf.module_id,
                pf.process_id,
                pf.process_desc,
                pf.parameter_json,
                pf.process_start_date,
                pf.process_finish_date,
                pf.created_on,
                pf.status,
                ps.status_desc,
                fn_get_process_log(pf.key_id) process_log,
                pf.process_item_id
            From
                app_process_finished pf,
                app_process_status   ps
            Where
                pf.status = ps.status
                And Exists

                (
                    Select
                        Max(pf2.created_on), pf2.parameter_json, pf2.process_id, pf2.empno, pf2.process_item_id
                    From
                        app_process_finished pf2
                    Where
                        pf2.created_on          = pf.created_on
                        And pf2.parameter_json  = pf.parameter_json
                        And pf2.process_id      = pf.process_id
                        And pf2.process_item_id = pf.process_item_id
                        And pf2.empno           = pf.empno
                        And pf2.empno           = Trim(v_empno)
                        And pf2.process_item_id = nvl(Trim(p_process_item_id), pf2.process_item_id)
                        And pf2.process_id      = nvl(Trim(p_process_id), pf2.process_id)
                    Group By
                        pf2.parameter_json, pf2.process_id, pf2.empno, pf2.process_item_id
                );

        Return p_rec;
    End fn_get_emp_process_list;

    Function fn_get_pending_process_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c         Sys_Refcursor;
        v_sysdate Date;
    Begin
        v_sysdate := sysdate;
        Insert Into app_process_finished
        (
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            process_start_date,
            process_finish_date,
            created_on,
            status,
            mail_to,
            mail_cc,
            process_item_id
        )
        Select
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            process_start_date,
            process_finish_date,
            created_on,
            status,
            mail_to,
            mail_cc,
            process_item_id
        From
            app_process_queue
        Where
            status In (c_process_finished, c_process_error);

        Delete
            From app_process_queue
        Where
            status In (c_process_finished, c_process_error);

        Insert Into app_process_queue(
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            created_on,
            status,
            mail_to,
            mail_cc,
            process_item_id
        )
        Select
            key_id,
            empno,
            module_id,
            process_id,
            process_desc,
            parameter_json,
            v_sysdate,
            c_process_pending,
            mail_to,
            mail_cc,
            process_item_id
        From
            app_process_queue_planned
        Where
            planned_start_date <= v_sysdate;

        Delete
            From app_process_queue_planned
        Where
            planned_start_date <= v_sysdate;

        Commit;

        Open c For
            Select
                *
            From
                app_process_queue
            Where
                status = c_process_pending
                And Rownum <= p_page_length
            Order By
                created_on;
        Return c;

    End;

    Function fn_get_process_log(
        p_key_id Varchar2
    ) Return Varchar2 As
        v_process_log app_process_queue_log.process_log%Type;
    Begin
        Select
            process_log
        Into
            v_process_log
        From
            (
                Select
                    process_log
                From
                    app_process_queue_log
                Where
                    key_id = Trim(p_key_id)
                Order By created_on Desc
            )
        Where
            Rownum = 1;
        Return v_process_log;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_process_log_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_key_id    Varchar2
    ) Return Sys_Refcursor As
        p_rec   Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        Open p_rec For
            Select
                Row_Number() Over (Order By
                        apql.created_on)                         As "step_no",
                to_char(apql.created_on, 'DD-Mon-YYYY HH:MI:SS') created_on,
                Case apql.process_log_type
                    When 'I' Then
                        'Info'
                    When 'W' Then
                        'Warning'
                    When 'E' Then
                        'Error'
                End                                              As process_log_type,
                process_log
            From
                app_process_queue_log apql
            Where
                apql.key_id = Trim(p_key_id)
            Order By
                apql.created_on;

        Return p_rec;
    Exception
        When Others Then
            Return Null;
    End;

End pkg_app_process_queue;