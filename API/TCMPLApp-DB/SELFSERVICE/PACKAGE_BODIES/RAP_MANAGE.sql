create or replace package body "TIMECURR"."RAP_MANAGE" as

   procedure sp_repost(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Yyyymm           varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
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

   end sp_repost;

   procedure sp_move_month(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Yyyymm           varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
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

   end sp_move_month;

   procedure sp_update_employee(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
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

      update costmast set noofemps = 0, NOOFCONS = 0;
      update costmast set noofemps =
             nvl((
                   select count(empno)
                     from emplmast
                    where emplmast.parent = costmast.costcode   
                      -- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
                      --AND EMPNO NOT LIKE '10%'
                      and emplmast.emptype in ('C', 'R', 'F')
                      and nvl(emplmast.status, 0) = 1
                ), 0);

      update costmast set NOOFCONS =
             nvl((
                   select count(empno)
                     from emplmast
                    where emplmast.parent = costmast.costcode   
                      -- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
                      --AND EMPNO NOT LIKE '10%'
                      and emplmast.emptype in ('C', 'F')
                      and nvl(emplmast.status, 0) = 1
                ), 0);
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

   end sp_update_employee;

end RAP_MANAGE;
/

grant execute on "TIMECURR"."RAP_MANAGE" to "TCMPL_APP_CONFIG";