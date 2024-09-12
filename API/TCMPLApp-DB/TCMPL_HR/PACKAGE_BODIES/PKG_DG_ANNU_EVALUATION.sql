create or replace package body "TCMPL_HR"."PKG_DG_ANNU_EVALUATION" as

   procedure sp_dg_annu_evaluation_add (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_key_id         varchar2,
      p_empno          varchar2,
      p_attendance     varchar2,
      p_location       varchar2,
      p_training_1     varchar2,
      p_training_2     varchar2,
      p_training_3     varchar2,
      p_training_4     varchar2,
      p_training_5     varchar2,
      p_feedback_1     varchar2,
      p_feedback_2     varchar2,
      p_feedback_3     varchar2,
      p_feedback_4     varchar2,
      p_feedback_5     varchar2,
      p_feedback_6     varchar2,
      p_comments_of_hr varchar2,
      p_message_type   out varchar2,
      p_message_text   out varchar2
   ) as
   begin
        -- TODO: Implementation required for Procedure PKG_DG_ANNU_EVALUATION.sp_dg_ANNU_evaluation_add
      null;
   end sp_dg_annu_evaluation_add;

   procedure sp_dg_annu_evaluation_update (
      p_person_id      varchar2,
      p_meta_id        varchar2,
      p_key_id         varchar2,
      p_attendance     varchar2,
      p_location       varchar2,
      p_training_1     varchar2,
      p_training_2     varchar2,
      p_training_3     varchar2,
      p_training_4     varchar2,
      p_training_5     varchar2,
      p_feedback_1     varchar2,
      p_feedback_2     varchar2,
      p_feedback_3     varchar2,
      p_feedback_4     varchar2,
      p_feedback_5     varchar2,
      p_feedback_6     varchar2,
      p_comments_of_hr varchar2,
      p_message_type   out varchar2,
      p_message_text   out varchar2
   ) as
   begin
        -- TODO: Implementation required for Procedure PKG_DG_ANNU_EVALUATION.sp_dg_ANNU_evaluation_update
      null;
   end sp_dg_annu_evaluation_update;

   procedure sp_dg_annu_evaluation_json_add (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_json_obj     varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno         varchar2(5);
      v_exists        number;
      v_share_pcnt    number;
      v_user_tcp_ip   varchar2(5) := 'NA';
      v_message_type  number := 0;
      is_error_in_row boolean := false;
      v_err_num       number := 0;
      cursor cur_json is
      select jt.*
        from
         json_table ( p_json_obj format json, '$[*]'
            columns (
               empno varchar2 ( 5 ) path '$.Empno',
               desgcode varchar2 ( 6 ) path '$.Desgcode',
               parent varchar2 ( 4 ) path '$.Parent',
               attendance Varchar2(200) Path '$.Attendance',
               location varchar2 ( 3 ) path '$.Location',
               training_1 varchar2 ( 800 ) path '$.Training1',
               training_2 varchar2 ( 800 ) path '$.Training2',
               training_3 varchar2 ( 800 ) path '$.Training3',
               training_4 varchar2 ( 800 ) path '$.Training4',
               training_5 varchar2 ( 800 ) path '$.Training5',
               feedback_1 varchar2 ( 800 ) path '$.Feedback1',
               feedback_2 varchar2 ( 800 ) path '$.Feedback2',
               feedback_3 varchar2 ( 800 ) path '$.Feedback3',
               feedback_4 varchar2 ( 800 ) path '$.Feedback4',
               feedback_5 varchar2 ( 800 ) path '$.Feedback5',
               feedback_6 varchar2 ( 800 ) path '$.Feedback6',
               comments_of_hr varchar2 ( 400 ) path '$.CommentsOfHr',
               isdeleted number path '$.Isdeleted'
            )
         )
      as "JT";

   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := not_ok;
         p_message_text := 'Invalid employee number';
         return;
      end if;

      for c1 in cur_json loop
         is_error_in_row := false;
         if c1.empno is null then
            is_error_in_row := true;
         end if;
         if c1.attendance is null then
            is_error_in_row := true;
         end if;
         if ( c1.training_1 is null ) then
            is_error_in_row := true;
         end if;
         if c1.training_2 is null then
            is_error_in_row := true;
         end if;
         if c1.training_3 is null then
            is_error_in_row := true;
         end if;
         if c1.training_4 is null then
            is_error_in_row := true;
         end if;
         if c1.training_5 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_1 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_2 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_3 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_4 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_5 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_6 is null then
            is_error_in_row := true;
         end if;
         if c1.comments_of_hr is null then
                --is_error_in_row := true;
            null;
         end if;
         if is_error_in_row = false then
            select count(*)
              into v_exists
              from dg_annu_evaluation
             where empno = c1.empno;

            if v_exists = 0 then
               insert into dg_annu_evaluation (
                  key_id,
                  empno,
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
                  created_on,
                  modified_by,
                  modified_on,
                  isdeleted,
                  hod_approval,
                  hod_approval_date
               ) values (
                  dbms_random.string(
                     'X',
                     8
                  ),
                  c1.empno,
                  c1.desgcode,
                  c1.parent,
                  c1.attendance,
                  c1.location,
                  c1.training_1,
                  c1.training_2,
                  c1.training_3,
                  c1.training_4,
                  c1.training_5,
                  c1.feedback_1,
                  c1.feedback_2,
                  c1.feedback_3,
                  c1.feedback_4,
                  c1.feedback_5,
                  c1.feedback_6,
                  c1.comments_of_hr,
                  v_empno,
                  sysdate,
                  v_empno,
                  sysdate,
                  0,
                  null,
                  null
               );

            end if;
         end if;
         if is_error_in_row or v_exists > 0 then
            v_err_num := v_err_num + 1;
         end if;
      end loop;

      if v_err_num != 0 then
         p_message_type := not_ok;
         p_message_text := 'Error :- Something wrong with data';
      else
         p_message_type := ok;
         p_message_text := 'Record inserted successfully.';
      end if;

      commit;
   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_evaluation_json_add;

   procedure sp_dg_annu_send_to_hr (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_empno        varchar2,
      p_json_obj     varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno         varchar2(5);
      v_key_id        varchar2(8);
      v_exists        number;
      v_share_pcnt    number;
      v_user_tcp_ip   varchar2(5) := 'NA';
      v_message_type  number := 0;
      is_error_in_row boolean := false;
      v_err_num       number := 0;
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
       where empno = p_empno;

      if v_exists = 0 then
         sp_dg_annu_evaluation_json_add(
                                       p_person_id => p_person_id,
                                       p_meta_id => p_meta_id,
                                       p_json_obj => p_json_obj,
                                       p_message_type => p_message_type,
                                       p_message_text => p_message_text
         );

         update dg_annu_evaluation
            set hod_approval = ok,
                hod_approval_date = sysdate
          where empno = p_empno;
         commit;
         return;
      end if;

      if v_exists = 1 then
         select key_id
           into v_key_id
           from dg_annu_evaluation
          where empno = p_empno;
         if v_key_id is not null then
            sp_dg_annu_evaluation_json_update(
                                             p_person_id => p_person_id,
                                             p_meta_id => p_meta_id,
                                             p_key_id => v_key_id,
                                             p_json_obj => p_json_obj,
                                             p_message_type => p_message_type,
                                             p_message_text => p_message_text
            );

            update dg_annu_evaluation
               set hod_approval = ok,
                   hod_approval_date = sysdate
             where key_id = v_key_id;

         end if;
         commit;
         return;
      end if;


   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_send_to_hr;

   procedure sp_dg_annu_send_to_hod (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_key_id       varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno         varchar2(5);
      v_exists        number;
      v_share_pcnt    number;
      v_user_tcp_ip   varchar2(5) := 'NA';
      v_message_type  number := 0;
      is_error_in_row boolean := false;
      v_err_num       number := 0;
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
        --SEND_TO_HR

      if ( v_exists = 1 ) then
         update dg_annu_evaluation
            set hod_approval = not_ok,
                hr_approval = not_ok,
                COMMENTS_OF_HR = null,
                hod_approval_date = sysdate
          where key_id = p_key_id;

         if ( sql%rowcount > 0 ) then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
         else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
         end if;
      end if;

      commit;
   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_send_to_hod;

   procedure sp_dg_annu_evaluation_json_update (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_key_id       varchar2,
      p_json_obj     varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno         varchar2(5);
      v_exists        number;
      v_share_pcnt    number;
      v_user_tcp_ip   varchar2(5) := 'NA';
      v_message_type  number := 0;
      is_error_in_row boolean := false;
      v_err_num       number := 0;
      cursor cur_json is
      select jt.*
        from
         json_table ( p_json_obj format json, '$[*]'
            columns (
               empno varchar2 ( 5 ) path '$.Empno',
               desgcode varchar2 ( 6 ) path '$.Desgcode',
               parent varchar2 ( 4 ) path '$.Parent',
               attendance Varchar2(200) Path '$.Attendance',
               location varchar2 ( 3 ) path '$.Location',
               training_1 varchar2 ( 800 ) path '$.Training1',
               training_2 varchar2 ( 800 ) path '$.Training2',
               training_3 varchar2 ( 800 ) path '$.Training3',
               training_4 varchar2 ( 800 ) path '$.Training4',
               training_5 varchar2 ( 800 ) path '$.Training5',
               feedback_1 varchar2 ( 800 ) path '$.Feedback1',
               feedback_2 varchar2 ( 800 ) path '$.Feedback2',
               feedback_3 varchar2 ( 800 ) path '$.Feedback3',
               feedback_4 varchar2 ( 800 ) path '$.Feedback4',
               feedback_5 varchar2 ( 800 ) path '$.Feedback5',
               feedback_6 varchar2 ( 800 ) path '$.Feedback6',
               comments_of_hr varchar2 ( 400 ) path '$.CommentsOfHr',
               isdeleted number path '$.Isdeleted'
            )
         )
      as "JT";

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

      if v_exists = 0 then
         p_message_type := not_ok;
         p_message_text := 'Error :- Record not found';
         return;
      end if;

      for c1 in cur_json loop
         is_error_in_row := false;
         if c1.empno is null then
            is_error_in_row := true;
         end if;
         if c1.attendance is null then
            is_error_in_row := true;
         end if;
         if ( c1.training_1 is null ) then
            is_error_in_row := true;
         end if;
         if c1.training_2 is null then
            is_error_in_row := true;
         end if;
         if c1.training_3 is null then
            is_error_in_row := true;
         end if;
         if c1.training_4 is null then
            is_error_in_row := true;
         end if;
         if c1.training_5 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_1 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_2 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_3 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_4 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_5 is null then
            is_error_in_row := true;
         end if;
         if c1.feedback_6 is null then
            is_error_in_row := true;
         end if;
         if c1.comments_of_hr is null then
                --is_error_in_row := true;
            null;
         end if;
         if is_error_in_row = false then
            select count(*)
              into v_exists
              from dg_annu_evaluation
             where empno = c1.empno;

            if v_exists = 1 then
               update dg_annu_evaluation
                  set location = c1.location,
                      modified_by = v_empno,
                      desgcode = c1.desgcode,
                      parent = c1.parent,
                      modified_on = sysdate,
                      attendance = c1.attendance,
                      training_1 = c1.training_1,
                      training_2 = c1.training_2,
                      training_3 = c1.training_3,
                      training_4 = c1.training_4,
                      training_5 = c1.training_5,
                      feedback_1 = c1.feedback_1,
                      feedback_2 = c1.feedback_2,
                      feedback_3 = c1.feedback_3,
                      feedback_4 = c1.feedback_4,
                      feedback_5 = c1.feedback_5,
                      feedback_6 = c1.feedback_6,
                      comments_of_hr = c1.comments_of_hr,
                      isdeleted = c1.isdeleted
                where key_id = p_key_id;
            end if;
         else
            p_message_type := not_ok;
            p_message_text := 'Error :- Something wrong with data';
            return;
         end if;

         if is_error_in_row or v_exists = 0 then
            v_err_num := v_err_num + 1;
         end if;
      end loop;

      if v_err_num != 0 then
         p_message_type := not_ok;
         p_message_text := 'Error :- Something wrong with data';
      else
         p_message_type := ok;
         p_message_text := 'Record updated successfully.';
      end if;

      commit;
   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_evaluation_json_update;

   procedure sp_dg_annu_validate_employee (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_empno        varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_exists          number;
      v_start_from_date date := to_date ( '2023-01-01', 'yyyy-MM-dd' );
      v_get_from_date   date := add_months(
                                        trunc(sysdate),
                                        -12
                              ); -- Past 12 months
      v_empno           varchar2(5) := 'NA';
      v_user_tcp_ip     varchar2(5) := 'NA';
      v_message_type    number := 0;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         p_message_type := not_ok;
         p_message_text := 'Invalid employee number';
         return;
      end if;

      select count(a.empno)
        into v_exists
        from vu_emplmast a
        left outer join dg_annu_evaluation b
      on a.empno = b.empno
       where a.empno = p_empno
         and a.status = 1
         and a.emptype = 'R'
         and nvl(
         hod_approval,
         not_ok
      ) = not_ok
         and ( a.doj >= v_start_from_date
         and add_months(
         a.doj,
         3
      ) <= trunc(sysdate) )
         and a.grade in (
         select grade
           from dg_mid_evaluation_grade c
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
      );

      if v_exists = 1 then
         p_message_type := ok;
         p_message_text := 'Valid record';
      else
         p_message_type := not_ok;
         p_message_text := 'InValid record';
      end if;

   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_validate_employee;

   procedure sp_dg_annu_save_hr_comment (
      p_person_id    varchar2,
      p_meta_id      varchar2,
      p_key_id       varchar2,
      p_hr_comments  varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_exists       number;
      v_empno        varchar2(5);
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
         update dg_annu_evaluation
            set comments_of_hr = p_hr_comments,
                HR_APPROVAL = ok,
                HR_APPROVAL_DATE = sysdate,
                HR_APPROVE_BY = v_empno
          where key_id = p_key_id;
         commit;
         p_message_type := ok;
         p_message_text := 'Hr comments updated successfully.';
      else
         p_message_type := not_ok;
         p_message_text := 'Hr comments not updated !!!';
      end if;
   exception
      when others then
         p_message_type := not_ok;
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end sp_dg_annu_save_hr_comment;
end pkg_dg_annu_evaluation;