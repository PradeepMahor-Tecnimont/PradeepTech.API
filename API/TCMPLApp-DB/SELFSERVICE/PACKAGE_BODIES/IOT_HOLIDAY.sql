--------------------------------------------------------
--  DDL for Package Body IOT_HOLIDAY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_HOLIDAY" As

   Procedure sp_add_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_office           Varchar2,
      p_date             Date,
      p_project          Varchar2,
      p_approver         Varchar2,
      p_hh1              Varchar2,
      p_mi1              Varchar2,
      p_hh2              Varchar2,
      p_mi2              Varchar2,
      p_reason           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
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

      holiday_attendance.sp_add_holiday(
         p_person_id     => p_person_id,
         p_meta_id       => p_meta_id,
         p_from_date     => p_date,
         p_projno        => p_project,
         p_last_hh       => to_number(Trim(p_hh1)),
         p_last_mn       => to_number(Trim(p_mi1)),
         p_last_hh1      => to_number(Trim(p_hh2)),
         p_last_mn1      => to_number(Trim(p_mi2)),
         p_lead_approver => p_approver,
         p_remarks       => p_reason,
         p_location      => Trim(P_office),
         p_user_tcp_ip   => Trim(v_user_tcp_ip),
         p_message_type  => p_message_type,
         p_message_text  => p_message_text
      );

      If v_message_type = ss.failure Then
         p_message_type := 'KO';
      Else
         p_message_type := 'OK';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_holiday;

   Procedure sp_delete_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
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

      holiday_attendance.sp_delete_holiday(
         p_person_id      => p_person_id,
         p_meta_id        => p_meta_id,
         p_application_id => p_application_id,
         p_message_type   => p_message_type,
         p_message_text   => p_message_text
      );

      If v_message_type = ss.failure Then
         p_message_type := 'KO';
      Else
         p_message_type := 'OK';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_delete_holiday;

   Procedure sp_holiday_approval(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,
      p_approver_profile  Number,
      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   ) As
      v_app_no            Varchar2(70);
      v_approval          Number; -- (1 = Approved , -1 = Rejected , 0 = Pending )
      v_remarks           Varchar2(70);
      v_count             Number;
      strsql              Varchar2(600);
      v_odappstat_rec     ss_odappstat%rowtype;
      v_approver_empno    Varchar2(5);
      v_user_tcp_ip       Varchar2(30);
      v_msg_type          Varchar2(20);
      v_msg_text          Varchar2(1000);
      v_medical_cert_file Varchar2(200);
   Begin

      v_approver_empno := get_empno_from_meta_id(p_meta_id);
      If v_approver_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Null;

      Commit;
      p_message_type   := 'OK';
      p_message_text   := 'Procedure executed successfully.';
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   End;

   Procedure sp_holiday_approval_lead(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_lead,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End;

   Procedure sp_holiday_approval_hod(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_hod,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End sp_holiday_approval_hod;

   Procedure sp_holiday_approval_hr(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_hrd,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End sp_holiday_approval_hr;

End IOT_HOLIDAY;
/

Grant Execute On "SELFSERVICE"."IOT_HOLIDAY" To "TCMPL_APP_CONFIG";