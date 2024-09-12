Create Or Replace Package Body tcmpl_hr.mis_prospective_employees As

    Procedure sp_create(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_costcode             Varchar2,
        p_emp_name             Varchar2,
        p_office_location_code Varchar2,
        p_proposed_doj         Date,

        p_join_status_code     Varchar2,
        p_empno                Varchar2 Default Null,

        p_grade                Varchar2 Default Null,
        p_designation          Varchar2 Default Null,
        p_employment_type      Varchar2 Default Null,
        p_sources_of_candidate Varchar2 Default Null,

        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2

    ) As
        v_by_empno      Varchar2(5);
        v_key_id        Varchar2(8);
        v_exists        Number;
        v_from_costcode Varchar2(4);
        v_status        Number;
        v_count         Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_key_id       := dbms_random.string('X', 8);

        Select
            Count(*)
        Into
            v_count
        From
            mis_mast_office_location
        Where
            office_location_code = p_office_location_code;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid office code.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            mis_mast_joining_status
        Where
            join_status_code = p_join_status_code;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid joining status code.';
            Return;
        End If;
        If p_empno Is Not Null Then
            Select
                Count(*)
            Into
                v_count
            From
                vu_emplmast
            Where
                empno = p_empno;
            If v_count = 0 Then
                p_message_type := not_ok;
                p_message_text := 'Invalid employee number.';
                Return;
            End If;

        End If;

        Insert Into mis_prospective_emp(
            key_id,
            costcode,
            emp_name,
            office_location_code,
            proposed_doj,
            join_status_code,
            empno,
            grade,
            designation,
            employment_type,
            sources_of_candidate,
            modified_by,
            modified_on
        )
        Values
        (
            v_key_id,
            p_costcode,
            upper(p_emp_name),
            p_office_location_code,
            p_proposed_doj,
            p_join_status_code,
            p_empno,
            p_grade,
            p_designation,
            p_employment_type,
            p_sources_of_candidate,
            v_by_empno,
            sysdate
        );
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,

        p_key_id                    Varchar2,

        p_costcode                  Varchar2,
        p_emp_name                  Varchar2,
        p_office_location_code      Varchar2,
        p_revised_doj               Date     Default Null,

        p_join_status_code          Varchar2,
        p_empno                     Varchar2 Default Null,

        p_grade                     Varchar2,
        p_designation               Varchar2,
        p_employment_type           Varchar2,
        p_sources_of_candidate      Varchar2,

        p_pre_emplmnt_medcl_test    Varchar2 Default Null,
        p_rec_for_appt              Varchar2 Default Null,
        p_offer_letter              Varchar2 Default Null,
        p_medcl_request_date        Date     Default Null,
        p_actual_appt_date          Date     Default Null,
        p_medcl_fitness_cert        Date     Default Null,
        p_rec_issued                Date     Default Null,
        p_rec_received              Date     Default Null,
        p_re_rec_appt               Varchar2 Default Null,
        p_re_pre_emplmnt_medcl_test Varchar2 Default Null,

        p_message_type Out          Varchar2,
        p_message_text Out          Varchar2
    ) As
        v_by_empno      Varchar2(5);
        v_key_id        Varchar2(8);
        v_exists        Number;
        v_from_costcode Varchar2(4);
        v_status        Number;
        v_count         Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_key_id       := dbms_random.string('X', 8);

        Select
            Count(*)
        Into
            v_count
        From
            mis_prospective_emp
        Where
            key_id = p_key_id;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid prospective employee.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            mis_mast_office_location
        Where
            office_location_code = p_office_location_code;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid office code.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            mis_mast_joining_status
        Where
            join_status_code = p_join_status_code;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid joining status code.';
            Return;
        End If;
        If p_empno Is Not Null Then
            Select
                Count(*)
            Into
                v_count
            From
                vu_emplmast
            Where
                empno = p_empno;
            If v_count = 0 Then
                p_message_type := not_ok;
                p_message_text := 'Invalid employee number.';
                Return;
            End If;

        End If;

        Update
            mis_prospective_emp
        Set
            costcode = p_costcode,
            emp_name = p_emp_name,
            office_location_code = p_office_location_code,
            revised_doj = p_revised_doj,
            join_status_code = p_join_status_code,
            empno = p_empno,
            grade = p_grade,
            designation = p_designation,
            employment_type = p_employment_type,
            sources_of_candidate = p_sources_of_candidate,

            pre_emplmnt_medcl_test = p_pre_emplmnt_medcl_test,
            medcl_request_date = p_medcl_request_date,
            actual_appt_date = p_actual_appt_date,
            medcl_fitness_cert = p_medcl_fitness_cert,
            re_pre_emplmnt_medcl_test = p_re_pre_emplmnt_medcl_test,
            rec_for_appt = p_rec_for_appt,
            rec_issued = p_rec_issued,
            rec_received = p_rec_received,
            re_rec_appt = p_re_rec_appt,
            offer_letter = p_offer_letter,

            modified_by = v_by_empno,
            modified_on = sysdate
        Where
            key_id = p_key_id;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno Varchar2(5);
        v_count    Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From mis_prospective_emp
        Where
            key_id = p_key_id;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_details(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_key_id                        Varchar2,

        p_costcode                  Out Varchar2,
        p_emp_name                  Out Varchar2,
        p_office_location_code      Out Varchar2,
        p_proposed_doj              Out Date,
        p_revised_doj               Out Date,

        p_join_status_code          Out Varchar2,
        p_empno                     Out Varchar2,

        p_grade                     Out Varchar2,
        p_designation               Out Varchar2,
        p_employment_type           Out Varchar2,
        p_sources_of_candidate      Out Varchar2,

        p_pre_emplmnt_medcl_test    Out Varchar2,
        p_rec_for_appt              Out Varchar2,
        p_offer_letter              Out Varchar2,
        p_medcl_request_date        Out Date,
        p_actual_appt_date          Out Date,
        p_medcl_fitness_cert        Out Date,
        p_rec_issued                Out Date,
        p_rec_received              Out Date,
        p_re_rec_appt               Out Varchar2,
        p_re_pre_emplmnt_medcl_test Out Varchar2,

        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As
        v_by_empno            Varchar2(5);
        v_count               Number;
        v_rec_prospective_emp mis_prospective_emp%rowtype;
    Begin
        v_by_empno                  := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            mis_prospective_emp
        Where
            key_id = p_key_id;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid prospective employee id.';
            Return;
        End If;

        Select
            *
        Into
            v_rec_prospective_emp
        From
            mis_prospective_emp
        Where
            key_id = p_key_id;

        p_costcode                  := v_rec_prospective_emp.costcode;
        p_emp_name                  := v_rec_prospective_emp.emp_name;
        p_office_location_code      := v_rec_prospective_emp.office_location_code;
        p_proposed_doj              := v_rec_prospective_emp.proposed_doj;
        p_revised_doj               := v_rec_prospective_emp.revised_doj;

        p_join_status_code          := v_rec_prospective_emp.join_status_code;
        p_empno                     := v_rec_prospective_emp.empno;

        p_grade                     := v_rec_prospective_emp.grade;
        p_designation               := v_rec_prospective_emp.designation;
        p_employment_type           := v_rec_prospective_emp.employment_type;
        p_sources_of_candidate      := v_rec_prospective_emp.sources_of_candidate;

        p_pre_emplmnt_medcl_test    := v_rec_prospective_emp.pre_emplmnt_medcl_test;
        p_rec_for_appt              := v_rec_prospective_emp.rec_for_appt;
        p_offer_letter              := v_rec_prospective_emp.offer_letter;
        p_medcl_request_date        := v_rec_prospective_emp.medcl_request_date;
        p_actual_appt_date          := v_rec_prospective_emp.actual_appt_date;
        p_medcl_fitness_cert        := v_rec_prospective_emp.medcl_fitness_cert;
        p_rec_issued                := v_rec_prospective_emp.rec_issued;
        p_rec_received              := v_rec_prospective_emp.rec_received;
        p_re_rec_appt               := v_rec_prospective_emp.re_rec_appt;
        p_re_pre_emplmnt_medcl_test := v_rec_prospective_emp.re_pre_emplmnt_medcl_test;

        p_message_type              := ok;
        p_message_text              := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;
End;