
create or replace package body "TIMECURR"."RAP_EXPCTJOBS" as
  
   procedure sp_add_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,
      P_NAME             varchar2,
      P_ACTIVE           number default null,
      P_BU               varchar2,
      P_ACTIVEFUTURE     number default null,
      P_FINAL_PROJNO     varchar2,
      P_NEWCOSTCODE      varchar2,
      P_TCMNO            varchar2,
      P_LCK              number default null,
      P_PROJ_TYPE        varchar2,

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

      insert into EXPTJOBS
      (
         PROJNO, NAME, ACTIVE, BU, ACTIVEFUTURE, FINAL_PROJNO,
         NEWCOSTCODE, TCMNO, LCK, PROJ_TYPE
      )
      values (
         P_PROJNO, P_NAME, P_ACTIVE, P_BU, P_ACTIVEFUTURE, P_FINAL_PROJNO,
         P_NEWCOSTCODE, P_TCMNO, P_LCK, P_PROJ_TYPE
      );

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

   end sp_add_expectedjobs;

   

   procedure sp_update_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,
      P_NAME             varchar2,
      P_ACTIVE           number default null,
      P_BU               varchar2,
      P_ACTIVEFUTURE     number default null,
      P_FINAL_PROJNO     varchar2,
      P_NEWCOSTCODE      varchar2,
      P_TCMNO            varchar2,
      P_LCK              number default null,
      P_PROJ_TYPE        varchar2,

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

      update EXPTJOBS
         set NAME = P_NAME,
             ACTIVE = P_ACTIVE,
             BU = P_BU,
             ACTIVEFUTURE = P_ACTIVEFUTURE,
             FINAL_PROJNO = P_FINAL_PROJNO,
             NEWCOSTCODE = P_NEWCOSTCODE,
             TCMNO = P_TCMNO,
             LCK = P_LCK,
             PROJ_TYPE = P_PROJ_TYPE
       where PROJNO = P_PROJNO;

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

   end sp_update_expectedjobs;

   
   procedure sp_delete_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,

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

      delete from EXPTJOBS
       where PROJNO = P_PROJNO;

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

   end sp_delete_expectedjobs;
   
end RAP_EXPCTJOBS;
/

grant execute on "TIMECURR"."RAP_EXPCTJOBS" to "TCMPL_APP_CONFIG";