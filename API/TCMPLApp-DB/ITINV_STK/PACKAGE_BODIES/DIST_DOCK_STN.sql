--------------------------------------------------------
--  DDL for Package Body DIST_DOCK_STN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_DOCK_STN" As

    Procedure remove_assignment (
        p_empno            Varchar2,
        p_sap_asset_code   Varchar2,
        p_success          Out                Varchar2,
        p_message          Out                Varchar2
    ) As
        v_count Number;
    Begin
        Delete From dist_dock_station_issued
        Where
            assigned_to_empno = p_empno
            And sap_asset_code = p_sap_asset_code;

        If Sql%rowcount = 0 Then
            p_success   := 'KO';
            p_message   := 'Err - No record found for the selected criteria.';
            return;
        End If;

        Commit;
        p_success   := 'OK';
        p_message   := 'Record delete successfully.';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := Sqlcode || ' - ' || Sqlerrm;
    End remove_assignment;

    Procedure add_assignment (
        p_empno            Varchar2,
        p_sap_asset_code   Varchar2,
        p_success          Out                Varchar2,
        p_message          Out                Varchar2
    ) As
    Begin
        Insert Into dist_dock_station_issued (
            assigned_to_empno,
            sap_asset_code
        ) Values (
            p_empno,
            p_sap_asset_code
        );

        If Sql%rowcount > 0 Then
            Commit;
            p_success   := 'OK';
            p_message   := 'Record added successfully.';
        Else
            p_success   := 'KO';
            p_message   := 'Err - Record could not be added.';
        End If;

        return;
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := Sqlcode || ' - ' || Sqlerrm;
    End add_assignment;

    Function get_emp_dock_stn_csv (
        p_empno Varchar2
    ) Return Varchar2 As
        v_dock_stn_csv Varchar2(200);
    Begin
        Select
            Listagg(ams_asset_id,
                    ', ') Within Group(
                Order By
                    ams_asset_id
            )
        Into v_dock_stn_csv
        From
            (
                Select Distinct
                    ams_asset_id
                From
                    (
                        Select
                            ams_asset_id
                        From
                            ams_asset_master
                        Where
                            sap_asset_code In (
                                Select
                                    sap_asset_code
                                From
                                    dist_dock_station_issued
                                Where
                                    assigned_to_empno = p_empno
                            )
                    )
            );

        Return v_dock_stn_csv;
    Exception
        When Others Then
            Return '';
    End;
    Function get_emp_dockstn_srno_csv (
        p_empno Varchar2
    ) Return Varchar2 As
        v_dock_stn_csv Varchar2(200);
    Begin
        Select
            Listagg(mfg_sr_no,
                    ', ') Within Group(
                Order By
                    mfg_sr_no
            )
        Into v_dock_stn_csv
        From
            (
                Select Distinct
                    mfg_sr_no
                From
                    (
                        Select
                            mfg_sr_no
                        From
                            ams_asset_master
                        Where
                            sap_asset_code In (
                                Select
                                    sap_asset_code
                                From
                                    dist_dock_station_issued
                                Where
                                    assigned_to_empno = p_empno
                            )
                    )
            );

        Return v_dock_stn_csv;
    Exception
        When Others Then
            Return '';
    End;
End dist_dock_stn;

/
