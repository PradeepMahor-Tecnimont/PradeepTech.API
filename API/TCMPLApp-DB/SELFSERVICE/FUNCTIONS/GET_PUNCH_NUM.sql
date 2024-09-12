--------------------------------------------------------
--  DDL for Function GET_PUNCH_NUM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_PUNCH_NUM" (
    param_empno         varchar2,
    param_date          date,
    param_first_punch   varchar2,
    param_purpose       varchar2 default ''
) return number as
    rec_punch_data   selfservice.ss_integratedpunch%rowtype;
    v_ret_val        number;
    v_option_0       number;
    v_option_1       number;
        --param_purpose varchar2(5);
begin
    v_option_0   := 0;
    v_option_1   := 1;
    if param_purpose in (
        'LC',
        'EGO',
        'DHRS'
    ) then
        v_option_0   := 1;
    end if;
    if param_first_punch = 'OK' then
        select
            *
        into rec_punch_data
        from
            (
                select
                    *
                from
                    selfservice.ss_integratedpunch
                where
                    empno = param_empno
                    and pdate = trunc(param_date)
                    and falseflag in (
                        v_option_0,
                        v_option_1
                    )
                order by
                    hh,
                    mm,
                    ss
            )
        where
            rownum = 1;

    elsif param_first_punch = 'KO' then
        select
            *
        into rec_punch_data
        from
            (
                select
                    *
                from
                    selfservice.ss_integratedpunch
                where
                    empno = param_empno
                    and pdate = trunc(param_date)
                    and falseflag in (
                        v_option_0,
                        v_option_1
                    )
                order by
                    hh desc,
                    mm desc,
                    ss desc
            )
        where
            rownum = 1;

    else
        return null;
    end if;

    v_ret_val    := ( rec_punch_data.hh * 60 ) + rec_punch_data.mm;
        --v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';
    return v_ret_val;
exception
    when others then
        return 0;
end get_punch_num;


/
