create or replace package body "DMS"."PKG_DM_AREA_TYPE_PROJECT_MAPPING_QRY" as


   function fn_areas_4_proj (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as
      c                sys_refcursor;
      v_desk_area_type varchar2(4) := 'AT02';
   begin
      open c for select area_id,
                        area_desc,
                        area_info,
                        desk_area_type_val,
                        desk_area_type_text,
                        is_restricted as is_restricted_val,
                        case
                           when is_restricted = 1 then
                                  'Yes'
                           else
                              'No'
                        end as is_restricted_text,
                         proj_count,
                        row_number,
                        total_row
                              from (
                               select a.area_key_id as area_id,
                                      a.area_desc as area_desc,
                                      a.area_catg_code as area_catg_code,
                                      a.area_info as area_info,
                                      a.desk_area_type as desk_area_type_val,
                                      b.description as desk_area_type_text,
                                      a.is_restricted as is_restricted,
                                      (
                                         select count(ct.project_no)
                                           from dm_area_type_project_mapping ct
                                          where ct.area_id = area_key_id
                                      ) as proj_count,
                                      row_number()
                                      over(
                                          order by a.area_key_id desc
                                      ) row_number,
                                      count(*)
                                      over() total_row
                                 from dm_desk_areas a,
                                      dm_area_type b
                                where a.desk_area_type = b.key_id
                                  and a.desk_area_type = v_desk_area_type
                                  and ( upper(
                                  a.area_desc
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
   end fn_areas_4_proj;


   function fn_dm_area_type_project_mapping_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_area_id        varchar2,
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
                        area_id,
                        project_no,
                        (
                               select distinct a.name
                                 from ss_projmast a
                                where a.proj_no = project_no
                            ) project_no_name,
                        modified_on,
                        modified_by
                        || ' : '
                        || get_emp_name(modified_by) as modified_by,
                        row_number,
                        total_row
                              from (
                               select a.key_id as key_id,
                                      a.area_id as area_id,
                                      a.modified_on,
                                      a.modified_by,
                                      a.project_no as project_no,
                                      row_number()
                                      over(
                                          order by a.area_id
                                      ) row_number,
                                      count(*)
                                      over() total_row
                                 from dm_area_type_project_mapping a
                                where a.area_id = p_area_id
                            )
                  where row_number between ( nvl(
                    p_row_number,
                    0
                 ) + 1 ) and ( nvl(
                    p_row_number,
                    0
                 ) + p_page_length );
      return c;
   end fn_dm_area_type_project_mapping_list;


   procedure sp_dm_area_type_project_mapping_details (
      p_person_id       varchar2,
      p_meta_id         varchar2,
      p_key_id          varchar2,
      p_area_catg_code  out varchar2,
      p_area_catg_desc  out varchar2,
      p_area_id         out varchar2,
      p_area_desc       out varchar2,
      p_project_no      out varchar2,
      p_project_no_name out varchar2,
      p_modified_by     out varchar2,
      p_modified_on     out date,
      p_message_type    out varchar2,
      p_message_text    out varchar2
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
        from dm_area_type_project_mapping
       where key_id = p_key_id;

      if v_exists = 1 then
         select b.area_catg_code as area_catg_code,
                e.description as area_catg_desc,
                a.area_id as area_id,
                b.area_desc as area_desc,
                (
                   select distinct proj_no
                     from ss_projmast
                    where proj_no = a.project_no
                ) as project_no,
                (
                   select distinct name
                     from ss_projmast
                    where proj_no = a.project_no
                ) as project_no_name,
                a.modified_on as modified_on,
                a.modified_by
                || ' : '
                || get_emp_name(
                   a.modified_by
                ) as modified_by
           into
            p_area_catg_code,
            p_area_catg_desc,
            p_area_id,
            p_area_desc,
            p_project_no,
            p_project_no_name,
            p_modified_on,
            p_modified_by
           from dm_area_type_project_mapping a,
                dm_desk_areas b,
                dm_desk_area_categories e
          where a.key_id = p_key_id
            and a.area_id = b.area_key_id
            and b.area_catg_code = e.area_catg_code;

         p_message_type := ok;
         p_message_text := 'Procedure executed successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'No matching project area type mapping exists !!!';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dm_area_type_project_mapping_details;


   function fn_dm_area_type_project_mapping_xl_list (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_generic_search varchar2 default null,
      p_area_id        varchar2 default null,
      p_project_no     varchar2 default null,
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
      open c for  
                Select
                    a.area_key_id As area_id,
                    a.area_desc   As area_desc,
                    a.area_info   As area_info,
                    Case
                        When a.is_restricted = 1 Then
                            'Yes'
                        Else
                            'No'
                    End           As is_restricted,
                    ct.project_no As project_no,
                    (
                        Select Distinct
                            a.name
                          From
                            ss_projmast a
                         Where
                            a.proj_no = ct.project_no
                    )             project_name,
                    ct.modified_by ||' : '|| get_emp_name(ct.modified_by) as modified_by,
                    ct.modified_on  as modified_on
                  From
                    dm_desk_areas                a,
                    dm_area_type_project_mapping ct
                 Where
                        a.desk_area_type = 'AT02'
                       And ct.area_id       = a.area_key_id
                 Order By
                    a.area_desc;
      return c;
   end fn_dm_area_type_project_mapping_xl_list;

end pkg_dm_area_type_project_mapping_qry;