--------------------------------------------------------
--  DDL for Package Body VPP_HR_QRY
--------------------------------------------------------

Create Or Replace Package Body tcmpl_hr.vpp_hr_qry As
    Function fn_get_premium(
        p_key_id         Varchar2,
        p_insured_sum_id Varchar2,
        p_config_key_id  Varchar2
    ) Return Number As
        v_premium vpp_premium_master.premium%Type;
    Begin
        Select
            premium
        Into
            v_premium
        From
            vpp_premium_master
        Where
            insured_sum_id    = p_insured_sum_id
            And config_key_id = p_config_key_id
            And persons       = (
                      Select
                          Count(*)
                      From
                          vpp_voluntary_parent_policy_d
                      Where
                          f_key_id = p_key_id
                  );
        Return v_premium;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_get_gst(
        p_key_id         Varchar2,
        p_insured_sum_id Varchar2,
        p_config_key_id  Varchar2
    ) Return Number As
        v_gst_amt vpp_premium_master.gst_amt%Type;
    Begin
        Select
            gst_amt
        Into
            v_gst_amt
        From
            vpp_premium_master
        Where
            insured_sum_id    = p_insured_sum_id
            And config_key_id = p_config_key_id
            And persons       = (
                      Select
                          Count(*)
                      From
                          vpp_voluntary_parent_policy_d
                      Where
                          f_key_id = p_key_id
                  );
        Return v_gst_amt;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_get_total_premium(
        p_key_id         Varchar2,
        p_insured_sum_id Varchar2,
        p_config_key_id  Varchar2
    ) Return Number As
        v_total_premium vpp_premium_master.total_premium%Type;
    Begin
        Select
            total_premium
        Into
            v_total_premium
        From
            vpp_premium_master
        Where
            insured_sum_id    = p_insured_sum_id
            And config_key_id = p_config_key_id
            And persons       = (
                      Select
                          Count(*)
                      From
                          vpp_voluntary_parent_policy_d
                      Where
                          f_key_id = p_key_id
                  );
        Return v_total_premium;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_get_people_count(
        p_key_id Varchar2,
        p_type   Varchar2
    ) Return Number As
        v_count Number;
    Begin
        If p_type = 'PARENTS' Then
            Select
                Count(key_id)
            Into
                v_count
            From
                vpp_voluntary_parent_policy_d
            Where
                f_key_id = p_key_id 
                 And relation_id In ( 'R01', 'R02' )
;
        Elsif p_type = 'INLAWS' Then
            Select
                Count(key_id)
            Into
                v_count
            From
                vpp_voluntary_parent_policy_d
            Where
                f_key_id = p_key_id
                And relation_id In ('R03', 'R04');
        Else
            Select
                Count(key_id)
            Into
                v_count
            From
                vpp_voluntary_parent_policy_d
            Where
                f_key_id = p_key_id;
        End If;
        Return v_count;
    End;

    Function fn_vpp_hr_list(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_generic_search    Varchar2,
        p_row_number        Number,
        p_page_length       Number,
        p_empno             Varchar2 Default Null,
        p_insured_sum_words Varchar2 Default Null,
        p_modified_on_from  Date     Default Null,
        p_modified_on_to    Date Default Null
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
        If p_generic_search Is Null Then
            Open c For
                Select
                    *
                From
                    (
                        Select
                            vpp.key_id                                       As "Application_Id",
                            vpp.empno,
                            ve.name                                          As employee,
                            to_char(ve.dob, 'dd-Mon-yyyy')                   As "emp_dob",
                            ve.parent,
                            ve.grade,
                            ve.desgcode                                      As designation,
                            ve.email,
                            Null                                             As mobileno,
                            ism.insured_sum_words,
                            Row_Number() Over(Order By vpp.modified_on Desc) row_number,
                            Count(*) Over()                                  total_row
                        From
                            vpp_voluntary_parent_policy vpp,
                            vpp_insured_sum_master      ism,
                            vpp_grade_group_master      ggm,
                            vpp_vu_emplmast             ve
                        Where
                            vpp.is_lock            = 1
                            And vpp.insured_sum_id = ism.insured_sum_id
                            And vpp.empno          = ve.empno
                            And ve.status          = 1
                            And ve.emptype In ('R', 'F')
                            And ism.is_active      = 1
                            And ggm.grade_grp      = (
                                     Select
                                         substr(grade, 1, 1)
                                     From
                                         vpp_vu_emplmast
                                     Where
                                         empno = Trim(v_empno)
                                         And grade Is Not Null
                                 )
                        Order By modified_on Desc
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Else
            Open c For
                Select
                    *
                From
                    (
                        Select
                            vpp.key_id                                       As "Application_Id",
                            vpp.empno,
                            ve.name                                          As employee,
                            to_char(ve.dob, 'dd-Mon-yyyy')                   As "emp_dob",
                            ve.parent,
                            ve.grade,
                            ve.desgcode                                      As designation,
                            ve.email,
                            Null                                             As mobileno,
                            ism.insured_sum_words,
                            Row_Number() Over(Order By vpp.modified_on Desc) row_number,
                            Count(*) Over()                                  total_row
                        From
                            vpp_voluntary_parent_policy vpp,
                            vpp_insured_sum_master      ism,
                            vpp_grade_group_master      ggm,
                            vpp_vu_emplmast             ve
                        Where
                            (upper(ve.name) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(ism.insured_sum_words) Like upper('%' || Trim(p_generic_search) || '%') Or
                                upper(vpp.empno) Like upper('%' || Trim(p_generic_search) || '%'))
                            And vpp.empno             = nvl(p_empno, vpp.empno)
                            And vpp.is_lock           = 1
                            And ve.status          = 1
                            And ism.insured_sum_words = nvl(p_insured_sum_words, ism.insured_sum_words)
                            And vpp.insured_sum_id    = ism.insured_sum_id
                            And vpp.empno             = ve.empno
                            And ve.emptype In ('R', 'F')
                            And ism.is_active         = 1
                            And ggm.grade_grp         = (
                                        Select
                                            substr(grade, 1, 1)
                                        From
                                            vpp_vu_emplmast
                                        Where
                                            empno = Trim(v_empno)
                                            And grade Is Not Null
                                    )
                        Order By modified_on Desc
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        End If;
        Return c;
    End fn_vpp_hr_list;

    Function fn_vpp_hr_list_excel(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_generic_search    Varchar2 Default Null,
        p_empno             Varchar2 Default Null,
        p_insured_sum_words Varchar2 Default Null,
        p_modified_on_from  Date     Default Null,
        p_modified_on_to    Date Default Null
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
        If p_generic_search Is Null Then
            Open c For
                Select
                    vpp.key_id                                 As "Application_Id",
                    vpp.empno,
                    ve.name                                    As employee,
                    to_char(ve.dob, 'dd-Mon-yyyy')             As "emp_dob",
                    ve.parent,
                    ve.grade,
                    ve.desgcode                                As designation,
                    ve.email,
                    emp_details.p_mobile                                       As mobileno,
                    vppd.name,
                    rm.relation,
                    to_char(vppd.dob, 'dd-Mon-yyyy')           As "dob",
                    vppd.gender,
                    ism.insured_sum_words,
                    trunc(vppd.modified_on)                    modified_on,
                    fn_get_people_count(vpp.key_id, 'PARENTS') As my_parents_count,
                    round(
                        fn_get_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'PARENTS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As my_parents_premium_amt,
                    round(
                        fn_get_gst(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'PARENTS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As my_parents_gst_amt,
                    round(
                        fn_get_total_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'PARENTS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As my_parents_total_premium,
                    fn_get_people_count(vpp.key_id, 'INLAWS')  As inlaws_count,
                    round(
                        fn_get_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'INLAWS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As inlaws_premium_amt,
                    round(
                        fn_get_gst(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'INLAWS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As inlaws_gst_amt,
                    round(
                        fn_get_total_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'INLAWS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As inlaws_total_premium,
                    fn_get_people_count(vpp.key_id, 'TOTAL')   As parents_count,
                    fn_get_premium(
                        vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                    )                                          As premium_amt,
                    fn_get_gst(
                        vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                    )                                          As gst_amt,
                    fn_get_total_premium(
                        vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                    )                                          As total_premium
                From
                    vpp_voluntary_parent_policy   vpp,
                    vpp_voluntary_parent_policy_d vppd,
                    vpp_insured_sum_master        ism,
                    vpp_relation_master           rm,
                    vpp_grade_group_master        ggm,
                    vpp_vu_emplmast               ve,
                    emp_details emp_details
                Where
                    vpp.key_id             = vppd.f_key_id
                    And vpp.is_lock        = 1
                    And vpp.insured_sum_id = ism.insured_sum_id
                    And vppd.relation_id   = rm.relation_id
                    And vpp.empno          = ve.empno
                    And ve.status          = 1
                    And ve.emptype In ('R', 'F')
                    And ism.is_active      = 1
                    And rm.is_active       = 1
                    And ggm.grade_grp      = substr(ve.grade, 1, 1)
                    And emp_details.empno = ve.empno
                Order By
                    modified_on Desc;
        Else
            Open c For
                Select
                    vpp.key_id                                 As "Application_Id",
                    vpp.empno,
                    ve.name                                    As employee,
                    to_char(ve.dob, 'dd-Mon-yyyy')             As "emp_dob",
                    ve.parent,
                    ve.grade,
                    ve.desgcode                                As designation,
                    ve.email,
                    emp_details.p_mobile                                       As mobileno,
                    vppd.name,
                    rm.relation,
                    to_char(vppd.dob, 'dd-Mon-yyyy')           As "dob",
                    vppd.gender,
                    ism.insured_sum_words,
                    trunc(vppd.modified_on)                    modified_on,
                    fn_get_people_count(vpp.key_id, 'PARENTS') As my_parents_count,
                    round(
                        fn_get_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'PARENTS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As my_parents_premium_amt,
                    round(
                        fn_get_gst(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'PARENTS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As my_parents_gst_amt,
                    round(
                        fn_get_total_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'PARENTS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As my_parents_total_premium,
                    fn_get_people_count(vpp.key_id, 'INLAWS')  As inlaws_count,
                    round(
                        fn_get_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'INLAWS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As inlaws_premium_amt,
                    round(
                        fn_get_gst(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'INLAWS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As inlaws_gst_amt,
                    round(
                        fn_get_total_premium(
                            vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                        ) * (fn_get_people_count(vpp.key_id, 'INLAWS') / fn_get_people_count(vpp.key_id, 'TOTAL')),
                        2
                    )                                          As inlaws_total_premium,
                    fn_get_people_count(vpp.key_id, 'TOTAL')   As parents_count,
                    fn_get_premium(
                        vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                    )                                          As premium_amt,
                    fn_get_gst(
                        vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                    )                                          As gst_amt,
                    fn_get_total_premium(
                        vpp.key_id, vpp.insured_sum_id, vpp.config_key_id
                    )                                          As total_premium
                From
                    vpp_voluntary_parent_policy   vpp,
                    vpp_voluntary_parent_policy_d vppd,
                    vpp_insured_sum_master        ism,
                    vpp_relation_master           rm,
                    vpp_grade_group_master        ggm,
                    vpp_vu_emplmast               ve,
                    emp_details emp_details
                Where
                    (upper(ve.name) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.name) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(rm.relation) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.dob) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.gender) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(ism.insured_sum_words) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.modified_on) Like upper('%' || Trim(p_generic_search) || '%'))
                    And vpp.empno             = nvl(p_empno, vpp.empno)
                    And vpp.is_lock           = 1
                    And ism.insured_sum_words = nvl(p_insured_sum_words, ism.insured_sum_words)
                    And vppd.modified_on Between nvl(p_modified_on_from, vppd.modified_on) And nvl(p_modified_on_to, vppd.
                    modified_on)
                    And vpp.key_id            = vppd.f_key_id
                    And vpp.insured_sum_id    = ism.insured_sum_id
                    And vppd.relation_id      = rm.relation_id
                    And ve.status          = 1
                    And vpp.empno             = ve.empno
                    And ve.emptype In ('R', 'F')
                    And ism.is_active         = 1
                    And rm.is_active          = 1
                    And ggm.grade_grp         = substr(ve.grade, 1, 1)
                    And emp_details.empno = ve.empno
                Order By
                    modified_on Desc;
        End If;
        Return c;
    End fn_vpp_hr_list_excel;

    Function fn_vpp_hr_list_not_locked_xl(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_generic_search    Varchar2 Default Null,
        p_empno             Varchar2 Default Null,
        p_insured_sum_words Varchar2 Default Null,
        p_modified_on_from  Date     Default Null,
        p_modified_on_to    Date Default Null
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
        If p_generic_search Is Null Then
            Open c For
                Select
                    vpp.key_id                       As "Application_Id",
                    vpp.empno,
                    ve.name                          As employee,
                    to_char(ve.dob, 'dd-Mon-yyyy')   As "emp_dob",
                    ve.parent,
                    ve.grade,
                    ve.desgcode                      As designation,
                    ve.email,
                    Null                             As mobileno,
                    vppd.name,
                    rm.relation,
                    to_char(vppd.dob, 'dd-Mon-yyyy') As "dob",
                    vppd.gender,
                    ism.insured_sum_words,
                    trunc(vppd.modified_on)          modified_on,
                    (
                        Select
                            Count(vppd1.key_id)
                        From
                            vpp_voluntary_parent_policy_d vppd1
                        Where
                            vppd1.f_key_id = vpp.key_id
                    )                                As parents_count,
                    (
                        Select
                            premium
                        From
                            vpp_premium_master
                        Where
                            insured_sum_id    = vpp.insured_sum_id
                            And config_key_id = vpp.config_key_id
                            And persons       = (
                                      Select
                                          Count(*)
                                      From
                                          vpp_voluntary_parent_policy_d
                                      Where
                                          f_key_id = vpp.key_id
                                  )
                    )                                As premium_amt,
                    (
                        Select
                            gst_amt
                        From
                            vpp_premium_master
                        Where
                            insured_sum_id    = vpp.insured_sum_id
                            And config_key_id = vpp.config_key_id
                            And persons       = (
                                      Select
                                          Count(*)
                                      From
                                          vpp_voluntary_parent_policy_d
                                      Where
                                          f_key_id = vpp.key_id
                                  )
                    )                                As gst_amt,
                    (
                        Select
                            total_premium
                        From
                            vpp_premium_master
                        Where
                            insured_sum_id    = vpp.insured_sum_id
                            And config_key_id = vpp.config_key_id
                            And persons       = (
                                      Select
                                          Count(*)
                                      From
                                          vpp_voluntary_parent_policy_d
                                      Where
                                          f_key_id = vpp.key_id
                                  )
                    )                                As total_premium
                From
                    vpp_voluntary_parent_policy   vpp,
                    vpp_voluntary_parent_policy_d vppd,
                    vpp_insured_sum_master        ism,
                    vpp_relation_master           rm,
                    vpp_grade_group_master        ggm,
                    vpp_vu_emplmast               ve
                Where
                    vpp.key_id             = vppd.f_key_id
                    And vpp.is_lock        = 0
                    And vpp.insured_sum_id = ism.insured_sum_id
                    And vppd.relation_id   = rm.relation_id
                    And vpp.empno          = ve.empno
                    And ve.status          = 1
                    And ve.emptype In ('R', 'F')
                    And ism.is_active      = 1
                    And rm.is_active       = 1
                    And ggm.grade_grp      = substr(ve.grade, 1, 1)
                Order By
                    modified_on Desc;
        Else
            Open c For
                Select
                    vpp.key_id                       As "Application_Id",
                    vpp.empno,
                    ve.name                          As employee,
                    to_char(ve.dob, 'dd-Mon-yyyy')   As "emp_dob",
                    ve.parent,
                    ve.grade,
                    ve.desgcode                      As designation,
                    ve.email,
                    Null                             As mobileno,
                    vppd.name,
                    rm.relation,
                    to_char(vppd.dob, 'dd-Mon-yyyy') As "dob",
                    vppd.gender,
                    ism.insured_sum_words,
                    trunc(vppd.modified_on)          modified_on,
                    (
                        Select
                            Count(vppd1.key_id)
                        From
                            vpp_voluntary_parent_policy_d vppd1
                        Where
                            vppd1.f_key_id = vpp.key_id
                    )                                As parents_count,
                    (
                        Select
                            premium
                        From
                            vpp_premium_master
                        Where
                            insured_sum_id    = vpp.insured_sum_id
                            And config_key_id = vpp.config_key_id
                            And persons       = (
                                      Select
                                          Count(*)
                                      From
                                          vpp_voluntary_parent_policy_d
                                      Where
                                          f_key_id = vpp.key_id
                                  )
                    )                                As premium_amt,
                    (
                        Select
                            gst_amt
                        From
                            vpp_premium_master
                        Where
                            insured_sum_id    = vpp.insured_sum_id
                            And config_key_id = vpp.config_key_id
                            And persons       = (
                                      Select
                                          Count(*)
                                      From
                                          vpp_voluntary_parent_policy_d
                                      Where
                                          f_key_id = vpp.key_id
                                  )
                    )                                As gst_amt,
                    (
                        Select
                            total_premium
                        From
                            vpp_premium_master
                        Where
                            insured_sum_id    = vpp.insured_sum_id
                            And config_key_id = vpp.config_key_id
                            And persons       = (
                                      Select
                                          Count(*)
                                      From
                                          vpp_voluntary_parent_policy_d
                                      Where
                                          f_key_id = vpp.key_id
                                  )
                    )                                As total_premium
                From
                    vpp_voluntary_parent_policy   vpp,
                    vpp_voluntary_parent_policy_d vppd,
                    vpp_insured_sum_master        ism,
                    vpp_relation_master           rm,
                    vpp_grade_group_master        ggm,
                    vpp_vu_emplmast               ve
                Where
                    (upper(ve.name) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.name) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(rm.relation) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.dob) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.gender) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(ism.insured_sum_words) Like upper('%' || Trim(p_generic_search) || '%') Or
                        upper(vppd.modified_on) Like upper('%' || Trim(p_generic_search) || '%'))
                    And vpp.empno             = nvl(p_empno, vpp.empno)
                    And vpp.is_lock           = 0
                    And ism.insured_sum_words = nvl(p_insured_sum_words, ism.insured_sum_words)
                    And vppd.modified_on Between nvl(p_modified_on_from, vppd.modified_on) And nvl(p_modified_on_to, vppd.
                    modified_on)
                    And vpp.key_id            = vppd.f_key_id
                    And vpp.insured_sum_id    = ism.insured_sum_id
                    And vppd.relation_id      = rm.relation_id
                    And vpp.empno             = ve.empno
                    And ve.status          = 1
                    And ve.emptype In ('R', 'F')
                    And ism.is_active         = 1
                    And rm.is_active          = 1
                    And ggm.grade_grp         = substr(ve.grade, 1, 1)
                Order By
                    modified_on Desc;
        End If;
        Return c;
    End fn_vpp_hr_list_not_locked_xl;

    Function fn_vpp_hr_list_not_filed_xl(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_generic_search    Varchar2 Default Null,
        p_empno             Varchar2 Default Null,
        p_insured_sum_words Varchar2 Default Null,
        p_modified_on_from  Date     Default Null,
        p_modified_on_to    Date Default Null
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
                ve.empno,
                ve.name                        As employee,
                to_char(ve.dob, 'dd-Mon-yyyy') As "emp_dob",
                ve.parent,
                ve.grade,
                ve.desgcode                    As designation,
                ve.email
            From
                vpp_vu_emplmast ve
            Where
                ve.status = 1
                And ve.empno Not In (
                    Select
                        a.empno
                    From
                        vpp_voluntary_parent_policy a
                )
            Order By
                ve.empno;

        Return c;
    End fn_vpp_hr_list_not_filed_xl;

    Function fn_vpp_hr_detail_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_key_id    Varchar2
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
                vppd.key_id   As key_id,
                vppd.name,
                vppr.relation,
                to_char(vppd.dob, 'dd-Mon-yyyy') As dob,
                vppd.gender,
                Row_Number() Over(Order By
                        vppd.modified_on Desc)   row_number,
                Count(*) Over()                  total_row
            From
                vpp_voluntary_parent_policy_d vppd,
                vpp_relation_master           vppr
            Where
                vppd.f_key_id        = p_key_id
                And vppr.relation_id = vppd.relation_id
            Order By
                vppd.dob;
        Return c;
    End fn_vpp_hr_detail_list;

    Procedure sp_vpp_hr_detail(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_application_id    Out Varchar2,
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
        v_config_id          Varchar2(8);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        /*
                Select
                    vpp.key_id,
                    ve.name,
                    vpp.insured_sum_id,
                    ism.insured_sum_words,
                    is_lock
                Into
                    p_application_id,
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
                    And vpp.empno      = Trim(p_empno)
                    And ve.emptype In ('R', 'F')
                    And ism.is_active  = 1
                    And ggm.grade_grp  = (
                         Select
                             substr(grade, 1, 1)
                         From
                             vpp_vu_emplmast
                         Where
                             empno = Trim(p_empno)
                             And grade Is Not Null
                     );
        
                If (p_application_id Is Not Null) Then
                    Select
                        premium, gst_amt, total_premium
                    Into
                        p_premium_amt,
                        p_gst_amt,
                        p_total_premium
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
        */
        Select
            vpp.key_id,
            -- vpp.empno,
            ve.name,
            vpp.insured_sum_id,
            ism.insured_sum_words,
            is_lock,
            vpp.config_key_id
        Into
            p_application_id,
            -- p_empno,
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
            And ve.status         = 1
            And vpp.config_key_id = config.key_id
            And vpp.empno         = Trim(p_empno)
            And ve.emptype In ('R', 'F')
            And ism.is_active     = 1
            And ggm.grade_grp     = (
                    Select
                        substr(grade, 1, 1)
                    From
                        vpp_vu_emplmast
                    Where
                        empno = Trim(p_empno)
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
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_vpp_hr_detail;

    Function fn_is_parent_delete_allowed(
        p_key_id Varchar
    ) Return Number
    As
        v_count Number := -1;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            vpp_voluntary_parent_policy_d
        Where
            key_id                = p_key_id
            And is_delete_allowed = 1;

        If v_count > 0 Then
            v_count := 1;
        Else
            v_count := 0;
        End If;

        Return v_count;

    Exception
        When Others Then
            Return 0;
    End;

End vpp_hr_qry;
/