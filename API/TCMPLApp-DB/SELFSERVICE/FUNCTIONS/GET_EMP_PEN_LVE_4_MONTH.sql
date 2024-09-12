--------------------------------------------------------
--  DDL for Function GET_EMP_PEN_LVE_4_MONTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_EMP_PEN_LVE_4_MONTH" (
    param_empno    in varchar2,
    param_yyyymm   in varchar2
) return varchar2 as
    v_pn_leave_period   number;
    v_pn_leave_hrs number;
begin
    select
        sum(leaveperiod)
    into v_pn_leave_period
    from
        ss_leaveledg
    where
        empno = param_empno
        and to_char(bdate,'yyyymm') = param_yyyymm
        and adj_type = 'PN';

    if nvl(v_pn_leave_period,0) = 0 then
        return null;
    else
        return to_char( (v_pn_leave_period /8 ),'90.999' );
    end if;
    --return null;

end get_emp_pen_lve_4_month;


/
