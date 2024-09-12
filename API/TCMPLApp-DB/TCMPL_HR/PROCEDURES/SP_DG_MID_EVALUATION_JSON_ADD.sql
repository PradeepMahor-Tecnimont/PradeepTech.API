create or replace procedure sp_dg_mid_evaluation_json_add (
   p_person_id    varchar2,
   p_meta_id      varchar2,
   p_empno        varchar2,
   p_Json_obj     varchar2,
   p_message_type out varchar2,
   p_message_text out varchar2
) as
   v_empno          varchar2(5);
   v_exists         number;
   v_share_pcnt     number;
   v_user_tcp_ip    varchar2(5) := 'NA';
   v_message_type   number := 0;
   v_emp_no         varchar2(5);
   v_desgcode       varchar2(6);
   v_parent         varchar2(4);
   v_attendance     varchar2(50);
   v_location       varchar2(3);
   v_skill_1        varchar2(50);
   v_skill_1_rating number;
   v_skill_1_remark varchar2(100);
   v_skill_2        varchar2(50);
   v_skill_2_rating number;
   v_skill_2_remark varchar2(100);
   v_skill_3        varchar2(50);
   v_skill_3_rating number;
   v_skill_3_remark varchar2(100);
   v_skill_4        varchar2(50);
   v_skill_4_rating number;
   v_skill_4_remark varchar2(100);
   v_skill_5        varchar2(50);
   v_skill_5_rating number;
   v_skill_5_remark varchar2(100);
   v_que_2_rating   number;
   v_que_2_remark   varchar2(100);
   v_que_3_rating   number;
   v_que_3_remark   varchar2(100);
   v_que_4_rating   number;
   v_que_4_remark   varchar2(100);
   v_que_5_rating   number;
   v_que_5_remark   varchar2(100);
   v_que_6_rating   number;
   v_que_6_remark   varchar2(100);
   v_observations   varchar2(400);
   v_isdeleted      number;
begin
   v_empno := get_empno_from_meta_id(p_meta_id);
   if v_empno = 'ERRRR' then
      p_message_type := not_ok;
      p_message_text := 'Invalid employee number';
      return;
   end if;

   select count(*)
     into v_exists
     from DG_MID_EVALUATION
    where trim(empno) = trim(p_empno);

   if v_exists = 0 then
      insert into DG_MID_EVALUATION
         select dbms_random.string(
            'X',
            8
         )       as KEY_ID,
                EMPNO,
                DESGCODE,
                PARENT,
                ATTENDANCE,
                LOCATION,
                SKILL_1,
                SKILL_1_RATING,
                SKILL_1_REMARK,
                SKILL_2,
                SKILL_2_RATING,
                SKILL_2_REMARK,
                SKILL_3,
                SKILL_3_RATING,
                SKILL_3_REMARK,
                SKILL_4,
                SKILL_4_RATING,
                SKILL_4_REMARK,
                SKILL_5,
                SKILL_5_RATING,
                SKILL_5_REMARK,
                QUE_2_RATING,
                QUE_2_REMARK,
                QUE_3_RATING,
                QUE_3_REMARK,
                QUE_4_RATING,
                QUE_4_REMARK,
                QUE_5_RATING,
                QUE_5_REMARK,
                QUE_6_RATING,
                QUE_6_REMARK,
                OBSERVATIONS,
                v_empno as CREATED_BY,
                sysdate as CREATED_On,
                v_empno as MODIFIED_BY,
                sysdate as MODIFIED_On,
                ISDELETED
           from
            json_table ( p_Json_obj, '$'
               columns (
                  empno varchar2 ( 5 ) path '$.empno',
                  desgcode varchar2 ( 6 ) path '$.desgcode',
                  parent varchar2 ( 4 ) path '$.parent',
                  attendance varchar2 ( 50 ) path '$.attendance',
                  location varchar2 ( 3 ) path '$.location',
                  skill_1 varchar2 ( 50 ) path '$.skill_1',
                  skill_1_rating number path '$.skill_1_rating',
                  skill_1_remark varchar2 ( 100 ) path '$.skill_1_remark',
                  skill_2 varchar2 ( 50 ) path '$.skill_2',
                  skill_2_rating number path '$.skill_2_rating',
                  skill_2_remark varchar2 ( 100 ) path '$.skill_2_remark',
                  skill_3 varchar2 ( 50 ) path '$.skill_3',
                  skill_3_rating number path '$.skill_3_rating',
                  skill_3_remark varchar2 ( 100 ) path '$.skill_3_remark',
                  skill_4 varchar2 ( 50 ) path '$.skill_4',
                  skill_4_rating number path '$.skill_4_rating',
                  skill_4_remark varchar2 ( 100 ) path '$.skill_4_remark',
                  skill_5 varchar2 ( 50 ) path '$.skill_5',
                  skill_5_rating number path '$.skill_5_rating',
                  skill_5_remark varchar2 ( 100 ) path '$.skill_5_remark',
                  que_2_rating number path '$.que_2_rating',
                  que_2_remark varchar2 ( 100 ) path '$.que_2_remark',
                  que_3_rating number path '$.que_3_rating',
                  que_3_remark varchar2 ( 100 ) path '$.que_3_remark',
                  que_4_rating number path '$.que_4_rating',
                  que_4_remark varchar2 ( 100 ) path '$.que_4_remark',
                  que_5_rating number path '$.que_5_rating',
                  que_5_remark varchar2 ( 100 ) path '$.que_5_remark',
                  que_6_rating number path '$.que_6_rating',
                  que_6_remark varchar2 ( 100 ) path '$.que_6_remark',
                  observations varchar2 ( 400 ) path '$.observations',
                  isdeleted number path '$.isdeleted'
               )
            );

      commit;
      p_message_type := 'OK';
      p_message_text := 'Record added successfully..';
   else
      p_message_type := 'KO';
      p_message_text := 'Record already exists !!!';
   end if;

exception
   when others then
      p_message_type := 'KO';
      p_message_text := 'ERR :- '
                        || sqlcode
                        || ' - '
                        || sqlerrm;
end sp_dg_mid_evaluation_json_add;