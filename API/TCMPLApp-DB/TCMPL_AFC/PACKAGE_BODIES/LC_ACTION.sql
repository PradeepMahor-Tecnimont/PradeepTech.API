--------------------------------------------------------
--  DDL for Package Body LC_ACTION
--------------------------------------------------------

create or replace package body "LC_ACTION" as

   procedure sp_add_main(
      p_person_id           varchar2,
      p_meta_id             varchar2,

      P_Company_Code        varchar2,
      P_Payment_Yyyymm      varchar2,
      P_Payment_Yyyymm_Half number,
      P_Projno              varchar2,
      P_Vendor_Key_Id       varchar2,
      P_Currency_Key_Id     varchar2,
      P_Lc_Amount           number,
      P_Remarks             varchar2,
      P_Send_To_Treasury  Number,

      p_message_type out    varchar2,
      p_message_text out    varchar2
   ) as
      v_Lc_Key_Id    varchar(8);
      v_sr_no        varchar(7);
      v_empno        varchar2(5);
      v_Lc_Status    varchar2(5) := 'L1';
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_sr_no        := 'IND' || Lc_no.nextval();
      v_Lc_Key_Id    := dbms_random.string('X', 8);

      insert into Afc_Lc_Main
      (Lc_Key_Id, Company_Code, Payment_Yyyymm, Payment_Yyyymm_Half, Projno, Remarks,
         Vendor_Key_Id, Currency_Key_Id, Lc_Amount, Modified_On,
         Modified_By, SERIAL_NO , Send_To_Treasury
      )
      values
      (v_Lc_Key_Id, P_Company_Code, P_Payment_Yyyymm, P_Payment_Yyyymm_Half,
         P_Projno, P_Remarks, P_Vendor_Key_Id, P_Currency_Key_Id, P_Lc_Amount,
         Sysdate, v_empno, v_sr_no , P_Send_To_Treasury
      );

      commit;

      insert into AFC_LC_LIVE_STATUS
         (KEY_ID, LC_KEY_ID, LIVE_STATUS_KEY_ID, MODIFIED_ON)
      values (dbms_random.string('X', 8), v_Lc_Key_Id, v_Lc_Status, sysdate);

      commit;

      LC_EMAIL.SEND_MAIL_FROM_API(
         P_MAIL_TO      => null,
         P_MAIL_CC      => null,
         P_MAIL_BCC     => null,
         P_MAIL_SUBJECT => 'New Sr No',
         P_MAIL_BODY    => 'Lc New Sr No. ' || v_sr_no,
         P_MAIL_PROFILE => null,
         P_SUCCESS      => p_message_type,
         P_MESSAGE      => p_message_text
      );

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_add_main;

   procedure sp_update_main(
      p_person_id           varchar2,
      p_meta_id             varchar2,

      P_application_id      varchar2,
      P_Company_Code        varchar2,
      P_Payment_Yyyymm      varchar2,
      P_Payment_Yyyymm_Half number,
      P_Projno              varchar2,
      P_Vendor_Key_Id       varchar2,
      P_Currency_Key_Id     varchar2,
      P_Lc_Amount           number,
      P_Remarks             varchar2,
P_Send_To_Treasury  Number,

      p_message_type out    varchar2,
      p_message_text out    varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(P_application_id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      update afc_lc_main set company_code = p_company_code,
             payment_yyyymm = p_payment_yyyymm,
             payment_yyyymm_half = p_payment_yyyymm_half,
             projno = p_projno,
             vendor_key_id = p_vendor_key_id,
             currency_key_id = p_currency_key_id,
             modified_on = sysdate,
             modified_by = v_empno,
             Lc_Amount = P_Lc_Amount,
             Remarks = P_Remarks,
             Send_To_Treasury = P_Send_To_Treasury
       where lc_key_id = P_application_id;

      commit;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_update_main;

   procedure sp_add_banks(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Application_id   varchar2,
      P_Issuing_Bank     varchar2,
      P_Discounting_Bank varchar2,
      P_Advising_Bank    varchar2,
      P_Validity_Date    date,
      p_ISSUE_DATE       date,
      p_LC_Number        number default null,
      P_Duration_Type    varchar2,
      P_No_Of_Days       number,
      P_Payment_Date_Est date,
      P_Remarks          varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      v_Lc_Status       varchar2(2) := 'L2';
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(P_Application_Id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      insert into Afc_Lc_Banks
      (Lc_Key_Id, Issuing_Bank, Discounting_Bank, Advising_Bank,
         Validity_Date, Duration_Type, No_Of_Days, Modified_On, Modified_By, ISSUE_DATE,
         LC_Number, Payment_Date_Est, Remarks
      )
      values
      (
         P_Application_Id, P_Issuing_Bank, P_Discounting_Bank, P_Advising_Bank,
         P_Validity_Date, P_Duration_Type, P_No_Of_Days, Sysdate, V_Empno, p_ISSUE_DATE,
         p_LC_Number, P_Payment_Date_Est, P_Remarks
      );

      commit;

      if P_LC_Number is not null then

         insert into AFC_LC_LIVE_STATUS
            (KEY_ID, LC_KEY_ID, LIVE_STATUS_KEY_ID, MODIFIED_ON)
         values (dbms_random.string('X', 8), P_Application_Id, v_Lc_Status, sysdate);

         commit;

         LC_EMAIL.SEND_MAIL_FROM_API(
            P_MAIL_TO      => null,
            P_MAIL_CC      => null,
            P_MAIL_BCC     => null,
            P_MAIL_SUBJECT => 'LC No',
            P_MAIL_BODY    => 'LC  No. ' || P_LC_Number,
            P_MAIL_PROFILE => null,
            P_SUCCESS      => p_message_type,
            P_MESSAGE      => p_message_text
         );
      end if;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_add_banks;

   procedure sp_update_banks(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Application_id   varchar2,
      P_Issuing_Bank     varchar2,
      P_Discounting_Bank varchar2,
      P_Advising_Bank    varchar2,
      P_Validity_Date    date,
      p_ISSUE_DATE       date,
      p_LC_Number        number default null,
      P_Duration_Type    varchar2,
      P_No_Of_Days       number,
      P_Payment_Date_Est date,
      P_Remarks          varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      v_Lc_Status       varchar2(2) := 'L2';
      v_empno           varchar2(5);
      v_old_lc_number   number      := null;
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(p_application_id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      select lc_number into v_old_lc_number
        from afc_lc_banks
       where lc_key_id = p_application_id;

      update afc_lc_banks
         set issuing_bank = p_issuing_bank,
             discounting_bank = p_discounting_bank,
             advising_bank = p_advising_bank,
             validity_date = p_validity_date,
             ISSUE_DATE = p_ISSUE_DATE,
             duration_type = p_duration_type,
             no_of_days = p_no_of_days,
             LC_Number = p_LC_Number,
             Payment_Date_Est = P_Payment_Date_Est,
             Remarks = P_Remarks,
             modified_on = sysdate,
             modified_by = v_empno
       where lc_key_id = p_application_id;

      commit;

      if v_old_lc_number is null then
         insert into AFC_LC_LIVE_STATUS
            (KEY_ID, LC_KEY_ID, LIVE_STATUS_KEY_ID, MODIFIED_ON)
         values (dbms_random.string('X', 8), P_Application_Id, v_Lc_Status, sysdate);

         commit;
      end if;

      if P_LC_Number is not null then

         if v_old_lc_number != P_LC_Number then

            LC_EMAIL.SEND_MAIL_FROM_API(
               P_MAIL_TO      => null,
               P_MAIL_CC      => null,
               P_MAIL_BCC     => null,
               P_MAIL_SUBJECT => 'LC No',
               P_MAIL_BODY    => 'LC  No. ' || P_LC_Number,
               P_MAIL_PROFILE => null,
               P_SUCCESS      => p_message_type,
               P_MESSAGE      => p_message_text
            );
         end if;
      end if;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_update_banks;

   procedure sp_add_acceptance(
      p_person_id          varchar2,
      p_meta_id            varchar2,

      P_Application_id     varchar2,
      P_Acceptance_Date    date,
      p_Remarks            varchar,
      P_Payment_Date_Act   date,
      P_Actual_Amount_Paid number,

      p_message_type out   varchar2,
      p_message_text out   varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      v_Lc_Status       varchar2(2) := 'L3';
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(P_Application_Id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      insert into Afc_Lc_Acceptance
      (
         Lc_Key_Id, Acceptance_Date, Remarks, Payment_Date_Act,
         Actual_Amount_Paid, Modified_On, Modified_By
      )
      values
      (
         P_Application_Id, P_Acceptance_Date, p_Remarks, P_Payment_Date_Act,
         P_Actual_Amount_Paid, Sysdate, V_Empno
      );

      commit;

      if P_Acceptance_Date is not null then

         insert into AFC_LC_LIVE_STATUS
            (KEY_ID, LC_KEY_ID, LIVE_STATUS_KEY_ID, MODIFIED_ON)
         values (dbms_random.string('X', 8), P_Application_Id, v_Lc_Status, sysdate);

      end if;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_add_acceptance;

   procedure sp_update_acceptance(
      p_person_id          varchar2,
      p_meta_id            varchar2,

      P_Application_id     varchar2,
      P_Acceptance_Date    date,
      p_Remarks            varchar,
      P_Payment_Date_Act   date,
      P_Actual_Amount_Paid number,

      p_message_type out   varchar2,
      p_message_text out   varchar2
   ) as
      v_Lc_Status_Check     varchar2(20);
      v_Lc_Status           varchar2(2) := 'L3';
      v_empno               varchar2(5);
      v_old_acceptance_date date;
      v_user_tcp_ip         varchar2(5) := 'NA';
      v_message_type        number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(p_application_id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      select acceptance_date into v_old_acceptance_date
        from afc_lc_acceptance
       where lc_key_id = p_application_id;

      update afc_lc_acceptance
         set acceptance_date = p_acceptance_date,
             Remarks = p_Remarks,
             payment_date_act = p_payment_date_act,
             actual_amount_paid = p_actual_amount_paid,
             modified_on = sysdate,
             modified_by = v_empno
       where lc_key_id = p_application_id;

      commit;

      if v_old_acceptance_date is null then
         if P_Acceptance_Date is not null then

            insert into AFC_LC_LIVE_STATUS
               (KEY_ID, LC_KEY_ID, LIVE_STATUS_KEY_ID, MODIFIED_ON)
            values (dbms_random.string('X', 8), P_Application_Id, v_Lc_Status, sysdate);

         end if;
      end if;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_update_acceptance;

   procedure sp_add_charges(
      p_person_id         varchar2,
      p_meta_id           varchar2,

      P_Application_Id    varchar2,
      P_Lc_Charges_Status varchar2,
      P_Basic_Charges     number,
      P_Other_Charges     number,
      P_Tax               number,
      P_Clint_File_Name   varchar2 default null,
      P_Server_File_Name  varchar2 default null,
      P_COMMISSION_RATE   varchar2 default null,
      P_DAYS              varchar2 default null,
      P_Remarks           varchar2,

      p_message_type out  varchar2,
      p_message_text out  varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      --v_sr_no        Varchar(7);
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(P_Application_Id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      insert into Afc_Lc_Charges
      (
         Key_Id, Lc_Key_Id, Status_Key_Id, Basic_Charges, Other_Charges,
         Tax, Clint_File_Name, Modified_On, Modified_By, Remarks, Server_File_Name,
         COMMISSION_RATE, Days
      )
      values
      (
         Dbms_Random.String('X', 8), P_Application_Id, P_Lc_Charges_Status, P_Basic_Charges,
         P_Other_Charges, P_Tax, P_Clint_File_Name, Sysdate, V_Empno, P_Remarks, P_Server_File_Name,
         P_COMMISSION_RATE, P_Days
      );

      commit;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_add_charges;

   procedure sp_update_charges(
      p_person_id         varchar2,
      p_meta_id           varchar2,

      P_Application_Id    varchar2,
      P_Lc_Charges_Status varchar2,
      P_Basic_Charges     number,
      P_Other_Charges     number,
      P_Tax               number,
      P_Clint_File_Name   varchar2 default null,
      P_Server_File_Name  varchar2 default null,
      P_COMMISSION_RATE   varchar2 default null,
      P_DAYS              varchar2 default null,
      P_Remarks           varchar2,

      p_message_type out  varchar2,
      p_message_text out  varchar2
   ) as
      v_lc_key_id       varchar2(8);
      v_Lc_Status_Check varchar2(20);
      --v_sr_no        Varchar(7);
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select LC_KEY_ID into v_lc_key_id from Afc_Lc_Charges where Key_Id = P_Application_Id;

      v_Lc_Status_Check := Get_Lc_Status(v_lc_key_id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      update Afc_Lc_Charges
         set Status_Key_Id = P_Lc_Charges_Status,
             Basic_Charges = P_Basic_Charges,
             Other_Charges = P_Other_Charges,
             Tax = P_Tax,
             Clint_File_Name = P_Clint_File_Name,
             Server_File_Name = P_Server_File_Name,
             Modified_On = Sysdate,
             Modified_By = V_Empno,
             COMMISSION_RATE = P_COMMISSION_RATE,
             Days = P_Days,
             Remarks = P_Remarks
       where Key_Id = P_Application_Id;

      commit;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_update_charges;

   procedure sp_add_amount(
      p_person_id         varchar2,
      p_meta_id           varchar2,

      p_application_id    varchar2,
      p_currency_key_id   varchar2,
      p_exchage_rate_date date,
      p_exchange_rate     number,
      p_lc_amount         number,
      p_amount_in_inr     number,

      p_message_type out  varchar2,
      p_message_text out  varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(P_Application_Id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      insert into afc_lc_amount
      (
         key_id, lc_key_id, currency_key_id, exchage_rate_date,
         exchange_rate, lc_amount, amount_in_inr, modified_on, modified_by
      )
      values
      (
         dbms_random.STRING('X', 8), p_application_id, p_currency_key_id, p_exchage_rate_date,
         p_exchange_rate, p_lc_amount, p_amount_in_inr, sysdate, v_empno
      );
      commit;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_add_amount;

   procedure sp_update_amount(
      p_person_id         varchar2,
      p_meta_id           varchar2,

      p_application_id    varchar2,
      p_currency_key_id   varchar2,
      p_exchage_rate_date date,
      p_exchange_rate     number,
      p_lc_amount         number,
      p_amount_in_inr     number,

      p_message_type out  varchar2,
      p_message_text out  varchar2
   ) as
      v_lc_key_id       varchar2(8);
      v_Lc_Status_Check varchar2(20);
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select LC_KEY_ID into v_lc_key_id from afc_lc_amount where Key_Id = P_Application_Id;

      v_Lc_Status_Check := Get_Lc_Status(v_lc_key_id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;

      update afc_lc_amount
         set currency_key_id = p_currency_key_id,
             exchage_rate_date = p_exchage_rate_date,
             exchange_rate = p_exchange_rate,
             lc_amount = p_lc_amount,
             amount_in_inr = p_amount_in_inr,
             modified_on = sysdate,
             modified_by = v_empno
       where key_id = p_application_id;

      commit;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_update_amount;

   procedure sp_update_lc_close(
      p_person_id           varchar2,
      p_meta_id             varchar2,

      P_Application_id      varchar2,
      P_Is_Active           number,
      p_Lc_Cl_Payment_Date  date,
      p_Lc_Cl_Actual_Amount number,
      p_Lc_Cl_Other_Charges number,
      P_Remarks             varchar2,

      p_message_type out    varchar2,
      p_message_text out    varchar2
   ) as
      v_Lc_Status    varchar2(2) := 'L4';
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

      update afc_lc_main set LC_STATUS = P_Is_Active,
             Lc_Cl_Other_Charges = p_Lc_Cl_Other_Charges,
             Lc_Cl_Actual_Amount = p_Lc_Cl_Actual_Amount,
             Lc_Cl_Payment_Date = p_Lc_Cl_Payment_Date,
             LC_CL_REMARKS = P_Remarks,
             LC_CL_MOD_ON = sysdate,
             LC_CL_MOD_BY = v_empno
       where lc_key_id = P_application_id;

      if P_Is_Active != 1 then

         insert into AFC_LC_LIVE_STATUS
            (KEY_ID, LC_KEY_ID, LIVE_STATUS_KEY_ID, MODIFIED_ON)
         values (dbms_random.string('X', 8), P_Application_Id, v_Lc_Status, sysdate);
      end if;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_update_lc_close;

   procedure sp_add_Po_Sap_Invoice(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Lc_Key_Id        varchar2,
      P_Po               number,
      P_Sap              number,
      P_Invoice          number,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_Lc_Status_Check := Get_Lc_Status(p_lc_key_id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;
      insert into afc_lc_main_po_sap_invoice
         (key_id, lc_key_id, po, sap, invoice, modified_on, modified_by)
      values
         (dbms_random.string('X', 8), p_lc_key_id, p_po, p_sap, p_invoice, sysdate, v_empno);
      commit;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_add_Po_Sap_Invoice;

   procedure sp_delete_Po_Sap_Invoice(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Application_Id   varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_Lc_Status_Check varchar2(20);
      v_lc_key_id       varchar2(8);
      v_empno           varchar2(5);
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number      := 0;
   begin
      v_empno           := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;
      
      select LC_KEY_ID into v_lc_key_id 
         from AFC_LC_MAIN_PO_SAP_INVOICE 
         where Key_Id = P_Application_Id;

      v_Lc_Status_Check := Get_Lc_Status(v_lc_key_id);

      if v_Lc_Status_Check != 'Open' then
         p_message_type := 'KO';
         p_message_text := 'Invalid action ,Lc Status is Closed.';
         return;
      end if;
      delete from AFC_LC_MAIN_PO_SAP_INVOICE
       where KEY_ID = P_Application_Id;

      p_message_type    := 'OK';
      p_message_text    := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_delete_Po_Sap_Invoice;

end LC_ACTION;
/