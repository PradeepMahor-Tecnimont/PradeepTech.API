Create Or Replace Package Body "COMMONMASTERS"."IOT_EMPDETAILS_DOC_UPLOAD" As

    Procedure emp_details_for_doc_upload(
        p_for_empno               Varchar2,
        
        --Passport
        p_pp_expiry_date      Out Date,
        p_pp_issue_date       Out Date,
        p_pp_number           Out Varchar2,
        p_pp_issued_at        Out Varchar2,
        p_pp_given_name       Out Varchar2,
        p_pp_surname          Out Varchar2,
        
        --AADHAAR
        p_ad_number           Out Varchar2,
        p_ad_name             Out Varchar2,

        --GTLI Nomination Percentage
        p_gtli_nom_pcnt       Out Number,
        
        --Can upload passport OK/KO
        p_can_upload_pp_doc   Out Varchar2,

        --Can upload aadhaar document OK/KO
        p_can_upload_ad_doc   Out Varchar2,

        --Can upload GTLI document OK/KO
        p_can_upload_gtli_doc Out Varchar2,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
        v_rec_lock_status emp_lock_status_vu%rowtype;

    Begin

        Select
            --e.empno,

            ed.passport_no,
            ed.issue_date,
            ed.expiry_date,
            ed.passport_issued_at,
            ed.passport_surname,
            ed.passport_given_name,
            ea.adhaar_no,
            ea.adhaar_name
        Into
            p_pp_number,
            p_pp_issue_date,
            p_pp_expiry_date,
            p_pp_issued_at,
            p_pp_surname,
            p_pp_given_name,
            p_ad_number,
            p_ad_name
        From
            emplmast    e,
            emp_details ed,
            emp_adhaar  ea

        Where
            e.empno     = p_for_empno
            And e.empno = ed.empno(+)
            And e.empno = ea.empno(+);

        --Get GTLI nomination percentage
        Select
            Sum(share_pcnt)
        Into
            p_gtli_nom_pcnt
        From
            emp_gtli
        Where
            empno = p_for_empno;

        Select
            *
        Into
            v_rec_lock_status
        From
            emp_lock_status_vu
        Where
            empno = p_for_empno;

        p_can_upload_pp_doc   := 'KO';
        p_can_upload_ad_doc   := 'KO';
        p_can_upload_gtli_doc := 'KO';

        If v_rec_lock_status.pp_lock = 1 Then
            p_can_upload_pp_doc := 'OK';
        End If;

        If v_rec_lock_status.adhaar_lock = 1 Then
            p_can_upload_ad_doc := 'OK';
        End If;

        --Get GTLI nomination = 100
        If v_rec_lock_status.gtli_lock = 1 And p_gtli_nom_pcnt = 100 Then
            p_can_upload_gtli_doc := 'OK';
        End If;

        p_message_type        := 'OK';
        p_message_text        := 'Procedure execute successfully';

    Exception
        When
        Others
        Then
            p_message_type := 'KO';
            p_message_text := 'Error - ' || sqlcode || ' - ' || sqlerrm;
    End emp_details_for_doc_upload;
    
    ----

    Procedure emp_details_4_docs(

        p_person_id               Varchar2,
        p_meta_id                 Varchar2,
        
        --Passport
        p_pp_expiry_date      Out Date,
        p_pp_issue_date       Out Date,
        p_pp_number           Out Varchar2,
        p_pp_issued_at        Out Varchar2,
        p_pp_given_name       Out Varchar2,
        p_pp_surname          Out Varchar2,
        
        --AADHAAR
        p_ad_number           Out Varchar2,
        p_ad_name             Out Varchar2,

        --GTLI Nomination Percentage
        p_gtli_nom_pcnt       Out Number,
        
        --Can upload passport OK/KO
        p_can_upload_pp_doc   Out Varchar2,

        --Can upload aadhaar document OK/KO
        p_can_upload_ad_doc   Out Varchar2,

        --Can upload GTLI document OK/KO
        p_can_upload_gtli_doc Out Varchar2,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
        v_rec_lock_status    emp_lock_status_vu%rowtype;
        v_by_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_by_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        emp_details_for_doc_upload(
            p_for_empno           => v_by_empno,
        
            --Passport
            p_pp_expiry_date      => p_pp_expiry_date,
            p_pp_issue_date       => p_pp_issue_date,
            p_pp_number           => p_pp_number,
            p_pp_issued_at        => p_pp_issued_at,
            p_pp_given_name       => p_pp_given_name,
            p_pp_surname          => p_pp_surname,
        
            --AADHAAR
            p_ad_number           => p_ad_number,
            p_ad_name             => p_ad_name,

            --GTLI Nomination Percentage
            p_gtli_nom_pcnt       => p_gtli_nom_pcnt,

            --Can upload passport OK/KO
            p_can_upload_pp_doc   => p_can_upload_pp_doc,

            --Can upload aadhaar document OK/KO
            p_can_upload_ad_doc   => p_can_upload_ad_doc,

            --Can upload GTLI document OK/KO
            p_can_upload_gtli_doc => p_can_upload_gtli_doc,

            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Error - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure hr_emp_details_4_docs(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_for_empno               Varchar2,
        --Passport
        p_pp_expiry_date      Out Date,
        p_pp_issue_date       Out Date,
        p_pp_number           Out Varchar2,
        p_pp_issued_at        Out Varchar2,
        p_pp_given_name       Out Varchar2,
        p_pp_surname          Out Varchar2,
        
        --AADHAAR
        p_ad_number           Out Varchar2,
        p_ad_name             Out Varchar2,

        --GTLI Nomination Percentage
        p_gtli_nom_pcnt       Out Number,
        
        --Can upload passport OK/KO
        p_can_upload_pp_doc   Out Varchar2,

        --Can upload aadhaar document OK/KO
        p_can_upload_ad_doc   Out Varchar2,

        --Can upload GTLI document OK/KO
        p_can_upload_gtli_doc Out Varchar2,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
        v_rec_lock_status    emp_lock_status_vu%rowtype;
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hr_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_hr_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        
        --Get details
        emp_details_for_doc_upload(
            p_for_empno           => p_for_empno,
        
            --Passport
            p_pp_expiry_date      => p_pp_expiry_date,
            p_pp_issue_date       => p_pp_issue_date,
            p_pp_number           => p_pp_number,
            p_pp_issued_at        => p_pp_issued_at,
            p_pp_given_name       => p_pp_given_name,
            p_pp_surname          => p_pp_surname,
        
            --AADHAAR
            p_ad_number           => p_ad_number,
            p_ad_name             => p_ad_name,

            --GTLI Nomination Percentage
            p_gtli_nom_pcnt       => p_gtli_nom_pcnt,

            --Can upload passport OK/KO
            p_can_upload_pp_doc   => p_can_upload_pp_doc,

            --Can upload aadhaar document OK/KO
            p_can_upload_ad_doc   => p_can_upload_ad_doc,

            --Can upload GTLI document OK/KO
            p_can_upload_gtli_doc => p_can_upload_gtli_doc,

            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Error - ' || sqlcode || ' - ' || sqlerrm;

    End;

End iot_empdetails_doc_upload;