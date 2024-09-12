--------------------------------------------------------
--  DDL for Package Body IOT_SWP_EXCLUDE_EMP
--------------------------------------------------------

create or replace package body "SELFSERVICE"."IOT_SWP_EXCLUDE_EMP" as

   procedure sp_add_swp_exclude_emp(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_empno            varchar2,
      p_start_date       date,
      p_end_date         date,
      p_reason           varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno    varchar2(5);
      v_emp_name varchar2(60);
      v_key_id   varchar2(8);
      v_Is_Active number := 1;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_key_id       := dbms_random.string('X', 8);

      commit;

      insert into swp_exclude_emp
         (key_id, empno, start_date, end_date, reason,Is_Active, modified_on, modified_by)
      values
         (v_key_id, p_empno, p_start_date, p_end_date, p_reason,v_Is_Active, Sysdate, v_empno);

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_add_swp_exclude_emp;

   procedure sp_update_swp_exclude_emp(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_Application_Id   varchar2,

      p_empno            varchar2,
      p_start_date       date,
      p_end_date         date,
      p_reason           varchar2,
      P_Is_Active        number,
      
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno    varchar2(5);
      v_emp_name varchar2(60);
      v_key_id   varchar2(8);
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      update swp_exclude_emp
         set empno = p_empno,
             start_date = p_start_date,
             end_date = p_end_date,
             reason = p_reason,
             is_active = P_Is_Active,
             modified_on = sysdate,
             modified_by = v_empno
       where key_id = p_application_id;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_update_swp_exclude_emp;

   procedure sp_delete_swp_exclude_emp(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_application_id   varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_count    number;
      v_empno    varchar2(5);
      v_tab_from varchar2(2);
   begin
      v_count        := 0;
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      delete from swp_exclude_emp
       where key_id = p_application_id;
      
      commit;
      
      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_delete_swp_exclude_emp;

end IOT_SWP_EXCLUDE_EMP;
/

grant execute on "SELFSERVICE"."IOT_SWP_EXCLUDE_EMP" to "TCMPL_APP_CONFIG";