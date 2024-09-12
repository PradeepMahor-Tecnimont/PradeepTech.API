/*------------------------------------------------------*/
/*  DDL for Package Body IOT_SWP_PRIMARY_WS_ADMIN*/
/*------------------------------------------------------*/
create or replace package body "SELFSERVICE"."IOT_SWP_EMP_TO_OFFICE" as
   /*type typ_tab_string is table of varchar(4000) index by binary_integer;*/
   procedure sp_assign_temp_desk(
      p_person_id           varchar2,
      p_meta_id             varchar2,

      p_emp_workspace_array typ_tab_string,
      p_errors       out    typ_tab_string,
      p_message_type out    varchar2,
      p_message_text out    varchar2
   ) as
      v_plan_start_date    date;
      v_plan_end_date      date;
      v_curr_start_date    date;
      v_curr_end_date      date;
      v_planning_exists    varchar2(200);
      v_pws_open           varchar2(200);
      v_sws_open           varchar2(200);
      v_ows_open           varchar2(200);

      v_mod_by_empno       varchar2(5);
      v_deskid             varchar2(10);
      v_empno              varchar2(5);
      v_start_date         date;

      v_valid_num          number;
      tab_valid_temp_desks typ_tab_temp_desks;
      v_rec_temp_desk      rec_temp_desk;
      v_err_num            number;
      is_error_in_row      boolean;
      v_msg_text           varchar2(4000);
      v_msg_type           varchar2(10);
      v_count              number;
      v_reason             varchar2(30);
      v_PRIMARY_WORKSPACE  number:= 1;
   begin
      v_err_num      := 0;
      v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
      if v_mod_by_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      iot_swp_common.get_planning_week_details(
         p_person_id       => p_person_id,
         p_meta_id         => p_meta_id,
         p_plan_start_date => v_plan_start_date,
         p_plan_end_date   => v_plan_end_date,
         p_curr_start_date => v_curr_start_date,
         p_curr_end_date   => v_curr_end_date,
         p_planning_exists => v_planning_exists,
         p_pws_open        => v_pws_open,
         p_sws_open        => v_sws_open,
         p_ows_open        => v_ows_open,
         p_message_type    => v_msg_type,
         p_message_text    => v_msg_text
      );

      if (v_msg_type = 'KO') then
         p_message_type := v_msg_type;
         p_message_text := v_msg_text;
         return;
      end if;

      for i in 1..p_emp_workspace_array.count
      loop
         is_error_in_row := false;
         with
            csv as (
               select p_emp_workspace_array(i) str
                 from dual
            )
         select trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                trim(regexp_substr(str, '[^~!~]+', 1, 2)) deskid,
                trim(regexp_substr(str, '[^~!~]+', 1, 3)) startdate
           into v_empno, v_deskid, v_start_date
           from csv;

         if (v_empno is null or (length(v_empno) != 5)) then
            v_err_num       := v_err_num + 1;
            p_errors(v_err_num) :=
               /*
               ID '~!~' 
               Section '~!~' 
               XL row number '~!~' 
               FieldName '~!~' 
               ErrorType '~!~' 
               ErrorTypeString '~!~' 
               Message */
               v_err_num || '~!~' ||
               '' || '~!~' ||
               i || '~!~' ||
               'Empno' || '~!~' ||
               '0' || '~!~' ||
               'Critical' || '~!~' ||
               'Invalid employee no. Null or not 5 char';
            is_error_in_row := true;
         end if;
         /*or length(v_deskid) > 10 or length(v_deskid) < 1*/
         if (v_deskid is null or (length(v_deskid) > 10 or length(v_deskid) < 1)) then
            v_err_num       := v_err_num + 1;
            p_errors(v_err_num) :=
               /*
               ID '~!~' 
               Section '~!~' 
               XL row number '~!~' 
               FieldName '~!~' 
               ErrorType '~!~' 
               ErrorTypeString '~!~' 
               Message */
               v_err_num || '~!~' ||
               '' || '~!~' ||
               i || '~!~' ||
               'Deskid' || '~!~' ||
               '0' || '~!~' ||
               'Critical' || '~!~' ||
               'Invalid deskid. Null or (char > 10 or < 1)';
            is_error_in_row := true;
         end if;

         if is_error_in_row = false then

            v_valid_num                              := nvl(v_valid_num, 0) + 1;

            tab_valid_temp_desks(v_valid_num).empno  := v_empno;
            tab_valid_temp_desks(v_valid_num).deskid := v_deskid;
         end if;

      end loop;

      if v_err_num != 0 then
         p_message_type := 'OO';
         p_message_text := 'Not all records were imported.';
         return;
      end if;

      for i in 1..v_valid_num
      loop

         delete
           from swp_temp_desk_allocation
          where empno = tab_valid_temp_desks(i).empno
            and
                start_date = v_plan_start_date;

         insert into swp_temp_desk_allocation
            (empno, deskid, start_date,PRIMARY_WORKSPACE, modified_by, modified_on)
         values (tab_valid_temp_desks(i).empno, tab_valid_temp_desks(i).deskid, v_plan_start_date,
               v_PRIMARY_WORKSPACE, v_mod_by_empno, sysdate);

         if (sql%rowcount = 0) then

            v_err_num := v_err_num + 1;
            p_errors(v_err_num) :=
               v_err_num || '~!~' ||   /*ID*/
               '' || '~!~' ||          /*Section*/
               i || '~!~' ||           /*XL row number*/
               'Empno' || '~!~' ||     /*FieldName*/
               '0' || '~!~' ||         /*ErrorType*/
               'Critical' || '~!~' ||  /*ErrorTypeString*/
               v_msg_text;             /*Message*/
         end if;

         commit;

      end loop;

      if v_err_num != 0 then
         p_message_type := 'OO';
         p_message_text := 'Not all records were imported.';
         rollback;
      else
         commit;
         p_message_type := 'OK';
         p_message_text := 'File imported successfully.';
      end if;

   exception
      when others then
         rollback;
         p_message_type := 'KO';
         p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

   end;

   procedure sp_delete_temp_desk(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_empno            varchar2,
      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_plan_start_date date;
      v_plan_end_date   date;
      v_curr_start_date date;
      v_curr_end_date   date;
      v_planning_exists varchar2(200);
      v_pws_open        varchar2(200);
      v_sws_open        varchar2(200);
      v_ows_open        varchar2(200);

      v_mod_by_empno    varchar2(5);

      v_msg_text        varchar2(4000);
      v_msg_type        varchar2(10);

   begin

      v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
      if v_mod_by_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      iot_swp_common.get_planning_week_details(
         p_person_id       => p_person_id,
         p_meta_id         => p_meta_id,
         p_plan_start_date => v_plan_start_date,
         p_plan_end_date   => v_plan_end_date,
         p_curr_start_date => v_curr_start_date,
         p_curr_end_date   => v_curr_end_date,
         p_planning_exists => v_planning_exists,
         p_pws_open        => v_pws_open,
         p_sws_open        => v_sws_open,
         p_ows_open        => v_ows_open,
         p_message_type    => v_msg_type,
         p_message_text    => v_msg_text
      );

      if (v_msg_type = 'KO') then
         p_message_type := v_msg_type;
         p_message_text := v_msg_text;
         return;
      end if;

      delete
        from swp_temp_desk_allocation
       where empno = p_empno
         and start_date = v_plan_start_date;

      commit;
      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         rollback;
         p_message_type := 'KO';
         p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

   end;

end iot_swp_emp_to_office;
/
grant execute on "SELFSERVICE"."IOT_SWP_EMP_TO_OFFICE" to "TCMPL_APP_CONFIG";