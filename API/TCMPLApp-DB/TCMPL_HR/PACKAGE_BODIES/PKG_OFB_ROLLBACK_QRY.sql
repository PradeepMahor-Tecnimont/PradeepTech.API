create or replace package body tcmpl_hr.pkg_ofb_rollback_qry as

    function fn_ofb_rollback_list (
        p_person_id      varchar2,
        p_meta_id        varchar2,
        p_status         number,
        p_generic_search varchar2 default null,
        p_row_number     number,
        p_page_length    number
    ) return sys_refcursor as

        c       sys_refcursor;
        v_empno varchar2(5);
        e_employee_not_found exception;
        pragma exception_init ( e_employee_not_found, -20001 );
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' then
            raise e_employee_not_found;
            return null;
        end if;
        open c for select *
                                from (
                                  select a.empno as empno,
                                         get_emp_name(
                                             a.empno
                                         ) as employee_name,
                                         (
                                             select c.costcode || ' : ' || c.name
                                               from vu_costmast c
                                              where c.costcode = d.parent
                                         ) as parent,
                                         d.grade,
                                         a.status,
                                         b.relieving_date,
                                         a.remarks,
                                         a.requested_by || ' : ' || get_emp_name(
                                             a.requested_by
                                         ) as requested_by,
                                         a.requested_on,
                                         a.approved_by || ' : ' || get_emp_name(
                                             a.approved_by
                                         ) as approved_by,
                                         a.approved_on,
                                         (
                                             case a.requested_by
                                                 when v_empno then
                                                     1
                                                 else
                                                     0
                                             end
                                         ) as delete_allowed,
                                         (
                                             case a.requested_by
                                                 when v_empno then
                                                     0
                                                 else
                                                     1
                                             end
                                         ) as approv_allowed,
                                         row_number()
                                         over(
                                              order by b.created_on desc
                                         ) row_number,
                                         count(*)
                                         over() total_row
                                    from ofb_rollback a,
                                         ofb_vu_emp_exits b,
                                         vu_emplmast d
                                   where a.empno = b.empno (+)
                                     and a.empno = d.empno (+)
                                     and a.status = p_status
                                     and ( upper(
                                      a.empno
                                  ) like upper('%' || trim(p_generic_search) || '%')
                                      or upper(
                                      b.employee_name
                                  ) like upper('%' || trim(p_generic_search) || '%')
                                      or upper(
                                      b.parent
                                  ) like upper('%' || trim(p_generic_search) || '%')
                                      or upper(
                                      b.dept_name
                                  ) like upper('%' || trim(p_generic_search) || '%') )
                              )
                    where row_number between ( nvl(
                       p_row_number,
                       0
                   ) + 1 ) and ( nvl(
                       p_row_number,
                       0
                   ) + p_page_length )
                    order by 1;

        return c;
    end fn_ofb_rollback_list;

    function fn_ofb_xl_rollback_list (
        p_person_id      varchar2,
        p_meta_id        varchar2,
        p_status         number,
        p_generic_search varchar2 default null
    ) return sys_refcursor as

        c       sys_refcursor;
        v_empno varchar2(5);
        e_employee_not_found exception;
        pragma exception_init ( e_employee_not_found, -20001 );
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' then
            raise e_employee_not_found;
            return null;
        end if;
        open c for select a.empno as empno,
                          get_emp_name(
                                  a.empno
                              ) as employee_name,
                          (
                                  select c.costcode || ' : ' || c.name
                                    from vu_costmast c
                                   where c.costcode = d.parent
                              ) as parent,
                          d.grade,
                          a.status,
                          b.relieving_date,
                          a.remarks,
                          a.requested_by || ' : ' || get_emp_name(
                                  a.requested_by
                              ) as requested_by,
                          a.requested_on,
                          a.approved_by || ' : ' || get_emp_name(
                                  a.approved_by
                              ) as approved_by,
                          a.approved_on,
                          (
                                  case a.requested_by
                                      when v_empno then
                                          1
                                      else
                                          0
                                  end
                              ) as delete_allowed,
                          (
                                  case a.requested_by
                                      when v_empno then
                                          0
                                      else
                                          1
                                  end
                              ) as approv_allowed
                                from ofb_rollback a,
                                     ofb_vu_emp_exits b,
                                     vu_emplmast d
                    where a.empno = b.empno (+)
                      and a.empno = d.empno (+)
                      and a.status = p_status
                      and ( upper(
                       a.empno
                   ) like upper('%' || trim(p_generic_search) || '%')
                       or upper(
                       b.employee_name
                   ) like upper('%' || trim(p_generic_search) || '%')
                       or upper(
                       b.parent
                   ) like upper('%' || trim(p_generic_search) || '%')
                       or upper(
                       b.dept_name
                   ) like upper('%' || trim(p_generic_search) || '%') )
                    order by a.requested_on desc;

        return c;
    end fn_ofb_xl_rollback_list;

end pkg_ofb_rollback_qry;