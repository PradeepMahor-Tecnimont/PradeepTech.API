--------------------------------------------------------
--  DDL for Package Body VPP_USER_QRY
--------------------------------------------------------
Create Or Replace Package Body tcmpl_hr.vpp_user_qry As

    Function fn_vpp_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                vpp.key_id                                          As "Application_Id",
                vpp.empno,
                vppd.name,
                rm.relation,
                to_char(vppd.dob, 'dd-Mon-yyyy')                    As "dob",
                vppd.gender,
                ism.insured_sum_words,
                vppd.key_id                                         As key_id_detail,
                vpp_hr_qry.fn_is_parent_delete_allowed(vppd.key_id) is_delete_val,
                Case
                    When vpp_hr_qry.fn_is_parent_delete_allowed(vppd.key_id) = 1 Then
                        'Delete not allowed, please contact HR'
                    Else
                        'Can be delete'
                End                                                 As is_delete_txt
            From
                vpp_voluntary_parent_policy   vpp,
                vpp_voluntary_parent_policy_d vppd,
                vpp_insured_sum_master        ism,
                vpp_relation_master           rm,
                vpp_grade_group_master        ggm,
                vpp_vu_emplmast               ve
            Where
                vpp.key_id             = vppd.f_key_id
                And vpp.insured_sum_id = ism.insured_sum_id
                And vppd.relation_id   = rm.relation_id
                And vpp.empno          = ve.empno
                And ve.status          = 1
                And vpp.empno          = Trim(v_empno)
                And ve.emptype In ('R', 'F')
                And ism.is_active      = 1
                And rm.is_active       = 1
                And ggm.grade_grp      = (
                         Select
                             substr(grade, 1, 1)
                         From
                             vpp_vu_emplmast
                         Where
                             empno = Trim(v_empno)
                             And grade Is Not Null
                     )
            Order By
                name;
        Return c;
    End fn_vpp_list;

    Procedure sp_vpp_detail(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_application_id    Out Varchar2,
        p_empno             Out Varchar2,
        p_employee          Out Varchar2,
        p_insured_sum_id    Out Varchar2,
        p_insured_sum_words Out Varchar2,
        p_premium_amt       Out Number,
        p_gst_amt           Out Number,
        p_total_premium     Out Number,
        p_is_lock           Out Number,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_config_id          Varchar2(10);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            vpp.key_id,
            vpp.empno,
            ve.name,
            vpp.insured_sum_id,
            ism.insured_sum_words,
            is_lock,
            vpp.config_key_id
        Into
            p_application_id,
            p_empno,
            p_employee,
            p_insured_sum_id,
            p_insured_sum_words,
            p_is_lock,
            v_config_id
        From
            vpp_voluntary_parent_policy vpp,
            vpp_insured_sum_master      ism,
            vpp_grade_group_master      ggm,
            vpp_vu_emplmast             ve,
            vpp_config                  config
        Where
            vpp.insured_sum_id    = ism.insured_sum_id
            And vpp.empno         = ve.empno
            And vpp.config_key_id = config.key_id
            And vpp.empno         = Trim(v_empno)
            And ve.status          = 1
            And ve.emptype In ('R', 'F')
            And ism.is_active     = 1
            And ggm.grade_grp     = (
                    Select
                        substr(grade, 1, 1)
                    From
                        vpp_vu_emplmast
                    Where
                        empno = Trim(v_empno)
                        And grade Is Not Null
                );

        If (p_application_id Is Not Null) Then
            Select
                a.premium,
                a.gst_amt,
                a.total_premium
            Into
                p_premium_amt,
                p_gst_amt,
                p_total_premium
            From
                vpp_premium_master a
            Where
                a.config_key_id    = v_config_id
                And insured_sum_id = (
                    Select
                        a.insured_sum_id
                    From
                        vpp_voluntary_parent_policy a
                    Where
                        a.key_id = p_application_id
                )
                And persons        = (
                           Select
                               Count(*)
                           From
                               vpp_voluntary_parent_policy_d
                           Where
                               f_key_id = p_application_id
                       );
        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Err - Data not found.';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_vpp_detail;

    /*
     Procedure sp_vpp_detail(
            p_person_id             Varchar2,
            p_meta_id               Varchar2,

            p_application_id    Out Varchar2,
            p_empno             Out Varchar2,
            p_employee          Out Varchar2,
            p_insured_sum_id    Out Varchar2,
            p_insured_sum_words Out Varchar2,
            p_premium_amt       Out Number,
            p_gst_amt           Out Number,
            p_total_premium     Out Number,
            p_is_lock           Out Number,

            p_message_type      Out Varchar2,
            p_message_text      Out Varchar2
        )
        As
            c                    Sys_Refcursor;
            v_empno              Varchar2(5);
            e_employee_not_found Exception;
            Pragma exception_init(e_employee_not_found, -20001);
        Begin
            v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                Return;
            End If;

            Select
                vpp.key_id,
                vpp.empno,
                ve.name,
                vpp.insured_sum_id,
                ism.insured_sum_words,
                is_lock
            Into
                p_application_id,
                p_empno,
                p_employee,
                p_insured_sum_id,
                p_insured_sum_words,

                p_is_lock

            From
                vpp_voluntary_parent_policy                        vpp,
                vpp_insured_sum_master                             ism, vpp_grade_group_master ggm, vpp_vu_emplmast ve
            Where
                vpp.insured_sum_id = ism.insured_sum_id
                And vpp.empno      = ve.empno
                And vpp.empno      = Trim(v_empno)
                And ve.emptype In ('R', 'F')
                And ism.is_active  = 1
                And ggm.grade_grp  = (
                     Select
                         substr(grade, 1, 1)
                     From
                         vpp_vu_emplmast
                     Where
                         empno = Trim(v_empno)
                         And grade Is Not Null
                 );

            If (p_application_id Is Not Null) Then
                Select
                    premium, gst_amt, total_premium
                Into
                    p_premium_amt, p_gst_amt, p_total_premium
                From
                    vpp_premium_master
                Where
                    insured_sum_id = (
                        Select
                            a.insured_sum_id
                        From
                            vpp_voluntary_parent_policy a
                        Where
                            a.key_id = p_application_id
                    )
                    And persons    = (
                           Select
                               Count(*)
                           From
                               vpp_voluntary_parent_policy_d
                           Where
                               f_key_id = p_application_id
                       );
            End If;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

        Exception
            When Others Then
                p_message_type := 'KO';
                p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
        End sp_vpp_detail;
    */
End vpp_user_qry;
/
Grant Execute On tcmpl_hr.vpp_user_qry To tcmpl_app_config;
/