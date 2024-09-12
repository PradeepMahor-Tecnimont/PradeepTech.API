--------------------------------------------------------
--  DDL for Function GETABSENTDATE_SHIFT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETABSENTDATE_SHIFT" (
    empnum        in varchar2,
    thedate       in date,
    param_shift   varchar2
) return number is
    v_holiday    number;
    v_count      number;
    isabsent     number;
    v_onleave    number;
    dateofjoin   date;
begin
    isabsent    := 0;
    v_holiday   := get_holiday(thedate);
    if nvl(param_shift,'ABCD') not in (
        'HH',
        'OO'
    ) and v_holiday = 0 then
        --If v_holiday = 0 Then
        select
            count(empno)
        into v_count
        from
            ss_integratedpunch
        where
            empno = trim(empnum)
            and pdate = thedate;

        if v_count = 0 then
            v_onleave   := isleavedeputour(thedate,empnum);
            if v_onleave = 0 then
                select
                    nvl(doj,thedate)
                into dateofjoin
                from
                    ss_emplmast
                where
                    empno = trim(empnum);

                if thedate < dateofjoin then
                    isabsent   := 0;
                else
                    isabsent   := 1;
                end if;

            elsif v_onleave = 1 then
                isabsent   := 2;
            else
                isabsent   := 3;
            end if;

        end if;

        --End If;

    end if;

    return isabsent;
end;


/
