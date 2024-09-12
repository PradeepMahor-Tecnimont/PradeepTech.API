--------------------------------------------------------
--  DDL for Package Body LC_MASTERS
--------------------------------------------------------

Create Or Replace Package Body "LC_MASTERS" As

   Procedure sp_add_bank(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_bank_desc        Varchar2,
      p_is_active        Number,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Insert Into AFC_BANKS
         (Bank_Key_Id, Bank_Desc, Is_Active, Modified_On, Modified_By)
      Values
         (dbms_random.string('X', 8), p_bank_desc, p_is_active, sysdate, v_empno);

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_bank;

   Procedure sp_update_bank(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_bank_desc        Varchar2,
      p_is_active        Number,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Update afc_banks
         Set bank_desc = p_bank_desc,
             is_active = p_is_active,
             modified_on = sysdate,
             modified_by = v_empno
       Where bank_key_id = p_application_id;

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_update_bank;

   Procedure sp_add_company(
      p_person_id          Varchar2,
      p_meta_id            Varchar2,

      p_company_code       Varchar2,
      p_company_full_name  Varchar2,
      p_company_short_name Varchar2,
      p_is_active          Number,

      p_message_type Out   Varchar2,
      p_message_text Out   Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;
      Insert Into Afc_Companys
         (Company_Code, Company_Full_Name, Company_Short_Name, Is_Active, Modified_On, Modified_By)
      Values
         (P_Company_Code, P_Company_Full_Name, P_Company_Short_Name, P_Is_Active, Sysdate, V_Empno);

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_company;

   Procedure sp_update_company(
      p_person_id          Varchar2,
      p_meta_id            Varchar2,

      p_company_code       Varchar2,
      p_company_full_name  Varchar2,
      p_company_short_name Varchar2,
      p_is_active          Number,

      p_message_type Out   Varchar2,
      p_message_text Out   Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Update afc_companys
         Set company_code = p_company_code,
             company_full_name = p_company_full_name,
             company_short_name = p_company_short_name,
             is_active = p_is_active,
             modified_on = sysdate,
             modified_by = v_empno
       Where company_code = p_company_code;

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_update_company;

   Procedure sp_add_currency(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_currency_code    Varchar2,
      p_currency_desc    Varchar2,
      p_is_active        Number,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Insert Into afc_currencies
         (currency_key_id, currency_code, currency_desc, is_active, modified_on, modified_by)
      Values
         (dbms_random.STRING('X', 4), p_currency_code, p_currency_desc, p_is_active, sysdate, v_empno);

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_currency;

   Procedure sp_update_currency(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_currency_code    Varchar2,
      p_currency_desc    Varchar2,
      p_is_active        Number,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Update afc_currencies
         Set currency_code = p_currency_code,
             currency_desc = p_currency_desc,
             is_active = p_is_active,
             modified_on = sysdate,
             modified_by = v_empno
       Where currency_key_id = p_application_id;

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_update_currency;

   Procedure sp_add_vendor(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_vendor_name      Varchar2,
      p_is_active        Number,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Insert Into afc_vendors
         (vendor_key_id, vendor_name, is_active, modified_on, modified_by)
      Values
         (dbms_random.STRING('X', 8), p_vendor_name, p_is_active, sysdate, v_empno);

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_vendor;

   Procedure sp_update_vendor(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_vendor_name      Varchar2,
      p_is_active        Number,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Update Afc_Vendors Set
             Vendor_Name = P_Vendor_Name,
             Is_Active = P_Is_Active,
             Modified_On = Sysdate,
             Modified_By = V_Empno
       Where Vendor_Key_Id = P_Application_Id;

      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_update_vendor;

End LC_MASTERS;
/
  GRANT EXECUTE ON "TCMPL_AFC"."LC_MASTERS" TO "TCMPL_APP_CONFIG";
