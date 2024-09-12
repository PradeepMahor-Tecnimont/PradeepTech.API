create or replace package body "DMS"."PKG_DM_AREA_TYPE_QRY" as

   function fn_dm_area_type_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_is_active      number default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as
      v_empno varchar2(5);
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c       sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      open c for select key_id,
                        short_desc,
                        description,
                        is_active as is_active_val,
                        case
                           when is_active = 1 then
                                  'Yes'
                           else
                              'No'
                        end as is_active_text,                         
                        modified_on,
                        ( modified_by || ' : ' || get_emp_name(modified_by) ) as modified_by,
                        0 As delete_allowed,
                        row_number,
                        total_row
                              from (
                               select a.key_id as key_id,
                                      a.short_desc as short_desc,
                                      a.description as description,
                                      a.is_active,                                      
                                      a.modified_on as modified_on,
                                      a.modified_by as modified_by,
                                      row_number()
                                      over(
                                          order by a.key_id
                                      ) row_number,
                                      count(*)
                                      over() total_row
                                 from dm_area_type a
                                where a.is_active = nvl(
                                     p_is_active,
                                     a.is_active
                                  )
                                  and ( upper(
                                  a.short_desc
                               ) like '%'
                                      || upper(
                                  trim(p_generic_search)
                               )
                                      || '%'
                                   or upper(
                                  a.description
                               ) like '%' || upper(
                                  trim(p_generic_search)
                               ) )
                            )
                  where row_number between ( nvl(
                    p_row_number,
                    0
                 ) + 1 ) and ( nvl(
                    p_row_number,
                    0
                 ) + p_page_length );
      return c;
   end fn_dm_area_type_list;


   procedure sp_dm_area_type_details (
      p_person_id          varchar2,
      p_meta_id            varchar2,
      p_key_id             varchar2,
      p_short_desc         out varchar2,
      p_description        out varchar2,
      p_is_active_val      out number,
      p_is_active_text     out varchar2,
      p_modified_on        out date,
      p_modified_by        out varchar2,
      p_message_type       out varchar2,
      p_message_text       out varchar2
   ) as
      v_exists       number;
      v_empno        varchar2(5);
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
        from dm_area_type
       where key_id = p_key_id;

      if v_exists = 1 then
         select short_desc,
                description,
                is_active,
                (case
                           when is_active = 1 then
                                  'Yes'
                           else
                              'No'
                        end 
                  ) as is_active_text,                
                modified_on,
                modified_by
           into
            p_short_desc,
            p_description,
            p_is_active_val,
            p_is_active_text,            
            p_modified_on,
            p_modified_by
           from dm_area_type
          where key_id = p_key_id;

         p_message_type := ok;
         p_message_text := 'Procedure executed successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'No matching Desk area type exists !!!';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dm_area_type_details;


   function fn_dm_area_type_xl_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null
   ) return sys_refcursor as
      v_empno varchar2(5);
      e_employee_not_found exception;
      pragma exception_init ( e_employee_not_found, -20001 );
      c       sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      open c for select a.key_id as key_id,
                        a.short_desc as short_desc,
                        a.description as description,
                        a.is_active as is_active_val,
                        a.is_active as is_active_text,
                        a.modified_on as modified_on,
                        a.modified_by as modified_by,
                        row_number()
                        over(
                                order by a.short_desc
                        ) row_number,
                        count(*)
                        over() total_row
                              from dm_area_type a
                  where ( upper(
                    a.short_desc
                 ) like '%'
                        || upper(
                    trim(p_generic_search)
                 )
                        || '%'
                     or upper(
                    a.description
                 ) like '%' || upper(
                    trim(p_generic_search)
                 ) );

      return c;
   end fn_dm_area_type_xl_list;

end pkg_dm_area_type_qry;