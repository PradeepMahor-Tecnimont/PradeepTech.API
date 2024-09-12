create or replace package body "TIMECURR"."RAP_EXPCTJOBS" as

   procedure sp_add_expectedjobs(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,
      P_NAME             varchar2,
      P_ACTIVE           number,
      P_BU               varchar2 default null,
      P_ACTIVEFUTURE     number,
      P_FINAL_PROJNO     varchar2 default null,
      P_NEWCOSTCODE      varchar2 default null,
      P_TCMNO            varchar2 default null,
      P_LCK              number   default null,
      P_PROJ_TYPE        varchar2 default null,

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
      P_ACTIVE           number,
      P_BU               varchar2 default null,
      P_ACTIVEFUTURE     number,
      P_FINAL_PROJNO     varchar2 default null,
      P_NEWCOSTCODE      varchar2 default null,
      P_TCMNO            varchar2 default null,
      P_LCK              number   default null,
      P_PROJ_TYPE        varchar2 default null,

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

   procedure sp_mv_by_months(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_Number_Of_Months number,

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

      update exptprjc
         set yymm = to_char(add_months(to_date(yymm, 'yyyymm'), P_Number_Of_Months), 'yyyymm')
       where projno = P_Projno;
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

   end sp_mv_by_months;

   procedure sp_mv_to_final_real(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_Real_Projno      varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      cursor C1 is select * from EXPTPRJC where PROJNO = P_Projno;
      V_COSTCODE     char(4);
      V_YYMM         char(6);
      V_HOURS        number;
      V_COUNT1       integer;
      V_COUNT        integer;
      REC            EXPTPRJC%ROWTYPE;
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

      open c1;
      select count(*) into V_COUNT from projmast where projno = P_Real_Projno;
      if V_COUNT > 0 then
         select count(*) into V_COUNT1 from prjcmast where projno = P_Real_Projno;
         if V_COUNT1 = 0 then
            loop
               fetch c1 into rec;
               exit when c1%NOTFOUND;
               V_COSTCODE := rec.costcode;
               v_yymm     := rec.yymm;
               v_hours    := rec.hours;
               insert into prjcMAST values (v_COSTCODE, P_Real_Projno, v_YYMM, v_HOURS);
            end loop;
            close c1;
         else
            p_message_type := 'KO';
            p_message_text := 'Projections already exists';
            return;

         end if;
      else
         p_message_type := 'KO';
         p_message_text := 'New project not availabe in master';
         return;
      end if;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         rollback;
         raise;
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_mv_to_final_real;

   procedure sp_mv_to_final_expected(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_expected_Projno  varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
      V_COSTCODE     char(4);
      V_YYMM         char(6);
      V_HOURS        number;
      V_COUNT1       integer;
      V_COUNT        integer;
      REC            EXPTPRJC%ROWTYPE;

   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select count(*) into V_COUNT from exptJOBS where projno = P_expected_Projno;
      if V_COUNT > 0 then

         select count(*) into V_COUNT1 from exptprjc where projno = P_expected_Projno;

         if V_COUNT1 = 0 then
            update exptprjc set projno = P_expected_Projno where projno = P_Projno;
         else
            p_message_type := 'KO';
            p_message_text := 'Projections already exists';
            return;
         end if;
      else
         p_message_type := 'KO';
         p_message_text := 'Project not availabe in master';
         return;
      end if;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         rollback;
         raise;
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_mv_to_final_expected;

   procedure sp_mv_to_final_Real_PC(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_Projno           varchar2,
      P_New_Projno       varchar2,
      P_Costcode         varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as

      cursor C1 is select *
                     from EXPTPRJC
                    where PROJNO = P_Projno
                      and COSTCODE = P_Costcode;
      V_COSTCODE     char(4);
      V_YYMM         char(6);
      V_HOURS        number;
      V_COUNT1       integer;
      V_COUNT        integer;
      REC            EXPTPRJC%ROWTYPE;
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

      open c1;
      select count(*) into V_COUNT
        from projmast
       where projno = P_New_Projno
         and COSTCODE = P_Costcode;
         
      if V_COUNT > 0 then
         select count(*) into V_COUNT1
           from prjcmast
          where projno = P_New_Projno
            and COSTCODE = P_Costcode;
         if V_COUNT1 = 0 then
            loop
               fetch c1 into rec;
               exit when c1%NOTFOUND;
               V_COSTCODE := rec.costcode;
               v_yymm     := rec.yymm;
               v_hours    := rec.hours;
               insert into prjcMAST values (v_COSTCODE, P_New_Projno, v_YYMM, v_HOURS);
            end loop;
            close c1;
            delete from EXPTPRJC
             where PROJNO = P_Projno
               and COSTCODE = P_Costcode;
         else
            p_message_type := 'KO';
            p_message_text := 'Projections  for costcode '
                              || P_Costcode
                              || ' already exists';
            return;
         end if;
      else
         p_message_type := 'KO';
         p_message_text := 'Project and costcode combination not availabe';
         return;
      end if;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         rollback;
         raise;
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_mv_to_final_Real_PC;

end RAP_EXPCTJOBS;
/

grant execute on "TIMECURR"."RAP_EXPCTJOBS" to "TCMPL_APP_CONFIG";