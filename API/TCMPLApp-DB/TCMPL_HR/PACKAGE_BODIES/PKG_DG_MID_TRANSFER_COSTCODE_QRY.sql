Create Or Replace Package Body "TCMPL_HR"."PKG_DG_MID_TRANSFER_COSTCODE_QRY" As

    Function fn_get_remarks(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_key_id                  Varchar2,
        p_action_id               Varchar2
    ) Return Varchar2 As    
        v_remarks                 dg_mid_transfer_costcode_approvals.remarks%type;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
    
        Select remarks into v_remarks from dg_mid_transfer_costcode_approvals
            Where apprl_action_id = p_action_id
            and key_id = trim(p_key_id);
        Return v_remarks;
    Exception
        When Others Then
            Return Null;
    End;       
    
    Function fn_dg_mid_transfer_costcode_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode       a,
                        dg_vu_module_user_role_actions dvmura
                    Where
                        dvmura.costcode        = a.current_costcode
                        And a.transfer_type_fk != 2
                        And dvmura.empno       = Trim(v_empno)
                        And dvmura.action_id   = c_source_action_id
                        And a.current_costcode = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode  = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_mid_transfer_costcode_list;

    Function fn_dg_hod_transfer_costcode_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                key_id                                      As key_id,
                transfer_type                               As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type)   As transfer_type_text,
                emp_no                                      As emp_no,
                get_emp_name(emp_no)                        As emp_name,
                current_costcode                            As current_costcode,
                target_costcode                             As target_costcode,
                transfer_date                               As transfer_date,
                remarks                                     As remarks,
                status                                      As status_val,
                fun_get_status_desc(status)                 As status_text,
                effective_transfer_date                     As effective_transfer_date,
                desgcode                                    As desgcode_val,
                fun_get_desg_desc(desgcode)               As desgcode_text,
                modified_on                                 As modified_on,
                modified_by                                 As modified_by,
                apprl_action_id                             As apprl_action_id,
                apprl_action_desc                           As apprl_action_desc,
                fn_is_approval_due(key_id, apprl_action_id) As is_approval_due,
                Row_Number() Over(Order By
                        modified_on Desc)                   row_number,
                Count(*) Over()                             total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        mtca.apprl_action_id                           As apprl_action_id,
                        atd.action_desc                                As apprl_action_desc,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode           a,
                        dg_mid_transfer_costcode_approvals mtca,
                        dg_vu_module_user_role_actions     dvmura,
                        dg_apprl_template_details          atd
                    Where
                        ((dvmura.costcode            = a.target_costcode
                                And dvmura.action_id = c_target_action_id)
                            Or
                            dvmura.action_id         In (c_hr_action_id,c_hr_hod_action_id))
                        And a.key_id                 = mtca.key_id
                        And atd.dg_key_id            = mtca.dg_key_id
                        And atd.apprl_action_id      = mtca.apprl_action_id
                        And mtca.apprl_action_id     = dvmura.action_id
                        And dvmura.module_id         = c_module_id
                        And a.status                 = 0
                        And mtca.is_approved Is Null
                        And dvmura.empno             = Trim(v_empno)
                        And a.current_costcode       = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode        = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_hod_transfer_costcode_list;

    Function fn_dg_hr_transfer_costcode_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode           a,
                        dg_mid_transfer_costcode_approvals mtca
                    Where
                        a.key_id                  = mtca.key_id
                        And mtca.apprl_action_id In (
                            Select
                                dvmura.action_id
                            From
                                dg_vu_module_user_role_actions dvmura
                            Where
                                dvmura.empno         = Trim(v_empno)
                                And dvmura.action_id In (c_hr_action_id,c_hr_hod_action_id)
                                And dvmura.module_id = c_module_id
                        )
                        And a.status              = 0
                        And mtca.is_approved Is Null
                        And ((mtca.key_id, mtca.parent_apprl_action_id) In (
                                Select
                                    mtca1.key_id, mtca1.apprl_action_id
                                From
                                    dg_mid_transfer_costcode_approvals mtca1
                                Where
                                    mtca1.is_approved = ok
                            )
                            Or a.transfer_type_fk = 2)
                        And a.current_costcode    = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode     = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_hr_transfer_costcode_list;

    Function fn_dg_return_transfer_costcode_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode           a,
                        dg_mid_transfer_costcode_approvals mtca
                    Where
                        a.key_id               = mtca.key_id
                        And mtca.apprl_action_id In (
                            Select
                                dvmura.action_id
                            From
                                dg_vu_module_user_role_actions dvmura
                            Where
                                dvmura.empno         = Trim(v_empno)
                                And dvmura.action_id In (c_hr_action_id,c_hr_hod_action_id)
                                And dvmura.module_id = c_module_id
                        )
                        And a.status           = 0
                        And mtca.is_approved Is Null
                        And a.transfer_type_fk = 2
                        And a.current_costcode = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode  = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.current_costcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.target_costcode) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_return_transfer_costcode_list;

    Procedure sp_dg_mid_transfer_costcode_details(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,

        p_key_id                      Varchar2,
        p_transfer_type_val       Out Number,
        p_transfer_type_text      Out Varchar2,
        p_emp_no                  Out Varchar2,
        p_emp_name                Out Varchar2,
        p_current_costcode_val    Out Varchar2,
        p_current_costcode_text   Out Varchar2,
        p_target_costcode_val     Out Varchar2,
        p_target_costcode_text    Out Varchar2,
        p_transfer_date           Out Date,
        p_transfer_end_date       Out Date,
        p_remarks                 Out Varchar2,
        p_status_val              Out Number,
        p_status_text             Out Varchar2,
        p_effective_transfer_date Out Date,
        p_desgcode_val            Out Varchar2,
        p_desgcode_text           Out Varchar2,
        p_site_code               Out Varchar2,
        p_job_group_code          Out Varchar2,
        p_job_group               Out Varchar2,
        p_jobdiscipline_code      Out Varchar2,
        p_jobdiscipline           Out Varchar2,
        p_jobtitle_code           Out Varchar2,
        p_jobtitle                Out Varchar2,
        p_modified_on             Out Date,
        p_modified_by             Out Varchar2,
        p_target_hod_remarks      Out Varchar2,
        p_hr_remarks              Out Varchar2,
        p_hr_hod_remarks          Out Varchar2,
        p_desgcode_new            Out Varchar2,
        p_desg_new                Out Varchar2,
        p_job_group_code_new      Out Varchar2,
        p_job_group_new           Out Varchar2,
        p_jobdiscipline_code_new  Out Varchar2,
        p_jobdiscipline_new       Out Varchar2,
        p_jobtitle_code_new       Out Varchar2,
        p_jobtitle_new            Out Varchar2,
        p_site_name               Out Varchar2,
        p_site_location           Out Varchar2,
        
        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
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
            dg_mid_transfer_costcode
        Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Select
                mtc.transfer_type_fk,
                fun_get_transfer_type_desc(mtc.transfer_type_fk),
                mtc.emp_no,
                get_emp_name(mtc.emp_no),
                mtc.current_costcode,
                fun_get_costcode_name(mtc.current_costcode),
                mtc.target_costcode,
                fun_get_costcode_name(mtc.target_costcode),
                mtc.transfer_date,
                mtc.transfer_end_date,
                mtc.remarks,
                mtc.status,
                fun_get_status_desc(mtc.status),
                mtc.effective_transfer_date,
                e.desgcode,
                mtc.site_code,
                e.jobgroup,
                e.jobgroupdesc,
                e.jobdiscipline,
                e.jobdisciplinedesc,
                e.jobtitle_code,
                e.jobtitle,
                mtc.modified_on,
                mtc.modified_by,
                fn_get_remarks(p_person_id => p_person_id,
                               p_meta_id  => p_meta_id,

                               p_key_id => p_key_id,
                               p_action_id => c_target_action_id),
                fn_get_remarks(p_person_id => p_person_id,
                               p_meta_id  => p_meta_id,

                               p_key_id => p_key_id,
                               p_action_id => c_hr_action_id),
                fn_get_remarks(p_person_id => p_person_id,
                               p_meta_id  => p_meta_id,

                               p_key_id => p_key_id,
                               p_action_id => c_hr_hod_action_id)                
            Into
                p_transfer_type_val,
                p_transfer_type_text,
                p_emp_no,
                p_emp_name,
                p_current_costcode_val,
                p_current_costcode_text,
                p_target_costcode_val,
                p_target_costcode_text,
                p_transfer_date,
                p_transfer_end_date,
                p_remarks,
                p_status_val,
                p_status_text,
                p_effective_transfer_date,
                p_desgcode_val,
                p_site_code,
                p_job_group_code,
                p_job_group,
                p_jobdiscipline_code,
                p_jobdiscipline,
                p_jobtitle_code,
                p_jobtitle,
                p_modified_on,
                p_modified_by,
                p_target_hod_remarks,
                p_hr_remarks,
                p_hr_hod_remarks
            From
                dg_mid_transfer_costcode mtc,
                vu_emplmast              e                
            Where
                mtc.emp_no     = e.empno
                And mtc.key_id = p_key_id;
            
            Begin
                Select 
                    mtcpp_d.desgcode,
                    d.desg,
                    mtcpp_jgm.job_group_code,
                    jgm.job_group,
                    mtcpp_jdm.jobdiscipline_code,
                    jdm.jobdiscipline,
                    mtcpp_jtm.jobtitle_code,
                    jtm.jobtitle
                Into
                    p_desgcode_new,     
                    p_desg_new,
                    p_job_group_code_new,  
                    p_job_group_new,
                    p_jobdiscipline_code_new,      
                    p_jobdiscipline_new,
                    p_jobtitle_code_new,
                    p_jobtitle_new
                From
                    dg_mid_transfer_costcode_perm_payroll mtcpp_d,
                    dg_mid_transfer_costcode_perm_payroll mtcpp_jgm,
                    dg_mid_transfer_costcode_perm_payroll mtcpp_jdm,
                    dg_mid_transfer_costcode_perm_payroll mtcpp_jtm,
                    vu_desgmast d,
                    vu_hr_jobgroup_master jgm,
                    vu_hr_jobdiscipline_master jdm,
                    vu_hr_jobtitle_master jtm
                Where
                        mtcpp_d.desgcode = d.desgcode
                    And mtcpp_jgm.job_group_code = jgm.job_group_code
                    And mtcpp_jdm.jobdiscipline_code = jdm.jobdiscipline_code
                    And mtcpp_jtm.jobtitle_code = jtm.jobtitle_code
                    And mtcpp_d.key_id = mtcpp_jgm.key_id 
                    And mtcpp_d.key_id = mtcpp_jdm.key_id 
                    And mtcpp_d.key_id = mtcpp_jtm.key_id 
                    And mtcpp_d.key_id = p_key_id;
            Exception
                When Others Then
                    p_desgcode_new := Null;              
                    p_job_group_code_new := Null;
                    p_jobdiscipline_code_new := Null;
                    p_jobtitle_code_new  := Null;
                    p_desg_new := Null;              
                    p_job_group_new := Null;
                    p_jobdiscipline_new := Null;
                    p_jobtitle_new  := Null;
            End;
            
            Begin
                Select 
                    sm.site_name,
                    sm.site_location
                Into                     
                    p_site_name,
                    p_site_location
                From 
                    dg_site_master           sm
                Where 
                    sm.key_id = Trim(p_site_code);
            Exception
                When Others Then
                    p_site_name := Null;
                    p_site_location := Null;
            End;
            
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';                       
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Costcode transfer exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_dg_mid_transfer_costcode_details;

    Function fn_dg_hod_transfer_costcode_history_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                apprl_action_desc                         As apprl_action_desc,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        Case     
                        When mtca.is_approved = 'OK' Then 1
                        When mtca.is_approved = 'KO' Then -1
                        When mtca.is_approved Is Null Then a.status
                        End                                            As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        atd.action_desc                                As apprl_action_desc,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode           a,
                        dg_mid_transfer_costcode_approvals mtca,
                        dg_vu_module_user_role_actions     dvmura,
                        dg_apprl_template_details          atd
                    Where
                        a.key_id                     = mtca.key_id
                        And atd.dg_key_id            = mtca.dg_key_id
                        And atd.apprl_action_id      = mtca.apprl_action_id
                        And dvmura.empno             = v_empno
                        And ((dvmura.costcode        = a.target_costcode
                                And dvmura.action_id = c_target_action_id)
                            Or dvmura.action_id      In (c_hr_action_id,c_hr_hod_action_id))
                        And dvmura.action_id         = atd.apprl_action_id
                        And a.status != 2
                        And atd.apprl_action_id != c_job_scheduler_action_id
                        And a.current_costcode       = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode        = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_hod_transfer_costcode_history_list;

    Function fn_dg_hr_transfer_costcode_history_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode a
                    Where
                        a.status In (1, -1, 3)
                        And a.current_costcode = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode  = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_hr_transfer_costcode_history_list;

    Function fn_dg_temporary_employees_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                Nvl(fn_get_last_transfer_end_date(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_key_id       => key_id
                ), transfer_end_date)                     As transfer_end_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                flag                                      As flag,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.transfer_end_date                            As transfer_end_date, 
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        a.flag                                         As flag,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode       a,
                        dg_vu_module_user_role_actions dvmura
                    Where
                        dvmura.empno           = v_empno
                        And dvmura.costcode    = a.target_costcode
                        And a.transfer_type_fk = 1
                        And a.status = 1
                        And a.current_costcode != a.target_costcode
                        And dvmura.action_id   = c_target_action_id
                        And a.current_costcode = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode  = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_temporary_employees_list;

    Function fn_get_apprl_status(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_key_id      Varchar2,

        p_row_number  Number Default Null,
        p_page_length Number Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                (Case
                     When is_approved = 'OK' Then
                         'Approved'
                     When is_approved = 'KO' Then
                         'Rejected'
                     Else
                         'Pending'
                 End)                                             approval_status,
                modified_on,
                modified_by,
                get_emp_name(modified_by)                         As modified_by_name,
                fun_get_approval_name(apprl_action_id, dg_key_id) As approval_by,
                apprl_action_step,
                remarks,
                null as transfer_end_date
            From
                dg_mid_transfer_costcode_approvals
            Where
                key_id = p_key_id

            Union All

            Select
                'Approved'                                                  approval_status,
                modified_on,
                modified_by,
                get_emp_name(modified_by)                                   As modified_by_name,
                fun_get_approval_name(c_target_action_id, c_tmplt_temp_transfer) As approval_by,
                null As apprl_action_step,
                remarks,
                transfer_end_date
            From
                dg_mid_transfer_costcode_post_approvals_log
            Where
                key_id = p_key_id

            Order By
                2,6;
        Return c;
    End fn_get_apprl_status;

    Function fun_get_approval_name(
        p_apprl_action_id In Varchar2,
        p_dg_key_id       In Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(100) := 'NA';
        v_count   Number        := 0;
    Begin
        Select
            action_desc
        Into
            v_ret_val
        From
            dg_apprl_template_details
        Where
            dg_key_id           = p_dg_key_id
            And apprl_action_id = p_apprl_action_id;
        Return v_ret_val;
    Exception
        When Others Then
            Return v_ret_val;
    End fun_get_approval_name;

    Function fun_get_status_desc(
        p_status In Number
    ) Return Varchar2 As
        v_ret_val Varchar2(50) := 'NA';
        v_count   Number       := 0;
    Begin
        Select
            description
        Into
            v_ret_val
        From
            dg_mid_transfer_status
        Where
            value = p_status;
        Return v_ret_val;
    Exception
        When Others Then
            Return v_ret_val;
    End fun_get_status_desc;

    Function fun_get_transfer_type_desc(
        p_transfer_type In Number
    ) Return Varchar2 As
        v_ret_val Varchar2(50) := 'NA';
        v_count   Number       := 0;
    Begin
        Select
            description
        Into
            v_ret_val
        From
            dg_mid_transfer_type
        Where
            value = p_transfer_type;
        Return v_ret_val;
    Exception
        When Others Then
            Return v_ret_val;
    End fun_get_transfer_type_desc;

    Function fun_get_costcode_name(
        p_costcode In Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(100) := 'NA';
        v_count   Number        := 0;
    Begin
        Select
            vu_cost.name
        Into
            v_ret_val
        From
            vu_costmast vu_cost
        Where
            vu_cost.costcode = p_costcode;
        Return v_ret_val;
    Exception
        When Others Then
            Return v_ret_val;
    End fun_get_costcode_name;

    Function fn_costcode_empno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                e.empno                     data_value_field,
                e.empno || ' - ' || e.name  data_text_field,
                e.assign || ' - ' || c.name data_group_field
            From
                vu_emplmast e,
                vu_costmast c
            Where
                e.assign     = c.costcode
                And e.status = 1
                And e.assign In
                (
                    Select
                        costcode
                    From
                        dg_vu_module_user_role_actions
                    Where
                        action_id = c_source_action_id
                        And empno = v_empno
                )
                And e.empno != v_empno
                And e.parent = e.assign
                And (e.empno, e.assign) Not In (
                    Select
                        emp_no, current_costcode
                    From
                        dg_mid_transfer_costcode
                    Where
                        status In (0, 2, 3)
                )
            Order By
                3,
                1;
        Return c;
    End fn_costcode_empno_list;

    Function fn_costcode_dept_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        
        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                c.costcode                    data_value_field,
                c.costcode || ' - ' || c.name data_text_field
            From
                vu_costmast c
            Where
                c.costcode != trim(p_costcode)
            Order By
                1;
        Return c;
    End fn_costcode_dept_list;

    Function fn_dg_hr_transfer_costcode_approved_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode a
                    Where
                        a.status               = 1
                        And a.current_costcode = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode  = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_hr_transfer_costcode_approved_list;

    Function fn_dg_hr_transfer_costcode_xl(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_generic_search   Varchar2 Default Null,

        p_current_costcode Varchar2 Default Null,
        p_target_costcode  Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                transfer_end_date                         As transfer_end_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                apprl_action_desc                         As apprl_action_desc,
                modified_on                               As modified_on,
                modified_by || ' : ' || get_emp_name(modified_by) As modified_by 
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.transfer_end_date                            As transfer_end_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        atd.action_desc                                As apprl_action_desc,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode           a,
                        dg_mid_transfer_costcode_approvals mtca,
                        dg_vu_module_user_role_actions     dvmura,
                        dg_apprl_template_details          atd
                    Where
                        a.key_id                     = mtca.key_id
                        And atd.dg_key_id            = mtca.dg_key_id
                        And atd.apprl_action_id      = mtca.apprl_action_id
                        And dvmura.empno             = v_empno
                        And ((dvmura.costcode        = a.target_costcode
                                And dvmura.action_id = c_target_action_id)
                            Or dvmura.action_id      In (c_hr_action_id,c_hr_hod_action_id))
                        And a.status != 2
                        And dvmura.action_id         = atd.apprl_action_id
                        And atd.apprl_action_id != c_job_scheduler_action_id
                        And a.current_costcode       = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode        = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                );
        Return c;
    End fn_dg_hr_transfer_costcode_xl;

    Function fn_dg_hod_transfer_employee_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode a

                    Where
                        a.transfer_type_fk     = 1
                        And a.status           = 1
                        And a.current_costcode In (
                            Select
                                costcode
                            From
                                dg_vu_module_user_role_actions
                            Where
                                empno = v_empno
                        )
                        And a.current_costcode = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode  = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_hod_transfer_employee_list;

    Function fn_dg_hr_transfer_employee_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_generic_search          Varchar2 Default Null,
        p_transfer_type           Number   Default Null,
        p_current_costcode        Varchar2 Default Null,
        p_target_costcode         Varchar2 Default Null,
        p_transfer_date           Date     Default Null,
        p_status                  Number   Default Null,
        p_effective_transfer_date Date     Default Null,
        p_desgcode                Varchar2 Default Null,
        p_row_number              Number,
        p_page_length             Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        v_count              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            dg_vu_module_user_role_actions
        Where
            empno = v_empno;
        If v_count = 0 Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                key_id                                    As key_id,
                transfer_type                             As transfer_type_val,
                fun_get_transfer_type_desc(transfer_type) As transfer_type_text,
                emp_no                                    As emp_no,
                get_emp_name(emp_no)                      As emp_name,
                current_costcode                          As current_costcode,
                target_costcode                           As target_costcode,
                transfer_date                             As transfer_date,
                remarks                                   As remarks,
                status                                    As status_val,
                fun_get_status_desc(status)               As status_text,
                effective_transfer_date                   As effective_transfer_date,
                desgcode                                  As desgcode_val,
                fun_get_desg_desc(desgcode)             As desgcode_text,
                modified_on                               As modified_on,
                modified_by                               As modified_by,
                Row_Number() Over(Order By
                        modified_on Desc)                 row_number,
                Count(*) Over()                           total_row
            From
                (
                    Select
                        a.key_id                                       As key_id,
                        a.transfer_type_fk                             As transfer_type,
                        a.emp_no                                       As emp_no,
                        a.current_costcode                             As current_costcode,
                        a.target_costcode                              As target_costcode,
                        a.transfer_date                                As transfer_date,
                        a.remarks                                      As remarks,
                        a.status                                       As status,
                        a.effective_transfer_date                      As effective_transfer_date,
                        a.desgcode                                     As desgcode,
                        a.modified_on                                  As modified_on,
                        a.modified_by                                  As modified_by,
                        Row_Number() Over(Order By a.modified_on Desc) row_number,
                        Count(*) Over()                                total_row
                    From
                        dg_mid_transfer_costcode a
                    Where
                        a.transfer_type_fk     = 1
                        And a.status           = 1
                        And a.current_costcode = nvl(Trim(p_current_costcode), a.current_costcode)
                        And a.target_costcode  = nvl(Trim(p_target_costcode), a.target_costcode)
                        And (upper(a.emp_no) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dg_hr_transfer_employee_list;

    Function fn_is_approval_due(
        p_key_id          Varchar2,
        p_apprl_action_id Varchar2
    ) Return Varchar2 As
        rec_costcode_approvals dg_mid_transfer_costcode_approvals%rowtype;
        v_count                Number;
    Begin
        Begin
            Select
                *
            Into
                rec_costcode_approvals
            From
                dg_mid_transfer_costcode_approvals
            Where
                key_id              = p_key_id
                And apprl_action_id = p_apprl_action_id
                And nvl(is_approved, not_ok) != ok;

        Exception
            When Others Then
                Return not_ok;
        End;

        Select
            Count(*)
        Into
            v_count
        From
            (

                With
                    data As(
                        Select
                            a.dg_key_id,
                            a.apprl_action_id,
                            b.action_name,
                            nvl(a.parent_apprl_action_id, 'XXXX') parent_apprl_action_id,
                            nvl(is_approved, not_ok)              is_approved
                        From
                            dg_mid_transfer_costcode_approvals a,
                            dg_apprl_template_details          b
                        Where
                            a.dg_key_id           = b.dg_key_id
                            And a.apprl_action_id = b.apprl_action_id
                            And a.key_id          = p_key_id
                        Union
                        Select
                            'NULL', 'XXXX', 'BLANK', Null, Null
                        From
                            dual
                    )

                Select
                    dg_key_id,
                    apprl_action_id,
                    action_name,
                    is_approved                    is_approved,
                    level,
                    lpad('|', (level * 2) - 1) || '<-' || action_name,
                    Max(level) Over () + 1 - level rev_level,
                    Connect_By_Isleaf              As leaf,
                    Rownum                         As row_num
                From
                    data
                Connect By Prior apprl_action_id = parent_apprl_action_id
                Start
                With
                    apprl_action_id = p_apprl_action_id
            )
        Where
            apprl_action_id <> p_apprl_action_id
            And is_approved = not_ok;

        If v_count > 0 Then
            Return not_ok;
        Else
            Return ok;
        End If;

    End;

    Function fn_get_extension_details(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_key_id      Varchar2,

        p_row_number  Number Default Null,
        p_page_length Number Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For           
            Select
                'Approved'                                                  approval_status,
                modified_on,
                modified_by,
                get_emp_name(modified_by)                                   As modified_by_name,
                fun_get_approval_name(c_target_action_id, c_tmplt_temp_transfer) As approval_by,
                null As apprl_action_step,
                remarks,
                transfer_end_date
            From
                dg_mid_transfer_costcode_post_approvals_log
            Where
                key_id = p_key_id
            Order By
                modified_on;
        Return c;
    End fn_get_extension_details;
    
    Function fn_get_last_transfer_end_date(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_key_id      Varchar2
    ) Return Date As        
        v_transfer_end_date dg_mid_transfer_costcode_post_approvals_log.transfer_end_date%type;
    Begin
        Select 
            transfer_end_date
        Into 
            v_transfer_end_date
        From
        (
            Select 
                transfer_end_date
            From 
                dg_mid_transfer_costcode_post_approvals_log
            Where 
                key_id = Trim(p_key_id)
            Order by 
                modified_on Desc            
        )
        Where rownum = 1;
        
        Return v_transfer_end_date;
    Exception
        When Others Then
            Return Null;
    End;
    
    Function fun_get_desg_desc(
        p_desgcode In Char
    ) Return Varchar2 As
        v_ret_val vu_desgmast.desg%type := 'NA';
    Begin
        Select
            desg
        Into
            v_ret_val
        From
            vu_desgmast
        Where
            desgcode = p_desgcode;
        Return v_ret_val;
    Exception
        When Others Then
            Return v_ret_val;
    End fun_get_desg_desc;
    
End pkg_dg_mid_transfer_costcode_qry;