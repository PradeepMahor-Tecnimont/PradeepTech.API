--------------------------------------------------------
--  DDL for Package Body DIST
--------------------------------------------------------

Create Or Replace Package Body "ITINV_STK"."DIST" As

    Function get_status_desc(
        p_status_code Number
    ) Return Varchar2 As
        v_desc Varchar2(100);
    Begin
        Select
            status_desc
        Into
            v_desc
        From
            dist_surface_status_mast
        Where
            status_code = p_status_code;

        Return v_desc;
    Exception
        When Others Then
            Return Null;
    End get_status_desc;

    Function get_exclude_grade_list Return typ_tab_grade
        Pipelined
    As
        tab_grade typ_tab_grade;
        v_grade   rec_grade;
    Begin
        v_grade.grade := '1X1';
        Pipe Row (v_grade);
        v_grade.grade := '1X2';
        Pipe Row (v_grade);
        v_grade.grade := '1X3';
        Pipe Row (v_grade);
        v_grade.grade := '1A1';
        Pipe Row (v_grade);
    End;

    Function get_emp_type_list Return typ_tab_emptype
        Pipelined
    As
        v_rec_emptype rec_emptype;
    Begin
        v_rec_emptype.emptype := 'R';
        Pipe Row (v_rec_emptype);
        /*
        v_rec_emptype.emptype := 'S';
        Pipe Row ( v_rec_emptype );
        v_rec_emptype.emptype := 'C';
        Pipe Row ( v_rec_emptype );
        */
        v_rec_emptype.emptype := 'F';
        Pipe Row (v_rec_emptype);
    End;

    Function get_prev_laptop_issued(
        param_empno Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(30);
    Begin
        Select
            laptop_ams_id
        Into
            v_ret_val
        From
            (
                Select
                    *
                From
                    dist_laptop_already_issued
                Where
                    empno = param_empno
                Order By permanent_issued Desc
            )
        Where
            Rownum = 1;

        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function is_prev_laptop_iss_permanent(
        param_empno Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(2);
    Begin
        Select
            permanent_issued
        Into
            v_ret_val
        From
            (
                Select
                    *
                From
                    dist_laptop_already_issued
                Where
                    empno = param_empno
                Order By permanent_issued Desc
            )
        Where
            Rownum = 1;

        Return
        Case
            When v_ret_val = 'OK' Then
                'Yes'
            Else
                'No'
        End;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_type_4_rep(
        param_emptype Varchar2
    ) Return Varchar2 As
        v_valid_emptypes   Varchar2(10) := 'RCSF';
        v_is_valid_emptype Number;
    Begin
        v_is_valid_emptype := instr(v_valid_emptypes, param_emptype);
        If v_is_valid_emptype > 0 Then
            Return param_emptype;
        Else
            Return param_emptype || '-EX';
        End If;
    End;

    Function get_emp_pc_count(
        param_empno Varchar2
    ) Return Number As
        v_count Number;
    Begin
        Select
        Distinct
            Count(*)
        Into
            v_count
        From
            (
                    (
            Select
                assetid
            From
                dm_vu_user_desk_pc
            Where
                empno          = param_empno
                And asset_type = 'PC'
            )
            Union
            (
            Select
                ams_id
            From
                dist_pc_2_emp_extra
            Where
                empno = param_empno
            )
            );

        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_emp_pc_csv(
        param_empno Varchar2
    ) Return Varchar2 As
        v_asset_csv Varchar2(200);
    Begin
        Select
            Listagg(assetid, ', ') Within
                Group (Order By
                    assetid)
        Into
            v_asset_csv
        From
            (
                Select
                Distinct
                    assetid
                From
                    (
                            (
                    Select
                        assetid
                    From
                        dm_vu_user_desk_pc
                    Where
                        empno          = param_empno
                        And asset_type = 'PC'
                    )
                    Union
                    (
                    Select
                        ams_id
                    From
                        dist_pc_2_emp_extra
                    Where
                        empno = param_empno
                    )
                    )
            );

        Return v_asset_csv;
    Exception
        When Others Then
            Return '';
    End;

    Function get_emp_laptop_count(
        param_empno Varchar2
    ) Return Number As
        v_count Number;
    Begin
        Select
        Distinct
            Count(*)
        Into
            v_count
        From
            (
                Select
                    assetid
                From
                    dm_vu_user_desk_pc
                Where
                    empno          = param_empno
                    And asset_type = 'NB'
                Union
                Select
                    ams_asset_id
                From
                    dist_vu_surface_laptop
                Where
                    assigned_to_empno = param_empno
                    And status_desc   = 'Delivery Complete'
                Union
                Select
                    laptop_ams_id
                From
                    dist_laptop_already_issued
                Where
                    empno = param_empno
            );

        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_emp_laptop_csv(
        param_empno Varchar2
    ) Return Varchar2 As
        v_asset_csv Varchar2(200);
    Begin
        Select
            Listagg(assetid, ', ') Within
                Group (Order By
                    assetid)
        Into
            v_asset_csv
        From
            (
                Select
                Distinct
                    assetid
                From
                    (
                        Select
                            laptop_ams_id assetid
                        From
                            dist_vu_laptop_issued
                        Where
                            empno = param_empno
                    )
            );

        Return v_asset_csv;
    Exception
        When Others Then
            Return '';
    End;

    Function get_letter_csv(
        param_empno Varchar2
    ) Return Varchar2 As
        v_letter_no_csv Varchar2(200);
    Begin
        Select
            Listagg(letter_no, ', ') Within
                Group (Order By
                    letter_no)
        Into
            v_letter_no_csv
        From
            ((
                Select
                    letter_ref_no letter_no
                From
                    dist_laptop_already_issued
                Where
                    empno = param_empno
            ));

        Return v_letter_no_csv;
    Exception
        When Others Then
            Return '';
    End;

    Function is_laptop_user(
        p_empno Varchar2
    ) Return Number As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dist_vu_laptop_issued
        Where
            empno = p_empno;
        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

End dist;
/