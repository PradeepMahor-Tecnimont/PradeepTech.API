Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_LOA_ADDENDUM_ACCEPTANCE" As

    Procedure sp_update_emp_loa_addendum_acceptance (
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_acceptance_status Number,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_emp   Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            empno
          Into v_emp
          From
            vu_emplmast
         Where
                status = 1 And
            empno  = v_empno And
            emptype In ( 'R',
                         'F' );

        Update emp_loa_addendum_acceptance
           Set
            acceptance_status = p_acceptance_status,
            acceptance_date = sysdate
         Where
                empno             = v_empno And
            acceptance_status = 0;

        If Sql%found Then
        delete from emp_loa_addendum_events where empno = v_empno;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error...Invalid operation';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_update_emp_loa_addendum_acceptance;

    Procedure sp_deemed_emp_loa_acceptance (
        p_person_id                       Varchar2,
        p_meta_id                         Varchar2,
        p_emp_list Out Sys_Refcursor,
        p_message_type                    Out Varchar2,
        p_message_text                    Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
        c       Sys_Refcursor;
    Begin
         
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        

        /*
        Select
            Count(b.empno)
          Into v_count
          From
            emp_loa_addendum_acceptance b
         Where
            b.acceptance_status = 0;

        If v_count = 0 Then
            p_message_type := ok;
            p_message_text := 'LOA Pending employees not found..';
            Return;
        End If;
        */

        Update emp_loa_addendum_acceptance
           Set
            acceptance_status = 2,
            acceptance_date = sysdate
         Where
            acceptance_status = 0;

        Open p_emp_list For 
        Select
            a1.empno       employee_no,
            get_emp_name(
                a1.empno
            )              employee_name,
            to_char(
                sysdate,
                'dd-Mon-yyyy'
            )              curr_date,
            to_char(
                a1.acceptance_date,
                'dd-Mon-yyyy hh24:mi:ss'
            )              acceptance_date
            ,
            a2.status_code status_code,
            a2.status_desc acceptance_status,
            a3.email email
          From
            tcmpl_hr.emp_loa_addendum_acceptance a1
            ,
            emp_relatives_loa_status_mast        a2 ,
          vu_emplmast a3
           Where
                  a1.acceptance_status = a2.status_code And
              a1.acceptance_status = 2
              and a1.empno = a3.empno;
 
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
       

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_deemed_emp_loa_acceptance;


    Procedure sp_add_event_pdf_generated(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_file_name        Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count                  Number;
        v_empno                  Varchar2(5);
        v_emp                    Varchar2(5);
        c_pdf_generated_event_id Constant Number(1) := 1;
        c_consent                Constant Number(1) := 1;
        c_deemed_consent         Constant Number(1) := 2;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;


        --Check consent enabled for Employee
        Select
            Count(*)
        Into
            v_count
        From
            emp_loa_addendum_acceptance
        Where
            empno = p_empno
            And acceptance_status In (c_consent, c_deemed_consent);

        If v_count != 1 Then
            p_message_type := not_ok;
            p_message_text := 'Employee not enabled for Addendum consent.';
            Return;
        End If;

        --Check event already exists
        Select
            Count(*)
        Into
            v_count
        From
            emp_loa_addendum_events
        Where
            empno        = p_empno
            And event_id = c_pdf_generated_event_id;

        If v_count != 0 Then
            p_message_type := not_ok;
            p_message_text := 'PDF already generated cannot update.';
            Return;
        End If;
        Insert Into emp_loa_addendum_events (
            empno,
            event_id,
            remarks,
            modified_on
        )
        Values
        (
            p_empno,
            c_pdf_generated_event_id,
            p_file_name,
            sysdate
        );
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_add_event_email_queued(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno                 Varchar2(5);
        v_emp                   Varchar2(5);
        v_count                 Number;

        c_email_queued_event_id Constant Number(1) := 2;
        c_consent               Constant Number(1) := 1;
        c_deemed_consent        Constant Number(1) := 2;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        --Check consent enabled for Employee
        Select
            Count(*)
        Into
            v_count
        From
            emp_loa_addendum_acceptance
        Where
            empno = p_empno
            And acceptance_status In (c_consent, c_deemed_consent);

        If v_count != 1 Then
            p_message_type := not_ok;
            p_message_text := 'Employee not enabled for Addendum consent.';
            Return;
        End If;

        --Check event already exists
        Select
            Count(*)
        Into
            v_count
        From
            emp_loa_addendum_events
        Where
            empno        = p_empno
            And event_id = c_email_queued_event_id;

        If v_count != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Email already queued cannot update.';
            Return;
        End If;
        Insert Into emp_loa_addendum_events (
            empno,
            event_id,
            remarks,
            modified_on
        )
        Values
        (
            p_empno,
            c_email_queued_event_id,
            'Email queued',
            sysdate
        );
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

End pkg_emp_loa_addendum_acceptance;