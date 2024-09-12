--------------------------------------------------------
--  DDL for Package Body LC_MASTERS_QRY
--------------------------------------------------------

Create Or Replace Package Body "LC_MASTERS_QRY" As

   Function fn_bank(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_is_active   Number Default Null,

      p_row_number  Number,
      p_page_length Number

   ) Return Sys_Refcursor As
      c Sys_Refcursor;
   Begin
      Open c For
         Select *
           From (
                   Select bank_key_id As application_id,
                          bank_desc As bank_desc,
                          is_active As is_active,
                          Row_Number() Over (Order By bank_key_id Desc) row_number,
                          Count(*) Over () total_row
                     From afc_banks
                     where is_active = nvl(p_is_active, is_active)
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          Order By bank_desc;
      Return c;
   End fn_bank;

   Function fn_company(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_is_active   Number Default Null,

      p_row_number  Number,
      p_page_length Number

   ) Return Sys_Refcursor As
      c Sys_Refcursor;
   Begin
      Open c For
         Select *
           From (
                   Select company_code As company_code,
                          company_full_name As company_full_name,
                          company_short_name As company_short_name,
                          is_active As is_active,
                          Row_Number() Over (Order By company_code Desc) As row_number,
                          Count(*) Over () total_row
                     From afc_companys
                     where is_active = nvl(p_is_active, is_active)
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          Order By company_code, company_full_name;
      Return c;
   End fn_company;

   Function fn_Currency(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_is_active   Number Default Null,

      p_row_number  Number,
      p_page_length Number

   ) Return Sys_Refcursor As
      c Sys_Refcursor;
   Begin
      Open c For
         Select *
           From (
                   Select Currency_Key_Id As application_id,
                          Currency_Code As Currency_Code,
                          Currency_Desc As Currency_Desc,
                          Is_Active As Is_Active,
                          Row_Number() Over (Order By Currency_Key_Id Desc) row_number,
                          Count(*) Over () total_row
                     From Afc_Currencies
                     where is_active = nvl(p_is_active, is_active)
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          Order By Currency_Code, Currency_Desc;
      Return c;
   End fn_Currency;

   Function fn_vendor(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_is_active   Number Default Null,

      p_row_number  Number,
      p_page_length Number

   ) Return Sys_Refcursor As
      c Sys_Refcursor;
   Begin
      Open c For
         Select *
           From (
                   Select vendor_key_id As application_id,
                          vendor_name As vendor_name,
                          is_active As is_active,
                          Row_Number() Over (Order By vendor_key_id Desc) row_number,
                          Count(*) Over () total_row
                     From afc_vendors
                     where is_active = nvl(p_is_active, is_active)
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          Order By vendor_name;

      Return c;
   End fn_vendor;

   Procedure sp_bank_details(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_Application_Id   Varchar2,

      p_bank_desc    Out Varchar2,
      p_is_active    Out Number,

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

      Select bank_desc, is_active
        Into p_bank_desc, p_is_active
        From afc_banks
       Where bank_key_id = p_Application_Id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_bank_details;

   Procedure sp_vendor_details(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_Application_Id   Varchar2,

      p_vendor_name  Out Varchar2,
      p_is_active    Out Number,

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

      Select vendor_name, is_active
        Into p_vendor_name, p_is_active
        From afc_vendors
       Where vendor_key_id = p_Application_Id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_vendor_details;

   Procedure sp_currency_details(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_Application_Id    Varchar2,

      p_currency_code Out Varchar2,
      p_currency_desc Out Varchar2,
      p_is_active     Out Number,

      p_message_type  Out Varchar2,
      p_message_text  Out Varchar2
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

      Select currency_code, currency_desc, is_active
        Into p_currency_code, p_currency_desc, p_is_active
        From Afc_Currencies
       Where currency_key_id = p_Application_Id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_currency_details;

   Procedure sp_company_details(
      p_person_id              Varchar2,
      p_meta_id                Varchar2,

      p_Application_Id         Varchar2,

      p_company_code       Out Varchar2,
      p_company_full_name  Out Varchar2,
      p_company_short_name Out Varchar2,
      p_is_active          Out Number,

      p_message_type       Out Varchar2,
      p_message_text       Out Varchar2
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

      Select company_code, company_full_name, company_short_name, is_active
        Into p_company_code, p_company_full_name, p_company_short_name, p_is_active
        From afc_companys
       Where company_code = p_Application_Id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_company_details;

End LC_MASTERS_QRY;
/
Grant Execute On "TCMPL_AFC"."LC_MASTERS_QRY" To "TCMPL_APP_CONFIG";