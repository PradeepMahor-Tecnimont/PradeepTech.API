create or replace package body "DMS"."PKG_DM_AREA_TYPE_PROJECT_MAPPING" as

   procedure sp_add_dm_area_type_project_mapping (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_area_id      varchar2,
      p_project_no   varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_exists       number;
      v_empno        varchar2(5);
      v_keyid        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number := 0;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := not_ok;
         p_message_text := 'Invalid employee number';
         return;
      end if;

      v_keyid := dbms_random.string('X',5);
      select count(*)
        into v_exists
        from dm_area_type_project_mapping
       where area_id = p_area_id
         and project_no = p_project_no;

      if v_exists = 0 then
         insert into dm_area_type_project_mapping (
            key_id,
            area_id,
            project_no,
            modified_on,
            modified_by
         ) values (
            v_keyid,
            p_area_id,
            p_project_no,
            sysdate,
            v_empno
         );
         commit;
         p_message_type := ok;
         p_message_text := 'Project area type mapping added successfully..';
      else
         p_message_type := not_ok;
         p_message_text := 'Project area type mapping already exists !!!';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '|| sqlcode|| ' - ' || sqlerrm;
   end sp_add_dm_area_type_project_mapping;


   procedure sp_update_dm_area_type_project_mapping (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_key_id       varchar2,
      p_area_id      varchar2,
      p_project_no   varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
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
         update dm_area_type_project_mapping
            set area_id = p_area_id,
                project_no = p_project_no,
                modified_on = sysdate,
                modified_by = v_empno
          where key_id = p_key_id;

         commit;
         p_message_type := ok;
         p_message_text := 'Project area type mapping updated successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'No matching Project area type mapping exists !!!';
      end if;
   exception
      when dup_val_on_index then
         p_message_type := not_ok;
         p_message_text := 'Project area type mapping already exists !!!';
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
   end sp_update_dm_area_type_project_mapping;


   procedure sp_delete_dm_area_type_project_mapping (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_key_id       varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno        varchar2(5);
      v_is_used      number;
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number := 0;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := not_ok;
         p_message_text := 'Invalid employee number';
         return;
      end if;

                       /* Select
                            Count(*)
                        Into
                            v_is_used
                        From
                            tblName
                        Where
                            keyId = p_keyId;

                        If v_is_used > 0 Then
                            p_message_type := not_ok;
                            p_message_text := 'Record cannot be delete, this record already used !!!';
                            Return;
                        End If;
                        */

      delete from dm_area_type_project_mapping
       where key_id = p_key_id;


      if ( sql%rowcount > 0 ) then
         commit;
         p_message_type := ok;
         p_message_text := 'Procedure executed successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'Procedure not executed.';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
   end sp_delete_dm_area_type_project_mapping;

end pkg_dm_area_type_project_mapping;