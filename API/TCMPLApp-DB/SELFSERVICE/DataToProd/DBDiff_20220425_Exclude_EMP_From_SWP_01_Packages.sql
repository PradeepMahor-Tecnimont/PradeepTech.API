--------------------------------------------------------
--  File created - Monday-April-25-2022   
--------------------------------------------------------
---------------------------
--New PACKAGE
--IOT_SWP_EXCLUDE_EMP
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EXCLUDE_EMP" as

   procedure sp_add_swp_exclude_emp(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_empno            varchar2,
      p_start_date       date,
      p_end_date         date,
      p_reason           varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

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
   );

   procedure sp_delete_swp_exclude_emp(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_application_id   varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

end IOT_SWP_EXCLUDE_EMP;
/
---------------------------
--New PACKAGE
--IOT_SWP_EXCLUDE_EMP_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EXCLUDE_EMP_QRY" as

   function fn_Swp_Exclude_Emp_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,

      p_start_date     date     default null,
      p_end_date       date     default null,
      P_Is_Active      number   default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor;

   procedure sp_Swp_Exclude_Emp_details(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_Application_Id   varchar2,

      p_Empno        out varchar2,
      p_Emp_name     out varchar2,
      p_start_date   out varchar2,
      p_end_date     out varchar2,
      p_Reason       out varchar2,
      P_Is_Active    out varchar2,

      p_modified_on  out varchar2,
      p_modified_by  out varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

end IOT_SWP_EXCLUDE_EMP_QRY;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_EXCLUDE_EMP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EXCLUDE_EMP_QRY" as

   function fn_Swp_Exclude_Emp_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,

      p_start_date     date     default null,
      p_end_date       date     default null,
      P_Is_Active      number   default null,

      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as
      v_empno              varchar2(5);
      e_employee_not_found exception;
      pragma exception_init(e_employee_not_found, -20001);
      c                    sys_refcursor;
   begin

      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;

      open c for
         select *
           from (
                   select a.key_id as key_id,
                          a.empno as Empno,
                          b.name as Employee_Name,
                          to_char(a.start_date, 'dd-Mon-yyyy') as start_date,
                          to_char(a.end_date, 'dd-Mon-yyyy') as end_date,
                          a.reason as Reason,
                          a.Is_Active as Is_Active , 
                          to_char(a.modified_on, 'dd-Mon-yyyy') as modified_on,
                          get_emp_name(a.modified_by) as modified_by,
                          row_number() over (order by a.key_id desc) row_number,
                          count(*) over () total_row
                     from Swp_Exclude_Emp a, ss_emplmast b
                    where a.EMPNO = b.EMPNO
                      and a.Is_Active = nvl(P_Is_Active, a.Is_Active)
                      --and (b.name like nvl(p_generic_search,'%') or b.empno like nvl(p_generic_search,'%'))
                    and (  upper(b.name) like upper('%'||p_generic_search||'%') 
                           or 
                           upper(b.empno) like upper('%'||p_generic_search||'%') 
                         )
                    order by a.start_date, a.end_date
                )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length);
      return c;

   end;

   procedure sp_Swp_Exclude_Emp_details(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_Application_Id   varchar2,

      p_Empno        out varchar2,
      p_Emp_name     out varchar2,
      p_start_date   out varchar2,
      p_end_date     out varchar2,
      p_Reason       out varchar2,
      P_Is_Active    out varchar2,

      p_modified_on  out varchar2,
      p_modified_by  out varchar2,

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

      select a.empno as Empno,
             b.name as Emp_name,
             to_char(a.start_date, 'dd-Mon-yyyy') as start_date,
             to_char(a.end_date, 'dd-Mon-yyyy') as end_date,
             a.reason as Reason,
             a.Is_Active as Is_Active,
             to_char(a.modified_on, 'dd-Mon-yyyy') as modified_on,
             a.modified_by modified_by
        into p_Empno,
             p_Emp_name,
             p_start_date,
             p_end_date,
             p_Reason,
             P_Is_Active,
             p_modified_on,
             p_modified_by
        from Swp_Exclude_Emp a, ss_emplmast b
       where a.EMPNO = b.EMPNO
         and a.key_id = p_Application_Id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_Swp_Exclude_Emp_details;

end IOT_SWP_EXCLUDE_EMP_QRY;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_EXCLUDE_EMP
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EXCLUDE_EMP" as

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
