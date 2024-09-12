---------------------------------------------------------------
--  DDL for Package body PKG_RELATIVES_AS_COLLEAGUES_SEND_EMAIL
---------------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."PKG_RELATIVES_AS_COLLEAGUES_SEND_EMAIL" As

    Procedure prc_get_relatives_decl_status_details(
        p_empno                            Varchar2,
        p_decl_status                      Number,

        p_decl_date                    Out Date,
        p_decl_status_text             Out Varchar2,
        p_relative_as_colleague_exists Out Varchar2,

        p_message_type                 Out Varchar2,
        p_message_text                 Out Varchar2
    ) As
    Begin
        Select
            decl_date,
            pkg_emp_loa_addendum_acceptance_qry.fn_get_emp_relatives_loa_status(rds.decl_status) As decl_status_text,
            relative_as_colleague_exists
        Into
            p_decl_date,
            p_decl_status_text,
            p_relative_as_colleague_exists
        From
            vu_emplmast               e,
            emp_relatives_decl_status rds
        Where
            rds.empno                   = e.empno
            And e.status                = 1
            And nvl(rds.decl_status, 0) = p_decl_status
            And e.empno                 = Trim(p_empno);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
    End;

    Function fnc_get_mail_body(
        p_empno                        Varchar2,
        p_accept_status                Varchar2,
        p_decl_date                    Date Default Null,
        p_relative_as_colleague_exists Varchar2 Default Null
    ) Return Varchar2 Is
        Cursor cur_rel Is
            Select
                colleague_empno    empno,
                colleague_name     name,
                colleague_dept     dept,
                pkg_relatives_as_colleagues_qry.frc_get_relatives_relation(
                    colleague_relation
                )                  As relation,
                colleague_location location
            From
                emp_relatives_as_colleagues
            Where
                empno = Trim(p_empno)
            Order By
                colleague_dept;

        v_msg_body                     Varchar2(4000);
        v_relative_as_colleague_exists Char(3) := 'No';
        v_communication_date           emp_relatives_as_colleagues_comm.communication_date%Type;
        v_name                         vu_emplmast.name%Type;
    Begin
        If nvl(p_relative_as_colleague_exists, not_ok) = ok Then
            v_relative_as_colleague_exists := 'Yes';
        End If;

        Select
            communication_date
        Into
            v_communication_date
        From
            (
                Select
                    communication_date
                From
                    emp_relatives_as_colleagues_comm
                Order By communication_date
            )
        Where
            Rownum = 1;

        Select
            name
        Into
            v_name
        From
            vu_emplmast
        Where
            empno = Trim(p_empno);

        v_msg_body := '<p>Dear ' || v_name || ',</p><br />';
        v_msg_body := v_msg_body || '<p>In reference to our email communication regarding Declaration of Relatives employed with TCMPL ';
        If p_accept_status = ok Then
            v_msg_body := v_msg_body || 'dated ' || v_communication_date || ' we hereby appreciate your declaration made on ' ||
                          p_decl_date || ', please find below the details submitted by ';
            v_msg_body := v_msg_body || 'you for your records.</p>';

            v_msg_body := v_msg_body || '<br /><p>Any relatives of mine employed with TCMPL (Yes/No) - ' || v_relative_as_colleague_exists ||
                          '</p>';

            If v_relative_as_colleague_exists = 'Yes' Then
                v_msg_body := v_msg_body || '<table style="border-collapse: collapse;width:75%; max-width:500px;" border="0"><tbody>';
                v_msg_body := v_msg_body || '<tr><th>Empno</th><th>Name</th><th>Dept</th><th>Relation</th><th>Location</th></tr>';
                For c1 In cur_rel
                Loop
                    v_msg_body := v_msg_body || '<tr><td>' || c1.empno || '</td><td>' || c1.name || '</td><td>' || c1.dept ||
                    '</td><td>' || c1.relation || '</td><td>' || c1.location || '</td></tr>';
                End Loop;
                v_msg_body := v_msg_body || '</tbody></table><br /><br />';
            End If;
        Else
            v_msg_body := v_msg_body || 'dated ' || v_communication_date || ' you have not responded and hence we are considering that you do not have any ';
            v_msg_body := v_msg_body || 'relatives employed with TCMPL.  Please note any false declaration will result in disciplinary action ';
            v_msg_body := v_msg_body || 'against the defaulting employee.';

            v_msg_body := v_msg_body || '<br /><p>Any relatives of mine employed with TCMPL (Yes/No) - ' || v_relative_as_colleague_exists ||
                          '</p>';
        End If;

        v_msg_body := v_msg_body || '<p>Regards, <br /><br />TCMPL HR</p>';

        Return v_msg_body;
    End fnc_get_mail_body;

    Procedure prc_process_mail_for_queue(
        p_empno                        Varchar2,
        p_email                        Varchar2,
        p_accept_status                Varchar2,
        p_decl_date                    Date     Default Null,
        p_relative_as_colleague_exists Varchar2 Default Null,

        p_message_type Out             Varchar2,
        p_message_text Out             Varchar2
    ) As
        v_subject  Varchar2(60);
        v_msg_body Varchar2(4000);
        v_success  Varchar2(1000);
        v_message  Varchar2(500);
        v_empno    Varchar2(5);
        v_mail_to  Varchar2(4000);
    Begin
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        v_subject      := c_subject;

        v_msg_body     := fnc_get_mail_body(p_empno                        => p_empno,
                                            p_accept_status                => p_accept_status,
                                            p_decl_date                    => p_decl_date,
                                            p_relative_as_colleague_exists => p_relative_as_colleague_exists);

        tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
            p_person_id    => Null,
            p_meta_id      => Null,
            p_mail_to      => p_email,
            p_mail_cc      => Null,
            p_mail_bcc     => Null,
            p_mail_subject => v_subject,
            p_mail_body1   => v_msg_body,
            p_mail_body2   => Null,
            p_mail_type    => 'HTML',
            p_mail_from    => c_mail_from,
            p_message_type => v_success,
            p_message_text => v_message
        );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End prc_process_mail_for_queue;

    Procedure prc_send_mail(
        p_person_id        Varchar2 Default Null,
        p_meta_id          Varchar2 Default Null,

        p_empno            Varchar2 Default Null,
        p_decl_status      Number,
        p_accept_status    Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno                        vu_emplmast.empno%Type;
        v_emp                          vu_emplmast.empno%Type;
        v_email                        vu_emplmast.email%Type;
        v_decl_date                    emp_relatives_decl_status.decl_date%Type;
        v_decl_status_text             emp_relatives_loa_status_mast.status_desc%Type;
        v_relative_as_colleague_exists emp_relatives_decl_status.relative_as_colleague_exists%Type;
    Begin
        If p_empno Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERROR' Then
                p_message_type := not_ok;
                p_message_text := 'Invalid employee number';
                Return;
            End If;
            v_emp   := v_empno;
        Else
            v_emp := p_empno;
        End If;

        Begin
            Select
                email
            Into
                v_email
            From
                vu_emplmast               e,
                emp_relatives_decl_status rds
            Where
                rds.empno    = e.empno
                And e.status = 1
                And e.empno  = Trim(v_emp);
        Exception
            When Others Then
                p_message_type := not_ok;
                p_message_text := 'Invalid employee number';
                Return;
        End;

        If v_email Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Email found blank !!!';
            Return;
        End If;

        prc_get_relatives_decl_status_details(
            p_empno                        => v_emp,
            p_decl_status                  => p_decl_status,

            p_decl_date                    => v_decl_date,
            p_decl_status_text             => v_decl_status_text,
            p_relative_as_colleague_exists => v_relative_as_colleague_exists,

            p_message_type                 => p_message_type,
            p_message_text                 => p_message_text
        );
        If p_message_type = ok Then
            prc_process_mail_for_queue(
                p_empno                        => v_emp,
                p_email                        => v_email,
                p_accept_status                => p_accept_status,
                p_decl_date                    => v_decl_date,
                p_relative_as_colleague_exists => v_relative_as_colleague_exists,

                p_message_type                 => p_message_type,
                p_message_text                 => p_message_text
            );

            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;
    End;

    Procedure sp_send_mail_on_declaration(
        p_person_id        Varchar2 Default Null,
        p_meta_id          Varchar2 Default Null,

        p_empno            Varchar2 Default Null,
        p_decl_status      Number,
        p_accept_status    Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        prc_send_mail(
            p_person_id     => p_person_id,
            p_meta_id       => p_meta_id,

            p_empno         => p_empno,
            p_decl_status   => 1,
            p_accept_status => ok,

            p_message_type  => p_message_type,
            p_message_text  => p_message_text
        );

        p_message_type := p_message_type;
        p_message_text := p_message_text;
    End;

    Procedure sp_send_mail_on_deemed_declaration(
        p_person_id        Varchar2 Default Null,
        p_meta_id          Varchar2 Default Null,

        p_empno            Varchar2 Default Null,
        p_decl_status      Number,
        p_accept_status    Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        prc_send_mail(
            p_person_id     => p_person_id,
            p_meta_id       => p_meta_id,

            p_empno         => p_empno,
            p_decl_status   => 2,
            p_accept_status => not_ok,

            p_message_type  => p_message_type,
            p_message_text  => p_message_text
        );

        p_message_type := p_message_type;
        p_message_text := p_message_text;
    End;

End pkg_relatives_as_colleagues_send_email;
/