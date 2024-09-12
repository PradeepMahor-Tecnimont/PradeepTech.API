--------------------------------------------------------
--  DDL for Package Body HR_PKG_COSTMAST_HOD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_COSTMAST_HOD" As

    Procedure update_cost_center_dy_hod (
        param_costcodeid    Char,
        param_dy_hod        Char,
        param_changed_nemps Number,
        param_success       Out Varchar2,
        param_message       Out Varchar2
    ) As
    Begin
        Update hr_costmast_hod
        Set
            dy_hod = param_dy_hod,
            changed_nemps = param_changed_nemps
        Where
            costcodeid = param_costcodeid;

        Update costmast
        Set
            dy_hod = param_dy_hod,
            changed_nemps = param_changed_nemps
        Where
            costcode = hr_pkg_common.get_costcode(param_costcodeid);

        Commit;
        param_success := 'OK';
        param_message := 'Dy HoD updated successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - '
                             || sqlcode
                             || ' - '
                             || sqlerrm;
    End update_cost_center_dy_hod;

End hr_pkg_costmast_hod;

/
