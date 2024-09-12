create or replace package body "DMS"."PKG_DM_AREA_TYPE" as

   procedure sp_add_dm_area_type (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_key_id       varchar2,
      p_short_desc   varchar2,
      p_description  varchar2,
      p_is_active    number,
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


      select count(*)
        into v_exists
        from dm_area_type
       where trim(upper(short_desc)) = trim(upper(p_short_desc))
         and is_active = 1;

      if v_exists = 0 then
         insert into dm_area_type (
            key_id,
            short_desc,
            description,
            is_active,
            modified_on,
            modified_by
         ) values (
            p_key_id,
            trim(p_short_desc),
            trim(p_description),
            p_is_active,
            sysdate,
            v_empno
         );

         commit;
         p_message_type := ok;
         p_message_text := 'Desk area type added successfully..';
      else
         p_message_type := not_ok;
         p_message_text := 'Desk area type already exists !!!';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_add_dm_area_type;

   procedure sp_update_dm_area_type (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_key_id       varchar2,
      p_short_desc   varchar2,
      p_description  varchar2,
      p_is_active    number,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_exists       number;
      v_is_used      number;
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
         if p_is_active = 0 then
            select count(*)
              into v_is_used
              from dm_desk_areas
             where desk_area_type = p_key_id;

            if v_is_used != 0 then
               p_message_type := not_ok;
               p_message_text := 'Record cannot be deactivate, this record already used in (Desk area master)!!!';
               return;
            end if;

         end if;

         update dm_area_type
            set short_desc = trim(p_short_desc),
                description = trim(p_description),
                is_active = p_is_active,
                modified_on = sysdate,
                modified_by = v_empno
          where key_id = p_key_id;

         commit;
         p_message_type := ok;
         p_message_text := 'Desk area type updated successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'No matching Desk area type exists !!!';
      end if;
   exception
      when dup_val_on_index then
         p_message_type := not_ok;
         p_message_text := 'Desk area type already exists !!!';
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_update_dm_area_type;


   procedure sp_delete_dm_area_type (
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

      select count(*)
        into v_is_used
        from dm_area_type
       where key_id = p_key_id
         and is_active = 1;

      if v_is_used > 0 then
         p_message_type := not_ok;
         p_message_text := 'Record cannot be delete, this record is active. !!!';
         return;
      end if;

      select count(*)
        into v_is_used
        from dm_desk_areas a,
             dm_area_type b
       where a.desk_area_type = b.key_id
         and b.key_id = p_key_id;

      if v_is_used > 0 then
         p_message_type := not_ok;
         p_message_text := 'Record cannot be deactivate, this record already used in (Desk area master)!!!';
         return;
      end if;

      delete from dm_area_type
       where key_id = p_key_id
         and is_active = 0;


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
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_delete_dm_area_type;

end pkg_dm_area_type;