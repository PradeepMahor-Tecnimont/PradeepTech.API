Create Or Replace Package Body "LC_SELECT_LIST_QRY" As

   Function fn_project_list(
      p_person_id Varchar2,
      p_meta_id   Varchar2
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'errrr' Then
         Raise e_employee_not_found;
         Return Null;
      End If;

      Open c For
         Select projno data_value_field,
                projno
                || ' - '
                || name data_text_field
           From vu_projmast
          Where active = 1
          Order By projno, name;

      Return c;
   End;

   Function fn_bank_list(
      p_person_id Varchar2,
      p_meta_id   Varchar2
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'errrr' Then
         Raise e_employee_not_found;
         Return Null;
      End If;

      Open c For
         Select Trim(bank_key_id) data_value_field,
                bank_desc data_text_field
           From afc_banks
          Where is_active = 1
          Order By bank_desc;

      Return c;
   End;

   Function fn_company_list(
      p_person_id Varchar2,
      p_meta_id   Varchar2
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'errrr' Then
         Raise e_employee_not_found;
         Return Null;
      End If;

      Open c For
         Select company_code data_value_field,
                company_short_name
                || ' - '
                || company_full_name data_text_field
           From AFC_COMPANYS
          Where is_active = 1
          Order By company_short_name;

      Return c;
   End;

   Function fn_currencies_list(
      p_person_id Varchar2,
      p_meta_id   Varchar2
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'errrr' Then
         Raise e_employee_not_found;
         Return Null;
      End If;

      Open c For
         Select currency_key_id data_value_field,
                currency_code
                || ' - '
                || currency_desc data_text_field
           From afc_currencies
          Where is_active = 1
          Order By currency_code, currency_desc;

      Return c;
   End;

   Function fn_vendors_list(
      p_person_id Varchar2,
      p_meta_id   Varchar2
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'errrr' Then
         Raise e_employee_not_found;
         Return Null;
      End If;

      Open c For
         Select vendor_key_id data_value_field,
                vendor_name data_text_field
           From afc_vendors
          Where is_active = 1
          Order By vendor_name;

      Return c;
   End;

   Function fn_charges_status_list(
      p_person_id Varchar2,
      p_meta_id   Varchar2
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'errrr' Then
         Raise e_employee_not_found;
         Return Null;
      End If;

      Open c For
          Select KEY_ID data_value_field,
                STATUS_DESC data_text_field
           From AFC_LC_CHARGES_STATUS_MASTER 
          
          Order By KEY_ID;

      Return c;
   End;

End;