Create Or Replace Package Body selfservice.pkg_region_holiday_calc As

    Function fn_holidays_between(
        p_empno      Varchar2,
        p_start_date Date,
        p_end_date   Date Default Null
    ) Return Number Is
        v_count            Number;
        v_emp_off_loc_code Varchar2(2);
        v_start_date       Date;
        v_end_date         Date;
    Begin
        v_start_date       := p_start_date;
        v_end_date         := nvl(p_end_date, v_end_date);
        v_emp_off_loc_code := tcmpl_hr.pkg_common.fn_get_emp_office_location(p_empno, v_start_date);

        If To_Date('1-Jan-2024', 'dd-Mon-yyyy') Between p_start_date And nvl(p_end_date, p_start_date) Then
            Return get_holidays_between(p_start_date, nvl(p_end_date, p_start_date));
        End If;

        With

            el As (
                Select
                    a.*, b.region_code
                From
                    (
                        Select
                            p_empno empno, To_Date(v_start_date) start_date, v_emp_off_loc_code office_location_code
                        From
                            dual
                        Union
                        Select
                            eo.empno, eo.start_date, office_location_code
                        From
                            tcmpl_hr.eo_employee_office_map eo
                        Where
                            eo.empno = p_empno
                            And eo.start_date Between (To_Date(v_start_date) + 1) And To_Date(v_end_date)
                    )                                 a,
                    tcmpl_hr.hd_region_office_loc_map b
                Where
                    a.office_location_code = b.office_location_code
                    And b.region_code <> 1
            ),
            datewise_region As (
                Select
                    dd.d_date,
                    el.empno,
                    el.start_date      loc_start_date,
                    el.office_location_code,
                    el.region_code,
                    Last_Value(office_location_code) Ignore Nulls Over (Order By
                            dd.d_date) As prev_loc,
                    Last_Value(region_code) Ignore Nulls Over (Order By
                            dd.d_date) As prev_region
                From
                    selfservice.ss_days_details dd,

                    el

                Where
                    dd.d_date Between To_Date(v_start_date) And To_Date(v_end_date)
                    And dd.d_date = el.start_date(+)
            )
        --select d_date,prev_region  from datewise_region;
        Select
            Count(*)
        Into
            v_count
        From
            (
                Select
                Distinct holiday
                From
                    tcmpl_hr.hd_region_holidays
                Where
                    (holiday, region_code) In
                    (
                        Select
                            d_date, prev_region
                        From
                            datewise_region
                        Union
                        Select
                            d_date, 1 -- Common holidays
                        From
                            ss_days_details
                        Where
                            d_date Between To_Date(v_start_date) And To_Date(v_end_date)
                    )
            );
        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_get_holiday(
        p_empno      Varchar2,
        p_start_date Date
    ) Return Number Is
        v_count            Number;
        v_emp_off_loc_code Varchar2(2);
        v_start_date       Date;
        v_end_date         Date;
        v_region_code      Number;
    Begin
        v_start_date       := p_start_date;

        If p_start_date < To_Date('1-Jan-2024', 'dd-Mon-yyyy') Then
            Return get_holiday(p_start_date);
        End If;

        v_emp_off_loc_code := tcmpl_hr.pkg_common.fn_get_emp_office_location(p_empno, v_start_date);

        Select
            region_code
        Into
            v_region_code
        From
            tcmpl_hr.hd_region_office_loc_map b
        Where
            b.office_location_code = v_emp_off_loc_code
            And b.region_code <> 1;

        Select
            Count(*)
        Into
            v_count
        From
            (
                Select
                Distinct holiday
                From
                    tcmpl_hr.hd_region_holidays
                Where
                    (holiday, region_code) In
                    (
                        Select
                            v_start_date, region_code
                        From
                            tcmpl_hr.hd_region_office_loc_map b
                        Where
                            b.office_location_code = v_emp_off_loc_code
                            And b.region_code <> 1
                        Union
                        Select
                            v_start_date, 1 -- Common holidays
                        From
                            dual
                    )
            );
        If v_count = 0 Then
            Return 0;
        Else

            If ltrim(rtrim(to_char(p_start_date, 'day'))) = 'sunday' Then
                Return 2;
            Elsif ltrim(rtrim(to_char(p_start_date, 'day'))) = 'saturday' Then
                Return 1;
            Else
                Return 3;
            End If;
        End If;
        Return v_count;
    Exception
        When Others Then
            Return 0;

    End;

    Function fn_is_holiday(
        p_empno      Varchar2,
        p_start_date Date
    ) Return Number Is
    Begin
        Return fn_get_holiday(
                p_empno      => p_empno,
                p_start_date => p_start_date
            );
    End;

End;