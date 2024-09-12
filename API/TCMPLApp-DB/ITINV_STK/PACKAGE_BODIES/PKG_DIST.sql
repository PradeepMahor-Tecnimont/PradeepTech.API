--------------------------------------------------------
--  DDL for Package Body PKG_DIST
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."PKG_DIST" As

    Function get_status_desc (
        p_status_code Number
    ) Return Varchar2 As
        v_desc Varchar2(100);
    Begin
        Select
            status_desc
        Into v_desc
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
        tab_grade   typ_tab_grade;
        v_grade     rec_grade;
    Begin
        v_grade.grade   := '1X1';
        Pipe Row ( v_grade );
        v_grade.grade   := '1X2';
        Pipe Row ( v_grade );
        v_grade.grade   := '1X3';
        Pipe Row ( v_grade );
        v_grade.grade   := '1A1';
        Pipe Row ( v_grade );
    End;

    Function get_emp_type_list Return typ_tab_emptype
        Pipelined
    As
        v_rec_emptype rec_emptype;
    Begin
        v_rec_emptype.emptype := 'R';
        Pipe Row ( v_rec_emptype );
        /*
        v_rec_emptype.emptype := 'S';
        Pipe Row ( v_rec_emptype );
        v_rec_emptype.emptype := 'C';
        Pipe Row ( v_rec_emptype );
        v_rec_emptype.emptype := 'F';
        Pipe Row ( v_rec_emptype );
        */
    End;

    Function is_prev_laptop_iss_permanent (
        param_empno Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(2);
    Begin
        Select
            permanent_issued
        Into v_ret_val
        From
            (
                Select
                    *
                From
                    dist_laptop_already_issued
                Where
                    empno = param_empno
                Order By
                    permanent_issued Desc
            )
        Where
            Rownum = 1;

        Return
            Case
                When v_ret_val = 'OK' Then
                    'Yes'
                Else 'No'
            End;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_type_4_rep (
        param_emptype Varchar2
    ) Return Varchar2 As
        v_valid_emptypes     Varchar2(10) := 'RCSF';
        v_is_valid_emptype   Number;
    Begin
        v_is_valid_emptype := Instr(v_valid_emptypes, param_emptype);
        If v_is_valid_emptype > 0 Then
            Return param_emptype;
        Else
            Return param_emptype || '-EX';
        End If;
    End;

    Function get_emp_pc_count (
        param_empno Varchar2
    ) Return Number As
        v_count Number;
    Begin
        Select Distinct
            Count(*)
        Into v_count
        From
            (
                ( Select
                    assetid
                From
                    dm_vu_user_desk_pc
                Where
                    empno = param_empno
                    And asset_type = 'PC'
                )
                Union
                ( Select
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

    Function get_emp_pc_csv (
        param_empno Varchar2
    ) Return Varchar2 As
        v_asset_csv Varchar2(200);
    Begin
        Select
            Listagg(assetid,
                    ', ') Within Group(
                Order By
                    assetid
            )
        Into v_asset_csv
        From
            (
                Select Distinct
                    assetid
                From
                    (
                        ( Select
                            assetid
                        From
                            dm_vu_user_desk_pc
                        Where
                            empno = param_empno
                            And asset_type = 'PC'
                        )
                        Union
                        ( Select
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

    Function get_emp_laptop_count (
        param_empno Varchar2
    ) Return Number As
        v_count Number;
    Begin
        Select Distinct
            Count(*)
        Into v_count
        From
            (
                Select Distinct
                    laptop_ams_id
                From
                    dist_vu_laptop_issued
                Where
                    empno = param_empno
            );

        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_emp_laptop_csv (
        param_empno      Varchar2,
        param_ret_type   Varchar2 Default 'AMS_ID'
    ) Return Varchar2 As
        v_asset_csv   Varchar2(200);
        v_ok_csv      Varchar2(100);
    Begin
        Select
            Listagg(assetid,
                    ', ') Within Group(
                Order By
                    assetid
            ) nb_list,
            Listagg(permanent_issued,
                    ', ') Within Group(
                Order By
                    assetid
            ) permanent_issued
        Into
            v_asset_csv,
            v_ok_csv
        From
            (
                Select Distinct
                    laptop_ams_id assetid,
                    permanent_issued
                From
                    dist_vu_laptop_issued
                Where
                    empno = param_empno
            );

        If param_ret_type = 'AMS_ID' Then
            Return v_asset_csv;
        Else
            Return Replace(Replace(v_ok_csv, 'OK', 'Yes'), 'KO', 'No');
        End If;

    Exception
        When Others Then
            Return '';
    End;

    Function get_emp_laptop_srno_csv (
        param_empno Varchar2
    ) Return Varchar2 As
        v_asset_srno_csv   Varchar2(200);
        v_ok_csv           Varchar2(100);
    Begin
        Select
            Listagg(mfg_sr_no,
                    ', ') Within Group(
                Order By
                    mfg_sr_no
            ) nb_srno_list
        Into v_asset_srno_csv
        From
            (
                Select Distinct
                    mfg_sr_no
                From
                    dist_vu_laptop_issued   a,
                    ams_asset_master        b
                Where
                    empno = param_empno
                    And a.laptop_ams_id = ams_asset_id
            );

        Return v_asset_srno_csv;
    Exception
        When Others Then
            Return '';
    End;

    Function get_laptop_model (
        p_empno Varchar2
    ) Return Varchar2 As
        v_nb_model Varchar2(1000);
    Begin
        Select
            Listagg(Nvl(lot_desc, asset_model),
                    ', ') Within Group(
                Order By
                    assetid
            ) nb_model
        Into v_nb_model
        From
            (
                Select Distinct
                    assetid,
                    b.asset_model,
                    c.lot_desc
                From
                    (
                        Select
                            laptop_ams_id assetid
                        From
                            dist_vu_laptop_issued
                        Where
                            empno = p_empno
                    ) a,
                    ams_asset_master          b,
                    dist_vu_laptop_lot_list   c
                Where
                    a.assetid = b.ams_asset_id
                    And a.assetid = c.ams_asset_id (+)
            );

        Return v_nb_model;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_pc_model (
        p_empno Varchar2
    ) Return Varchar2 As
        v_pc_model Varchar2(1000);
    Begin
        Select
            Listagg(asset_model,
                    ', ') Within Group(
                Order By
                    assetid
            )
        Into v_pc_model
        From
            (
                Select Distinct
                    assetid,
                    b.asset_model
                From
                    (
                        Select
                            assetid
                        From
                            dm_vu_user_desk_pc
                        Where
                            empno = p_empno
                            And asset_type = 'PC'
                        Union
                        Select
                            ams_id
                        From
                            dist_pc_2_emp_extra
                        Where
                            empno = p_empno
                    ) a,
                    ams_asset_master b
                Where
                    a.assetid = b.ams_asset_id
            );

        Return v_pc_model;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_desg (
        p_empno Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(100);
    Begin
        Select
            desg
        Into v_ret_val
        From
            vu_desgmast
        Where
            desgcode In (
                Select
                    desgcode
                From
                    vu_emplmast
                Where
                    empno = p_empno
            );

        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_headset_csv (
        param_empno Varchar2
    ) Return Varchar2 As
        v_asset_csv Varchar2(1000);
    Begin
        Select
            Listagg(mfg_sr_no,
                    ', ') Within Group(
                Order By
                    mfg_sr_no
            ) hs_list
        Into v_asset_csv
        From
            (
                Select Distinct
                    mfg_sr_no
                From
                    dist_headset_issued
                Where
                    assigned_to_empno = param_empno
            );

        Return v_asset_csv;
    Exception
        When Others Then
            Return '';
    End;

End pkg_dist;

/

  GRANT EXECUTE ON "ITINV_STK"."PKG_DIST" TO "SELFSERVICE";
