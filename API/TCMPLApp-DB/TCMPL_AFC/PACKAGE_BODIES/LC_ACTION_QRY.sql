--------------------------------------------------------
--  DDL for Package Body LC_ACTION_QRY
--------------------------------------------------------

create or replace package body "LC_ACTION_QRY" as

   function fn_main(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2 default null,
      P_Vendor_Key_Id    varchar2 default null,
      P_Currency_Code    varchar2 default null,
      P_Company_Code     varchar2 default null,
      P_Send_To_Treasury number   default null,

      p_row_number       number,
      p_page_length      number

   ) return sys_refcursor as
      c sys_refcursor;
   begin
      open c for
         select *
           from (
                   select A.SERIAL_NO as Lc_Serial_No,
                          A.Lc_Key_Id as Application_Id,
                          A.Company_Code as Company_Code,
                          A.Payment_Yyyymm as Payment_Yyyymm,
                          case A.Payment_Yyyymm_Half
                             when 1 then
                                'First half'
                             when 2 then
                                'Second half'
                          end as Payment_Yyyymm_Half,
                          (
                             select distinct d.Projno
                                    || ' - '
                                    || d.name
                               from Vu_projmast d
                              where d.projno = A.projno
                          ) as Projno,
                          B.Vendor_Name as Vendor,
                          C.Currency_Code as Currency_Code,
                          C.Currency_Desc as Currency_Desc,
                          A.LC_Status as Lc_Status,
                          to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as Modified_On,
                          get_emp_name(A.MODIFIED_BY) as Modified_By,
                          A.Send_To_Treasury as Send_To_Treasury,
                          row_number() over (order by Lc_Key_Id desc) row_number,
                          count(*) over () total_row
                     from Afc_Lc_Main A, Afc_Vendors B, Afc_Currencies C
                    where A.Vendor_Key_Id = B.Vendor_Key_Id
                      and A.Currency_Key_Id = C.Currency_Key_Id
                      and a.Projno = nvl(P_Projno, A.Projno)
                      and a.Vendor_Key_Id = nvl(P_Vendor_Key_Id, a.Vendor_Key_Id)
                      and a.Currency_Key_Id = nvl(P_Currency_Code, a.Currency_Key_Id)
                      and a.Company_Code = nvl(P_Company_Code, a.Company_Code)
                      and (a.SEND_TO_TREASURY = nvl(P_Send_To_Treasury, a.SEND_TO_TREASURY))
                )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
          order by Lc_Serial_No desc;
      return c;
   end fn_main;

   function fn_amount(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      P_Application_Id varchar2,

      p_row_number     number,
      p_page_length    number

   ) return sys_refcursor as
      c sys_refcursor;
   begin
      open c for
         select *
           from (
                   select A.KEY_ID as Application_Id,
                          A.lc_key_id as Lc_Key_Id,
                          A.currency_key_id as currency_key_id,
                          b.currency_code as currency_code,
                          b.currency_desc as currency_desc,
                          to_char(A.exchage_rate_date, 'dd-Mon-yyyy') as Exchange_Rate_Date,
                          to_char(A.exchange_rate) as Exchange_Rate,
                          to_char(A.lc_amount) as lc_amount,
                          to_char(A.amount_in_inr) as amount_in_inr,
                          row_number() over (order by key_id desc) row_number,
                          count(*) over () total_row
                     from AFC_LC_AMOUNT A, AFC_CURRENCIES B
                    where A.LC_KEY_ID = P_Application_Id
                      and A.CURRENCY_KEY_ID = B.CURRENCY_KEY_ID
                )
          --Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          order by CURRENCY_CODE;
      return c;
   end fn_amount;

   function fn_lc_charges(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      P_Application_Id varchar2,

      p_row_number     number,
      p_page_length    number

   ) return sys_refcursor as
      c sys_refcursor;
   begin
      open c for
         select *
           from (
                   select A.KEY_ID as Application_Id,
                          A.LC_KEY_ID as Lc_Key_Id,
                          A.STATUS_KEY_ID as Lc_Charges_Status_Val,
                          B.STATUS_DESC as Lc_Charges_Status_Text,
                          A.BASIC_CHARGES as Basic_Charges,
                          A.OTHER_CHARGES as Other_Charges,
                          A.TAX as Tax,
                          A.Clint_File_Name as Clint_File_Name,
                          A.Server_File_Name as Server_File_Name,
                          A.REMARKS as Remarks,
                          A.COMMISSION_RATE as COMMISSION_RATE,
                          A.DAYS as DAYS,

                          row_number() over (order by A.KEY_ID desc) row_number,
                          count(*) over () total_row
                     from AFC_LC_CHARGES A, AFC_LC_CHARGES_STATUS_MASTER B
                    where A.LC_KEY_ID = P_Application_Id
                      and A.STATUS_KEY_ID = B.KEY_ID
                )
          --Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          order by Lc_Charges_Status_Val;
      return c;
   end fn_lc_charges;

   function fn_lc_live_status(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      P_Application_Id varchar2,

      p_row_number     number,
      p_page_length    number

   ) return sys_refcursor as
      c sys_refcursor;
   begin
      open c for
         select *
           from (
                   select B.KEY_ID as Application_Id,
                          A.LC_KEY_ID as Lc_Key_Id,
                          A.REMARKS as Remarks,
                          (
                             select STATUS_DESC
                               from AFC_LC_Live_STATUS_MASTER
                              where trim(KEY_ID) = trim(B.LIVE_STATUS_KEY_ID)
                          ) as Live_Status,
                          B.LIVE_STATUS_KEY_ID as LIVE_STATUS_KEY_ID,
                          to_char(B.MODIFIED_ON, 'dd-Mon-yyyy hh24:mi') as Modified_On,
                          row_number() over (order by A.LC_KEY_ID desc) row_number,
                          count(*) over () total_row
                     from AFC_LC_MAIN A,
                          AFC_LC_LIVE_STATUS B
                    where A.LC_KEY_ID = B.LC_KEY_ID
                      and A.LC_KEY_ID = P_Application_Id
                    order by A.SERIAL_NO, B.LIVE_STATUS_KEY_ID desc

                )
          --Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          order by LIVE_STATUS_KEY_ID desc;
      return c;
   end fn_lc_live_status;

   procedure sp_main_details(
      p_person_id                    varchar2,
      p_meta_id                      varchar2,

      p_Application_Id               varchar2,

      p_Lc_Serial_No             out varchar2,
      p_Company_Code             out varchar2,
      P_Company_Full_Name        out varchar2,
      P_Company_Short_Name       out varchar2,
      p_Payment_Yyyymm           out varchar2,
      p_Payment_Yyyymm_Half_val  out varchar2,
      p_Payment_Yyyymm_Half_Text out varchar2,
      p_Projno                   out varchar2,
      p_Project                  out varchar2,
      p_Vendor                   out varchar2,
      P_Vendor_Key_Id            out varchar2,
      P_CURRENCY_KEY_ID          out varchar2,
      p_Currency_Code            out varchar2,
      p_Currency_Desc            out varchar2,
      p_Lc_Status_Val            out varchar2,
      p_Lc_Status_Text           out varchar2,
      P_Lc_Amount                out varchar2,
      p_MODIFIED_ON              out varchar2,
      p_MODIFIED_BY              out varchar2,
      p_LC_CL_PAYMENT_DATE       out varchar2,
      p_LC_CL_ACTUAL_AMOUNT      out varchar2,
      p_LC_CL_OTHER_CHARGES      out varchar2,
      p_LC_CL_MOD_ON             out varchar2,
      p_LC_CL_MOD_BY             out varchar2,
      p_Remarks                  out varchar2,
      p_LC_CL_REMARKS            out varchar2,
      P_Send_To_Treasury         out varchar2,

      p_message_type             out varchar2,
      p_message_text             out varchar2
   ) as
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select A.SERIAL_NO as Lc_Serial_No,
             A.Company_Code as Company_Code,
             D.Company_Full_Name as Company_Full_Name,
             D.Company_Short_Name as Company_Short_Name,
             A.Payment_Yyyymm as Payment_Yyyymm,
             A.projno as Projno,
             A.Payment_Yyyymm_Half as Payment_Yyyymm_Half_val,
             case A.Payment_Yyyymm_Half
                when 1 then
                   'First half'
                when 2 then
                   'Second half'
             end as Payment_Yyyymm_Half_Text,
             case A.Lc_Status
                when 1 then
                   'Open'
                when 0 then
                   'Closed'
             end as Lc_Status_Text,
             (
                select distinct d.Projno
                       || ' - '
                       || d.name
                  from Vu_projmast d
                 where d.projno = A.projno
             ) as Project,
             B.Vendor_Name as Vendor,
             A.Vendor_Key_Id as Vendor_Key_Id,
             A.CURRENCY_KEY_ID as CURRENCY_KEY_ID,
             C.Currency_Code as Currency_Code,
             C.Currency_Desc as Currency_Desc,
             A.Lc_Status as Lc_StatusVal,
             to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as MODIFIED_ON,
             get_emp_name(A.MODIFIED_BY) as MODIFIED_BY,
             to_char(A.LC_CL_PAYMENT_DATE, 'dd-Mon-yyyy') as LC_CL_PAYMENT_DATE,
             A.LC_CL_ACTUAL_AMOUNT as LC_CL_ACTUAL_AMOUNT,
             A.LC_CL_OTHER_CHARGES as LC_CL_OTHER_CHARGES,
             to_char(A.LC_CL_MOD_ON, 'dd-Mon-yyyy') as LC_CL_MOD_ON,
             get_emp_name(A.LC_CL_MOD_BY) as LC_CL_MOD_BY,
             A.Lc_Amount as Lc_Amount,
             A.Remarks as Remarks,
             A.LC_CL_REMARKS as LC_CL_REMARKS,
             A.Send_To_Treasury as Send_To_Treasury
        into P_Lc_Serial_No,
             P_Company_Code,
             P_Company_Full_Name,
             P_Company_Short_Name,
             P_Payment_Yyyymm,
             P_Projno,
             p_Payment_Yyyymm_Half_val,
             p_Payment_Yyyymm_Half_Text,
             P_Lc_Status_Text,
             p_Project,
             P_Vendor,
             P_Vendor_Key_Id,
             P_CURRENCY_KEY_ID,
             P_Currency_Code,
             P_Currency_Desc,
             P_Lc_Status_Val,
             P_MODIFIED_ON,
             P_MODIFIED_BY,
             P_LC_CL_PAYMENT_DATE,
             P_LC_CL_ACTUAL_AMOUNT,
             P_LC_CL_OTHER_CHARGES,
             P_LC_CL_MOD_ON,
             P_LC_CL_MOD_BY,
             P_Lc_Amount,
             P_Remarks,
             P_LC_CL_REMARKS,
             P_Send_To_Treasury
        from Afc_Lc_Main A, Afc_Vendors B, Afc_Currencies C, Afc_companys D
       where A.Company_Code = D.Company_Code
         and A.Vendor_Key_Id = B.Vendor_Key_Id
         and A.Currency_Key_Id = C.Currency_Key_Id
         and A.LC_KEY_ID = P_Application_Id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_main_details;

   procedure sp_bank_details(
      p_person_id               varchar2,
      p_meta_id                 varchar2,

      p_Application_Id          varchar2,

      p_issuing_bank_id     out varchar2,
      p_discounting_bank_id out varchar2,
      p_advising_bank_id    out varchar2,
      p_issuing_bank        out varchar2,
      p_discounting_bank    out varchar2,
      p_advising_bank       out varchar2,
      p_validity_date       out varchar2,
      p_ISSUE_DATE          out varchar2,
      p_duration_type_Val   out varchar2,
      p_duration_type_Text  out varchar2,
      p_no_of_days          out varchar2,
      P_LC_Number           out varchar2,
      p_payment_date_est    out varchar2,
      p_Lc_Status_Val       out varchar2,
      p_Lc_Status_Text      out varchar2,
      p_Remarks             out varchar2,
      P_Send_To_Treasury    out varchar2,

      p_message_type        out varchar2,
      p_message_text        out varchar2
   ) as
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select distinct trim(A.Issuing_Bank) as Issuing_Bank_ID,
             trim(A.Discounting_Bank) as Discounting_Bank_Id,
             trim(A.Advising_Bank) as Advising_Bank_Id,
             to_char(A.Validity_Date, 'dd-Mon-yyyy') as Validity_Date,
             (
                select distinct Bank_Desc
                  from Afc_Banks B
                 where A.Issuing_Bank = B.Bank_Key_Id
             ) as Issuing_Bank,
             (
                select distinct Bank_Desc
                  from Afc_Banks B
                 where A.Discounting_Bank = B.Bank_Key_Id
             ) as Discounting_Bank,
             (
                select distinct Bank_Desc
                  from Afc_Banks B
                 where A.Advising_Bank = B.Bank_Key_Id
             ) as Advising_Bank,
             to_char(A.Duration_Type) as Duration_Type_Val,
             case A.Duration_Type
                when '1' then
                   'Usance Period(U)'
                when '2' then
                   'LC Tenure(T)'
             end as duration_type_Text,
             A.No_Of_Days as No_Of_Days,
             to_char(A.ISSUE_DATE, 'dd-Mon-yyyy') as ISSUE_DATE,
             LC_Number as LC_Number,
             to_char(A.payment_date_est, 'dd-Mon-yyyy') as payment_date_est,
             B.Lc_Status as Lc_Status_Val,
             case B.Lc_Status
                when 1 then
                   'Open'
                when 0 then
                   'Closed'
             end as Lc_Status_Text,
             A.Remarks as Remarks,
             B.Send_To_Treasury as Send_To_Treasury
        into P_Issuing_Bank_ID,
             P_Discounting_Bank_Id,
             P_Advising_Bank_Id,
             P_Validity_Date,
             P_Issuing_Bank,
             P_Discounting_Bank,
             P_Advising_Bank,
             P_Duration_Type_Val,
             P_Duration_Type_Text,
             P_No_Of_Days,
             p_ISSUE_DATE,
             P_LC_Number,
             P_payment_date_est,
             p_Lc_Status_Val,
             p_Lc_Status_Text,
             P_Remarks,
             P_Send_To_Treasury
        from Afc_Lc_Banks A, AFC_LC_MAIN B
       where A.Lc_Key_Id = P_Application_Id
         and A.Lc_Key_Id = B.Lc_Key_Id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_bank_details;

   procedure sp_acceptance_details(
      p_person_id              varchar2,
      p_meta_id                varchar2,

      p_Application_Id         varchar2,

      p_acceptance_date    out varchar2,
      p_Remarks            out varchar2,
      p_payment_date_act   out varchar2,
      p_actual_amount_paid out varchar2,
      P_Send_To_Treasury   out varchar2,

      p_message_type       out varchar2,
      p_message_text       out varchar2
   ) as
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select to_char(acceptance_date, 'dd-Mon-yyyy') as acceptance_date,
             to_char(payment_date_act, 'dd-Mon-yyyy') as payment_date_act,
             actual_amount_paid as actual_amount_paid,
             Remarks as Remarks
        into p_acceptance_date,
             p_payment_date_act,
             p_actual_amount_paid,
             P_Remarks
        from afc_lc_acceptance
       where lc_key_id = p_application_id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_acceptance_details;

   procedure sp_lc_charges_details(
      p_person_id                  varchar2,
      p_meta_id                    varchar2,

      p_Application_Id             varchar2,

      P_Lc_Key_Id              out varchar2,
      P_Lc_Charges_Status_Val  out varchar2,
      P_Lc_Charges_Status_Text out varchar2,
      P_Basic_Charges          out varchar2,
      P_Other_Charges          out varchar2,
      P_Tax                    out varchar2,
      P_Clint_File_Name        out varchar2,
      P_Server_File_Name       out varchar2,
      P_COMMISSION_RATE        out varchar2,
      P_DAYS                   out varchar2,
      P_Remarks                out varchar2,
      P_Send_To_Treasury       out varchar2,

      p_message_type           out varchar2,
      p_message_text           out varchar2
   ) as
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select A.LC_KEY_ID as Lc_Key_Id,
             B.KEY_ID as Lc_Charges_Status_Val,
             B.STATUS_DESC as Lc_Charges_Status_Text,
             A.BASIC_CHARGES as Basic_Charges,
             A.OTHER_CHARGES as Other_Charges,
             A.TAX as Tax,
             A.Clint_File_Name as Clint_File_Name,
             A.Server_File_Name as Server_File_Name,
             A.DAYS as Days,
             A.COMMISSION_RATE as COMMISSION_RATE,
             A.Remarks as Remarks
        into P_Lc_Key_Id,
             P_Lc_Charges_Status_Val,
             P_Lc_Charges_Status_Text,
             P_Basic_Charges,
             P_Other_Charges,
             P_Tax,
             P_Clint_File_Name,
             P_Server_File_Name,
             P_Days,
             P_COMMISSION_RATE,
             P_Remarks
        from AFC_LC_CHARGES A, AFC_LC_CHARGES_STATUS_MASTER B
       where A.KEY_ID = P_Application_Id
         and A.STATUS_KEY_ID = B.KEY_ID;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_lc_charges_details;

   procedure sp_lc_amount_details(
      p_person_id              varchar2,
      p_meta_id                varchar2,

      p_Application_Id         varchar2,

      P_Lc_Key_Id          out varchar2,
      P_Currency_key_Id    out varchar2,
      P_Currency_Code      out varchar2,
      P_Currency_Desc      out varchar2,
      P_Exchange_Rate_Date out varchar2,
      P_Exchange_Rate      out varchar2,
      P_Lc_Amount          out varchar2,
      P_Amount_In_Inr      out varchar2,
      P_Send_To_Treasury   out varchar2,

      p_message_type       out varchar2,
      p_message_text       out varchar2
   ) as
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select A.lc_key_id as Lc_Key_Id,
             A.currency_key_id as currency_key_id,
             b.currency_code as currency_code,
             b.currency_desc as currency_desc,
             to_char(A.exchage_rate_date, 'dd-Mon-yyyy') as Exchange_Rate_Date,
             to_char(A.exchange_rate) as Exchange_Rate,
             to_char(A.lc_amount) as lc_amount,
             to_char(A.amount_in_inr) as amount_in_inr
        into P_Lc_Key_Id,
             P_Currency_key_id,
             P_Currency_code,
             P_Currency_desc,
             P_Exchange_Rate_Date,
             P_Exchange_Rate,
             P_lc_amount,
             P_amount_in_inr
        from AFC_LC_AMOUNT A, AFC_CURRENCIES B
       where A.KEY_ID = P_Application_Id
         and A.CURRENCY_KEY_ID = B.CURRENCY_KEY_ID;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_lc_amount_details;

   function fn_main_Po_Sap_Invoice(
      p_person_id   varchar2,
      p_meta_id     varchar2,

      P_Lc_Key_Id   varchar2,

      p_row_number  number,
      p_page_length number

   ) return sys_refcursor as
      c sys_refcursor;
   begin
      open c for
         select *
           from (
                   select KEY_ID as Application_Id,
                          Lc_Key_Id as Lc_Key_Id,
                          to_char(Po) as Po,
                          to_char(SAP) as Sap,
                          to_char(INVOICE) as Invoice,
                          to_char(MODIFIED_ON, 'dd-Mon-yyyy') as Modified_On,
                          get_emp_name(MODIFIED_BY) as Modified_By,
                          row_number() over (order by KEY_ID desc) row_number,
                          count(*) over () total_row
                     from AFC_LC_MAIN_PO_SAP_INVOICE
                    where Lc_Key_Id = P_Lc_Key_Id
                )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
          order by Po, SAP, INVOICE desc;
      return c;
   end fn_main_Po_Sap_Invoice;

   function fn_main_excel(
      p_person_id varchar2,
      p_meta_id   varchar2

   ) return sys_refcursor as
      c sys_refcursor;
   begin
      open c for
         select *
           from (
                   select A.SERIAL_NO as Lc_Serial_No,
                          A.Lc_Key_Id as Application_Id,
                          A.Company_Code as Company_Code,
                          A.Payment_Yyyymm as Payment_Yyyymm,
                          case A.Payment_Yyyymm_Half
                             when 1 then
                                'First half'
                             when 2 then
                                'Second half'
                          end as Payment_Yyyymm_Half,
                          (
                             select distinct d.Projno
                                    || ' - '
                                    || d.name
                               from Vu_projmast d
                              where d.projno = A.projno
                          ) as Projno,
                          B.Vendor_Name as Vendor,
                          C.Currency_Code as Currency_Code,
                          C.Currency_Desc as Currency_Desc,
                          A.LC_Status as Lc_Status,
                          to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as Modified_On,
                          get_emp_name(A.MODIFIED_BY) as Modified_By
                     from Afc_Lc_Main A, Afc_Vendors B, Afc_Currencies C

                )
          --Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          order by Lc_Serial_No desc;
      return c;
   end fn_main_excel;

   function fn_Get_Bank(
      P_BANK_KEY_ID varchar2
   ) return varchar2
   as
      v_return varchar2(200);
   begin

      select distinct Bank_Desc
        into v_return
        from AFC_BANKS
       where BANK_KEY_ID = P_BANK_KEY_ID;

      return v_return;

   end fn_Get_Bank;

   function fn_Get_Project(
      P_PROJ_NO varchar2
   ) return varchar2
   as
      v_return varchar2(200);
   begin

      select distinct PROJ_NO
             || ' - '
             || Name
        into v_return
        from VU_PROJMAST
       where PROJ_NO = P_PROJ_NO;

      return v_return;

   end fn_Get_Project;

   function fn_Get_LC_AMOUNT(
      P_LC_KEY_ID varchar2
   ) return number
   as
      v_return number := 0;
   begin

      select sum(LC_AMOUNT)
        into v_return
        from AFC_LC_AMOUNT
       where LC_KEY_ID = P_LC_KEY_ID; --4HW3E0F6

      return v_return;

   end fn_Get_LC_AMOUNT;

   function fn_Get_AMOUNT_IN_INR(
      P_LC_KEY_ID varchar2
   ) return number
   as
      v_return number := 0;
   begin

      select sum(AMOUNT_IN_INR)
        into v_return
        from AFC_LC_AMOUNT
       where LC_KEY_ID = P_LC_KEY_ID; --4HW3E0F6

      return v_return;

   end fn_Get_AMOUNT_IN_INR;

   function fn_Get_COMPANY(

      P_COMPANY_CODE varchar2

   ) return varchar2
   as
      v_return varchar2(200);
   begin

      select distinct Company_Short_Name
             || ' - '
             || Company_Full_Name Name
        into v_return
        from AFC_COMPANYS
       where COMPANY_CODE = P_COMPANY_CODE;

      return v_return;

   end fn_Get_COMPANY;

   function fn_Get_Currency(

      P_CURRENCY_KEY_ID varchar2

   ) return varchar2
   as
      v_return varchar2(200);
   begin

      select Currency_Code
             || ' - '
             || Currency_Desc as Currency
        into v_return
        from AFC_CURRENCIES
       where CURRENCY_KEY_ID = P_CURRENCY_KEY_ID;

      return v_return;

   end fn_Get_Currency;

   function fn_Get_Vendor(
      P_VENDOR_KEY_ID varchar2
   ) return varchar2
   as
      v_return varchar2(200);
   begin

      select VENDOR_NAME
        into v_return
        from AFC_VENDORS
       where VENDOR_KEY_ID = P_VENDOR_KEY_ID;

      return v_return;

   end fn_Get_Vendor;

   function fn_Get_PO(
      P_LC_KEY_ID varchar2
   ) return varchar2
   as
      v_return varchar2(200) := 'PO List';
   begin

  select RTRIM(XMLAGG(XMLELEMENT(e,PO || ',')).EXTRACT('//text()'),',') PO 
      into v_return
         from  AFC_LC_MAIN_PO_SAP_INVOICE
         where LC_KEY_ID =  P_LC_KEY_ID;

      return v_return;

   end fn_Get_PO;

   function fn_Get_TOTAL_LC_charges(
      P_LC_KEY_ID varchar2
   ) return number
   as
      v_return        number := 0;
      v_BASIC_CHARGES number := 0;
      v_OTHER_CHARGES number := 0;
      v_TAX           number := 0;
   begin

      select sum(BASIC_CHARGES),
             sum(OTHER_CHARGES),
             sum(TAX)
        into v_BASIC_CHARGES, v_OTHER_CHARGES, v_TAX
        from AFC_LC_CHARGES
       where LC_KEY_ID = P_LC_KEY_ID;

      v_return := (v_BASIC_CHARGES + v_OTHER_CHARGES + v_TAX);

      return v_return;

   end fn_Get_TOTAL_LC_charges;

   function fn_Get_COMMISSION_RATE(
      P_LC_KEY_ID varchar2
   ) return number
   as
      v_return number := 0;

   begin

      select sum(COMMISSION_RATE)
        into v_return
        from AFC_LC_CHARGES
       where LC_KEY_ID = P_LC_KEY_ID;

      return v_return;

   end fn_Get_COMMISSION_RATE;

   function fn_Get_Days(
      P_LC_KEY_ID varchar2
   ) return number
   as
      v_return number := 0;

   begin

      select sum(DAYS)
        into v_return
        from AFC_LC_CHARGES
       where LC_KEY_ID = P_LC_KEY_ID;

      return v_return;

   end fn_Get_Days;

end LC_ACTION_QRY;
/