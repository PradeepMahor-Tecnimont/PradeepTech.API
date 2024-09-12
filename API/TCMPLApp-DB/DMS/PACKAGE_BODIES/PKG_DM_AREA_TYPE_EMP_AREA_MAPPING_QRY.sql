create or replace package body "DMS"."PKG_DM_AREA_TYPE_EMP_AREA_MAPPING_QRY" as

   function fn_dm_area_type_emp_area_mapping_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_desk_type      varchar2 default null,
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
      open c for 
      select *
              from (
                           Select
                            a.key_id                                              As key_id,
                            b.area_catg_code                                      As area_catg_code,
                            e.description                                         As area_catg_desc,
                            a.desk_type                                           As desk_area_type_code,
                            d.description                                         As desk_area_type_desc,
                            a.area_id                                             As area_id,
                            b.area_desc                                           As area_desc,
                            a.empno                                               As emp_no,
                            c.name                                                As emp_name,
                            a.modified_on                                         As modified_on,
                            a.modified_by || ' : ' || get_emp_name(a.modified_by) As modified_by,
                            Row_Number()
                            Over(
                                 Order By
                                    a.desk_type
                            )                                                     row_number,
                            Count(*)
                            Over()                                                total_row
                          From
                            dm_area_type_emp_area_mapping a,
                            dm_desk_areas                 b,
                            dm_desk_area_categories       e,
                            ss_emplmast                   c,
                            dm_area_type                  d
                         Where
                                a.empno = c.empno
                               And a.area_id        = b.area_key_id
                               And b.area_catg_code = e.area_catg_code
                               And a.desk_type      = d.key_id
                               And a.desk_type      = nvl(Trim(p_desk_type),a.desk_type)
                               And ( upper(a.desk_type) Like '%' || upper(Trim(p_generic_search)) || '%'
                                    Or upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' 
                                    Or upper(c.name) Like '%' || upper(Trim(p_generic_search)) || '%' )
                            )
                  where row_number between ( nvl(
                    p_row_number,
                    0
                 ) + 1 ) and ( nvl(
                    p_row_number,
                    0
                 ) + p_page_length );
      return c;
   end fn_dm_area_type_emp_area_mapping_list;


   procedure sp_dm_area_type_emp_area_mapping_details (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_key_id         varchar2,
      p_area_catg_code out varchar2,
      p_area_catg_desc out varchar2,
      P_Area_id out varchar2,
      P_Area_Desc out varchar2,
      p_area_type_code out varchar2,
      p_area_type_desc out varchar2,
      p_emp_no         out varchar2,
      p_emp_name       out varchar2,
      p_modified_by    out varchar2,
      p_modified_on    out date,
      p_message_type   out varchar2,
      p_message_text   out varchar2
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
        from dm_area_type_emp_area_mapping
       where key_id = p_key_id;

      if v_exists = 1 then
         select 
                b.area_catg_code as area_catg_code,
                e.description as area_catg_desc,                
                a.desk_type as desk_type_code,
                d.description as desk_type_desk,
                b.area_key_id as area_id,
                b.area_desc as area_desc,
                a.empno as emp_no,
                c.name as emp_name,
                a.modified_on as modified_on,
                a.modified_by
                || ' : '
                || get_emp_name(
                   a.modified_by
                ) as modified_by
           into             
            p_area_catg_code,
            p_area_catg_desc,
            p_area_type_code,
            p_area_type_desc,
            P_Area_id,
            P_Area_Desc,
            p_emp_no,
            p_emp_name,
            p_modified_on,
            p_modified_by
           from dm_area_type_emp_area_mapping a,
                dm_desk_areas b,
                dm_desk_area_categories e,
                ss_emplmast c,
                dm_area_type d
          where a.key_id = p_key_id
            and a.empno = c.empno
            and a.desk_type = b.area_key_id
            and a.desk_type = d.key_id
            and b.area_catg_code = e.area_catg_code;

         p_message_type := ok;
         p_message_text := 'Procedure executed successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'No matching employee desk area type mapping exists !!!';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dm_area_type_emp_area_mapping_details;


   function fn_dm_area_type_emp_area_mapping_xl_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_desk_type      varchar2 default null,
      p_modified_on    date default null
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
                        b.area_catg_code as area_catg_code,
                        e.description as area_catg_desc,
                        a.desk_type as desk_area_type_code,
                        d.description as desk_area_type_desc,
                        a.area_id as area_id,
                        b.area_desc as area_desc,
                        a.empno as emp_no,
                        c.name as emp_name,
                        a.modified_on as modified_on,
                        a.modified_by
                        || ' : '
                        || get_emp_name(
                               a.modified_by
                            ) as modified_by,
                        row_number()
                        over(
                                order by a.desk_type
                        ) row_number,
                        count(*)
                        over() total_row
                              from dm_area_type_emp_area_mapping a,
                                   dm_desk_areas b,
                                   dm_desk_area_categories e,
                                   ss_emplmast c,
                                   dm_area_type d
                 where a.empno = c.empno
               and a.area_id = b.area_key_id
                 and b.area_catg_code = e.area_catg_code
                 and  a.desk_type = d.KEY_ID
                    and ( upper(
                    b.area_desc
                 ) like '%'
                        || upper(
                    trim(p_generic_search)
                 )
                        || '%'
                     or upper(
                    c.name
                 ) like '%'
                        || upper(
                    trim(p_generic_search)
                 )
                        || '%' );
      return c;
   end fn_dm_area_type_emp_area_mapping_xl_list;

end pkg_dm_area_type_emp_area_mapping_qry;