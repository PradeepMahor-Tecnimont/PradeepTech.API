Create Or Replace Package Body "TCMPL_HR"."PKG_DG_MID_EVALUATION_QRY" As

    Function fn_dg_mid_evaluation_pending_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_for_hod_or_hr  Varchar2,
        p_generic_search Varchar2 Default Null,
        p_grade          Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        v_empno              Varchar2(5);
        v_start_from_date    Date := To_Date ('2023-07-3', 'yyyy-MM-dd');
        v_get_from_date      Date := add_months(trunc(sysdate), -3);     -- Past 3 months
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_for_hod_or_hr = 'HOD' Then
            Open c For
                Select
                    key_id,
                    empno,
                    name,
                    abbr,
                    grade,
                    emptype,
                    email,
                    assign,
                    parent,
                    doj,
                    hod_approval,
                    (Case
                         When key_id Is Null Then
                             ''
                         Else
                             'Draft'
                     End) As status,
                    row_number,
                    total_row
                From
                    (
                        Select
                            b.key_id,
                            a.empno                                empno,
                            a.name                                 name,
                            a.abbr                                 abbr,
                            a.grade                                grade,
                            a.emptype                              emptype,
                            a.email                                email,
                            a.assign                               assign,
                            a.parent                               parent,
                            a.doj                                  doj,
                            b.hod_approval,
                            Row_Number() Over(Order By a.doj Desc) row_number,
                            Count(*) Over()                        total_row
                        From
                            vu_emplmast                       a
                            Left Outer Join dg_mid_evaluation b
                            On a.empno = b.empno
                        Where
                            a.status                      = 1
                            And a.emptype                 = 'R'
                            And nvl(hod_approval, not_ok) = not_ok
                            And (a.doj >= v_start_from_date And
                                add_months(a.doj, 3) <= trunc(sysdate))
                            And a.grade In (
                                Select
                                    grade
                                From
                                    dg_mid_evaluation_grade c
                            )
                            And a.parent                  = nvl(p_parent, a.parent)
                            And a.grade                   = nvl(p_grade, a.grade)

                            And
                            a.parent In (
                                Select
                                    costcode
                                From
                                    vu_costmast
                                Where
                                    hod = v_empno
                                Union
                                Select
                                    costcode
                                From
                                    tcmpl_app_config.sec_module_user_roles_costcode
                                Where
                                    empno         = v_empno
                                    And module_id = 'M19'
                                    And role_id   = 'R003'
                            )
                            And (upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%')
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            Return c;
        End If;

        If p_for_hod_or_hr = 'HR' Then
            Open c For
                Select
                    key_id,
                    empno,
                    name,
                    abbr,
                    grade,
                    emptype,
                    email,
                    assign,
                    parent,
                    doj,
                    hod_approval,
                    (Case
                         When key_id Is Null Then
                             ''
                         Else
                             'Draft'
                     End) As status,
                    row_number,
                    total_row
                From
                    (
                        Select
                            b.key_id,
                            a.empno                                empno,
                            a.name                                 name,
                            a.abbr                                 abbr,
                            a.grade                                grade,
                            a.emptype                              emptype,
                            a.email                                email,
                            a.assign                               assign,
                            a.parent                               parent,
                            a.doj                                  doj,
                            b.hod_approval,
                            Row_Number() Over(Order By a.doj Desc) row_number,
                            Count(*) Over()                        total_row
                        From
                            vu_emplmast                       a
                            Left Outer Join dg_mid_evaluation b
                            On a.empno = b.empno
                        Where
                            a.status                        = 1
                            And a.emptype                   = 'R'
                            And nvl(b.hod_approval, not_ok) = not_ok
                            And 
                            --b.hod_approval = ok And
                            (a.doj >= v_start_from_date And
                                add_months(a.doj, 3) <= trunc(sysdate))
                            And a.grade In (
                                Select
                                    grade
                                From
                                    dg_mid_evaluation_grade c
                            )
                            And a.parent                    = nvl(p_parent, a.parent)
                            And a.grade                     = nvl(p_grade, a.grade)
                            And
                            (upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%')
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            Return c;
        End If;

    End fn_dg_mid_evaluation_pending_list;

    Function fn_dg_mid_evaluation_history_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_for_hod_or_hr  Varchar2,
        p_generic_search Varchar2 Default Null,
        p_grade          Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        v_empno              Varchar2(5);
        v_start_from_date    Date := To_Date ('2023-07-3', 'yyyy-MM-dd');
        v_get_from_date      Date := add_months(trunc(sysdate), -3);     -- Past 3 months
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_for_hod_or_hr = 'HOD' Then
            Open c For
                Select
                    key_id,
                    empno,
                    name,
                    abbr,
                    grade,
                    emptype,
                    email,
                    assign,
                    parent,
                    doj,
                    hod_approval,
                    row_number,
                    total_row
                From
                    (
                        Select
                            b.key_id,
                            a.empno                                empno,
                            a.name                                 name,
                            a.abbr                                 abbr,
                            a.grade                                grade,
                            a.emptype                              emptype,
                            a.email                                email,
                            a.assign                               assign,
                            a.parent                               parent,
                            a.doj                                  doj,
                            b.hod_approval,
                            Row_Number() Over(Order By a.doj Desc) row_number,
                            Count(*) Over()                        total_row
                        From
                            vu_emplmast                       a
                            Left Outer Join dg_mid_evaluation b
                            On a.empno = b.empno
                        Where
                            a.status         = 1
                            And a.emptype    = 'R'
                            And hod_approval = ok
                            And b.key_id Is Not Null
                            And (a.doj >= '3-Jul-2023' And
                                add_months(a.doj, 3) <= add_months(trunc(sysdate), 3))
                            And
                            a.parent In (
                                Select
                                    costcode
                                From
                                    vu_costmast
                                Where
                                    hod = v_empno
                                Union
                                Select
                                    costcode
                                From
                                    tcmpl_app_config.sec_module_user_roles_costcode
                                Where
                                    empno         = v_empno
                                    And module_id = 'M19'
                                    And role_id   = 'R003'
                            )
                            And a.parent     = nvl(p_parent, a.parent)
                            And a.grade      = nvl(p_grade, a.grade)

                            And
                            a.parent In (
                                Select
                                    costcode
                                From
                                    vu_costmast
                                Where
                                    hod = v_empno
                                Union
                                Select
                                    costcode
                                From
                                    tcmpl_app_config.sec_module_user_roles_costcode
                                Where
                                    empno         = v_empno
                                    And module_id = 'M19'
                                    And role_id   = 'R003'
                            )
                            And
                            (upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%')
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            Return c;
        End If;

        If p_for_hod_or_hr = 'HR' Then
            Open c For
                Select
                    key_id,
                    empno,
                    name,
                    abbr,
                    grade,
                    emptype,
                    email,
                    assign,
                    parent,
                    doj,
                    hod_approval,
                    row_number,
                    total_row
                From
                    (
                        Select
                            b.key_id,
                            a.empno                                empno,
                            a.name                                 name,
                            a.abbr                                 abbr,
                            a.grade                                grade,
                            a.emptype                              emptype,
                            a.email                                email,
                            a.assign                               assign,
                            a.parent                               parent,
                            a.doj                                  doj,
                            b.hod_approval,
                            Row_Number() Over(Order By a.doj Desc) row_number,
                            Count(*) Over()                        total_row
                        From
                            vu_emplmast                       a
                            Left Outer Join dg_mid_evaluation b
                            On a.empno = b.empno
                        Where
                            a.status         = 1
                            And a.emptype    = 'R'
                            And hod_approval = ok
                            And b.key_id Is Not Null
                            And (a.doj <= v_get_from_date)
                            And a.parent     = nvl(p_parent, a.parent)
                            And a.grade      = nvl(p_grade, a.grade)
                            And
                            (upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%')
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            Return c;
        End If;

    End fn_dg_mid_evaluation_history_list;

    Function fn_dg_mid_evaluation_hod_pending_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_grade          Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        v_empno              Varchar2(5);
        v_start_from_date    Date := To_Date ('2023-07-3', 'yyyy-MM-dd');
        v_get_from_date      Date := add_months(trunc(sysdate), -3);     -- Past 3 months
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Return fn_dg_mid_evaluation_pending_list(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,
                p_for_hod_or_hr  => 'HOD',
                p_generic_search => p_generic_search,
                p_grade          => p_grade,
                p_parent         => p_parent,
                p_row_number     => p_row_number,
                p_page_length    => p_page_length
            );
    End fn_dg_mid_evaluation_hod_pending_list;

    Function fn_dg_mid_evaluation_hr_pending_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_grade          Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        v_empno              Varchar2(5);
        v_start_from_date    Date := To_Date ('2023-07-3', 'yyyy-MM-dd');
        v_get_from_date      Date := add_months(trunc(sysdate), -3);     -- Past 3 months
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Return fn_dg_mid_evaluation_pending_list(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,
                p_for_hod_or_hr  => 'HR',
                p_generic_search => p_generic_search,
                p_grade          => p_grade,
                p_parent         => p_parent,
                p_row_number     => p_row_number,
                p_page_length    => p_page_length
            );
    End fn_dg_mid_evaluation_hr_pending_list;

    Function fn_dg_mid_evaluation_hod_history_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_grade          Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        v_empno              Varchar2(5);
        v_start_from_date    Date := To_Date ('2023-07-3', 'yyyy-MM-dd');
        v_get_from_date      Date := add_months(trunc(sysdate), -3);     -- Past 3 months
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Return fn_dg_mid_evaluation_history_list(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,
                p_for_hod_or_hr  => 'HOD',
                p_generic_search => p_generic_search,
                p_grade          => p_grade,
                p_parent         => p_parent,
                p_row_number     => p_row_number,
                p_page_length    => p_page_length
            );
    End fn_dg_mid_evaluation_hod_history_list;

    Function fn_dg_mid_evaluation_hr_history_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_grade          Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        v_empno              Varchar2(5);
        v_start_from_date    Date := To_Date ('2023-07-3', 'yyyy-MM-dd');
        v_get_from_date      Date := add_months(trunc(sysdate), -3);     -- Past 3 months
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Return fn_dg_mid_evaluation_history_list(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,
                p_for_hod_or_hr  => 'HR',
                p_generic_search => p_generic_search,
                p_grade          => p_grade,
                p_parent         => p_parent,
                p_row_number     => p_row_number,
                p_page_length    => p_page_length
            );
    End fn_dg_mid_evaluation_hr_history_list;

    Procedure sp_dg_mid_evaluation_detail(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_key_id                 Varchar2,
        p_empno              Out Varchar2,
        p_desgcode           Out Varchar2,
        p_parent             Out Varchar2,
        p_attendance         Out Varchar2,
        p_location           Out Varchar2,
        p_skill1             Out Varchar2,
        p_skill1_rating_val  Out Number,
        p_skill1_rating_text Out Varchar2,
        p_skill1_remark      Out Varchar2,
        p_skill2             Out Varchar2,
        p_skill2_rating_val  Out Number,
        p_skill2_rating_text Out Varchar2,
        p_skill2_remark      Out Varchar2,
        p_skill3             Out Varchar2,
        p_skill3_rating_val  Out Number,
        p_skill3_rating_text Out Varchar2,
        p_skill3_remark      Out Varchar2,
        p_skill4             Out Varchar2,
        p_skill4_rating_val  Out Number,
        p_skill4_rating_text Out Varchar2,
        p_skill4_remark      Out Varchar2,
        p_skill5             Out Varchar2,
        p_skill5_rating_val  Out Number,
        p_skill5_rating_text Out Varchar2,
        p_skill5_remark      Out Varchar2,
        p_que2_rating_val    Out Number,
        p_que2_rating_text   Out Varchar2,
        p_que2_remark        Out Varchar2,
        p_que3_rating_val    Out Number,
        p_que3_rating_text   Out Varchar2,
        p_que3_remark        Out Varchar2,
        p_que4_rating_val    Out Number,
        p_que4_rating_text   Out Varchar2,
        p_que4_remark        Out Varchar2,
        p_que5_rating_val    Out Number,
        p_que5_rating_text   Out Varchar2,
        p_que5_remark        Out Varchar2,
        p_que6_rating_val    Out Number,
        p_que6_rating_text   Out Varchar2,
        p_que6_remark        Out Varchar2,
        p_observations       Out Varchar2,
        p_created_by         Out Varchar2,
        p_created_on         Out Varchar2,
        p_modified_by        Out Varchar2,
        p_modified_on        Out Varchar2,
        p_isdeleted          Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hod_approval_date  Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5) := 'NA';
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            dg_mid_evaluation
        Where
            empno = p_key_id;

        Select
            Count(*)
        Into
            v_exists
        From
            dg_mid_evaluation
        Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Select
                empno,
                desgcode,
                parent,
                attendance,
                location,
                skill_1,
                skill_1_rating,
                get_rating_text(skill_1_rating),
                skill_1_remark,
                skill_2,
                skill_2_rating,
                get_rating_text(skill_2_rating),
                skill_2_remark,
                skill_3,
                skill_3_rating,
                get_rating_text(skill_3_rating),
                skill_3_remark,
                skill_4,
                skill_4_rating,
                get_rating_text(skill_4_rating),
                skill_4_remark,
                skill_5,
                skill_5_rating,
                get_rating_text(skill_5_rating),
                skill_5_remark,
                que_2_rating,
                get_rating_text(que_2_rating),
                que_2_remark,
                que_3_rating,
                get_rating_text(que_3_rating),
                que_3_remark,
                que_4_rating,
                get_rating_text(que_4_rating),
                que_4_remark,
                que_5_rating,
                get_rating_text(que_5_rating),
                que_5_remark,
                que_6_rating,
                get_rating_text(que_6_rating),
                que_6_remark,
                observations,
                created_by,
                --to_char(created_on, 'DD-Mon-YYYY') as created_on,
                created_on,
                modified_by,
                --to_char(modified_on, 'DD-Mon-YYYY') as modified_on,
                modified_on,
                isdeleted,
                hod_approval,
                hod_approval_date
            Into
                p_empno,
                p_desgcode,
                p_parent,
                p_attendance,
                p_location,
                p_skill1,
                p_skill1_rating_val,
                p_skill1_rating_text,
                p_skill1_remark,
                p_skill2,
                p_skill2_rating_val,
                p_skill2_rating_text,
                p_skill2_remark,
                p_skill3,
                p_skill3_rating_val,
                p_skill3_rating_text,
                p_skill3_remark,
                p_skill4,
                p_skill4_rating_val,
                p_skill4_rating_text,
                p_skill4_remark,
                p_skill5,
                p_skill5_rating_val,
                p_skill5_rating_text,
                p_skill5_remark,
                p_que2_rating_val,
                p_que2_rating_text,
                p_que2_remark,
                p_que3_rating_val,
                p_que3_rating_text,
                p_que3_remark,
                p_que4_rating_val,
                p_que4_rating_text,
                p_que4_remark,
                p_que5_rating_val,
                p_que5_rating_text,
                p_que5_remark,
                p_que6_rating_val,
                p_que6_rating_text,
                p_que6_remark,
                p_observations,
                p_created_by,
                p_created_on,
                p_modified_by,
                p_modified_on,
                p_isdeleted,
                p_hod_approval,
                p_hod_approval_date
            From
                dg_mid_evaluation
            Where
                key_id = p_key_id;
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching record exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_dg_mid_evaluation_detail;

    Procedure sp_dg_mid_evaluation_get_key_id(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_key_id       Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5) := 'NA';
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(key_id)
        Into
            v_exists
        From
            dg_mid_evaluation
        Where
            empno = p_empno;

        If v_exists = 1 Then
            Select
                key_id
            Into
                p_key_id
            From
                dg_mid_evaluation
            Where
                empno = p_empno;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching record exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_dg_mid_evaluation_get_key_id;

    Function get_rating_text(
        p_rating In Number
    ) Return Varchar2 As
        v_return_val Varchar2(50);
    Begin
        v_return_val := 'no data found';
        If p_rating Is Null Then
            Return '';
        End If;
        Select
            rating_desc
        Into
            v_return_val
        From
            dg_rating_master
        Where
            rating_id = p_rating;

        Return v_return_val;
    Exception
        When Others Then
            Return 'ERRRR';
    End get_rating_text;

End pkg_dg_mid_evaluation_qry;