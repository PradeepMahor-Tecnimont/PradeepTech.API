Create Or Replace Package Body tcmpl_hr.pkg_common As

    Function fn_get_employee_name(
        p_empno Varchar2
    ) Return Varchar2 As
        v_emp_name Varchar2(100);
    Begin
        Select
            name
        Into
            v_emp_name
        From
            vu_emplmast
        Where
            empno = p_empno;
        Return v_emp_name;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_dept_name(
        p_costcode Varchar2
    ) Return Varchar2 As
        v_dept_name Varchar2(100);
    Begin
        Select
            name
        Into
            v_dept_name
        From
            vu_costmast
        Where
            costcode = p_costcode;
        Return v_dept_name;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_designation_name(
        p_desg_code Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(100);
    Begin
        If p_desg_code Is Null Then
            Return Null;
        End If;
        Select
            desg
        Into
            v_ret_val
        From
            vu_desgmast
        Where
            desgcode = p_desg_code;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_office_location_desc(
        p_office_location_code Varchar2
    ) Return Varchar2 As
        v_office_location_desc Varchar2(100);
    Begin
        Select
            office_location_desc
        Into
            v_office_location_desc
        From
            mis_mast_office_location
        Where
            office_location_code = p_office_location_code;
        Return v_office_location_desc;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_emp_office_location(
        p_empno      Varchar2,
        p_start_date Date Default Null
    ) Return Varchar2 As
        v_ret_val             Varchar2(2);
        c_default_office_code Constant Varchar2(2) := '01';
        v_count               Number;
        v_start_date          Date;
    Begin
        v_start_date := nvl(p_start_date, trunc(sysdate));

        Select
            office_location_code
        Into
            v_ret_val
        From
            (
                Select
                    office_location_code, start_date
                From
                    eo_employee_office_map
                Where
                    empno = p_empno
                    And start_date <= v_start_date
                Order By empno,
                    start_date Desc
            )
        Where
            Rownum = 1;

        Return v_ret_val;
    Exception
        When Others Then
            Return c_default_office_code;
    End;
    Function fn_is_emp_resigned(
        p_empno Varchar2
    ) Return Varchar2 As
        c_resignation_withdrawn Constant Varchar2(2) := '02';
        v_count                 Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            mis_resigned_emp
        Where
            empno = p_empno
            And resign_status_code <> c_resignation_withdrawn;
        If v_count > 0 Then
            Return ok;
        Else
            Return not_ok;
        End If;
    Exception
        When Others Then
            Return not_ok;
    End;

    Function fn_emp_res_pincode(
        p_empno Varchar2
    ) Return Varchar2
    As
        v_emp_res_pincode Varchar2(10);
    Begin
        Select
            Trim(to_char(r_pincode))
        Into
            v_emp_res_pincode
        From
            emp_details
        Where
            empno = p_empno;
        Return v_emp_res_pincode;
    Exception
        When Others Then
            Return Null;
    End;

End;