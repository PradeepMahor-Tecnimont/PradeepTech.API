--------------------------------------------------------
--  DDL for Package Body HOLIDAY_ATTENDANCE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."HOLIDAY_ATTENDANCE" As

    Procedure sp_add_holiday (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_from_date     Date,
        p_projno        Varchar2,
        p_last_hh       Number,
        p_last_mn       Number,
        p_last_hh1      Number,
        p_last_mn1      Number,
        p_lead_approver Varchar2,
        p_remarks       Varchar2,
        p_location      Varchar2,
        p_user_tcp_ip   Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Number := 0;
    Begin
        If p_location Is Null Or p_projno Is Null Or p_last_hh Is Null Or p_lead_approver Is Null Or p_from_date Is Null Then
            p_message_type := 'KO';
            p_message_text := 'Blank values found. Cannot proceed';
            Return;
        End If;
        
        --check credentials
        --v_empno := get_empno_from_person_id(p_person_id);
        v_empno    := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --save application
        add_holiday(p_person_id, p_meta_id, p_from_date, p_projno, p_last_hh,
                   p_last_mn, p_last_hh1, p_last_mn1, p_lead_approver, p_remarks,
                   p_location, p_user_tcp_ip, p_message_type, p_message_text);

        If p_message_type = 'OK' Then
            -- call send mail
            Return;
        Else
            Return;
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_holiday;

    Procedure add_holiday (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_from_date     Date,
        p_projno        Varchar2,
        p_last_hh       Number,
        p_last_mn       Number,
        p_last_hh1      Number,
        p_last_mn1      Number,
        p_lead_approver Varchar2,
        p_remarks       Varchar2,
        p_location      Varchar2,
        p_user_tcp_ip   Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As

        v_empno              Varchar2(5);
        v_count              Number;
        v_lead_approval_none Number := 4;
        v_lead_approval      Number := 0;
        v_hod_approval       Number := 0;
        v_hrd_approval       Number := 0;
        v_recno              Number;
        v_app_no             ss_holiday_attendance.app_no%Type;
        v_description        ss_holiday_attendance.description%Type;
        v_none               Char(4) := 'None';
    Begin
        --check credentials
        --v_empno := get_empno_from_person_id(p_person_id);
        v_empno    := get_empno_from_meta_id(p_meta_id);
        
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --check if application exists
        Select
            Count(empno)
        Into v_count
        From
            ss_holiday_attendance
        Where
                empno = v_empno
            And pdate = p_from_date;

        If v_count = 0 Then
            -- get last counter no.
            Begin
                Select
                    nvl(Max(to_number(substr(app_no, instr(app_no, '/', - 1) + 1))), 0) recno
                Into v_recno
                From
                    ss_holiday_attendance
                Where
                    empno = v_empno
                Group By
                    empno;

            Exception
                When no_data_found Then
                    v_recno := 0;
            End;
            --application no.
            v_app_no := 'HA/'
                        || v_empno
                        || '/'
                        || to_char(sysdate, 'DDMMYYYY')
                        || '/'
                        || to_char(v_recno + 1);
                
            -- description
            v_description := 'Appl for Holiday Attendance on '
                             || to_char(p_from_date, 'DD/MM/YYYY')
                             || ' Time '
                             || p_last_hh
                             || ':'
                             || p_last_mn
                             || ' - '
                             || p_last_hh1
                             || ':'
                             || p_last_mn1
                             || ' Location - '
                             || p_location;

            Insert Into ss_holiday_attendance (
                empno,
                pdate,
                app_no,
                app_date,
                start_hh,
                start_mm,
                end_hh,
                end_mm,
                remarks,
                location,
                description,
                lead_apprl_empno,
                projno,
                lead_apprl,
                hod_apprl,
                hrd_apprl,
                user_tcp_ip
            ) Values (
                v_empno,
                p_from_date,
                v_app_no,
                sysdate,
                p_last_hh,
                p_last_mn,
                p_last_hh1,
                p_last_mn1,
                p_remarks,
                p_location,
                v_description,
                p_lead_approver,
                p_projno,
                    Case p_lead_approver
                        When v_none Then
                            v_lead_approval_none
                        Else
                            v_lead_approval
                    End,
                v_hod_approval,
                v_hrd_approval,
                p_user_tcp_ip
            );

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Success';
        Else
            p_message_type := 'KO';
            p_message_text := 'Holiday attendance already created !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End add_holiday;

    Procedure sp_delete_holiday (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_application_id     Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2   
    ) AS 
        v_empno              Varchar2(5);
        v_count              Number;
    BEGIN
     --check credentials
        --v_empno := get_empno_from_person_id(p_person_id);
        v_empno    := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --check if application exists
        Select
            Count(*)
        Into v_count
        From
            ss_holiday_attendance
        Where  app_no = p_application_id and pdate > sysdate;
            
        If v_count > 0 Then     
        
            Delete from ss_holiday_attendance Where app_no = p_application_id ;
             Commit;
            p_message_type := 'OK';
            p_message_text := 'Success';
            
        Else
            p_message_type := 'KO';
            p_message_text := 'Application not exists.!!!';
            Return; 
        end if;
        
   Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
END sp_delete_holiday;

End holiday_attendance;

/
