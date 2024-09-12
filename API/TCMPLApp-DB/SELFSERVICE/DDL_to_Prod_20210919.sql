--------------------------------------------------------
--  File created - Sunday-September-19-2021   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SS_LEAVETYPE
---------------------------
ALTER TABLE "SS_LEAVETYPE" ADD ("IS_ACTIVE" NUMBER(1,0));

---------------------------
--Changed PACKAGE
--XL_BLOB
---------------------------
CREATE OR REPLACE PACKAGE "XL_BLOB" As 

    Procedure upload_file (
        p_blob      Blob,
        p_blob_id   In          Varchar2,
        p_success   Out         Varchar2,
        p_message   Out         Varchar2
    );

    Procedure upload_blob_file (
        p_blob      Blob,
        p_blob_id   Out         Varchar2,
        p_success   Out         Varchar2,
        p_message   Out         Varchar2
    );

End xl_blob;
/
---------------------------
--New PACKAGE
--SCHEMA_OBJECTS
---------------------------
CREATE OR REPLACE PACKAGE "SCHEMA_OBJECTS" As
   

    Procedure grant_obj_priv;

End schema_objects;
/
---------------------------
--New PACKAGE
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

End iot_select_list_qry;
/
---------------------------
--New PACKAGE
--IOT_LEAVE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "IOT_LEAVE_QRY" As

    Function fn_leave_ledger_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_leave_ledger_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number := 0,
        p_page_length Number := 15
    ) Return Sys_Refcursor;

    Function fn_leave_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_leave_qry;
/
---------------------------
--New PACKAGE
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE "IOT_LEAVE" As 

    /* TODO enter package declarations (types, exceptions, methods etc) here */
    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    );

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2,
        p_contact_address        Varchar2,
        p_contact_std            Varchar2,
        p_contact_phone          Varchar2,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2,
        p_med_cert_file_nm       Varchar2,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );
End iot_leave;
/
---------------------------
--New PACKAGE
--IOT_EMPLMAST
---------------------------
CREATE OR REPLACE PACKAGE "IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor);

    Procedure employee_details(p_empno        Varchar2,
                               p_name     Out Varchar2,
                               p_parent   Out Varchar2,
                               p_metaid   Out Varchar2,
                               p_personid Out Varchar2,
                               p_success  Out Varchar2,
                               p_message  Out Varchar2
    );
    Procedure employee_details_ref_cur(p_empno               Varchar2,
                                       p_out_emp_details Out Sys_Refcursor);

    Function fn_employee_details_ref(p_empno Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor;
End iot_emplmast;
/
---------------------------
--Changed PACKAGE
--GENERATE_CSHARP_CODE
---------------------------
CREATE OR REPLACE PACKAGE "GENERATE_CSHARP_CODE" As 

    Procedure proc_to_class (
        p_package_name   In               Varchar2,
        p_proc_name      In               Varchar2,
        p_class          Out              Varchar2
    );

    Procedure table_to_class (
        p_table_view_name Varchar2,
        p_class Out Varchar2
    );

Procedure proc_to_iot_class (
        p_package_name   In               Varchar2,
        p_proc_name      In               Varchar2,
        p_class          Out              Varchar2
    );
End generate_csharp_code;
/
---------------------------
--New PACKAGE BODY
--SCHEMA_OBJECTS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SCHEMA_OBJECTS" As

    Procedure grant_obj_priv As

        Cursor cur_schema_objs Is
        Select
            object_name,
            Case
                When object_type = 'TABLE'     Then
                    'SELECT,INSERT,UPDATE,DELETE'
                When object_type = 'VIEW'      Then
                    'SELECT'
                When object_type In ( 'PACKAGE',
                                      'FUNCTION',
                                      'PROCEDURE' ) Then
                    'EXECUTE'
                When object_type = 'SEQUENCE'  Then
                    'SELECT'
            End obj_priv
        From
            user_objects
        Where
            object_type In ( 'TABLE',
                             'VIEW',
                             'PACKAGE',
                             'PROCEDURE',
                             'FUNCTION',
                             'SEQUENCE' );

    Begin
        For obj In cur_schema_objs Loop
            If obj.obj_priv Is Not Null Then
                Execute Immediate 'Grant '
                                  || obj.obj_priv
                                  || ' on '
                                  || obj.object_name
                                  || ' to tcmpl_app_config';

            End If;
        End Loop;
    End grant_obj_priv;

End schema_objects;
/
---------------------------
--New PACKAGE BODY
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_LEAVE" As

    Procedure get_leave_details_from_app(
        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_leave_app ss_leaveapp%rowtype;
    Begin
        Select
            *
        Into
            v_leave_app
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        p_emp_name           := get_emp_name(v_leave_app.empno);
        p_leave_type         := v_leave_app.leavetype;
        p_start_date         := to_char(v_leave_app.bdate, 'dd-Mon-yyyy');
        p_end_date           := to_char(v_leave_app.edate, 'dd-Mon-yyyy');

        p_leave_period       := to_days(v_leave_app.leaveperiod);
        p_last_reporting     := to_char(v_leave_app.work_ldate, 'dd-Mon-yyyy');
        p_resuming           := to_char(v_leave_app.resm_date, 'dd-Mon-yyyy');

        p_projno             := v_leave_app.projno;
        p_care_taker         := v_leave_app.caretaker;
        p_reason             := v_leave_app.reason;
        p_med_cert_available := v_leave_app.mcert;
        p_contact_address    := v_leave_app.contact_add;
        p_contact_std        := v_leave_app.contact_std;
        p_contact_phone      := v_leave_app.contact_phn;
        p_office             := v_leave_app.office;
        p_lead_name          := get_emp_name(v_leave_app.lead_code);
        p_discrepancy        := v_leave_app.discrepancy;
        p_med_cert_file_nm   := v_leave_app.med_cert_file_name;

        If nvl(v_leave_app.lead_apprl, 0) = 1 Or nvl(v_leave_app.hod_apprl, 0) = 1 Or nvl(v_leave_app.hrd_apprl, 0) = 1 Then
            p_flag_can_del := 'KO';
        Else
            p_flag_can_del := 'OK';
        End If;

        p_lead_approval      := ss.approval_text(v_leave_app.lead_apprl);
        p_hod_approval       := ss.approval_text(v_leave_app.hod_apprl);
        p_hr_approval        := ss.approval_text(v_leave_app.hrd_apprl);

        p_message_text       := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_adj(
        p_application_id    Varchar2,

        p_emp_name      Out Varchar2,
        p_leave_type    Out Varchar2,
        p_start_date    Out Varchar2,
        p_end_date      Out Varchar2,

        p_leave_period  Out Number,

        p_reason        Out Varchar2,

        p_lead_approval Out Varchar2,
        p_hod_approval  Out Varchar2,
        p_hr_approval   Out Varchar2,

        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_leave_adj ss_leave_adj%rowtype;
    Begin
        Select
            *
        Into
            v_leave_adj
        From
            ss_leave_adj
        Where
            adj_no = p_application_id;
        p_emp_name     := get_emp_name(v_leave_adj.empno);
        p_leave_type   := v_leave_adj.leavetype;
        p_start_date   := to_char(v_leave_adj.bdate, 'dd-Mon-yyyy');
        p_end_date     := to_char(v_leave_adj.edate, 'dd-Mon-yyyy');

        p_leave_period := to_days(v_leave_adj.leaveperiod);
        p_reason       := v_leave_adj.description;
        p_message_text := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => Null,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_new_leave;

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2,
        p_contact_address        Varchar2,
        p_contact_std            Varchar2,
        p_contact_phone          Varchar2,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2,
        p_med_cert_file_nm       Varchar2,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Number;
    Begin

        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        leave.add_leave_app(
            param_empno            => v_empno,
            param_leave_type       => p_leave_type,
            param_bdate            => p_start_date,
            param_edate            => p_end_date,
            param_half_day_on      => p_half_day_on,
            param_projno           => p_projno,
            param_caretaker        => p_care_taker,
            param_reason           => p_reason,
            param_cert             => p_med_cert_available,
            param_contact_add      => p_contact_address,
            param_contact_std      => p_contact_std,
            param_contact_phn      => p_contact_phone,
            param_office           => p_office,
            param_dataentryby      => v_empno,
            param_lead_empno       => p_lead_empno,
            param_discrepancy      => p_discrepancy,
            param_med_cert_file_nm => p_med_cert_file_nm,
            param_tcp_ip           => Null,
            param_nu_app_no        => p_new_application_id,
            param_msg_type         => v_message_type,
            param_msg              => p_message_text
        );

        If v_message_type = ss.failure Then
            v_message_type := 'KO';
        Else
            v_message_type := 'OK';
        End If;

    End;

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            get_leave_details_from_app(
                p_application_id     => p_application_id,

                p_emp_name           => p_emp_name,
                p_leave_type         => p_leave_type,
                p_start_date         => p_start_date,
                p_end_date           => p_end_date,

                p_leave_period       => p_leave_period,
                p_last_reporting     => p_last_reporting,
                p_resuming           => p_resuming,

                p_projno             => p_projno,
                p_care_taker         => p_care_taker,
                p_reason             => p_reason,
                p_med_cert_available => p_med_cert_available,
                p_contact_address    => p_contact_address,
                p_contact_std        => p_contact_std,
                p_contact_phone      => p_contact_phone,
                p_office             => p_office,
                p_lead_name          => p_lead_name,
                p_discrepancy        => p_discrepancy,
                p_med_cert_file_nm   => p_med_cert_file_nm,

                p_lead_approval      => p_lead_approval,
                p_hod_approval       => p_hod_approval,
                p_hr_approval        => p_hr_approval,

                p_flag_can_del       => p_flag_can_del,

                p_message_type       => p_message_type,
                p_message_text       => p_message_text
            );
            p_flag_is_adj := 'KO';
        Else
            get_leave_details_from_adj(
                p_application_id => p_application_id,

                p_emp_name       => p_emp_name,
                p_leave_type     => p_leave_type,
                p_start_date     => p_start_date,
                p_end_date       => p_end_date,

                p_leave_period   => p_leave_period,

                p_reason         => p_reason,

                p_lead_approval  => p_lead_approval,
                p_hod_approval   => p_hod_approval,
                p_hr_approval    => p_hr_approval,

                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );
            p_flag_is_adj  := 'OK';
            p_flag_can_del := 'KO';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;
End iot_leave;
/
---------------------------
--New PACKAGE BODY
--IOT_LEAVE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_LEAVE_QRY" As

    Function get_leave_applications(
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        dt.*,
                        Row_Number() Over (Order By dt.app_date_4_sort) row_number,
                        Count(*) Over ()                                total_row
                    From
                        (
                            Select
                                app_date_4_sort,
                                lead,
                                app_no,
                                application_date,
                                start_date,
                                end_date,
                                leave_type,
                                leave_period,
                                lead_approval_desc,
                                hod_approval_desc,
                                hrd_approval_desc,
                                lead_reason,
                                hod_reason,
                                hrd_reason,
                                from_tab,
                                is_pl,
                                Sum(is_pl) Over (Order By app_date_4_sort Desc) As pl_total,
                                Case
                                    When Sum(is_pl) Over (Order By app_date_4_sort Desc) <= 3
                                        And is_pl = 1
                                    Then
                                        app_no
                                    Else
                                        ''
                                End                                             As edit_pl_app,
                                med_cert_file_name
                            From
                                (
                                        (
                                Select
                                    ss_leaveapp.app_date                                                                    As
                                    app_date_4_sort,
                                    get_emp_name(ss_leaveapp.lead_apprl_empno)                                              As
                                    lead,
                                    ltrim(rtrim(ss_leaveapp.app_no))                                                        As
                                    app_no,
                                    to_char(ss_leaveapp.app_date, 'dd-Mon-yyyy')                                            As
                                    application_date,
                                    to_char(ss_leaveapp.bdate, 'dd-Mon-yyyy')                                               As
                                    start_date,
                                    to_char(ss_leaveapp.edate, 'dd-Mon-yyyy')                                               As
                                    end_date,
                                    ss_leaveapp.leavetype                                                                   As
                                    leave_type,
                                    to_days(ss_leaveapp.leaveperiod)                                                        As
                                    leave_period,
                                    decode(nvl(ss_leaveapp.lead_apprl, 0), 0, 'Pending', 1, 'Apprd', 2, 'DisAppr', 4, 'NA')
                                    As lead_approval_desc,
                                    decode(ss_leaveapp.hod_apprl, 0, 'Pending', 1, 'Apprd', 2, 'DisAppr')                   As
                                    hod_approval_desc,
                                    decode(ss_leaveapp.hrd_apprl, 0, 'Pending', 1, 'Apprd', 2, 'DisAppr')                   As
                                    hrd_approval_desc,
                                    ss_leaveapp.lead_reason,
                                    ss_leaveapp.hodreason                                                                   As
                                    hod_reason,
                                    ss_leaveapp.hrdreason                                                                   As
                                    hrd_reason,
                                    '1'                                                                                     As
                                    from_tab,
                                    Case
                                        When nvl(ss_leaveapp.hrd_apprl, 0) = 1
                                            And ss_leaveapp.leavetype      = 'PL'
                                        Then
                                            1
                                        Else
                                            0
                                    End                                                                                     As
                                    is_pl,
                                    med_cert_file_name
                                From
                                    ss_leaveapp
                                Where
                                    ss_leaveapp.app_no Not Like 'Prev%'
                                    And Trim(ss_leaveapp.empno) = p_empno
                                )
                                Union
                                (
                                Select
                                    a.app_date                                                        As app_date_4_sort,
                                    ''                                                                As lead,
                                    Trim(a.app_no)                                                    As app_no,
                                    to_char(a.app_date, 'dd-Mon-yyyy')                                As application_date,
                                    to_char(a.bdate, 'dd-Mon-yyyy')                                   As start_date,
                                    to_char(a.edate, 'dd-Mon-yyyy')                                   As end_date,
                                    Trim(a.leavetype)                                                 As leave_type,
                                    to_days(decode(a.db_cr, 'D', a.leaveperiod * - 1, a.leaveperiod)) As leave_period,
                                    'NA'                                                              As lead_approval_desc,
                                    'Apprd'                                                           As hod_approval_desc,
                                    'Apprd'                                                           As hrd_approval_desc,
                                    ''                                                                As lead_reason,
                                    ''                                                                As hod_reason,
                                    ''                                                                As hrd_reason,
                                    '2'                                                               As from_tab,
                                    0                                                                 As is_pl,
                                    Null                                                              As med_cert_file_name
                                From
                                    ss_leaveledg a
                                Where
                                    a.empno = lpad(Trim(p_empno), 5, 0)
                                    And a.app_no Not Like 'Prev%'
                                    And ltrim(rtrim(a.app_no)) Not In
                                    (
                                        Select
                                            ss_leaveapp.app_no
                                        From
                                            ss_leaveapp
                                        Where
                                            ss_leaveapp.empno = p_empno
                                    )
                                )
                                )
                            Where
                                start_date >= add_months(sysdate, - 24)
                            Order By app_date_4_sort Desc
                        ) dt
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function get_leave_ledger(
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                app_no,
                app_date,
                leave_type,
                description,
                b_date,
                e_date,
                no_of_days_db,
                no_of_days_cr,
                row_number,
                total_row
            From
                (
                    Select
                        app_no,
                        app_date,
                        leavetype                              leave_type,
                        description,
                        dispbdate                              b_date,
                        dispedate                              e_date,
                        to_days(dbday)                         no_of_days_db,
                        to_days(crday)                         no_of_days_cr,
                        Row_Number() Over (Order By dispbdate) row_number,
                        Count(*) Over ()                       total_row
                    From
                        ss_displedg
                    Where
                        empno = p_empno
                        And dispbdate Between p_start_date And p_end_date
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End get_leave_ledger;

    Function fn_leave_ledger_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        Select
            empno
        Into
            v_empno
        From
            ss_emplmast
        Where
            personid   = p_person_id
            And metaid = p_meta_id
            And status = 1;
        c := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_self;

    Function fn_leave_ledger_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        Select
            empno
        Into
            v_empno
        From
            ss_emplmast
        Where
            empno      = p_empno
            And status = 1;
        c := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_other;

    Function fn_leave_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        Select
            empno
        Into
            v_empno
        From
            ss_emplmast
        Where
            empno      = p_empno
            And status = 1;
        c := get_leave_applications(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_applications_4_other;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := get_leave_applications(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_applications_4_self;

End iot_leave_qry;
/
---------------------------
--New PACKAGE BODY
--IOT_EMPLMAST
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor) As
    Begin

        Open p_out_emp_list For
            Select
                empno, name, parent, assign
            From
                ss_emplmast
            Where
                status     = 1
                And parent = p_dept;
    End employee_list_dept;

    Procedure employee_details(p_empno        Varchar2,
                               p_name     Out Varchar2,
                               p_parent   Out Varchar2,
                               p_metaid   Out Varchar2,
                               p_personid Out Varchar2,
                               p_success  Out Varchar2,
                               p_message  Out Varchar2
    ) As
    Begin
        Select
            name, parent, metaid, personid
        Into
            p_name, p_parent, p_metaid, p_personid
        From
            ss_emplmast
        Where
            empno = p_empno;
        p_success := 'OK';
        p_message := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End employee_details;

    Procedure employee_details_ref_cur(p_empno               Varchar2,
                                       p_out_emp_details Out Sys_Refcursor) As
    Begin
        Open p_out_emp_details For
            Select
                name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = p_empno;
    End;
    /*
        Function fn_employee_details_ref(p_empno         Varchar2,
                                         p_rownum In Out Number) Return Sys_Refcursor
        As
            c Sys_Refcursor;
        Begin
            Open c For
                Select
                    name, parent, metaid, personid, p_rownum
                From
                    ss_emplmast
                Where
                    empno = p_empno;
            p_rownum := -1;
            Return c;
        End;
    */
    Function fn_employee_details_ref(p_empno Varchar2) Return Sys_Refcursor
    As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = p_empno;

        Return c;
    End;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor
    As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno, name, parent, metaid, personid
            From
                ss_emplmast
            Where
            status=1;
                --parent     = p_dept
                --And status = 1;
        --p_rownum := -1;
        Return c;
    End;
End iot_emplmast;
/
---------------------------
--Changed PACKAGE BODY
--GENERATE_CSHARP_CODE
---------------------------
CREATE OR REPLACE PACKAGE BODY "GENERATE_CSHARP_CODE" As

    Procedure proc_to_class (
        p_package_name   In               Varchar2,
        p_proc_name      In               Varchar2,
        p_class          Out              Varchar2
    ) As

        Cursor cur_proc_params Is
        Select
            object_name,
            package_name,
            argument_name,
            data_type,
            in_out
        From
            user_arguments
        Where
            package_name = Upper(p_package_name)
            And object_name = Upper(p_proc_name)
        Order By
            position;

        v_class        Varchar2(4000);
        v_properties   Varchar2(2000);
        v_datatype     Varchar2(60);
        v_class_name   Varchar2(60);
    Begin
        v_class        := 'public class CLASS_NAME ! { ! public string CommandText {get => "' --
         || Upper(p_package_name) || '.' || Upper(p_proc_name) || '"; } ! PARAM_NAMES ! }';

        v_class_name   := Replace(Initcap(p_package_name) || Initcap(p_proc_name), '_', '');

        v_class        := Replace(v_class, 'CLASS_NAME', v_class_name);
        For cur_row In cur_proc_params Loop
            v_datatype :=
                Case cur_row.data_type
                    When 'VARCHAR2' Then
                        'string'
                    When 'CHAR' Then
                        'string'
                    When 'DATE' Then
                        'DateTime'
                    When 'NUMBER' Then
                        'Int32'
                    Else 'string'
                End;

            If cur_row.in_out = 'OUT' Then
                v_properties := v_properties || ' public ' || v_datatype || ' Out' || Trim(Replace(Initcap(cur_row.argument_name)
                , '_')) || ' { get; set; } ! ';
            Else
                v_properties := v_properties || ' public ' || v_datatype || '    ' || Replace(Initcap(cur_row.argument_name), '_'
                ) || ' { get; set; } ! ';
            End If;

        End Loop;

        v_class        := Replace(Replace(v_class, 'PARAM_NAMES', v_properties), '!', Chr(13));

        p_class        := v_class;
    End proc_to_class;

    Procedure table_to_class (
        p_table_view_name Varchar2,
        p_class Out Varchar2
    ) As

        Cursor cur_columns Is
        Select
            table_name,
            column_name,
            data_type
        From
            user_tab_columns
        Where
            table_name = Upper(p_table_view_name);

        v_class        Varchar(4000);
        v_properties   Varchar2(3900);
        v_datatype     Varchar2(60);
        v_class_name   Varchar2(60);
    Begin
        v_class   := 'public class CHANGE_CLASS_NAME ! { ! PARAM_NAMES ! }';
        For cur_row In cur_columns Loop
            v_datatype     :=
                Case cur_row.data_type
                    When 'VARCHAR2' Then
                        'string'
                    When 'CHAR' Then
                        'string'
                    When 'DATE' Then
                        'DateTime'
                    When 'NUMBER' Then
                        'Int32'
                    Else 'string'
                End;

            v_properties   := v_properties || ' public ' || v_datatype || ' ' || Replace(Initcap(cur_row.column_name), '_') || '{get;set;}! '
            ;

        End Loop;

        v_class   := Replace(Replace(v_class, 'PARAM_NAMES', v_properties), '!', Chr(13));

        p_class   := v_class;
    End;

    Procedure proc_to_iot_class (
        p_package_name   In               Varchar2,
        p_proc_name      In               Varchar2,
        p_class          Out              Varchar2
    ) As

        Cursor cur_proc_params Is
        Select
            object_name,
            package_name,
            argument_name,
            data_type,
            in_out
        From
            user_arguments
        Where
            package_name = Upper(p_package_name)
            And object_name = Upper(p_proc_name)
        Order By
            position;

        v_class        Varchar2(4000);
        v_properties   Varchar2(2000);
        v_datatype     Varchar2(60);
        v_class_name   Varchar2(60);
    Begin
        v_class        := 'public class CLASS_NAME ! { ! public string CommandText {get => "' --
         || Upper(p_package_name) || '.' || Upper(p_proc_name) || '"; } ! PARAM_NAMES ! }';

        v_class_name   := Replace(Initcap(p_package_name) || Initcap(p_proc_name), '_', '');

        v_class        := Replace(v_class, 'CLASS_NAME', v_class_name);
        For cur_row In cur_proc_params Loop
            v_datatype :=
                Case cur_row.data_type
                    When 'VARCHAR2' Then
                        'string'
                    When 'CHAR' Then
                        'string'
                    When 'DATE' Then
                        'DateTime'
                    When 'NUMBER' Then
                        'Int32'
                    Else 'string'
                End;

            If cur_row.in_out = 'OUT' Then
                v_properties := v_properties || ' public ' || v_datatype || ' ' || Trim(Replace(Initcap(cur_row.argument_name)
                , '_')) || ' { get; set; } ! ';
            Else
                v_properties := v_properties || ' public ' || v_datatype || '    ' || Replace(Initcap(cur_row.argument_name), '_'
                ) || ' { get; set; } ! ';
            End If;

        End Loop;

        v_class        := Replace(Replace(v_class, 'PARAM_NAMES', v_properties), '!', Chr(13));

        p_class        := v_class;
    End proc_to_iot_class;


End generate_csharp_code;
/
---------------------------
--New PACKAGE BODY
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                leavetype   data_value_field,
                description data_text_field
            From
                ss_leavetype
            Where
                is_active = 1;
        Return c;
    End fn_leave_type_list;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'None'          data_value_field,
                'Head Of Dept.' data_text_field
            From
                dual
            Union
            Select
                a.empno data_value_field,
                b.name  data_text_field
            From
                ss_lead_approver a,
                ss_emplmast      b
            Where
                a.empno      = b.empno
                And a.parent In
                (
                    Select
                        e.assign
                    From
                        ss_emplmast e
                    Where
                        e.personid = p_person_id
                )
                And b.status = 1;
        Return c;
    End;
End iot_select_list_qry;
/
---------------------------
--New FUNCTION
--TO_DAYS
---------------------------
CREATE OR REPLACE FUNCTION "TO_DAYS" (
    p_hrs In Varchar2
) Return Varchar2 As
    v_days         Varchar2(10);
    v_positive_hrs Number;
Begin
    If nvl(p_hrs, 0) = 0 Then
        Return '';
    End If;
    If p_hrs < 0 Then
        v_positive_hrs := p_hrs * -1;
    Else
        v_positive_hrs := p_hrs;
    End If;
    v_days := trunc(v_positive_hrs / 8);

    v_days := v_days || '.' || Mod(v_positive_hrs, 8);

    If p_hrs < 0 Then
        v_days := '-' || v_days;
    End If;
    Return v_days;
End to_days;
/
---------------------------
--New FUNCTION
--GET_EMPNO_FROM_PERSON_ID
---------------------------
CREATE OR REPLACE FUNCTION "GET_EMPNO_FROM_PERSON_ID" (
    p_person_id In Varchar2
) Return Varchar2 As
    v_empno Varchar2(5);
Begin
    Select
        empno
    Into
        v_empno
    From
        ss_emplmast
    Where
        personid   = p_person_id
        And status = 1;
    Return v_empno;
Exception
    When Others Then
        Return 'ERRRR';
End get_empno_from_person_id;
/
