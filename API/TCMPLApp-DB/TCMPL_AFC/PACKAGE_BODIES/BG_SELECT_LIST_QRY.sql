Create Or Replace Package Body "BG_SELECT_LIST_QRY" As

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
         Select Trim(BankId) data_value_field,
                bankName data_text_field
           From bg_bank_mast
          Where isDeleted = 0
          and IsVisible =1
          Order By bankName;

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
         Select compId data_value_field,
                Domain 
                || ' - '
                || CompDesc data_text_field
           From BG_COMPANY_mast
          Where isDeleted = 0
          and IsVisible =1
          Order By CompDesc;

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
         Select currid data_value_field, 
                 currdesc data_text_field
           From bg_currency_mast
          Where isDeleted = 0
          and IsVisible =1
          Order By currid, currdesc;

      Return c;
   End;

   
End;