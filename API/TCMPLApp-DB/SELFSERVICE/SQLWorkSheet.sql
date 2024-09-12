
With
    params As
    (
        Select
            :p_friday_date As p_friday_date,
            :p_row_number  As p_row_number,
            :p_page_length As p_page_length,
            :p_empno       As p_empno,
            :p_assign_code As p_assign_code
        From
            dual
    ),
    primary_work_space As(
        Select
            a.empno, a.primary_workspace, a.start_date
        From
            swp_primary_workspace a, params
        Where
            trunc(a.start_date) = (
                Select
                    Max(trunc(start_date))
                From
                    swp_primary_workspace b
                Where
                    b.empno = a.empno
                    And b.start_date <= params.p_friday_date
            )
    )
Select
    *
From
    (
        Select
            a.empno                                               As empno,
            a.name                                                As employee_name,
            a.assign,
            a.parent,
            a.office,
            a.emptype,
            iot_swp_common.get_emp_work_area(Null, Null, a.empno) As work_area,
            iot_swp_common.is_emp_laptop_user(a.empno)            As is_laptop_user,
            Case iot_swp_common.is_emp_laptop_user(a.empno)
                When 1 Then
                    'Yes'
                Else
                    'No'
            End                                                   As is_laptop_user_text,
            a.grade                                               As emp_grade,
            nvl(b.primary_workspace, 0)                           As primary_workspace,
            Row_Number() Over(Order By a.name)                    As row_number,
            Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                When 'OK' Then
                    'Yes'
                Else
                    'No'
            End                                                   As is_eligible_desc,
            iot_swp_common.is_emp_eligible_for_swp(a.empno)       As is_eligible,
            Count(*) Over()                                       As total_row
        From
            ss_emplmast        a,
            primary_work_space b,
            swp_include_emptype c
            params
        Where
            a.empno      = b.empno(+)
            And a.assign = nvl(params.p_assign_code, a.assign)
            And a.status = 1
            And a.empno  = nvl(params.p_empno, a.empno)
            And a.emptype = c.emptype
            
            And a.assign Not In (
                Select
                    assign
                From
                    swp_exclude_assign
            )
            And a.emptype In (
            !EMPTYPE_SUBQUERY!
            )
            and 
            b.primary_workspace in (
            )
            and a.grade in(
            )
        Order By a.name
    ), params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length);
    
    
    
/*

    A t t e n d a n c e   Q u e r y 

*/


With
    work_days As (
        Select
            *
        From
            ss_days_details d
        Where
            d.d_date Between :cp_start_date And nvl(:cp_end_date, sysdate)
            And d.d_date Not In (
                Select
                    holiday
                From
                    ss_holidays
                Where
                    holiday Between :cp_start_date And nvl(:cp_end_date, sysdate)
            )
    )
Select
    e.empno,
    e.name,
    e.parent,
    e.assign,
    e.emptype,
    e.grade,
    wd.d_date,
    iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)           n_pws,
    iot_swp_common.fn_get_attendance_status(e.empno, wd.d_date) attendance_status
From
    ss_emplmast              e, work_days wd
Where
    e.status = 1
    And e.emptype In (
        Select
            emptype
        From
            swp_include_emptype
    )
    And e.assign Not In (
        Select
            assign
        From
            swp_exclude_assign
    )
    And e.emptype <> 'X1'
Order By
    d_date;