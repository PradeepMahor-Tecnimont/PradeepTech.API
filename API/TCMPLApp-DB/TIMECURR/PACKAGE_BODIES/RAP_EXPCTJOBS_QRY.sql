create or replace package body "TIMECURR"."RAP_EXPCTJOBS_QRY" as

   function fn_expected_Jobs(
      p_person_id    varchar2,
      p_meta_id      varchar2,

      p_projno       varchar2 default null,
      p_active       number   default null,
      p_activefuture number   default null,

      p_row_number   number,
      p_page_length  number

   ) return sys_refcursor as
      c sys_refcursor;
   begin

      open c for
         select *
           from (
                   select PROJNO as Project_No,
                          NAME as Project_Name,
                          ACTIVE as Is_Active,
                          BU as Bu,
                          ACTIVEFUTURE as Is_Active_Future,
                          FINAL_PROJNO as Final_Project_No,
                          NEWCOSTCODE as New_Costcode,
                          TCMNO as Tcmno,
                          LCK as Is_Locked,
                          PROJ_TYPE as Project_Type,
                          row_number() over (order by PROJNO desc) row_number,
                          count(*) over () total_row
                     from EXPTJOBS
                    where (
                            upper(PROJNO) like (upper(NVL('%' || p_projno || '%', PROJNO)))
                            Or upper(NAME) like (upper(NVL('%' || p_projno || '%', NAME)))
                            )
                      and ACTIVE = NVL(p_active, ACTIVE)
                      and ACTIVEFUTURE = NVL(p_activefuture, ACTIVEFUTURE)
                )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
          order by Project_No;
      return c;
   end fn_expected_Jobs;

   procedure sp_expectedjobs_details(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      P_PROJNO           varchar2,

      P_NAME         out varchar2,
      P_ACTIVE       out varchar2,
      P_BU           out varchar2,
      P_ACTIVEFUTURE out varchar2,
      P_FINAL_PROJNO out varchar2,
      P_NEWCOSTCODE  out varchar2,
      P_TCMNO        out varchar2,
      P_LCK          out varchar2,
      P_PROJ_TYPE    out varchar2,

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

      select NAME as Project_Name,
             ACTIVE as Is_Active,
             BU as Bu,
             ACTIVEFUTURE as Is_Active_Future,
             FINAL_PROJNO as Final_Project_No,
             NEWCOSTCODE as New_Costcode,
             TCMNO as Tcmno,
             LCK as Is_Locked,
             PROJ_TYPE as Project_Type
        into P_NAME,
             P_ACTIVE,
             P_BU,
             P_ACTIVEFUTURE,
             P_FINAL_PROJNO,
             P_NEWCOSTCODE,
             P_TCMNO,
             P_LCK,
             P_PROJ_TYPE
        from EXPTJOBS
       where PROJNO = P_PROJNO;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_expectedjobs_details;

end RAP_EXPCTJOBS_QRY;
/

grant execute on "TIMECURR"."RAP_EXPCTJOBS_QRY" to "TCMPL_APP_CONFIG";