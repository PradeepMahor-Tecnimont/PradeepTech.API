Create Or Replace Package Body "SELFSERVICE"."IOT_SWP_EMPLOYEES_QRY" As

    Function fn_swp_employees(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,

        p_start_date                Date,
        p_end_date                  Date,
        p_is_exclude_x1_employees   Number,
        p_include_employee_location Varchar2 

    ) Return Sys_Refcursor As
        v_empno                     Varchar2(5);
        e_employee_not_found        Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                           Sys_Refcursor;
        v_exclude_grade             Varchar2(2);
        c_location_all              Varchar2(15)  := 'ALL';
        c_location_delhi            Varchar2(15)  := 'GURUGRAM';
        c_location_others           Varchar2(15)  := 'OTHERS';
        --v_loc_sub_query             Varchar2(500);
        c_location_code_gurugram    Varchar2(2)   := '03';
        v_grugram_loc_costcodes_qry Varchar2(500);
        v_query                     Varchar2(3000);
        v_column_01_qry             Varchar2(200) := '';
    Begin

        v_empno                     := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        v_grugram_loc_costcodes_qry := '(select costcode from tcmpl_hr.mis_mast_costcode_location where office_location_code = ''' ||
                                       c_location_code_gurugram || ''')';

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If upper(trim(p_include_employee_location)) = c_location_all Then
            v_grugram_loc_costcodes_qry := ' ';
        Elsif upper(trim(p_include_employee_location)) = c_location_delhi Then
            v_grugram_loc_costcodes_qry := ' and assign in ' || v_grugram_loc_costcodes_qry;
        Elsif upper(trim(p_include_employee_location)) = c_location_others Then
            v_grugram_loc_costcodes_qry := ' and assign not in ' || v_grugram_loc_costcodes_qry;
        Else
            Return Null;
        End If;

        v_query                     := '
With
    params As (
        Select
            :p_start_date    As p_start_date,
            :p_end_date      As p_end_date,
            :p_exclude_grade As p_exclude_grade
        From
            dual
    )
Select
    empno, name As employee_name, emptype, grade, parent, assign
From
    ss_emplmast e,
    params
Where
    (
        e.status = 1
        Or dol Between params.p_start_date And params.p_end_date
    )
    and e.doj <= params.p_end_date
    And e.emptype In (
        Select
            emptype
        From
            swp_include_emptype
    )
    And e.grade <> params.p_exclude_grade'  ;

        v_query                     := v_query || v_grugram_loc_costcodes_qry;

        Open c For
            v_query using p_start_date,p_end_date, v_exclude_grade;

        Return c;
    End fn_swp_employees;

End iot_swp_employees_qry;