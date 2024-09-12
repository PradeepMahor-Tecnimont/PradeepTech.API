Create Or Replace Package Body tcmpl_hr.mis_resigned_employees As

    Procedure sp_create (
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_emp_resign_date       Date,
        p_hr_receipt_date       Date,
        p_date_of_relieving     Date,
        p_emp_resign_reason     Varchar2,
        p_primary_reason        Varchar2,
        p_secondary_reason      Varchar2 Default Null,
        p_moving_to_location    Varchar2 Default Null,
        p_current_location      Varchar2 Default Null,
        p_additional_feedback   Varchar2,
        p_interview_complete    Varchar2,
        p_percent_increase      Number Default Null,
        p_resign_status         Varchar2,
        p_commitment_onrollback Varchar2 Default Null,
        p_last_date_in_office   Date Default Null,
        p_email_sent            Varchar2,
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
    ) As

        v_by_empno      Varchar2(5);
        v_key_id        Varchar2(8);
        v_exists        Number;
        v_from_costcode Varchar2(4);
        v_status        Number;
        v_count         Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_key_id       := dbms_random.string('X', 8);

        --Check valid Empno
        Select
            Count(*)
          Into v_count
          From
            vu_emplmast
         Where
            empno = p_empno;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee.';
            Return;
        End If;

        --Check blank values
        If p_emp_resign_date Is Null Or p_hr_receipt_date Is Null Or p_date_of_relieving Is Null Or p_emp_resign_reason Is Null Or p_primary_reason
        Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Blank values found. Cannot proceed.';
            Return;
        End If;

        --Check Last date is office is given
        If
            p_resign_status In ( '03', '04' )
            And p_last_date_in_office Is Null
        Then
            p_message_type := not_ok;
            p_message_text := 'Last date in office is required.';
            Return;
        End If;

        --Check Reason type is valid
        Select
            Count(*)
          Into v_count
          From
            mis_mast_resign_reason_types
         Where
            resign_reason_type = p_primary_reason;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid resign type code.';
            Return;
        End If;

        --Check resign status code
        Select
            Count(*)
          Into v_count
          From
            mis_mast_resign_reason_types
         Where
            resign_reason_type = p_resign_status;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid resign status code.';
            Return;
        End If;

        Insert Into mis_resigned_emp (
            key_id,
            empno,
            emp_resign_date,
            hr_receipt_date,
            date_of_relieving,
            emp_resign_reason,
            primary_reason,
            secondary_reason,
            moving_to_location,
            current_location,
            additional_feedback,
            exit_interview_complete,
            percent_increase,
            resign_status_code,
            commitment_on_rollback,
            actual_last_date_in_office,
            is_email_sent,
            modified_by,
            modified_on
        ) Values (
            v_key_id,
            p_empno,
            p_emp_resign_date,
            p_hr_receipt_date,
            p_date_of_relieving,
            p_emp_resign_reason,
            p_primary_reason,
            p_secondary_reason,
            p_moving_to_location,
            p_current_location,
            p_additional_feedback,
            p_interview_complete,
            p_percent_increase,
            p_resign_status,
            p_commitment_onrollback,
            p_last_date_in_office,
            p_email_sent,
            v_by_empno,
            sysdate
        );

        If ( Sql%rowcount > 0 ) Then
            If p_email_sent = ok Then
                mis_resigned_employees.send_mail(p_empno => p_empno);
            End If;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

     Procedure sp_update(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_key_id                Varchar2,

        p_empno                 Varchar2,
        p_emp_resign_date       Date,
        p_hr_receipt_date       Date,
        p_date_of_relieving     Date,
        p_emp_resign_reason     Varchar2,

        p_primary_reason        Varchar2,
        p_secondary_reason      Varchar2 Default Null,
        p_moving_to_location    Varchar2 Default Null,
        p_current_location      Varchar2 Default Null,

        p_additional_feedback   Varchar2,
        p_interview_complete    Varchar2,
        p_percent_increase      Number   Default Null,
        p_resign_status         Varchar2,
        p_commitment_onrollback Varchar2 Default Null,
        p_last_date_in_office   Date     Default Null,
        p_email_sent            Varchar2,

        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) As
        v_by_empno      Varchar2(5);
        v_key_id        Varchar2(8);
        v_exists        Number;
        v_from_costcode Varchar2(4);
        v_status        Number;
        v_count         Number;
        v_status_email  Varchar2(2):= null;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        --Check valid Empno
        Select
            Count(*)
        Into
            v_count
        From
            mis_resigned_emp
        Where
            key_id    = p_key_id
            And empno = p_empno;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee.';
            Return;
        End If;

        --Check blank values
        If p_emp_resign_date Is Null Or p_hr_receipt_date Is Null Or p_date_of_relieving Is Null Or p_emp_resign_reason Is
        Null Or p_primary_reason Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Blank values found. Cannot proceed.';
            Return;
        End If;

        --Check Last date is office is given
        If p_resign_status In ('03', '04') And p_last_date_in_office Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Last date in office is required.';
            Return;
        End If;

        --Check Reason type is valid
        Select
            Count(*)
        Into
            v_count
        From
            mis_mast_resign_reason_types
        Where
            resign_reason_type = p_primary_reason;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid resign type code.';
            Return;
        End If;

        --Check resign status code
        Select
            Count(*)
        Into
            v_count
        From
            mis_mast_resign_reason_types
        Where
            resign_reason_type = p_resign_status;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid resign status code.';
            Return;
        End If;

        Select
            nvl(is_email_sent, not_ok)
          Into v_status_email
          From
            mis_resigned_emp
         Where
                key_id = p_key_id
               And empno = p_empno;

        Update
            mis_resigned_emp
        Set
            emp_resign_date = p_emp_resign_date,
            hr_receipt_date = p_hr_receipt_date,
            date_of_relieving = p_date_of_relieving,
            emp_resign_reason = p_emp_resign_reason,

            primary_reason = p_primary_reason,
            secondary_reason = p_secondary_reason,
            moving_to_location = p_moving_to_location,
            current_location = p_current_location,

            additional_feedback = p_additional_feedback,
            exit_interview_complete = p_interview_complete,
            percent_increase = p_percent_increase,
            resign_status_code = p_resign_status,
            commitment_on_rollback = p_commitment_onrollback,
            actual_last_date_in_office = p_last_date_in_office,
            is_email_sent = p_email_sent,

            modified_by = v_by_empno,
            modified_on = sysdate
        Where
            key_id = p_key_id;
/*
        If (Sql%rowcount > 0) Then
            If p_email_sent = ok Then
                mis_resigned_employees.send_mail(
                    p_empno => p_empno
                );
            End If;
        End If;
*/
        If ( Sql%rowcount > 0 ) Then
            

            If p_email_sent = ok And v_status_email = not_ok Then
                mis_resigned_employees.send_mail(p_empno => p_empno);
            End If;

        End If;
        
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_key_id       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno Varchar2(5);
        v_count    Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From mis_resigned_emp
         Where
            key_id = p_key_id;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_details (
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,
        p_key_id                     Varchar2,
        p_empno                      Out Varchar2,
        p_employee_name              Out Varchar2,
        p_emp_resign_date            Out Date,
        p_hr_receipt_date            Out Date,
        p_date_of_relieving          Out Date,
        p_emp_resign_reason          Out Varchar2,
        p_primary_reason             Out Varchar2,
        p_primary_reason_desc        Out Varchar2,
        p_secondary_reason           Out Varchar2,
        p_secondary_reason_desc      Out Varchar2,
        p_moving_to_location         Out Varchar2,
        p_current_location           Out Varchar2,
        p_current_loc_desc           Out Varchar2,
        p_additional_feedback        Out Varchar2,
        p_exit_interview_complete    Out Varchar2,
        p_percent_increase           Out Number,
        p_resign_status_code         Out Varchar2,
        p_resign_status_desc         Out Varchar2,
        p_commitment_on_rollback     Out Varchar2,
        p_actual_last_date_in_office Out Varchar2,
        p_doj                        Out Date,
        p_grade                      Out Varchar2,
        p_designation                Out Varchar2,
        p_department                 Out Varchar2,
        p_email_sent                 Out Varchar2,
        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_by_empno         Varchar2(5);
        v_count            Number;
        v_rec_resigned_emp mis_resigned_emp%rowtype;
    Begin
        v_by_empno                   := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        --Employee Resigned Data
        Select
            *
          Into v_rec_resigned_emp
          From
            mis_resigned_emp
         Where
            key_id = p_key_id;

        --Primary Reason Description
        Select
            resign_reason_desc
          Into p_primary_reason_desc
          From
            mis_mast_resign_reason_types
         Where
            resign_reason_type = v_rec_resigned_emp.primary_reason;

        --Secodnary Reason Description
        If v_rec_resigned_emp.secondary_reason Is Not Null Then
            Select
                resign_reason_desc
              Into p_secondary_reason
              From
                mis_mast_resign_reason_types
             Where
                resign_reason_type = v_rec_resigned_emp.primary_reason;

        End If;

        --Employee Current location description
        If v_rec_resigned_emp.current_location Is Not Null Then
            Select
                loc_desc
              Into p_current_loc_desc
              From
                mis_mast_cur_emp_res_loc
             Where
                loc_id = v_rec_resigned_emp.current_location;

        End If;

        --Employee resign status description
        If v_rec_resigned_emp.current_location Is Not Null Then
            Select
                resign_status_desc
              Into p_resign_status_desc
              From
                mis_mast_resign_status
             Where
                resign_status_code = v_rec_resigned_emp.resign_status_code;

        End If;

        p_empno                      := v_rec_resigned_emp.empno;
        p_employee_name              := pkg_common.fn_get_employee_name(v_rec_resigned_emp.empno);
        p_emp_resign_date            := v_rec_resigned_emp.emp_resign_date;
        p_hr_receipt_date            := v_rec_resigned_emp.hr_receipt_date;
        p_date_of_relieving          := v_rec_resigned_emp.date_of_relieving;
        p_emp_resign_reason          := v_rec_resigned_emp.emp_resign_reason;
        p_primary_reason             := v_rec_resigned_emp.primary_reason;
        p_secondary_reason           := v_rec_resigned_emp.secondary_reason;
        p_moving_to_location         := v_rec_resigned_emp.moving_to_location;
        p_current_location           := v_rec_resigned_emp.current_location;
        p_additional_feedback        := v_rec_resigned_emp.additional_feedback;
        p_percent_increase           := v_rec_resigned_emp.percent_increase;
        p_resign_status_code         := v_rec_resigned_emp.resign_status_code;
        p_commitment_on_rollback     := v_rec_resigned_emp.commitment_on_rollback;
        p_actual_last_date_in_office := v_rec_resigned_emp.actual_last_date_in_office;
        If v_rec_resigned_emp.exit_interview_complete = ok Then
            p_exit_interview_complete := 'Yes';
        Else
            p_exit_interview_complete := 'No';
        End If;

        If v_rec_resigned_emp.is_email_sent = ok Then
            p_email_sent := 'Yes';
        Else
            p_email_sent := 'No';
        End If;

        --Employee Doj, Grade, Designation, Department Data
        Select
            a.doj,
            a.grade,
            (
                Select
                    d.desg
                  From
                    vu_desgmast d
                 Where
                    d.desgcode = a.desgcode
            ) designation,
            a.parent || ' - ' || (
                Select
                    cc.name
                  From
                    vu_costmast cc
                 Where
                    cc.costcode = a.parent
            ) department
          Into
            p_doj,
            p_grade,
            p_designation,
            p_department
          From
            vu_emplmast a
         Where
            a.empno = v_rec_resigned_emp.empno;

        p_message_type               := ok;
        p_message_text               := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_emp_details (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_empno        Varchar2,
        p_doj          Out Date,
        p_grade        Out Varchar2,
        p_designation  Out Varchar2,
        p_department   Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno         Varchar2(5);
        v_count            Number;
        v_rec_resigned_emp mis_resigned_emp%rowtype;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            a.doj,
            a.grade,
            (
                Select
                    d.desg
                  From
                    vu_desgmast d
                 Where
                    d.desgcode = a.desgcode
            ) designation,
            a.parent || ' - ' || (
                Select
                    cc.name
                  From
                    vu_costmast cc
                 Where
                    cc.costcode = a.parent
            ) department
          Into
            p_doj,
            p_grade,
            p_designation,
            p_department
          From
            vu_emplmast a
         Where
            a.empno = p_empno;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure send_mail (
        p_empno Varchar2
    ) As

        v_emp_name         Varchar2(100);
        v_emp_email        Varchar2(100);
        v_hod_mail         Varchar2(100);
        v_resignation_date Date;
        v_relieving_date   Date;
        v_mail_subject     Varchar2(800);
        v_mail_to          Varchar2(2000);
        v_msg_body         Varchar2(4000);
        v_mail_cc          Varchar2(2000);
        v_success          Varchar2(20);
        v_message          Varchar2(2000);
    Begin
        Select
            a.name,
            a.email,
            (
                Select
                    vu_b.email
                  From
                    vu_emplmast vu_b
                 Where
                    vu_b.empno In (
                        Select
                            hod
                          From
                            vu_costmast
                         Where
                                costcode = a.parent
                               And hod Not In ( '04600', '04132' )
                    )
            ) hod_email,
            re.emp_resign_date,
            re.date_of_relieving
          Into
            v_emp_name,
            v_emp_email,
            v_hod_mail,
            v_resignation_date,
            v_relieving_date
          From
            vu_emplmast      a,
            mis_resigned_emp re
         Where
                a.empno = p_empno
               And a.empno = re.empno;

        v_mail_to      := v_emp_email;

        If (v_hod_mail Is Null Or v_hod_mail = '') Then
            v_mail_cc := replace(c_mail_cc,chr(10),'');
        Else
            v_mail_cc := v_hod_mail || ';' || c_mail_cc;
        End If;

        v_mail_subject := 'HR-MIS : Acceptance of Resignation - ' || p_empno || ':' || v_emp_name;
        v_msg_body     := replace(c_mail_body, '[EMPNAME]', p_empno || '-' || v_emp_name);
        v_msg_body     := replace(v_msg_body, '[RESIGNATIONDATE]', to_char(v_resignation_date, 'dd-Mon-yyyy'));
        v_msg_body     := replace(v_msg_body, '[RELIEVINGDATE]', to_char(v_relieving_date, 'dd-Mon-yyyy'));
        send_mail_from_api(p_mail_to => v_mail_to, p_mail_cc => v_mail_cc, p_mail_bcc => Null, p_mail_subject => v_mail_subject,
                          p_mail_body => v_msg_body, p_mail_profile => 'SELFSERVICE', p_mail_format => 'HTML', p_success => v_success
                          ,
                          p_message => v_message);

        Insert Into mis_resigned_mail_log (
            mail_to,
            mail_from,
            mail_cc,
            mail_bcc,
            mail_success,
            mail_success_message,
            mail_date
        ) Values (
            v_mail_to,
            Null,
            v_mail_cc,
            Null,
            v_success,
            v_message,
            sysdate
        );

        Commit;
    End send_mail;

End;