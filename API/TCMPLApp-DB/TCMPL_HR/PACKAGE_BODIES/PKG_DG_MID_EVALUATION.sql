create or replace package body "TCMPL_HR"."PKG_DG_MID_EVALUATION" as
 
    procedure sp_dg_mid_evaluation_add (
        p_person_id      varchar2,
        p_meta_id        varchar2,
        p_key_id         varchar2,
        p_empno          varchar2,
        p_attendance     varchar2,
        p_location       varchar2,
        skill_1          varchar2,
        p_skill_1_rating number,
        p_skill_1_remark varchar2,
        p_skill_2        varchar2,
        p_skill_2_rating number,
        p_skill_2_remark varchar2,
        p_skill_3        varchar2,
        p_skill_3_rating number,
        p_skill_3_remark varchar2,
        p_skill_4        varchar2,
        p_skill_4_rating number,
        p_skill_4_remark varchar2,
        p_skill_5        varchar2,
        p_skill_5_rating number,
        p_skill_5_remark varchar2,
        p_que_2_rating   number,
        p_que_2_remark   varchar2,
        p_que_3_rating   number,
        p_que_3_remark   varchar2,
        p_que_4_rating   number,
        p_que_4_remark   varchar2,
        p_que_5_rating   number,
        p_que_5_remark   varchar2,
        p_que_6_rating   number,
        p_que_6_remark   varchar2,
        p_observations   varchar2,
        p_message_type   out varchar2,
        p_message_text   out varchar2
    ) as
    begin
        -- TODO: Implementation required for Procedure PKG_DG_MID_EVALUATION.sp_dg_mid_evaluation_add
        null;
    end sp_dg_mid_evaluation_add;
 
    procedure sp_dg_mid_evaluation_update (
        p_person_id      varchar2,
        p_meta_id        varchar2,
        p_key_id         varchar2,
        p_attendance     varchar2,
        p_location       varchar2,
        skill_1          varchar2,
        p_skill_1_rating number,
        p_skill_1_remark varchar2,
        p_skill_2        varchar2,
        p_skill_2_rating number,
        p_skill_2_remark varchar2,
        p_skill_3        varchar2,
        p_skill_3_rating number,
        p_skill_3_remark varchar2,
        p_skill_4        varchar2,
        p_skill_4_rating number,
        p_skill_4_remark varchar2,
        p_skill_5        varchar2,
        p_skill_5_rating number,
        p_skill_5_remark varchar2,
        p_que_2_rating   number,
        p_que_2_remark   varchar2,
        p_que_3_rating   number,
        p_que_3_remark   varchar2,
        p_que_4_rating   number,
        p_que_4_remark   varchar2,
        p_que_5_rating   number,
        p_que_5_remark   varchar2,
        p_que_6_rating   number,
        p_que_6_remark   varchar2,
        p_observations   varchar2,
        p_message_type   out varchar2,
        p_message_text   out varchar2
    ) as
    begin
        -- TODO: Implementation required for Procedure PKG_DG_MID_EVALUATION.sp_dg_mid_evaluation_update
        null;
    end sp_dg_mid_evaluation_update;
 
    procedure sp_dg_mid_evaluation_json_add (
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
        select
            jt.*
          from
                json_table ( p_json_obj format json, '$[*]'
                    columns (
                        empno varchar2 ( 5 ) path '$.Empno',
                        desgcode varchar2 ( 6 ) path '$.Desgcode',
                        parent varchar2 ( 4 ) path '$.Parent',
                        attendance number path '$.Attendance',
                        location varchar2 ( 3 ) path '$.Location',
                        skill_1 varchar2 ( 200 ) path '$.Skill1',
                        skill_1_rating number path '$.Skill1Rating',
                        skill_1_remark varchar2 ( 200 ) path '$.Skill1Remark',
                        skill_2 varchar2 ( 200 ) path '$.Skill2',
                        skill_2_rating number path '$.Skill2Rating',
                        skill_2_remark varchar2 ( 200 ) path '$.Skill2Remark',
                        skill_3 varchar2 ( 200 ) path '$.Skill3',
                        skill_3_rating number path '$.Skill3Rating',
                        skill_3_remark varchar2 ( 200 ) path '$.Skill3Remark',
                        skill_4 varchar2 ( 200 ) path '$.Skill4',
                        skill_4_rating number path '$.Skill4Rating',
                        skill_4_remark varchar2 ( 200 ) path '$.Skill4Remark',
                        skill_5 varchar2 ( 200 ) path '$.Skill5',
                        skill_5_rating number path '$.Skill5Rating',
                        skill_5_remark varchar2 ( 200 ) path '$.Skill5Remark',
                        que_2_rating number path '$.Que2Rating',
                        que_2_remark varchar2 ( 200 ) path '$.Que2Remark',
                        que_3_rating number path '$.Que3Rating',
                        que_3_remark varchar2 ( 200 ) path '$.Que3Remark',
                        que_4_rating number path '$.Que4Rating',
                        que_4_remark varchar2 ( 200 ) path '$.Que4Remark',
                        que_5_rating number path '$.Que5Rating',
                        que_5_remark varchar2 ( 200 ) path '$.Que5Remark',
                        que_6_rating number path '$.Que6Rating',
                        que_6_remark varchar2 ( 200 ) path '$.Que6Remark',
                        observations varchar2 ( 400 ) path '$.Observations',
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
            if ( c1.skill_1 is null or c1.skill_1_rating is null     ) then
                is_error_in_row := true;
            end if;
 
            if coalesce(
                c1.skill_2,
                to_char(c1.skill_2_rating),
                c1.skill_2_remark
            ) is not null then
                if ( c1.skill_2 is null or c1.skill_2_rating is null     ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if coalesce(
                c1.skill_3,
                to_char(c1.skill_3_rating),
                c1.skill_3_remark
            ) is not null then
                if ( c1.skill_3 is null or c1.skill_3_rating is null     ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if coalesce(
                c1.skill_4,
                to_char(c1.skill_4_rating),
                c1.skill_4_remark
            ) is not null then
                if ( c1.skill_4 is null or c1.skill_4_rating is null   ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if coalesce(
                c1.skill_5,
                to_char(c1.skill_5_rating),
                c1.skill_5_remark
            ) is not null then
                if ( c1.skill_5 is null or c1.skill_5_rating is null  ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if c1.que_2_rating is null  then
                is_error_in_row := true;
            end if;
 
            if c1.que_3_rating is null  then
                is_error_in_row := true;
            end if;
 
            if c1.que_4_rating is null  then
                is_error_in_row := true;
            end if;
 
            if c1.que_5_rating is null   then
                is_error_in_row := true;
            end if;
 
            if c1.que_6_rating is null  then
                is_error_in_row := true;
            end if;
 
            if is_error_in_row = false then
                select
                    count(*)
                  into v_exists
                  from
                    dg_mid_evaluation
                 where
                    empno = c1.empno;
 
                if v_exists = 0 then
                    insert into dg_mid_evaluation (
                        key_id,
                        empno,
                        desgcode,
                        parent,
                        attendance,
                        location,
                        skill_1,
                        skill_1_rating,
                        skill_1_remark,
                        skill_2,
                        skill_2_rating,
                        skill_2_remark,
                        skill_3,
                        skill_3_rating,
                        skill_3_remark,
                        skill_4,
                        skill_4_rating,
                        skill_4_remark,
                        skill_5,
                        skill_5_rating,
                        skill_5_remark,
                        que_2_rating,
                        que_2_remark,
                        que_3_rating,
                        que_3_remark,
                        que_4_rating,
                        que_4_remark,
                        que_5_rating,
                        que_5_remark,
                        que_6_rating,
                        que_6_remark,
                        observations,
                        created_by,
                        created_on,
                        modified_by,
                        modified_on,
                        isdeleted
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
                        c1.skill_1,
                        c1.skill_1_rating,
                        c1.skill_1_remark,
                        c1.skill_2,
                        c1.skill_2_rating,
                        c1.skill_2_remark,
                        c1.skill_3,
                        c1.skill_3_rating,
                        c1.skill_3_remark,
                        c1.skill_4,
                        c1.skill_4_rating,
                        c1.skill_4_remark,
                        c1.skill_5,
                        c1.skill_5_rating,
                        c1.skill_5_remark,
                        c1.que_2_rating,
                        c1.que_2_remark,
                        c1.que_3_rating,
                        c1.que_3_remark,
                        c1.que_4_rating,
                        c1.que_4_remark,
                        c1.que_5_rating,
                        c1.que_5_remark,
                        c1.que_6_rating,
                        c1.que_6_remark,
                        c1.observations,
                        v_empno,
                        sysdate,
                        v_empno,
                        sysdate,
                        0
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
            p_message_text := 'ERR :- ' ||
            sqlcode ||
            ' - ' || sqlerrm;
    end sp_dg_mid_evaluation_json_add;
 
    procedure sp_dg_mid_send_to_hr (
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
 
        select
            count(*)
          into v_exists
          from
            dg_mid_evaluation
         where
            empno = p_empno;
 
        if v_exists = 0 then
            sp_dg_mid_evaluation_json_add(
                                         p_person_id => p_person_id,
                                         p_meta_id => p_meta_id,
                                         p_json_obj => p_json_obj,
                                         p_message_type => p_message_type,
                                         p_message_text => p_message_text
            );
 
            update dg_mid_evaluation
               set
                hod_approval = ok,
                hod_approval_date = sysdate
             where
                empno = p_empno;
            commit;
            return;
        end if;
 
        if v_exists = 1 then
            select
                key_id
              into v_key_id
              from
                dg_mid_evaluation
             where
                empno = p_empno;
            if v_key_id is not null then
                sp_dg_mid_evaluation_json_update(
                                                p_person_id => p_person_id,
                                                p_meta_id => p_meta_id,
                                                p_key_id => v_key_id,
                                                p_json_obj => p_json_obj,
                                                p_message_type => p_message_type,
                                                p_message_text => p_message_text
                );
 
                update dg_mid_evaluation
                   set
                    hod_approval = ok,
                    hod_approval_date = sysdate
                 where
                    key_id = v_key_id;
 
            end if;
            commit;
            return;
        end if;
 
 
    exception
        when others then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' ||
            sqlcode ||
            ' - ' || sqlerrm;
    end sp_dg_mid_send_to_hr;
 
    procedure sp_dg_mid_send_to_hod (
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
 
        select
            count(*)
          into v_exists
          from
            dg_mid_evaluation
         where
            key_id = p_key_id;
        --SEND_TO_HR
 
        if ( v_exists = 1 ) then
            update dg_mid_evaluation
               set
                hod_approval = not_ok,
                hod_approval_date = sysdate
             where
                key_id = p_key_id;
 
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
            p_message_text := 'ERR :- ' ||
            sqlcode ||
            ' - ' || sqlerrm;
    end sp_dg_mid_send_to_hod;
 
    procedure sp_dg_mid_evaluation_json_update (
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
        select
            jt.*
          from
                json_table ( p_json_obj format json, '$[*]'
                    columns (
                        empno varchar2 ( 5 ) path '$.Empno',
                        desgcode varchar2 ( 6 ) path '$.Desgcode',
                        parent varchar2 ( 4 ) path '$.Parent',
                        attendance varchar2 ( 50 ) path '$.Attendance',
                        location varchar2 ( 3 ) path '$.Location',
                        skill_1 varchar2 ( 200 ) path '$.Skill1',
                        skill_1_rating number path '$.Skill1Rating',
                        skill_1_remark varchar2 ( 200 ) path '$.Skill1Remark',
                        skill_2 varchar2 ( 200 ) path '$.Skill2',
                        skill_2_rating number path '$.Skill2Rating',
                        skill_2_remark varchar2 ( 200 ) path '$.Skill2Remark',
                        skill_3 varchar2 ( 200 ) path '$.Skill3',
                        skill_3_rating number path '$.Skill3Rating',
                        skill_3_remark varchar2 ( 200 ) path '$.Skill3Remark',
                        skill_4 varchar2 ( 200 ) path '$.Skill4',
                        skill_4_rating number path '$.Skill4Rating',
                        skill_4_remark varchar2 ( 200 ) path '$.Skill4Remark',
                        skill_5 varchar2 ( 200 ) path '$.Skill5',
                        skill_5_rating number path '$.Skill5Rating',
                        skill_5_remark varchar2 ( 200 ) path '$.Skill5Remark',
                        que_2_rating number path '$.Que2Rating',
                        que_2_remark varchar2 ( 200 ) path '$.Que2Remark',
                        que_3_rating number path '$.Que3Rating',
                        que_3_remark varchar2 ( 200 ) path '$.Que3Remark',
                        que_4_rating number path '$.Que4Rating',
                        que_4_remark varchar2 ( 200 ) path '$.Que4Remark',
                        que_5_rating number path '$.Que5Rating',
                        que_5_remark varchar2 ( 200 ) path '$.Que5Remark',
                        que_6_rating number path '$.Que6Rating',
                        que_6_remark varchar2 ( 200 ) path '$.Que6Remark',
                        observations varchar2 ( 400 ) path '$.Observations',
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
 
        select
            count(*)
          into v_exists
          from
            dg_mid_evaluation
         where
            key_id = p_key_id;
 
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
            if ( c1.skill_1 is null or c1.skill_1_rating is null     ) then
                is_error_in_row := true;
            end if;
 
            if coalesce(
                c1.skill_2,
                to_char(c1.skill_2_rating),
                c1.skill_2_remark
            ) is not null then
                if ( c1.skill_2 is null or c1.skill_2_rating is null     ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if coalesce(
                c1.skill_3,
                to_char(c1.skill_3_rating),
                c1.skill_3_remark
            ) is not null then
                if ( c1.skill_3 is null or c1.skill_3_rating is null     ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if coalesce(
                c1.skill_4,
                to_char(c1.skill_4_rating),
                c1.skill_4_remark
            ) is not null then
                if ( c1.skill_4 is null or c1.skill_4_rating is null   ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if coalesce(
                c1.skill_5,
                to_char(c1.skill_5_rating),
                c1.skill_5_remark
            ) is not null then
                if ( c1.skill_5 is null or c1.skill_5_rating is null  ) then
                    is_error_in_row := true;
                end if;
            end if;
 
            if c1.que_2_rating is null  then
                is_error_in_row := true;
            end if;
 
            if c1.que_3_rating is null  then
                is_error_in_row := true;
            end if;
 
            if c1.que_4_rating is null  then
                is_error_in_row := true;
            end if;
 
            if c1.que_5_rating is null   then
                is_error_in_row := true;
            end if;
 
            if c1.que_6_rating is null  then
                is_error_in_row := true;
            end if;
 
            if is_error_in_row = false then
                select
                    count(*)
                  into v_exists
                  from
                    dg_mid_evaluation
                 where
                    empno = c1.empno;
 
                if v_exists = 1 then
                    update dg_mid_evaluation
                       set
                        location = c1.location,
                        que_2_rating = c1.que_2_rating,
                        modified_by = v_empno,
                        skill_1_rating = c1.skill_1_rating,
                        skill_2_rating = c1.skill_2_rating,
                        skill_3_rating = c1.skill_3_rating,
                        que_5_rating = c1.que_5_rating,
                        que_6_rating = c1.que_6_rating,
                        desgcode = c1.desgcode,
                        que_4_rating = c1.que_4_rating,
                        que_3_rating = c1.que_3_rating,
                        que_3_remark = c1.que_3_remark,
                        que_2_remark = c1.que_2_remark,
                        parent = c1.parent,
                        modified_on = sysdate,
                        que_6_remark = c1.que_6_remark,
                        attendance = c1.attendance,
                        skill_2_remark = c1.skill_2_remark,
                        observations = c1.observations,
                        que_4_remark = c1.que_4_remark,
                        que_5_remark = c1.que_5_remark,
                        skill_1 = c1.skill_1,
                        skill_3 = c1.skill_3,
                        skill_2 = c1.skill_2,
                        skill_1_remark = c1.skill_1_remark,
                        skill_3_remark = c1.skill_3_remark,
                        skill_5 = c1.skill_5,
                        skill_4 = c1.skill_4,
                        skill_4_remark = c1.skill_4_remark,
                        skill_5_remark = c1.skill_5_remark,
                        isdeleted = c1.isdeleted,
                        skill_4_rating = c1.skill_4_rating,
                        skill_5_rating = c1.skill_5_rating
                     where
                        key_id = p_key_id;
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
            p_message_text := 'ERR :- ' ||
            sqlcode ||
            ' - ' || sqlerrm;
    end sp_dg_mid_evaluation_json_update;
 
  procedure sp_dg_mid_validate_employee (
        p_person_id    varchar2,
        p_meta_id      varchar2,
        p_empno        varchar2,
        p_message_type out varchar2,
        p_message_text out varchar2
    ) as
        v_exists          number;
        v_start_from_date date := to_date ( '2023-07-3', 'yyyy-MM-dd' );
        v_get_from_date   date := add_months(
                                          trunc(sysdate),
                                          -3
                                );
         -- Past 3 months
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
 
        select
            count(a.empno)
          into v_exists
          from
            vu_emplmast       a
              left outer join dg_mid_evaluation b
            on a.empno = b.empno
         where
                a.empno = p_empno
               and a.status                  = 1
               and a.emptype                 = 'R'
               and nvl(
                hod_approval,
                not_ok
            ) = not_ok
               and ( a.doj >= v_start_from_date
               and add_months(a.doj,3) <= trunc(sysdate) )
               and a.grade in (
                select
                    grade
                  from
                    dg_mid_evaluation_grade c
            )               
               and a.parent in (
                select
                    costcode
                  from
                    vu_costmast
                 where
                    hod = v_empno
                union
                select
                    costcode
                  from
                    tcmpl_app_config.sec_module_user_roles_costcode
                 where
                        empno = v_empno
                       and module_id = 'M19'
                       and role_id   = 'R003'
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
            p_message_text := 'ERR :- ' ||
            sqlcode ||
            ' - ' || sqlerrm;
    end sp_dg_mid_validate_employee;
 
 
end pkg_dg_mid_evaluation;