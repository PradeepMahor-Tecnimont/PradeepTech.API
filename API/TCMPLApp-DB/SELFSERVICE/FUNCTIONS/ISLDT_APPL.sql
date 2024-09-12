--------------------------------------------------------
--  DDL for Function ISLDT_APPL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLDT_APPL" (
    pempno   in varchar2,
    ppdate   in date
) return number as
    vretval   number;
begin
    vretval   := 0;
    select
        count(*)
    into vretval
    from
        ss_ondutyapp
    where
        empno = pempno
        and pdate = ppdate
        and type in (
            'IO',
            'OD'
        )
        and nvl(lead_apprl,0) <> 2
        and nvl(hod_apprl,0) <> 2
        and nvl(hrd_apprl,0) <> 2;

    if vretval > 0 then
        return ss.ldt_onduty;
    end if;

     select
        count(*)
    into vretval
    from
        ss_ondutyapp
    where
        empno = pempno
        and pdate = ppdate
        and type = 'MP'
        and nvl(lead_apprl,0) <> 2
        and nvl(hod_apprl,0) <> 2
        and nvl(hrd_apprl,0) <> 2;

    if vretval > 0 then
        return ss.ldt_missed_punch;
    end if;


        select
            count(*)
        into vretval
        from
            ss_depu
        where
            empno = pempno
            and bdate <= ppdate
            and nvl(edate,bdate) >= ppdate
            and type in (
                'HT',
                'VS',
                'TR',
                'DP',
                'RW' -- Remote Working
            )
            and nvl(lead_apprl,0) <> 2
            and nvl(hod_apprl,0) <> 2
            and nvl(hrd_apprl,0) <> 2;

        if vretval > 0 then
            return ss.ldt_depu;
        end if;



        select
            count(*)
        into vretval
        from
            ss_leaveapp
        where
            empno = pempno
            and bdate <= ppdate
            and nvl(edate,bdate) >= ppdate
            and nvl(lead_apprl,0) <> 2
            and nvl(hod_apprl,0) <> 2
            and nvl(hrd_apprl,0) <> 2;

        if vretval > 0 then
            return ss.ldt_leave;
        end if;


    return vretval;
end isldt_appl;


/
