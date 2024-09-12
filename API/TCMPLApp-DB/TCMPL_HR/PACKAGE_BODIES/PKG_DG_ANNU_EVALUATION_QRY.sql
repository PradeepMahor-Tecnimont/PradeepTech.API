create or replace package body "TCMPL_HR"."PKG_DG_ANNU_EVALUATION_QRY" as

   function fn_dg_annu_evaluation_pending_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_for_hod_or_hr  varchar2,
      p_generic_search varchar2 default null,
      p_grade          varchar2 default null,
      p_parent         varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as

      v_empno           varchar2(5);
      v_start_from_date date := to_date ( '2023-01-01', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              );     -- Past 12 months
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c                 sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      if p_for_hod_or_hr = 'HOD' then
         open c for select key_id,
                           empno,
                           name,
                           abbr,
                           grade,
                           emptype,
                           email,
                           assign,
                           parent,
                           doj,
                           hod_approval,
                           (                           
                                  case
                                    when nvl( hod_approval, not_ok ) = 'OK' then
                                     'Approved by Hod'
                                     when key_id is null then
                                        ''                                     
                                     else
                                        'Draft'
                                  end
                               ) as status,
                           row_number,
                           total_row
                                 from (
                                  select b.key_id,
                                         a.empno empno,
                                         a.name name,
                                         a.abbr abbr,
                                         a.grade grade,
                                         a.emptype emptype,
                                         a.email email,
                                         a.assign assign,
                                         a.parent parent,
                                         a.doj doj,
                                         b.hod_approval,
                                         row_number()
                                         over(
                                             order by a.doj desc
                                         ) row_number,
                                         count(*)
                                         over() total_row
                                    from vu_emplmast a
                                    left outer join dg_annu_evaluation b
                                  on a.empno = b.empno
                                   where a.status = 1
                                     and a.emptype = 'R'
                                     and nvl(
                                     hod_approval,
                                     not_ok
                                  ) = not_ok
                                     and ( a.doj >= v_start_from_date
                                     and (add_months(
                                     a.doj,
                                     10
                                  ) + 15) <= trunc(sysdate) )
                                     and a.grade in (
                                     select grade
                                       from dg_mid_evaluation_grade c
                                  )
                                     and a.parent = nvl(
                                     p_parent,
                                     a.parent
                                  )
                                     and a.grade = nvl(
                                     p_grade,
                                     a.grade
                                  )
                                     and a.parent in (
                                     select costcode
                                       from vu_costmast
                                      where hod = v_empno
                                     union
                                     select costcode
                                       from tcmpl_app_config.sec_module_user_roles_costcode
                                      where empno = v_empno
                                        and module_id = 'M19'
                                        and role_id = 'R003'
                                  )
                                     and ( upper(
                                     a.empno
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%'
                                      or upper(
                                     a.name
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%' )
                               )
                     where row_number between ( nvl(
                       p_row_number,
                       0
                    ) + 1 ) and ( nvl(
                       p_row_number,
                       0
                    ) + p_page_length );
         return c;
      end if;

      if p_for_hod_or_hr = 'HR' then
         open c for select key_id,
                           empno,
                           name,
                           abbr,
                           grade,
                           emptype,
                           email,
                           assign,
                           parent,
                           doj,
                           hod_approval,                           
                           (                           
                                  case
                                    when nvl( hod_approval, not_ok ) = 'OK' then
                                     'Approved by Hod'
                                     when key_id is null then
                                        ''                                     
                                     else
                                        'Draft'
                                  end
                               ) as status,
                           row_number,
                           total_row
                                 from (
                                  select b.key_id,
                                         a.empno empno,
                                         a.name name,
                                         a.abbr abbr,
                                         a.grade grade,
                                         a.emptype emptype,
                                         a.email email,
                                         a.assign assign,
                                         a.parent parent,
                                         a.doj doj,
                                         b.hod_approval,
                                         row_number()
                                         over(
                                             order by a.doj desc
                                         ) row_number,
                                         count(*)
                                         over() total_row
                                    from vu_emplmast a
                                    left outer join dg_annu_evaluation b
                                  on a.empno = b.empno
                                   where a.status = 1
                                     and a.emptype = 'R'
                                     --and nvl( b.hod_approval, not_ok ) = not_ok
                                     and nvl( b.HR_APPROVAL, not_ok ) = not_ok
                                     and ( a.doj >= v_start_from_date
                                     and (add_months(
                                     a.doj,
                                     10
                                  ) + 15) <= trunc(sysdate) )
                                     and a.grade in (
                                     select grade
                                       from dg_mid_evaluation_grade c
                                  )
                                     and a.parent = nvl(
                                     p_parent,
                                     a.parent
                                  )
                                     and a.grade = nvl(
                                     p_grade,
                                     a.grade
                                  )
                                     and ( upper(
                                     a.empno
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%'
                                      or upper(
                                     a.name
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%' )
                               )
                     where row_number between ( nvl(
                       p_row_number,
                       0
                    ) + 1 ) and ( nvl(
                       p_row_number,
                       0
                    ) + p_page_length );
         return c;
      end if;

      if p_for_hod_or_hr = 'HR_APPRL' then
         open c for select key_id,
                           empno,
                           name,
                           abbr,
                           grade,
                           emptype,
                           email,
                           assign,
                           parent,
                           doj,
                           hod_approval,
                           (
                                  case
                                     when hod_approval = 'OK' then
                                        'Approved by Hod'
                                     else
                                        'Draft'
                                  end
                               ) as status,
                           row_number,
                           total_row
                                 from (
                                  select b.key_id,
                                         a.empno empno,
                                         a.name name,
                                         a.abbr abbr,
                                         a.grade grade,
                                         a.emptype emptype,
                                         a.email email,
                                         a.assign assign,
                                         a.parent parent,
                                         b.hr_approval,
                                         a.doj doj,
                                         b.hod_approval,
                                         not_ok,
                                         row_number()
                                         over(
                                             order by a.doj desc
                                         ) row_number,
                                         count(*)
                                         over() total_row
                                    from dg_annu_evaluation b,
                                         vu_emplmast a
                                   where nvl(
                                        b.HOD_APPROVAL,
                                        not_ok
                                     ) = ok
                                     and nvl(
                                     b.HR_APPROVAL,
                                     not_ok
                                  ) = not_ok
                                     and a.status = 1
                                     and b.empno = a.empno
                                     and a.emptype = 'R' 
                            --and  ( a.doj >= v_start_from_date and add_months( a.doj, 3 ) <= trunc(sysdate) )
                                     and a.grade in (
                                     select grade
                                       from dg_mid_evaluation_grade c
                                  )
                                     and a.parent = nvl(
                                     p_parent,
                                     a.parent
                                  )
                                     and a.grade = nvl(
                                     p_grade,
                                     a.grade
                                  )
                                     and ( upper(
                                     a.empno
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%'
                                      or upper(
                                     a.name
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%' )
                               )
                     where row_number between ( nvl(
                       p_row_number,
                       0
                    ) + 1 ) and ( nvl(
                       p_row_number,
                       0
                    ) + p_page_length );
         return c;
      end if;

   end fn_dg_annu_evaluation_pending_list;

   function fn_dg_annu_evaluation_history_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_for_hod_or_hr  varchar2,
      p_generic_search varchar2 default null,
      p_grade          varchar2 default null,
      p_parent         varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as

      v_empno           varchar2(5);
      v_start_from_date date := to_date ( '2023-01-1', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              );     -- Past 12 months
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c                 sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      if p_for_hod_or_hr = 'HOD' then
         open c for select key_id,
                           empno,
                           name,
                           abbr,
                           grade,
                           emptype,
                           email,
                           assign,
                           parent,
                           doj,
                           hod_approval,
                           row_number,
                           total_row
                                 from (
                                  select b.key_id,
                                         a.empno empno,
                                         a.name name,
                                         a.abbr abbr,
                                         a.grade grade,
                                         a.emptype emptype,
                                         a.email email,
                                         a.assign assign,
                                         a.parent parent,
                                         a.doj doj,
                                         b.hod_approval,
                                         row_number()
                                         over(
                                             order by a.doj desc
                                         ) row_number,
                                         count(*)
                                         over() total_row
                                    from vu_emplmast a
                                    left outer join dg_annu_evaluation b
                                  on a.empno = b.empno
                                   where a.status = 1
                                     and a.emptype = 'R'
                                     and Nvl(b.hod_approval, not_ok) = ok     
                                     and a.parent in (
                                     select costcode
                                       from vu_costmast
                                      where hod = v_empno
                                     union
                                     select costcode
                                       from tcmpl_app_config.sec_module_user_roles_costcode
                                      where empno = v_empno
                                        and module_id = 'M19'
                                        and role_id = 'R003'
                                  )
                                     and a.parent = nvl(
                                     p_parent,
                                     a.parent
                                  )
                                     and a.grade = nvl(
                                     p_grade,
                                     a.grade
                                  )                                    
                                     and ( upper(
                                     a.empno
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%'
                                      or upper(
                                     a.name
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%' )
                               )
                     where row_number between ( nvl(
                       p_row_number,
                       0
                    ) + 1 ) and ( nvl(
                       p_row_number,
                       0
                    ) + p_page_length );
         return c;
      end if;

      if p_for_hod_or_hr = 'HR' then
         open c for select key_id,
                           empno,
                           name,
                           abbr,
                           grade,
                           emptype,
                           email,
                           assign,
                           parent,
                           doj,
                           hod_approval,
                           row_number,
                           total_row
                                 from (
                                  select b.key_id,
                                         a.empno empno,
                                         a.name name,
                                         a.abbr abbr,
                                         a.grade grade,
                                         a.emptype emptype,
                                         a.email email,
                                         a.assign assign,
                                         a.parent parent,
                                         a.doj doj,
                                         b.hod_approval,
                                         row_number()
                                         over(
                                             order by a.doj desc
                                         ) row_number,
                                         count(*)
                                         over() total_row
                                    from vu_emplmast a
                                    left outer join dg_annu_evaluation b
                                  on a.empno = b.empno
                                   where a.status = 1
                                     and a.emptype = 'R'                                     
                                     and nvl( b.HR_APPROVAL, not_ok ) = ok
                                     and nvl( b.HOD_APPROVAL, not_ok ) = ok  
                                     and a.parent = nvl(
                                     p_parent,
                                     a.parent
                                  )
                                     and a.grade = nvl(
                                     p_grade,
                                     a.grade
                                  )
                                     and ( upper(
                                     a.empno
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%'
                                      or upper(
                                     a.name
                                  ) like '%'
                                         || upper(
                                     trim(p_generic_search)
                                  )
                                         || '%' )
                               )
                     where row_number between ( nvl(
                       p_row_number,
                       0
                    ) + 1 ) and ( nvl(
                       p_row_number,
                       0
                    ) + p_page_length );
         return c;
      end if;

   end fn_dg_annu_evaluation_history_list;

   function fn_dg_annu_evaluation_hod_pending_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_grade          varchar2 default null,
      p_parent         varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as

      v_empno           varchar2(5);
      v_start_from_date date := to_date ( '2023-01-01', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              );     -- Past 12 months
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c                 sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      return fn_dg_annu_evaluation_pending_list(
                                               p_person_id => p_person_id,
                                               p_meta_id => p_meta_id,
                                               p_for_hod_or_hr => 'HOD',
                                               p_generic_search => p_generic_search,
                                               p_grade => p_grade,
                                               p_parent => p_parent,
                                               p_row_number => p_row_number,
                                               p_page_length => p_page_length
             );
   end fn_dg_annu_evaluation_hod_pending_list;

   function fn_dg_annu_evaluation_hr_pending_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_grade          varchar2 default null,
      p_parent         varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as

      v_empno           varchar2(5);
      v_start_from_date date := to_date ( '2023-01-01', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              );     -- Past 12 months
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c                 sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      return fn_dg_annu_evaluation_pending_list(
                                               p_person_id => p_person_id,
                                               p_meta_id => p_meta_id,
                                               p_for_hod_or_hr => 'HR',
                                               p_generic_search => p_generic_search,
                                               p_grade => p_grade,
                                               p_parent => p_parent,
                                               p_row_number => p_row_number,
                                               p_page_length => p_page_length
             );
   end fn_dg_annu_evaluation_hr_pending_list;

   function fn_dg_annu_hr_action_pending_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_grade          varchar2 default null,
      p_parent         varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as

      v_empno           varchar2(5);
      v_start_from_date date := to_date ( '2023-01-01', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              );     -- Past 12 months
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c                 sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      return fn_dg_annu_evaluation_pending_list(
                                               p_person_id => p_person_id,
                                               p_meta_id => p_meta_id,
                                               p_for_hod_or_hr => 'HR_APPRL',
                                               p_generic_search => p_generic_search,
                                               p_grade => p_grade,
                                               p_parent => p_parent,
                                               p_row_number => p_row_number,
                                               p_page_length => p_page_length
             );
   end fn_dg_annu_hr_action_pending_list;


   function fn_dg_annu_evaluation_hod_history_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_grade          varchar2 default null,
      p_parent         varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as

      v_empno           varchar2(5);
      v_start_from_date date := to_date ( '2023-01-01', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              );     -- Past 12 months
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c                 sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      return fn_dg_annu_evaluation_history_list(
                                               p_person_id => p_person_id,
                                               p_meta_id => p_meta_id,
                                               p_for_hod_or_hr => 'HOD',
                                               p_generic_search => p_generic_search,
                                               p_grade => p_grade,
                                               p_parent => p_parent,
                                               p_row_number => p_row_number,
                                               p_page_length => p_page_length
             );
   end fn_dg_annu_evaluation_hod_history_list;

   function fn_dg_annu_evaluation_hr_history_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_grade          varchar2 default null,
      p_parent         varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as

      v_empno           varchar2(5);
      v_start_from_date date := to_date ( '2023-01-01', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              );     -- Past 12 months
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c                 sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      return fn_dg_annu_evaluation_history_list(
                                               p_person_id => p_person_id,
                                               p_meta_id => p_meta_id,
                                               p_for_hod_or_hr => 'HR',
                                               p_generic_search => p_generic_search,
                                               p_grade => p_grade,
                                               p_parent => p_parent,
                                               p_row_number => p_row_number,
                                               p_page_length => p_page_length
             );
   end fn_dg_annu_evaluation_hr_history_list;

   procedure sp_dg_annu_evaluation_detail (
      p_person_id         varchar2,
      p_meta_id           varchar2,
      p_key_id            varchar2,
      p_empno             out varchar2,
      p_desgcode          out varchar2,
      p_parent            out varchar2,
      p_attendance        out varchar2,
      p_location          out varchar2,
      p_training1         out varchar2,
      p_training2         out varchar2,
      p_training3         out varchar2,
      p_training4         out varchar2,
      p_training5         out varchar2,
      p_feedback1         out varchar2,
      p_feedback2         out varchar2,
      p_feedback3         out varchar2,
      p_feedback4         out varchar2,
      p_feedback5         out varchar2,
      p_feedback6         out varchar2,
      p_comments_of_hr    out varchar2,
      p_created_by        out varchar2,
      p_created_on        out varchar2,
      p_modified_by       out varchar2,
      p_modified_on       out varchar2,
      p_isdeleted         out varchar2,
      p_hod_approval      out varchar2,
      p_hod_approval_date out varchar2,
      p_hr_approval       out varchar2,
      p_hr_approval_date  out varchar2,
      P_HR_APPROVE_BY     out varchar2,
      p_message_type      out varchar2,
      p_message_text      out varchar2
   ) as
      v_exists       number;
      v_empno        varchar2(5) := 'NA';
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number := 0;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := not_ok;
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select count(*)
        into v_exists
        from dg_annu_evaluation
       where key_id = p_key_id;

      if v_exists = 1 then
         select empno,
                desgcode,
                parent,
                attendance,
                location,
                training_1,
                training_2,
                training_3,
                training_4,
                training_5,
                feedback_1,
                feedback_2,
                feedback_3,
                feedback_4,
                feedback_5,
                feedback_6,
                comments_of_hr,
                created_by,
                --to_char(created_on, 'DD-Mon-YYYY') as created_on,
                created_on,
                modified_by,
                --to_char(modified_on, 'DD-Mon-YYYY') as modified_on,
                modified_on,
                isdeleted,
                hod_approval,
                hod_approval_date,
                hr_approval,
                to_char(
                   hr_approval_date,
                   'DD-Mon-YYYY'
                ) as hr_approval_date,
                HR_APPROVE_BY
           into
            p_empno,
            p_desgcode,
            p_parent,
            p_attendance,
            p_location,
            p_training1,
            p_training2,
            p_training3,
            p_training4,
            p_training5,
            p_feedback1,
            p_feedback2,
            p_feedback3,
            p_feedback4,
            p_feedback5,
            p_feedback6,
            p_comments_of_hr,
            p_created_by,
            p_created_on,
            p_modified_by,
            p_modified_on,
            p_isdeleted,
            p_hod_approval,
            p_hod_approval_date,
            p_hr_approval,
            p_hr_approval_date,
            P_HR_APPROVE_BY
           from dg_annu_evaluation
          where key_id = p_key_id;
         commit;
         p_message_type := ok;
         p_message_text := 'Procedure executed successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'No matching record exists !!!';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_evaluation_detail;

   procedure sp_dg_annu_evaluation_get_key_id (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_empno        varchar2,
      p_key_id       out varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_exists       number;
      v_empno        varchar2(5) := 'NA';
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number := 0;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := not_ok;
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select count(key_id)
        into v_exists
        from dg_annu_evaluation
       where empno = p_empno;

      if v_exists = 1 then
         select key_id
           into p_key_id
           from dg_annu_evaluation
          where empno = p_empno;
         p_message_type := ok;
         p_message_text := 'Procedure executed successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'No matching record exists !!!';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_evaluation_get_key_id;

   Function fn_dg_annu_evaluation_hr_pending_list_xl (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_parent    Varchar2 Default Null
    ) Return Sys_Refcursor As

        v_empno           Varchar2(5);
        v_start_from_date Date := To_Date ( '2023-01-01', 'yyyy-MM-dd' );
        v_get_from_date   Date := add_months(
                                          trunc(sysdate),
                                          -12
                                );     -- Past 12 months
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c                 Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                       key_id,
                       empno,
                       name,
                       abbr,
                       grade,
                       emptype,
                       email,
                       assign,
                       parent,
                       doj,
                       (Case
                     When nvl(hod_approval,not_ok) = 'OK' Then
                         'Yes'
                     Else
                        'No'
                    End)                                             hod_approval,
                       (
                           Case
                               When nvl(
                                   hod_approval,
                                   not_ok
                               ) = 'OK' Then
                                   'Approved by Hod'
                               When key_id Is Null Then
                                   ''
                               Else
                                   'Draft'
                           End
                       ) As status,
                       row_number,
                       total_row
                     From
                       (
                           Select
                               b.key_id,
                               a.empno   empno,
                               a.name    name,
                               a.abbr    abbr,
                               a.grade   grade,
                               a.emptype emptype,
                               a.email   email,
                               a.assign  assign,
                               a.parent  parent,
                               a.doj     doj,
                               b.hod_approval,
                               Row_Number()
                               Over(
                                    Order By
                                       a.doj Desc
                               )         row_number,
                               Count(*)
                               Over()    total_row
                             From
                               vu_emplmast        a
                                 Left Outer Join dg_annu_evaluation b
                               On a.empno = b.empno
                            Where
                                   a.status = 1
                                  And a.emptype = 'R'
                                  And nvl(
                                   b.hr_approval,
                                   not_ok
                               ) = not_ok
                                  And ( a.doj >= v_start_from_date
                                  and (add_months(
                                     a.doj,
                                     10
                                  ) + 15) <= trunc(sysdate) )
                                  And a.grade In (
                                   Select
                                       grade
                                     From
                                       dg_mid_evaluation_grade c
                               )
                                  And a.parent = nvl(
                                   p_parent,
                                   a.parent
                               )
                       );
        Return c;
    End fn_dg_annu_evaluation_hr_pending_list_xl;
    
end pkg_dg_annu_evaluation_qry;