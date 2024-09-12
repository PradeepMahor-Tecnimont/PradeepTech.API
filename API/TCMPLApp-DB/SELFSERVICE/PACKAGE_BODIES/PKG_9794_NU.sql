--------------------------------------------------------
--  DDL for Package Body PKG_9794_NU
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_9794_NU" as
--do not use

    function get_gate_no return varchar2 is
        v_ret_val   varchar2(2);
    begin
        v_ret_val   := to_char(trunc(dbms_random.value(1,4) ),'FM00');

        return v_ret_val;
    end;

    procedure gen_data_4_match_found as
/*
        Cursor c1 Is Select
                        *
                      From
                        ( Select
                              empno,
                              d_date,
                              first_punch,
                              last_punch,
                              first_punch_sec,
                              last_punch_sec,
                              ( Select
                                    Count(*)
                                  From
                                    ss_9794_punch_first_last b
                                 Where b.empno <> a.empno and
                                    first_punch Between ( first_punch_sec + 75 ) And ( first_punch_sec + 360 ) And last_punch Between
                                    ( last_punch_sec - 720 ) And ( last_punch_sec + 75 ) and b.empno <> a.empno
                              ) As count_found
                            From
                              ss_9794_punch_required a
                        )
                     Where
                        count_found <> 0 And first_punch <> '0';
                        */
/*
        Cursor c1 Is Select
                        *
                      From
                        ( Select
                              empno,
                              d_date,
                              first_punch,
                              last_punch,
                              first_punch_sec,
                              last_punch_sec
                            From
                              ss_9794_punch_required a
                        )
                     Where
                        first_punch <> '0';
*/

        cursor c1 is select
                        empno,
                        d_date,
                        pkg_09794.get_punch(empno,d_date,'OK') first_punch,
                        pkg_09794.get_punch(empno,d_date,'KO') last_punch,
                        pkg_09794.get_punch_sec(empno,d_date,'OK') first_punch_sec,
                        pkg_09794.get_punch_sec(empno,d_date,'KO') last_punch_sec
                    from
                        (
                            select
                                empno,
                                to_date(yyyymmdd,'yyyymmdd') d_date
                            from
                                ss_9794_punch_required_2
                        );

        v_random_num   number;
        v_count        number;
    begin
        for c2 in c1 loop
            select
                count(*)
            into v_count
            from
                ss_9794_punch_first_last
            where
                empno not in (
                    select
                        src_emp
                    from
                        ss_9794_punch_generate
                    where
                        for_emp = c2.empno
                )
                and first_punch between ( c2.first_punch_sec + 75 ) and ( c2.first_punch_sec + 360 )
                and last_punch between ( c2.last_punch_sec - 720 ) and ( c2.last_punch_sec + 75 )
                and ( empno,
                      p_date ) in (
                    select
                        empno,
                        pdate
                    from
                        ss_9794_vu_bt_punch_count
                );

            if v_count = 0 then
                continue;
            end if;
            v_random_num   := trunc(dbms_random.value(1,v_count) );
            insert into ss_9794_punch_generate (
                for_emp,
                for_date,
                src_emp,
                src_date
            )
                select
                    c2.empno    for_emp,
                    c2.d_date   for_date,
                    empno       src_emp,
                    p_date      src_date
                from
                    (
                        select
                            empno,
                            p_date,
                            rownum row_num
                        from
                            ss_9794_punch_first_last
                        where
                            empno <> c2.empno
                            and first_punch between ( c2.first_punch_sec + 75 ) and ( c2.first_punch_sec + 360 )
                            and last_punch between ( c2.last_punch_sec - 720 ) and ( c2.last_punch_sec + 75 )
                            and empno not in (
                                select
                                    src_emp
                                from
                                    ss_9794_punch_generate
                                where
                                    for_emp = c2.empno
                            )
                            and ( empno,
                                  p_date ) in (
                                select
                                    empno,
                                    pdate
                                from
                                    ss_9794_vu_bt_punch_count
                            )
                    )
                where
                    row_num = v_random_num;

            commit;
        end loop;
    end;
--do not use

    procedure gen_data_4_match_not_found as

        cursor cur_ts is select
                            empno,
                            yyyymmdd
                        from
                            ss_9794_punch_required_3;

        cursor emp_punch (
            p_empno varchar2,
            p_date date
        ) is select distinct
                 pdate,
                 hh,
                 mm,
                 b.office,
                 a.falseflag
             from
                 ss_integratedpunch a,
                 ss_swipe_mach_mast b
             where
                 empno = p_empno
                 and office like 'MOC1%'
                 and a.mach = b.mach_name (+)
                 and trunc(pdate) = trunc(p_date)
                 and falseflag = 1
             order by
                 hh,
                 mm;

        v_count                number;
        v_lunch                number;
        v_diner                number;
        c_lunch_end            number;
        v_diner_end            number;
        v_row_cntr             number;
        v_random_num           number;
        v_random_in            number;
        v_random_out           number;
        v_for_date             date;
        v_for_time             number;
        v_for_time_chr         varchar2(20);
        v_shift                varchar2(2);
        v_food_time_start      number;
        v_food_time_end        number;
        v_food_time_adjusted   boolean;
        v_food_time_2_adjust   number;
    begin
        v_lunch       := 45000; --12:30pm
        c_lunch_end   := 51300; --14:15 
        v_diner       := 72000; --20:00 - 8:00pm
        v_diner_end   := 79200; --22:00 - 10:00pm
        for cur_row in cur_ts loop
            select
                count(*)
            into v_count
            from
                ss_integratedpunch a,
                ss_swipe_mach_mast b
            where
                empno = cur_row.empno
                and b.office like 'MOC1%'
                and a.mach = b.mach_name (+)
                and pdate = to_date(cur_row.yyyymmdd,'yyyymmdd')
                and falseflag = 1;

            if v_count = 0 then
                continue;
            end if;
            v_row_cntr             := 1;
            v_for_date             := to_date(cur_row.yyyymmdd,'yyyymmdd');
            v_shift                := getshift1(cur_row.empno,v_for_date);
            if v_shift = 'GS' then
                v_food_time_start   := 45000; -- 12:30pm
                v_food_time_end     := 51300; --14:15 - 2:15pm
            else
                v_food_time_start   := 72000; --20:00 - 8:00pm
                v_food_time_end     := 79200; --22:00 - 10:00pm
            end if;

            v_food_time_adjusted   := false;
            for emp_punch_row in emp_punch(cur_row.empno,v_for_date) loop
                v_random_num           := trunc(dbms_random.value(75,240) ); ---1:15 min to 4 minute
                v_food_time_2_adjust   := trunc(dbms_random.value(1500,1800) );  --(25 Minutes)
                --FOOD Time
                v_for_time             := ( emp_punch_row.hh * 3600 ) + ( emp_punch_row.mm * 60 ) + v_random_num;

                if mod(v_row_cntr,2) = 1 then
                    v_for_time   := ( emp_punch_row.hh * 3600 ) + ( emp_punch_row.mm * 60 ) + v_random_num;
                else
                    v_for_time   := ( emp_punch_row.hh * 3600 ) + ( emp_punch_row.mm * 60 ) - v_random_num;
                end if;

                if v_row_cntr > 1 and v_food_time_adjusted = false then
                    if v_for_time between v_food_time_start and v_food_time_end then
                        if mod(v_row_cntr,2) = 0 then
                            v_for_time             := v_for_time - v_food_time_2_adjust; --(25 Minutes before --Out Punch)
                            v_food_time_adjusted   := true;
                        end if;

                    end if;
                end if;

                v_for_time_chr         := sec_to_char(v_for_time);
                insert into ss_9794_punch_genrat_no_found (
                    empno,
                    p_date,
                    time_sec,
                    time_chr
                ) values (
                    cur_row.empno,
                    v_for_date,
                    v_for_time,
                    v_for_time_chr
                );

                v_row_cntr             := v_row_cntr + 1;
            end loop;
            /*
            If v_count > 0 Then
                Continue;
            End If;
            If cur_row.first_punch_sec < v_lunch And cur_row.last_punch_sec > v_diner_end Then
                gen_lunch;
                Null;
            Elsif cur_row.first_punch_sec > 45000 And cur_row.first_punch_sec <= v_diner Then
                gen_diner;
            End If;
            */

        end loop;

    end;
--do not use

    procedure update_sub_cont_emp_ss_data as
        cursor c1 is select
                         *
                     from
                         ss_9794_ts_ss_may_jun
                     where
                         empno like '%X%';

    begin
        for c2 in c1 loop
            update ss_9794_ts_ss_may_jun
            set
                first_punch = pkg_09794.get_punch(case c2.empno
                    when 'X0576'   then 'X0618'
                    when 'X0577'   then 'X0619'
                    when 'X0578'   then 'X0620'
                    when 'X0579'   then 'X0621'
                    when 'X0580'   then 'X0621'
                end,c2.ts_date,'OK'),
                last_punch = pkg_09794.get_punch(case c2.empno
                    when 'X0576'   then 'X0618'
                    when 'X0577'   then 'X0619'
                    when 'X0578'   then 'X0620'
                    when 'X0579'   then 'X0621'
                    when 'X0580'   then 'X0621'
                end,c2.ts_date,'KO'),
                first_punch_sec = pkg_09794.get_punch_sec(case c2.empno
                    when 'X0576'   then 'X0618'
                    when 'X0577'   then 'X0619'
                    when 'X0578'   then 'X0620'
                    when 'X0579'   then 'X0621'
                    when 'X0580'   then 'X0621'
                end,c2.ts_date,'OK'),
                last_punch_sec = pkg_09794.get_punch_sec(case c2.empno
                    when 'X0576'   then 'X0618'
                    when 'X0577'   then 'X0619'
                    when 'X0578'   then 'X0620'
                    when 'X0579'   then 'X0621'
                    when 'X0580'   then 'X0621'
                end,c2.ts_date,'KO')
            where
                empno = c2.empno
                and ts_date = c2.ts_date;

        end loop;
    end;
-- do not use

    procedure gen_lunch_4_not_found is

        cursor c1 is select
                        *
                    from
                        (
                            select
                                empno,
                                p_date,
                                min(time_sec) first_punch,
                                max(time_sec) last_punch,
                                count(*) rec_count
                            from
                                ss_9794_punch_genrat_no_found
                            group by
                                empno,
                                p_date
                        )
                    where
                        rec_count < 4;

        type typ_tbl is
            table of ss_9794_punch_genrat_no_found%rowtype index by pls_integer;
        tbl_punch           typ_tbl;
        v_shift             varchar2(2);
        v_food_time_start   number;
        v_food_time_end     number;
    begin
        for c2 in c1 loop
            if c2.first_punch < 45000 then
                v_food_time_start   := 45000; --from 12:30pm
            else
                v_food_time_start   := 72000; --from 20:00 - 8:00pm
            end if;

            v_food_time_start   := v_food_time_start + trunc(dbms_random.value(300,900) );  --5min to 15min from 12:30pm
            v_food_time_end     := v_food_time_start + trunc(dbms_random.value(2100,2700) ); --35min to 45min
            select
                *
            bulk collect
            into tbl_punch
            from
                ss_9794_punch_genrat_no_found
            where
                empno = c2.empno
                and p_date = c2.p_date
            order by
                time_sec;
            --if tbl_punch(1).time_sec < v_food_time_start and tbl_punch(1).time_sec > v_food_time_end  then

            insert into ss_9794_punch_genrat_no_found (
                empno,
                p_date,
                time_sec,
                time_chr
            ) values (
                c2.empno,
                c2.p_date,
                v_food_time_start,
                sec_to_char(v_food_time_start)
            );

            insert into ss_9794_punch_genrat_no_found (
                empno,
                p_date,
                time_sec,
                time_chr
            ) values (
                c2.empno,
                c2.p_date,
                v_food_time_end,
                sec_to_char(v_food_time_end)
            );
            --end if;

        end loop;
    end;
--do not use

    procedure gen_punch_morining_evening is

        cursor c1 is select
                        *
                    from
                        (
                            select
                                empno,
                                p_date,
                                min(time_sec) first_punch,
                                max(time_sec) last_punch,
                                count(*) rec_count
                            from
                                ss_9794_punch_genrat_no_found
                            group by
                                empno,
                                p_date
                        );

        v_morning_out   number;
        v_morning_in    number;
        v_evening_out   number;
        v_evening_in    number;
    begin
        for c2 in c1 loop
            v_morning_out   := c2.first_punch + trunc(dbms_random.value(420,900) ); --7 to 15 min

            v_morning_in    := v_morning_out + trunc(dbms_random.value(600,900) ); --(10 to 15) min
            v_evening_out   := c2.last_punch - trunc(dbms_random.value(2700,3600) ); --30 to 45 min

            v_evening_in    := v_evening_out + trunc(dbms_random.value(600,900) ); --(10 to 15) min
            insert into ss_9794_punch_genrat_no_found (
                empno,
                p_date,
                time_sec,
                time_chr
            ) values (
                c2.empno,
                c2.p_date,
                v_morning_out,
                sec_to_char(v_morning_out)
            );

            insert into ss_9794_punch_genrat_no_found (
                empno,
                p_date,
                time_sec,
                time_chr
            ) values (
                c2.empno,
                c2.p_date,
                v_morning_in,
                sec_to_char(v_morning_in)
            );

            insert into ss_9794_punch_genrat_no_found (
                empno,
                p_date,
                time_sec,
                time_chr
            ) values (
                c2.empno,
                c2.p_date,
                v_evening_out,
                sec_to_char(v_evening_out)
            );

            insert into ss_9794_punch_genrat_no_found (
                empno,
                p_date,
                time_sec,
                time_chr
            ) values (
                c2.empno,
                c2.p_date,
                v_evening_in,
                sec_to_char(v_evening_in)
            );

        end loop;
    end;

    procedure update_number_tid is
/*
        cursor c1 is select
                        rowid,
                        empno,
                        p_date,
                        time_sec
                    from
                        ss_9794_punch_genrat_no_found
                    order by
                        empno,
                        p_date,
                        time_sec;
*/
        cursor c1 is select
                        rowid,
                        empno,
                        p_date,
                        time_sec
                    from
                        ss_9794_punch_generate_4_bt
                    order by
                        empno,
                        p_date,
                        time_sec;

        v_tid           number;
        v_in_out        number;
        v_in_out_flag   number;
        v_prev_empno    varchar2(5);
        v_gate_id       varchar2(2);
    begin
        v_tid          := 105101167;
        v_prev_empno   := 'XXXX';
        for c2 in c1 loop
        /*
            v_gate_id      := to_char(trunc(dbms_random.value(1,4) ),'FM00');

            if v_prev_empno <> c2.empno then
                v_in_out_flag   := 0;
            else
                if v_in_out_flag = 0 then
                    v_in_out_flag   := 1;
                else
                    v_in_out_flag   := 0;
                end if;
            end if;

            update ss_9794_punch_genrat_no_found
            set
                tid = v_tid,
                gate_no = v_gate_id,
                in_out = v_in_out_flag
            where
                rowid = c2.rowid;

            v_prev_empno   := c2.empno;
            */
            update ss_9794_punch_generate_4_bt
            set
                tid = v_tid
            where
                rowid = c2.rowid;
            v_tid          := v_tid + 1;

        end loop;

    end;
--donot use

    procedure delete_punch_between is

        cursor c1 is select
                        *
                    from
                        ss_punch
                    where
                        ( empno,
                          pdate ) in (
                            select
                                empno,
                                to_date(pdate,'yyyymmdd')
                            from
                                ss_9794_punch_2_del
                        );

        max_row_id     varchar2(30);
        min_row_id     varchar2(30);
        max_time_sec   number;
        min_time_sec   number;
    begin
        for c2 in c1 loop
            select
                max( (hh * 3600 + mm * 60 + ss) ),
                min( (hh * 3600 + mm * 60 + ss) )
            into
                max_time_sec,
                min_time_sec
            from
                ss_punch
            where
                empno = c2.empno
                and pdate = ( c2.pdate )
            group by
                empno,
                pdate;

            delete from ss_punch
            where
                empno = c2.empno
                and pdate = ( c2.pdate )
                and ( hh * 3600 + mm * 60 + ss ) not in (
                    max_time_sec,
                    min_time_sec
                );

        end loop;
    end;

    procedure insert_food_tm (
        param_yyyymmddnn   varchar2,
        param_empno        varchar2,
        param_date         date,
        pp_start_time      number
    ) is
        v_food_time_start   number;
        v_food_time_end     number;
    begin
        v_food_time_start   := pp_start_time + trunc(dbms_random.value(300,900) );  --5min to 15min from 12:30pm
        v_food_time_end     := v_food_time_start + trunc(dbms_random.value(2100,2700) ); --35min to 45min
        insert into ss_9794_punch_generate_4_bt (
            key_id,
            empno,
            p_date,
            time_sec,
            time_chr,
            in_out,
            gate_no
        ) values (
            param_yyyymmddnn,
            param_empno,
            param_date,
            v_food_time_start,
            sec_to_char(v_food_time_start),
            c_out,
            to_char(trunc(dbms_random.value(1,3.9) ),'FM00')
        );

        insert into ss_9794_punch_generate_4_bt (
            key_id,
            empno,
            p_date,
            time_sec,
            time_chr,
            in_out,
            gate_no
        ) values (
            param_yyyymmddnn,
            param_empno,
            param_date,
            v_food_time_end,
            sec_to_char(v_food_time_end),
            c_in,
            to_char(trunc(dbms_random.value(1,3.9) ),'FM00')
        );

    end;

    procedure find_ins_food_time (
        param_empno           varchar2,
        param_date            date,
        param_yyyymmddnn      varchar2,
        param_food_tm_start   number,
        param_food_tm_end     number
    ) is

        cursor cur_punch_4_bt (
            cur_p_empno varchar2,
            cur_p_date date
        ) is select
                 *
             from
                 (
                     select
                         in_out,
                         lag(time_sec,1,0) over(
                             order by
                                 time_sec
                         ) as prev_out_time,
                         time_sec   in_time,
                         lead(time_sec,1,0) over(
                             order by
                                 time_sec
                         ) as out_time,
                         lead(time_sec,2,0) over(
                             order by
                                 time_sec
                         ) as next_in_time
                     from
                         ss_9794_punch_generate_4_bt a
                     where
                         empno = cur_p_empno
                         and p_date = cur_p_date
                     order by
                         time_sec
                 )
             where
                 in_out = c_in;

        v_punch_between_food_tm_count   number;
        v_punch_after_food_tm_start     number;
        v_nu_in_time                    number;
        v_nu_out_time                   number;
        v_count                         number;
        v_row_cntr                      number;
        v_break_period                  number;
    begin
        --Check punch count is ODD / EVEN
        select
            count(*)
        into v_count
        from
            ss_9794_punch_generate_4_bt
        where
            empno = param_empno
            and p_date = param_date
            and key_id = param_yyyymmddnn;

        if mod(v_count,2) <> 0 then
            return;
        end if;
            --Check Punch Count is ODD

            --Check Punches between food_tm
        select
            count(*)
        into v_punch_between_food_tm_count
        from
            ss_9794_punch_generate_4_bt
        where
            empno = param_empno
            and p_date = param_date
            and time_sec between param_food_tm_start and param_food_tm_end
            and key_id = param_yyyymmddnn;

        if v_punch_between_food_tm_count > 2 then
            return;
        end if;
        if v_punch_between_food_tm_count = 2 then
            --return;
            null;
        end if;
            --Check Punches between food_tm

            --Check Punches After food_tm Start
        select
            count(*)
        into v_punch_after_food_tm_start
        from
            ss_9794_punch_generate_4_bt
        where
            empno = param_empno
            and p_date = param_date
            and time_sec > ( param_food_tm_start + 3600 )
            and key_id = param_yyyymmddnn
            and in_out = c_out;

        if v_punch_after_food_tm_start = 0 then
            return;
        end if;
            --Check Punches After food_tm Start
            ---
        for emp_punch4bt in cur_punch_4_bt(param_empno,param_date) loop
            if emp_punch4bt.next_in_time <> 0 and emp_punch4bt.next_in_time < param_food_tm_start then
                continue;
            end if;

            v_row_cntr       := v_row_cntr + 1;
            --If there is no punch between lunch time
            if ( v_punch_between_food_tm_count = 0 ) then
                    -- insert food_tm
                insert_food_tm(param_yyyymmddnn,param_empno,param_date,param_food_tm_start);
                return;
            end if;

            v_break_period   := ( trunc(dbms_random.value(38,48) ) * 60 );

            if ( ( emp_punch4bt.in_time between param_food_tm_start and param_food_tm_end ) ) then
                --difference between in time and previous out time is more then 30 mins exit
                --No lunch time required it already exists
                if emp_punch4bt.in_time - emp_punch4bt.prev_out_time > v_break_period or emp_punch4bt.prev_out_time = 0 then
                    return;
                end if;

                v_nu_in_time   := emp_punch4bt.prev_out_time + v_break_period;
                --if nue intime is greater then out time then 
                --skip
                if v_nu_in_time < emp_punch4bt.out_time then
                    delete from ss_9794_punch_generate_4_bt
                    where
                        empno = param_empno
                        and p_date = param_date
                        and time_sec = emp_punch4bt.in_time;
                --Insert nu extended in time

                    insert into ss_9794_punch_generate_4_bt (
                        key_id,
                        empno,
                        p_date,
                        time_sec,
                        time_chr,
                        in_out,
                        gate_no
                    ) values (
                        param_yyyymmddnn,
                        param_empno,
                        param_date,
                        v_nu_in_time,
                        sec_to_char(v_nu_in_time),
                        c_in,
                        to_char(trunc(dbms_random.value(1,3.9) ),'FM00')
                    );

                    return;
                end if;

            end if;
                --OUT Time is between food_tm Time

            v_break_period   := ( trunc(dbms_random.value(38,48) ) * 60 );

            if ( ( emp_punch4bt.out_time between param_food_tm_start and param_food_tm_end ) ) then
                        --difference between Next in time and out time is more then 30 mins exit
                if emp_punch4bt.next_in_time - emp_punch4bt.out_time > v_break_period or emp_punch4bt.next_in_time = 0 then
                    return;
                end if;

                v_nu_out_time   := emp_punch4bt.next_in_time - v_break_period;
                if ( v_nu_out_time < emp_punch4bt.next_in_time ) then
                    delete from ss_9794_punch_generate_4_bt
                    where
                        empno = param_empno
                        and p_date = param_date
                        and time_sec = emp_punch4bt.out_time;

                    insert into ss_9794_punch_generate_4_bt (
                        key_id,
                        empno,
                        p_date,
                        time_sec,
                        time_chr,
                        in_out,
                        gate_no
                    ) values (
                        param_yyyymmddnn,
                        param_empno,
                        param_date,
                        v_nu_out_time,
                        sec_to_char(v_nu_out_time),
                        c_out,
                        to_char(trunc(dbms_random.value(1,3.9) ),'FM00')
                    );

                    return;
                end if;

            end if;

        end loop;

    end find_ins_food_time;


    procedure gen_punch_4_first_break (
        param_empno        varchar2,
        param_date         date,
        param_yyyymmddnn   varchar2
    ) as

        cursor cur_punch_4_bt (
            cur_p_empno varchar2,
            cur_p_date date
        ) is select
                 *
             from
                 (
                     select
                         in_out,
                         lag(time_sec,1,0) over(
                             order by
                                 time_sec
                         ) as prev_out_time,
                         time_sec   in_time,
                         lead(time_sec,1,0) over(
                             order by
                                 time_sec
                         ) as out_time,
                         lead(time_sec,2,0) over(
                             order by
                                 time_sec
                         ) as next_in_time
                     from
                         ss_9794_punch_generate_4_bt a
                     where
                         empno = cur_p_empno
                         and p_date = cur_p_date
                     order by
                         time_sec
                 )
             where
                 prev_out_time = 0;

        cursor cur_punch_4_bt1 (
            cur_p_empno varchar2,
            cur_p_date date
        ) is select
                 *
             from
                 ss_9794_punch_generate_4_bt
             where
                 empno = cur_p_empno
                 and p_date = cur_p_date
                 and key_id = param_yyyymmddnn
             order by
                 time_sec;

        v_count            number;
        v_row_cntr         number;
        v_in_time          number;
        v_out_time         number;
        v_break_out_time   number;
        v_break_in_time    number;
        v_gate_no          varchar2(2);
        --v_pdate            date;
    begin
        v_row_cntr   := 0;
        --for c1 in cur_ts loop
            --v_pdate   := to_date(c1.yyyymmdd,'yyyymmdd');
        for emp_punch4bt in cur_punch_4_bt(param_empno,param_date) loop
            v_row_cntr   := v_row_cntr + 1;
            if emp_punch4bt.out_time - emp_punch4bt.in_time > 5400 then
                v_break_out_time   := emp_punch4bt.in_time + trunc(dbms_random.value(420,900) ); --7 to 15 min

                v_break_in_time    := v_break_out_time + trunc(dbms_random.value(600,900) ); --(10 to 15) min
                v_gate_no          := get_gate_no;
                insert into ss_9794_punch_generate_4_bt (
                    key_id,
                    empno,
                    p_date,
                    time_sec,
                    time_chr,
                    in_out,
                    gate_no
                ) values (
                    param_yyyymmddnn,
                    param_empno,
                    param_date,
                    v_break_out_time,
                    sec_to_char(v_break_out_time),
                    c_out,
                    v_gate_no
                );

                v_gate_no          := get_gate_no;
                insert into ss_9794_punch_generate_4_bt (
                    key_id,
                    empno,
                    p_date,
                    time_sec,
                    time_chr,
                    in_out,
                    gate_no
                ) values (
                    param_yyyymmddnn,
                    param_empno,
                    param_date,
                    v_break_in_time,
                    sec_to_char(v_break_in_time),
                    c_in,
                    v_gate_no
                );

            end if;

            if v_row_cntr = 1 then
                exit;
            end if;
        end loop;

        --end loop;

    end;

    procedure gen_punch_4_last_break (
        param_empno        varchar2,
        param_date         date,
        param_yyyymmddnn   varchar2
    ) as

        cursor cur_punch_4_bt (
            cur_p_empno varchar2,
            cur_p_date date
        ) is select
                 *
             from
                 (
                     select
                         in_out,
                         lag(time_sec,1,0) over(
                             order by
                                 time_sec
                         ) as prev_out_time,
                         time_sec   in_time,
                         lead(time_sec,1,0) over(
                             order by
                                 time_sec
                         ) as out_time,
                         lead(time_sec,2,0) over(
                             order by
                                 time_sec
                         ) as next_in_time
                     from
                         ss_9794_punch_generate_4_bt a
                     where
                         empno = cur_p_empno
                         and p_date = cur_p_date
                     order by
                         time_sec
                 )
             where
                 next_in_time = 0;

        cursor cur_punch_4_bt1 (
            cur_p_empno varchar2,
            cur_p_date date
        ) is select
                 *
             from
                 ss_9794_punch_generate_4_bt
             where
                 empno = cur_p_empno
                 and p_date = cur_p_date
                 and key_id = param_yyyymmddnn
             order by
                 time_sec;

        v_count            number;
        v_row_cntr         number;
        v_in_time          number;
        v_out_time         number;
        v_break_out_time   number;
        v_break_in_time    number;
        v_gate_no          varchar2(2);
        --v_pdate            date;
    begin
        v_row_cntr   := 0;
        for emp_punch4bt in cur_punch_4_bt(param_empno,param_date) loop
            v_row_cntr   := v_row_cntr + 1;
            if emp_punch4bt.out_time - emp_punch4bt.in_time > 5400 then
                v_break_in_time    := emp_punch4bt.out_time - trunc(dbms_random.value(420,900) ); --7 to 15 min

                v_break_out_time   := v_break_in_time - trunc(dbms_random.value(600,900) ); --(10 to 15) min
                v_gate_no          := get_gate_no;
                insert into ss_9794_punch_generate_4_bt (
                    key_id,
                    empno,
                    p_date,
                    time_sec,
                    time_chr,
                    in_out,
                    gate_no
                ) values (
                    param_yyyymmddnn,
                    param_empno,
                    param_date,
                    v_break_out_time,
                    sec_to_char(v_break_out_time),
                    c_out,
                    v_gate_no
                );

                v_gate_no          := get_gate_no;
                insert into ss_9794_punch_generate_4_bt (
                    key_id,
                    empno,
                    p_date,
                    time_sec,
                    time_chr,
                    in_out,
                    gate_no
                ) values (
                    param_yyyymmddnn,
                    param_empno,
                    param_date,
                    v_break_in_time,
                    sec_to_char(v_break_in_time),
                    c_in,
                    v_gate_no
                );

            end if;

            if v_row_cntr = 1 then
                exit;
            end if;
        end loop;

    end;


    procedure gen_punch_as_per_ss (
        param_yyyymmddnn varchar2
    ) as

        cursor cur_ts is select
                            empno,
                            yyyymmdd
                        from
                            ss_9794_punch_required_3;

        cursor emp_punch (
            p_empno varchar2,
            p_date date
        ) is select distinct
                 pdate,
                 hh,
                 mm,
                 b.office,
                 a.falseflag
             from
                 ss_integratedpunch a,
                 ss_swipe_mach_mast b
             where
                 empno = p_empno
                 and ( office like 'MOC1%'
                       or type = 'IO' )
                 and a.mach = b.mach_name (+)
                 and trunc(pdate) = trunc(p_date)
                 and falseflag = 1
             order by
                 hh,
                 mm;

        v_count          number;
        v_row_cntr       number;
        v_random_num     number;
        v_random_in      number;
        v_random_out     number;
        v_for_date       date;
        v_for_time       number;
        v_for_time_chr   varchar2(20);
        v_in_out         number;
        v_gate_no        varchar2(2);
    begin
        for cur_row in cur_ts loop
            select
                count(*)
            into v_count
            from
                ss_integratedpunch a,
                ss_swipe_mach_mast b
            where
                empno = cur_row.empno
                and ( b.office like 'MOC1%'
                      or type = 'IO' )
                and a.mach = b.mach_name (+)
                and pdate = to_date(cur_row.yyyymmdd,'yyyymmdd')
                and falseflag = 1;

            if v_count = 0 then
                continue;
            end if;
            v_row_cntr   := 1;
            v_for_date   := to_date(cur_row.yyyymmdd,'yyyymmdd');
            for emp_punch_row in emp_punch(cur_row.empno,v_for_date) loop
                v_random_num     := trunc(dbms_random.value(75,240) ); ---1:15 min to 4 minute
                if mod(v_row_cntr,2) = 1 then --IN
                    v_for_time   := ( emp_punch_row.hh * 3600 ) + ( emp_punch_row.mm * 60 ) + v_random_num;

                    v_in_out     := c_in; --IN
                else --OUT
                    v_for_time   := ( emp_punch_row.hh * 3600 ) + ( emp_punch_row.mm * 60 ) - v_random_num;

                    v_in_out     := c_out; --OUT
                end if;

                v_for_time_chr   := sec_to_char(v_for_time);
                v_gate_no        := to_char(trunc(dbms_random.value(1,4) ),'FM00');

                insert into ss_9794_punch_generate_4_bt (
                    key_id,
                    empno,
                    p_date,
                    time_sec,
                    time_chr,
                    in_out,
                    gate_no
                ) values (
                    param_yyyymmddnn,
                    cur_row.empno,
                    v_for_date,
                    v_for_time,
                    v_for_time_chr,
                    v_in_out,
                    v_gate_no
                );

                v_row_cntr       := v_row_cntr + 1;
            end loop;

            find_ins_food_time(cur_row.empno,v_for_date,param_yyyymmddnn,c_lunch_start,c_lunch_end);
            find_ins_food_time(cur_row.empno,v_for_date,param_yyyymmddnn,c_diner_start,c_diner_end);
            gen_punch_4_first_break(cur_row.empno,v_for_date,param_yyyymmddnn);
            gen_punch_4_last_break(cur_row.empno,v_for_date,param_yyyymmddnn);
        end loop;
    end gen_punch_as_per_ss;

--Donot Use


--DoNot use

    procedure gen_punch_4_lunch (
        param_empno        varchar2,
        param_date         date,
        param_yyyymmddnn   varchar2
    ) as

        cursor cur_ts is select
                            empno,
                            yyyymmdd
                        from
                            ss_9794_punch_required_3;

        v_count            number;
        v_row_cntr         number;
        v_in_time          number;
        v_out_time         number;
        v_break_out_time   number;
        v_break_in_time    number;
        v_gate_no          varchar2(2);
        v_pdate            date;
        v_4_lunch          number;
        v_4_diner          number;
    begin
        v_row_cntr   := 0;
        for c1 in cur_ts loop
            v_pdate   := to_date(c1.yyyymmdd,'yyyymmdd');
            --Check if IN Punch is before LUNCH
            select
                count(*)
            into v_4_lunch
            from
                ss_9794_punch_generate_4_bt
            where
                empno = c1.empno
                and p_date = v_pdate
                and time_sec <= ( c_lunch_start + 1800 )
                and key_id = param_yyyymmddnn;

            --Check if OUT Punch is AFTER Dinner

            select
                count(*)
            into v_4_diner
            from
                ss_9794_punch_generate_4_bt
            where
                empno = c1.empno
                and p_date = v_pdate
                and time_sec >= ( c_diner_start + 1800 )
                and key_id = param_yyyymmddnn;

            if v_4_lunch > 0 then
            -- Valid for  L U N C H
                null;
            elsif v_4_diner > 0 then
                null;
                --It is valid for D I N N E R
            end if;
        end loop;

    end gen_punch_4_lunch;

end pkg_9794_nu;


/
