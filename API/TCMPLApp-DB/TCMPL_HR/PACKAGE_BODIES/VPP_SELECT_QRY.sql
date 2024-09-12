--------------------------------------------------------
--  DDL for Package Body VPP_SELECT_QRY
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."VPP_SELECT_QRY" As

    Function fn_relation_select_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  rm.relation_id data_value_field,
                                  rm.relation    data_text_field
                                From
                                  vpp_relation_master rm
                    Where
                           is_active = 1 And
                       Not Exists (
                           Select
                               relation_id
                             From
                               vpp_voluntary_parent_policy   vpp,
                               vpp_voluntary_parent_policy_d vppd
                            Where
                                   vpp.key_id       = vppd.f_key_id And
                               vppd.relation_id = rm.relation_id And
                               vpp.empno        = Trim(v_empno)
                       )
                    Order By
                       relation;
        Return c;
    End fn_relation_select_list;

    Function fn_insured_sum_select_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  ism.insured_sum_id    data_value_field,
                                  ism.insured_sum_words data_text_field
                                From
                                  vpp_insured_sum_master ism,
                                  vpp_grade_group_master ggm
                    Where
                           ism.insured_sum_id >= ggm.insured_sum_id_from And
                       ism.insured_sum_id <= ggm.insured_sum_id_to And
                       ggm.grade_grp = (
                           Select
                               substr(
                                   grade,
                                   1,
                                   1
                               )
                             From
                               vpp_vu_emplmast
                            Where
                                   empno = Trim(v_empno) And
                               grade Is Not Null
                       )
                    Order By
                       insured_sum_id Desc;

        Return c;
    End fn_insured_sum_select_list;

    Function fn_empno_select_filter_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  vpp.empno data_value_field,
                                  ve.name   data_text_field
                                From
                                  vpp_voluntary_parent_policy vpp,
                                  vpp_vu_emplmast             ve
                    Where
                       vpp.empno = ve.empno
                    Order By
                       vpp.empno;
        Return c;
    End fn_empno_select_filter_list;

    Function fn_insured_sum_select_fi_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select Distinct
                                  ism.insured_sum_id    data_value_field,
                                  ism.insured_sum_words data_text_field
                                From
                                  vpp_voluntary_parent_policy vpp,
                                  vpp_insured_sum_master      ism
                    Where
                       ism.insured_sum_id = vpp.insured_sum_id
                    Order By
                       ism.insured_sum_id Desc;

        Return c;
    End fn_insured_sum_select_fi_list;


    Function fn_insured_sum_frm_config_select_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        v_count Number;
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            Count(*)
          Into v_count
          From
            vpp_premium_master     pm,
            vpp_grade_group_master ggm,
            vpp_config             vc,
            vpp_vu_emplmast        ve
         Where
                pm.config_key_id      = vc.key_id And
            vc.is_initiate_config = 1 And
            pm.insured_sum_id >= ggm.insured_sum_id_from And
            pm.insured_sum_id <= ggm.insured_sum_id_to And
            ggm.grade_grp         = substr(
                ve.grade,
                1,
                1
            ) And
            ve.empno              = Trim(v_empno)
         Order By
            pm.insured_sum_id Desc;


        If v_count != 0 Then
            Open c For Select Distinct
                                      pm.insured_sum_id  data_value_field,
                                      pm.lacs || ' Lacs' data_text_field
                                    From
                                      vpp_premium_master     pm,
                                      vpp_grade_group_master ggm,
                                      vpp_config             vc,
                                      vpp_vu_emplmast        ve
                        Where
                               pm.config_key_id      = vc.key_id And
                           vc.is_initiate_config = 1 And
                           pm.insured_sum_id >= ggm.insured_sum_id_from And
                           pm.insured_sum_id <= ggm.insured_sum_id_to And
                           ggm.grade_grp         = substr(
                               ve.grade,
                               1,
                               1
                           ) And
                           ve.empno              = Trim(v_empno)
                        Order By
                           pm.insured_sum_id Desc;
            Return c;
        Else
            Open c For Select Distinct
                                      pm.insured_sum_id  data_value_field,
                                      pm.lacs || ' Lacs' data_text_field
                                    From
                                      vpp_premium_master          pm,
                                      vpp_grade_group_master      ggm,
                                      vpp_voluntary_parent_policy vpp,
                                      vpp_vu_emplmast             ve
                        Where
                               vpp.config_key_id = pm.config_key_id And
                           pm.insured_sum_id >= ggm.insured_sum_id_from And
                           pm.insured_sum_id <= ggm.insured_sum_id_to And
                           ggm.grade_grp     = substr(
                               ve.grade,
                               1,
                               1
                           ) And
                           ve.empno          = vpp.empno And
                           ve.empno          = Trim(v_empno)
                        Order By
                           pm.insured_sum_id Desc;
            Return c;
        End If;


    End fn_insured_sum_frm_config_select_list;


End vpp_select_qry;
/
Grant Execute On "TCMPL_HR"."VPP_SELECT_QRY" To "TCMPL_APP_CONFIG";
/