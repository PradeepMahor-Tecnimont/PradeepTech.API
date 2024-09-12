--------------------------------------------------------
--  DDL for Package Body PKG_CV_COPY_DATA
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."PKG_CV_COPY_DATA" As

    Procedure sp_cv_copy_data_from_old_empno(p_person_id        Varchar2,
                                             p_meta_id          Varchar2,
                                             p_old_empno        Varchar2,
                                             p_new_empno        Varchar2,
                                             p_message_type Out Varchar2,
                                             p_message_text Out Varchar2) As
        v_count  Number;
        v_metaid emplmast.metaid%Type;
    Begin
        If p_old_empno Is Null Or p_new_empno Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Blank employee no found';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            cv_emplmast
        Where
            empno = Trim(p_new_empno);
        If v_count = 1 Then
            p_message_type := not_ok;
            p_message_text := 'CV already exists';
            Return;
        End If;

        Begin
            Select
            Distinct metaid
            Into
                v_metaid
            From
                emplmast
            Where
                empno In (p_old_empno, p_new_empno);
        Exception
            When Others Then
                p_message_type := not_ok;
                p_message_text := 'Employee does not match';
                Return;
        End;

        Insert Into cv_emplmast
        Select
            year,
            p_new_empno,
            fullname,
            nationality,
            birthdate,
            per_add1,
            d_per_add2,
            d_per_add3,
            per_state,
            per_pin,
            per_std,
            per_telno,
            res_add1,
            d_res_add2,
            d_res_add3,
            res_state,
            res_pin,
            res_std,
            res_telno,
            passportno,
            passportissuedate,
            passportexpdate,
            passportissueplace,
            joiningdate,
            presentposition,
            fromyear,
            responsibility,
            dateofissue,
            dept,
            mothertongue,
            notes,
            issuedate,
            hod_apprl,
            hrd_apprl,
            locked,
            unlock
        From
            cv_emplmast
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_education
        Select
            year,
            p_new_empno,
            srno,
            dip_degree,
            institute,
            discipline,
            yymm,
            deg_type
        From
            cv_education
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_prevemplbrief
        Select
            year,
            p_new_empno,
            company,
            position,
            no_of_years,
            no_of_months,
            company_desc,
            srno
        From
            cv_prevemplbrief
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_prevempldetails
        Select
            year,
            p_new_empno,
            company,
            position,
            fromperiod,
            toperiod,
            responsibility,
            company_desc,
            position_desc,
            srno
        From
            cv_prevempldetails
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_prevemplprojectdetails
        Select
            year,
            p_new_empno,
            project,
            client,
            location,
            country,
            description,
            company,
            position,
            projno,
            srno
        From
            cv_prevemplprojectdetails
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_language
        Select
            year,
            p_new_empno,
            srno,
            language,
            read,
            write,
            speak
        From
            cv_language
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_traininginfo
        Select
            year,
            p_new_empno,
            rcvd_training,
            org_quality,
            locked,
            issuedate,
            hod_apprl,
            hrd_apprl,
            dept,
            notes
        From
            cv_traininginfo
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_training
        Select
            year,
            p_new_empno,
            srno,
            tr_name,
            yyyy,
            duration,
            'OTHERS',
            0,
            Null,
            conducted_by,
            bond_bdate,
            bond_edate,
            bond_val,
            Null
        From
            cv_training
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_emp_work_tech_mast
        Select
            p_new_empno,
            work_tech_id
        From
            cv_emp_work_tech_mast
        Where
            empno = Trim(p_old_empno);

        Insert Into cv_emp_work_tech_det
        Select
            p_new_empno,
            id,
            sub_id,
            last_work_year
        From
            cv_emp_work_tech_det
        Where
            empno = Trim(p_old_empno);

        Commit;

        p_message_type := ok;
        p_message_text := 'Success';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End sp_cv_copy_data_from_old_empno;

End pkg_cv_copy_data;
/