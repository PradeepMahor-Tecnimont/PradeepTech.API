--------------------------------------------------------
--  DDL for Package Body IOT_SWP_EMP_PROJ_MAP_QRY
--------------------------------------------------------

create or replace package body "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" as

   function fn_emp_proj_map_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,
      p_projno         varchar2 default null,
      p_assign_code    varchar2 default null,

      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor
   is
      c                     sys_refcursor;
      v_count               number;
      v_empno               varchar2(5);
      v_hod_sec_assign_code varchar2(4);
      e_employee_not_found  exception;
      pragma exception_init(e_employee_not_found, -20001);

   begin

      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;

      if v_empno is null or p_assign_code is not null then
         v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                     p_hod_sec_empno => v_empno,
                                     p_assign_code   => p_assign_code
                                  );
      end if;
      open c for
         with proj as (select distinct proj_no, name from ss_projmast  where active =1)
         select *
           from (
                   select empprojmap.key_id as keyid,
                          empprojmap.empno as empno,
                          a.name as empname,
                          empprojmap.projno as projno,
                          b.name as projname,
                          row_number() over (order by empprojmap.key_id desc) row_number,
                          count(*) over () total_row
                     from swp_emp_proj_mapping empprojmap,
                          ss_emplmast a,
                          proj b
                    where a.empno = empprojmap.empno
                      and b.proj_no = empprojmap.projno
                      and empprojmap.projno = nvl(p_projno, empprojmap.projno)
                      and (upper(a.name) like upper('%'
                                || p_generic_search
                                || '%')
                             or
                             upper(a.empno) like upper('%'
                                || p_generic_search
                                || '%')
                          )
                      and empprojmap.empno in (
                             select distinct empno
                               from ss_emplmast
                              where status = 1
                                and a.assign = nvl(v_hod_sec_assign_code, a.assign)
                          /*
                          And assign In (
                                  Select parent
                                    From ss_user_dept_rights
                                   Where empno = v_empno
                                  Union
                                  Select costcode
                                    From ss_costmast
                                   Where hod = v_empno
                               )
                          */
                          )

                )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
          order by empno,
                projno;
      return c;

   end fn_emp_proj_map_list;

   procedure sp_Swp_Emp_Emp_Proj_details(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_Application_Id   varchar2,

      p_Empno        out varchar2,
      p_Emp_name     out varchar2,
      P_Projno       out varchar2,
      P_Proj_Name    out varchar2,

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

      with proj as (select distinct proj_no, name from ss_projmast where active =1)
      select empprojmap.empno as empno,
             a.name as empname,
             empprojmap.projno as projno,
             b.name as projname
        into P_empno,
             P_emp_name,
             P_Projno,
             P_Proj_Name
        from swp_emp_proj_mapping empprojmap,
             ss_emplmast a,
             proj b
       where empprojmap.key_id = p_Application_Id
         and a.empno = empprojmap.empno
         and b.proj_no = empprojmap.projno;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_Swp_Emp_Emp_Proj_details;

   --  GRANT EXECUTE ON "IOT_SWP_EMP_PROJ_MAP_QRY" TO "TCMPL_APP_CONFIG";

end iot_swp_emp_proj_map_qry;
/

grant execute on "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" to "TCMPL_APP_CONFIG";