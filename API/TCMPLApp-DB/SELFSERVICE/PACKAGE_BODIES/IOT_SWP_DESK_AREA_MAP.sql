--------------------------------------------------------
--  DDL for Package Body IOT_SWP_DESK_AREA_MAP_QRY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP" As

   Procedure sp_add_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_deskid           Varchar2,
      p_area             Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno       Varchar2(5);
      v_user_tcp_ip Varchar2(5)  := 'NA';
      v_key_id      Varchar2(10) := dbms_random.string('X', 10);
      v_count       Number       := 0;
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Select Count(*) Into v_count
        From SWP_DESK_AREA_MAPPING
       Where deskid = p_deskid;

      If v_count > 0 Then
         p_message_type := 'KO';
         p_message_text := 'Record already present';
         Return;
      End If;

      Insert Into SWP_DESK_AREA_MAPPING
         (KYE_ID, DESKID, AREA_KEY_ID, MODIFIED_ON, MODIFIED_BY)
      Values (v_key_id, p_deskid, p_area, sysdate, v_empno);

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_desk_area;

   Procedure sp_update_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_deskid           Varchar2,
      p_area             Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno       Varchar2(5);
      v_user_tcp_ip Varchar2(5) := 'NA';
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Update SWP_DESK_AREA_MAPPING
         Set DESKID = p_deskid, AREA_KEY_ID = p_area,
             MODIFIED_ON = sysdate, MODIFIED_BY = v_empno
       Where KYE_ID = p_application_id;

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_update_desk_area;

   Procedure sp_delete_desk_area(
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

      Delete From SWP_DESK_AREA_MAPPING
       Where KYE_ID = p_application_id;

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_delete_desk_area;

End IOT_SWP_DESK_AREA_MAP;
/

Grant Execute On "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP" To "TCMPL_APP_CONFIG";