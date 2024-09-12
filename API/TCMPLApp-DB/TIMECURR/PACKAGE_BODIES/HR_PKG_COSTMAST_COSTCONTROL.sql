--------------------------------------------------------
--  DDL for Package Body HR_PKG_COSTMAST_COSTCONTROL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_COSTMAST_COSTCONTROL" As

    Procedure update_cost_center_costcontrol (
        param_costcodeid   Char,
        param_tm01id       Char,
        param_tmaid        Char,
        param_activity     Varchar2,
        param_group_chart  Varchar2,
        param_italian_name Varchar2,
        param_cmid         Char,
        param_phase        Char,
        param_success      Out Varchar2,
        param_message      Out Varchar2
    ) As
    Begin
        Update hr_costmast_costcontrol
        Set
            tm01id = param_tm01id,
            tmaid = param_tmaid,
            activity =
                Case param_activity
                    When 'Yes' Then
                        1
                    Else
                        0
                End,
            group_chart =
                Case param_group_chart
                    When 'Yes' Then
                        1
                    Else
                        0
                End,
            italian_name = param_italian_name,
            cmid = param_cmid,
            phase = param_phase
        Where
            costcodeid = param_costcodeid;

        Update costmast
        Set
            tm01_grp = hr_pkg_common.get_tm01_grp(param_tm01id),
            tma_grp = hr_pkg_common.get_tma_grp(param_tmaid),
            activity =
                Case param_activity
                    When 'Yes' Then
                        1
                    Else
                        0
                End,
            group_chart =
                Case param_group_chart
                    When 'Yes' Then
                        1
                    Else
                        0
                End,
            italian_name = param_italian_name,
            comp = hr_pkg_common.get_comp_report(param_cmid),
            phase = param_phase
        Where
            costcode = hr_pkg_common.get_costcode(param_costcodeid);

        Commit;
        param_success := 'OK';
        param_message := 'Cost control updated successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - '
                             || sqlcode
                             || ' - '
                             || sqlerrm;
    End update_cost_center_costcontrol;

End hr_pkg_costmast_costcontrol;

/
