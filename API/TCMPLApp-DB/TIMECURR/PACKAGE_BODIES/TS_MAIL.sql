Create Or Replace Package Body timecurr.ts_mail As
    
    --SEND MAIL TO USERS WHO HAVE NOT FILLED THEIR TIMESHEETS
    Procedure proc_mail_notfilled_timesheet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        Cursor cur_not_filled Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_not_filled_list
            From
                (
                    Select
                        empno,
                        replace(mailbcc, ',', '.')                     user_email,

                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                a.empno empno,
                                a.email mailbcc
                            From
                                emplmast a
                            Where
                                a.emptype In (
                                    Select
                                        emptype
                                    From
                                        emptypemast
                                    Where
                                        nvl(tm, 0) = 1
                                )
                                And nvl(a.status, 0) = 1
                                And a.email Is Not Null
                                And Not Exists (
                                    Select
                                        time_mast.*
                                    From
                                        time_mast b
                                    Where
                                        b.yymm      = Trim(p_yymm)
                                        And b.yymm  = (
                                             Select
                                                 pros_month
                                             From
                                                 tsconfig
                                         )
                                        And b.empno = a.empno
                                )
                                And Exists (
                                    Select
                                        c.*
                                    From
                                        costmast c
                                    Where
                                        c.costcode In (
                                            Select
                                                costcode
                                            From
                                                deptphase
                                            Where
                                                isprimary = 1
                                        )
                                        And nvl(c.active, 0) = 1
                                        And c.costcode       = a.assign
                                        And c.costcode Not In (
                                            Select
                                                deptno
                                            From
                                                ngts_deputation_dept
                                        )
                                )
                                --AND nvl(a.costhead, 0) = 0
                                And dol Is Null
                        )
                    Order By empno
                )
            Group By
                group_id;

        v_mail_csv Varchar2(2000);
        v_subject  Varchar2(1000);
        v_msg_body Varchar2(2000);
        v_success  Varchar2(1000);
        v_message  Varchar2(500);
        v_empno    Varchar2(5);
    Begin
        p_message_type := 'OK';
        p_message_text := 'No data found to process';

        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If p_yymm Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Processing month cannot be blank';
            Return;
        End If;
        
        Select
            create_mail_body_notfilled(p_yymm, (
                    Select
                        name
                    From
                        emplmast
                    Where
                        empno = v_empno
                ))
        Into
            v_msg_body
        From
            dual;

        v_subject      := 'Timesheet not yet Created';

        For email_not_filled_row In cur_not_filled
        Loop
            v_mail_csv := email_not_filled_row.email_not_filled_list;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'Text',
                p_mail_from    => c_mail_from,
                p_message_type => v_success,
                p_message_text => v_message
            );
        End Loop;

        p_message_type := p_message_type;
        p_message_text := p_message_text;

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End proc_mail_notfilled_timesheet;

    --SEND MAIL TO USERS WHO HAVE NOT LOCKED THEIR TIMESHEETS
    Procedure proc_mail_notlocked_timesheet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        Cursor cur_not_locked Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_not_locked_list
            From
                (
                    Select
                        empno,
                        replace(mailbcc, ',', '.')                     user_email,

                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                a.empno empno,
                                a.email mailbcc
                            From
                                emplmast a
                            Where
                                a.emptype In (
                                    Select
                                        emptype
                                    From
                                        emptypemast
                                    Where
                                        nvl(tm, 0) = 1
                                )
                                And nvl(a.status, 0) = 1
                                And a.email Is Not Null
                                And Exists (
                                    Select
                                        b.*
                                    From
                                        time_mast b
                                    Where
                                        nvl(locked, 0) = 0
                                        And b.yymm     = Trim(p_yymm)
                                        And b.yymm     = (
                                                Select
                                                    pros_month
                                                From
                                                    tsconfig
                                            )
                                        And b.empno    = a.empno
                                        And Exists (
                                            Select
                                                c.*
                                            From
                                                costmast c
                                            Where
                                                c.costcode In (
                                                    Select
                                                        costcode
                                                    From
                                                        deptphase
                                                    Where
                                                        isprimary = 1
                                                )
                                                And nvl(c.active, 0) = 1
                                                And c.costcode Not In (
                                                    Select
                                                        deptno
                                                    From
                                                        ngts_deputation_dept
                                                )
                                        )
                                )
                        )
                    Order By empno
                )
            Group By
                group_id;

        v_mail_csv Varchar2(2000);
        v_subject  Varchar2(1000);
        v_msg_body Varchar2(2000);
        v_success  Varchar2(1000);
        v_message  Varchar2(500);
        v_empno    Varchar2(5);
    Begin
        p_message_type := 'OK';
        p_message_text := 'No data found to process';

        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If p_yymm Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Processing month cannot be blank';
            Return;
        End If;
        
        Select
            create_mail_body_notlocked(p_yymm, (
                    Select
                        name
                    From
                        emplmast
                    Where
                        empno = v_empno
                ))
        Into
            v_msg_body
        From
            dual;

        v_subject      := 'Timesheet not yet Locked';

        For email_not_locked_row In cur_not_locked
        Loop
            v_mail_csv := email_not_locked_row.email_not_locked_list;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'Text',
                p_mail_from    => c_mail_from,
                p_message_type => v_success,
                p_message_text => v_message
            );
        End Loop;

        p_message_type := p_message_type;
        p_message_text := p_message_text;

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End proc_mail_notlocked_timesheet;

    --SEND MAIL TO HoDs WHO HAVE NOT YET POSTED THEIR EMPLOYEES TIMESHEETS

    Procedure proc_mail_notposted_timesheet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        Cursor cur_not_posted Is
            Select
                user_email,
                create_mail_body_notposted(p_yymm, costcode, name, (
                        Select
                            name
                        From
                            emplmast
                        Where
                            empno = get_empno_from_meta_id(p_meta_id)
                    )) mail_body
            From
                (

                    Select
                    Distinct

                        replace(c.email, ',', '.') user_email,
                        b.costcode                 costcode,
                        b.name                     name

                    From
                        emplmast a,
                        costmast b,
                        emplmast c
                    Where
                        b.hod                = c.empno
                        And c.email Is Not Null
                        And nvl(c.status, 0) = 1
                        And a.emptype In (
                            Select
                                emptype
                            From
                                emptypemast
                            Where
                                nvl(tm, 0) = 1
                        )
                        And nvl(a.status, 0) = 1
                        And a.assign In (
                            Select
                                costcode
                            From
                                deptphase
                            Where
                                isprimary = 1
                        )
                        And b.costcode Not In (
                            Select
                                deptno
                            From
                                ngts_deputation_dept
                        )
                        And ((a.assign       = b.costcode
                                And Not Exists (
                                    Select
                                        time_mast.*
                                    From
                                        time_mast d
                                    Where
                                        nvl(d.posted, 0) = 1
                                        And d.yymm       = Trim(p_yymm)
                                        And d.yymm       = (
                                                  Select
                                                      pros_month
                                                  From
                                                      tsconfig
                                              )
                                        And d.empno      = a.empno
                                ))
                            Or Exists (
                                Select
                                    time_mast.*
                                From
                                    time_mast d
                                Where
                                    (d.locked         = 0
                                        Or d.approved = 0
                                        Or d.posted   = 0)
                                    And d.yymm        = Trim(p_yymm)
                                    And d.yymm        = (
                                               Select
                                                   pros_month
                                               From
                                                   tsconfig
                                           )
                                    And d.empno       = a.empno
                                    And d.assign      = b.costcode
                            ))
                    Order By c.email
                );

        v_mail_csv Varchar2(2000);
        v_subject  Varchar2(1000);
        v_msg_body Varchar2(4000);
        v_success  Varchar2(1000);
        v_message  Varchar2(500);
        v_empno    Varchar2(5);
    Begin
        p_message_type := 'OK';
        p_message_text := 'No data found to process';
        
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If p_yymm Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Processing month cannot be blank';
            Return;
        End If;
        
        v_subject      := 'Timesheets Pending for your Approval/Posting';

        For email_not_posted_row In cur_not_posted
        Loop
            v_mail_csv := email_not_posted_row.user_email;
            v_msg_body := email_not_posted_row.mail_body;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => v_mail_csv,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'Text',
                p_mail_from    => c_mail_from,
                p_message_type => v_success,
                p_message_text => v_message
            );
        End Loop;

        p_message_type := p_message_type;
        p_message_text := p_message_text;

    End proc_mail_notposted_timesheet;

    --CREATE MAIL BODY 
    --CALLED BY proc_mail_notfilled_timesheet    
    Function create_mail_body_notfilled(
        p_yymm           Varchar2,
        p_empname_logged Varchar2
    ) Return Varchar2 Is
        p_create_msg Varchar2(4000);
    Begin
        p_create_msg := 'Dear Sir/Madam,' || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'This is to inform you that Timesheet has not yet been Created by you for this month.' ||
                        chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Do the needful at the earliest.' || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Waiting for Creating of Timesheet for the month ' || p_yymm || '.' || chr(13) ||
                        chr(10) || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Please ignore this mail if on Long Term Deputation etc.' || chr(13) || chr(10) ||
                        chr(13) || chr(10) || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Thanks,' || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Timesheet application' || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) ||
        chr(10);
        p_create_msg := p_create_msg || 'This is an automated TCMPL Mail.';

        Return p_create_msg;
    End;    

    --CREATE MAIL BODY 
    --CALLED BY proc_mail_notlocked_timesheet
    Function create_mail_body_notlocked(
        p_yymm           Varchar2,
        p_empname_logged Varchar2
    ) Return Varchar2 Is
        p_create_msg Varchar2(4000);
    Begin
        p_create_msg := 'Dear Sir/Madam,' || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'This is to inform you that Timesheet has not been Locked by you for this month.' ||
                        chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Do the needful at the earliest.' || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Waiting for Locking of Timesheet for the month ' || p_yymm || '.' || chr(13) || chr(
        10) || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Please ignore this mail if on Long Term Deputation etc.' || chr(13) || chr(10) ||
                        chr(13) || chr(10) || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Thanks,' || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Timesheet application' || chr(13) || chr(10) || chr(13) || chr(10) || chr(13) ||
        chr(10);
        p_create_msg := p_create_msg || 'This is an automated TCMPL Mail.';

        Return p_create_msg;
    End;

    --CREATE MAIL BODY 
    --CALLED BY proc_mail_notposted_timesheet    
    Function create_mail_body_notposted(
        p_yymm           Varchar2,
        p_parent         Varchar2,
        p_name           Varchar2,
        p_empname_logged Varchar2
    ) Return Varchar2 Is

        Cursor cur_body Is
            Select
                a.empno || ' ' || a.name || Chr(13) || Chr(10) mailbody
            From
                emplmast a
            Where
                nvl(a.status, 0) = 1
                And a.emptype In (
                    Select
                        emptype
                    From
                        emptypemast
                    Where
                        nvl(tm, 0) = 1
                )
                And Not Exists (
                    Select
                        b.*
                    From
                        time_mast b
                    Where
                        b.yymm       = p_yymm
                        And b.posted = 1
                        And b.yymm   = (
                              Select
                                  pros_month
                              From
                                  tsconfig
                          )
                        And b.empno  = a.empno
                )
                And assign       = Trim(p_parent)

            Union

            Select
                a.empno || ' ' || a.name || Chr(13) || Chr(10) mailbody
            From
                emplmast a
            Where
                nvl(a.status, 0) = 1
                And a.emptype In (
                    Select
                        emptype
                    From
                        emptypemast
                    Where
                        nvl(tm, 0) = 1
                )
                And Exists (
                    Select
                        b.*
                    From
                        time_mast b
                    Where
                        b.yymm        = p_yymm
                        And (b.locked = 0 Or b.approved = 0 Or b.posted = 0)
                        And b.yymm    = (
                               Select
                                   pros_month
                               From
                                   tsconfig
                           )
                        And b.empno   = a.empno
                        And b.assign  = Trim(p_parent)
                )

            Order By
                1;

        p_create_msg Varchar2(4000);
    Begin
        p_create_msg := ' Dear Sir, ' || chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'This is to inform you that timesheet(s) created by ' || p_parent || ' ' || p_name;
        p_create_msg := p_create_msg || ' is waiting for HOD''s approval for the month ' || p_yymm || '.' || chr(13) || chr(
        10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Please do the needful at the earliest.' || chr(13) || chr(10) || chr(13) || chr(
        10);

        p_create_msg := p_create_msg || 'Secondly - List of Employees not Submitted / Locked / Approved timesheet(s).' ||
                        chr(13) || chr(10);
        p_create_msg := p_create_msg || 'Ignore if these personnel are not supposed to fill timesheet.' || chr(13) || chr(
        10) || chr(13) || chr(10);

        For cur_body_row In cur_body
        Loop
            p_create_msg := p_create_msg || cur_body_row.mailbody || chr(13) || chr(10);
        End Loop;

        p_create_msg := p_create_msg || 'Thanks,' || chr(13) || chr(10) || 'Timesheet application' || chr(13) || chr(10) ||
        chr(13) || chr(10) || chr(13) || chr(10);
        p_create_msg := p_create_msg || 'This is an automated TCMPL Mail.';

        Return p_create_msg;
    End;

    --	Grant execute on ts_mail to tcmpl_app_config;

End ts_mail;