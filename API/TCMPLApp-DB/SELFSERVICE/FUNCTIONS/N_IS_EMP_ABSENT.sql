--------------------------------------------------------
--  DDL for Function N_IS_EMP_ABSENT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_IS_EMP_ABSENT" (
    param_empno        in varchar2,
    param_date         in varchar2,
    param_shift_code   in varchar2,
    param_doj          in varchar2
) return varchar2 as

    v_holiday           number;
    v_count             number;
    c_is_absent         constant number := 1;
    c_not_absent        constant number := 0;
    c_leave_depu_tour   constant number := 2;
    v_on_ldt            number;
    v_ldt_appl          number;
begin
    v_holiday    := get_holiday(param_date);
    if v_holiday > 0 or nvl(param_shift_code,'ABCD') in (
        'HH',
        'OO'
    ) then
        --return -1;
        return c_not_absent;
    end if;

    --Check DOJ & DOL

    if param_date < nvl(param_doj,param_date) then
        --return -5;
        return c_not_absent;
    end if;
    v_on_ldt     := isleavedeputour(param_date,param_empno);
    if v_on_ldt = 1 then
        --return -2;
        --return c_leave_depu_tour;
        return c_not_absent;
    end if;
    select
        count(empno)
    into v_count
    from
        ss_integratedpunch
    where
        empno = trim(param_empno)
        and pdate = param_date;

    if v_count > 0 then
        --return -3;
        return c_not_absent;
    end if;
    v_ldt_appl   := isldt_appl(param_empno,param_date);
    if v_ldt_appl > 0 then
        --return -6;
        return c_not_absent;
    end if;
    --return -4;
    return c_is_absent;
end n_is_emp_absent;


/
