--------------------------------------------------------
--  DDL for Package Body HR_PKG_COSTMAST_AFC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_COSTMAST_AFC" As

    Procedure update_cost_center_afc (
        param_costcodeid    Char,
        param_tcmcostcodeid Char,
        param_tcm_act_ph_id Char,
        param_tcm_pas_ph_id Char,
        param_po            Varchar2,
        param_success       Out Varchar2,
        param_message       Out Varchar2
    ) As
    Begin
        Update hr_costmast_afc
        Set
            tcmcostcodeid = param_tcmcostcodeid,
            tcm_act_ph_id = param_tcm_act_ph_id,
            tcm_pas_ph_id = param_tcm_pas_ph_id,
            po = param_po
        Where
            costcodeid = param_costcodeid;

        Update costmast
        Set
            tcm_cc = hr_pkg_common.get_tcm_cost_center(param_tcmcostcodeid),
            tcm_act_ph = hr_pkg_common.get_tcm_act_ph(param_tcm_act_ph_id),
            tcm_pas_ph = hr_pkg_common.get_tcm_pas_ph(param_tcm_pas_ph_id),
            po = param_po
        Where
            costcode = hr_pkg_common.get_costcode(param_costcodeid);

        Commit;
        param_success := 'OK';
        param_message := 'AFC updated successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - '
                             || sqlcode
                             || ' - '
                             || sqlerrm;
    End update_cost_center_afc;

End hr_pkg_costmast_afc;

/
