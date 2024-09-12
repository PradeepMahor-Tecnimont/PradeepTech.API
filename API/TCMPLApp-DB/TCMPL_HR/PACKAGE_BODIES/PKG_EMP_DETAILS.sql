Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_DETAILS" As

    Procedure sp_add_primary_details(
        p_empno               Varchar2,
        p_first_name          Varchar2 Default Null,
        p_surname             Varchar2 Default Null,
        p_father_name         Varchar2 Default Null,
        p_p_add1              Varchar2 Default Null,
        p_p_house_no          Varchar2 Default Null,
        p_p_city              Varchar2 Default Null,
        p_p_district          Varchar2 Default Null,
        p_p_state             Varchar2 Default Null,
        p_p_pincode           Number   Default Null,
        p_p_country           Varchar2 Default Null,
        p_place_of_birth      Varchar2 Default Null,
        p_country_of_birth    Varchar2 Default Null,
        p_nationality         Varchar2 Default Null,
        p_p_phone             Varchar2 Default Null,
        p_no_of_child         Number   Default Null,
        p_personal_email      Varchar2 Default Null,
        p_p_mobile            Varchar2 Default Null,
        p_no_dad_husb_in_name Number   Default Null,

        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_exists       Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Select
            Count(*)
        Into
            v_exists
        From
            emp_details
        Where
            Trim(empno) = Trim(p_empno);

        If v_exists = 0 Then
            Insert Into emp_details
            (
                empno,
                name,
                surname,
                father_name,
                p_add_1,
                p_house_no,
                p_city,
                p_district,
                p_state,
                p_pincode,
                p_country,
                place_of_birth,
                country_of_birth,
                nationality,
                p_phone,
                no_of_child,
                personal_email,
                no_dad_husb_in_name,
                p_mobile,
                modified_on
            )

            Values
            (
                Trim(p_empno),
                upper(Trim(p_first_name)),
                upper(Trim(p_surname)),
                upper(Trim(p_father_name)),
                Trim(p_p_add1),
                upper(Trim(p_p_house_no)),
                upper(Trim(p_p_city)),
                upper(Trim(p_p_district)),
                upper(Trim(p_p_state)),
                p_p_pincode,
                upper(Trim(p_p_country)),
                Trim(p_place_of_birth),
                Trim(p_country_of_birth),
                Trim(p_nationality),
                Trim(p_p_phone),
                p_no_of_child,
                lower(Trim(p_personal_email)),
                p_no_dad_husb_in_name,
                Trim(p_p_mobile),
                sysdate
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee primary details added successfully..';
        Else
            Select
                Count(*)
            Into
                v_exists
            From
                emp_details
            Where
                empno = Trim(p_empno);

            If v_exists = 1 Then

                Update
                    emp_details
                Set
                    name = upper(Trim(p_first_name)),
                    surname = upper(Trim(p_surname)),
                    father_name = upper(Trim(p_father_name)),
                    p_add_1 = Trim(p_p_add1),
                    p_house_no = upper(Trim(p_p_house_no)),
                    p_city = upper(Trim(p_p_city)),
                    p_district = upper(Trim(p_p_district)),
                    p_state = upper(Trim(p_p_state)),
                    p_pincode = p_p_pincode,
                    p_country = upper(Trim(p_p_country)),
                    place_of_birth = Trim(p_place_of_birth),
                    country_of_birth = Trim(p_country_of_birth),
                    nationality = Trim(p_nationality),
                    p_phone = Trim(p_p_phone),
                    no_of_child = p_no_of_child,
                    personal_email = lower(Trim(p_personal_email)),
                    p_mobile = Trim(p_p_mobile),
                    no_dad_husb_in_name = p_no_dad_husb_in_name,
                    modified_on = sysdate
                Where
                    empno = Trim(p_empno);

                Commit;

                p_message_type := ok;
                p_message_text := 'Employee primary details updated successfully.';
            Else
                p_message_type := not_ok;
                p_message_text := 'No matching Employee primary details exists !!!';
            End If;
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee primary details already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_primary_details;

    Procedure sp_add_secondary_details(
        p_empno            Varchar2,

        p_blood_group      Varchar2 Default Null,
        p_religion         Varchar2 Default Null,
        p_marital_status   Varchar2 Default Null,
        p_r_add1           Varchar2 Default Null,
        p_r_house_no       Varchar2 Default Null,
        p_r_city           Varchar2 Default Null,
        p_r_pincode        Number   Default Null,
        p_r_district       Varchar2 Default Null,
        p_r_state          Varchar2 Default Null,
        p_r_country        Varchar2 Default Null,
        p_phone_res        Varchar2 Default Null,
        p_mobile_res       Varchar2 Default Null,
        p_ref_person_name  Varchar2 Default Null,
        p_f_add1           Varchar2 Default Null,
        p_f_house_no       Varchar2 Default Null,
        p_f_city           Varchar2 Default Null,
        p_f_district       Varchar2 Default Null,
        p_f_state          Varchar2 Default Null,
        p_f_pincode        Number   Default Null,
        p_f_country        Varchar2 Default Null,
        p_ref_person_phone Varchar2 Default Null,
        p_co_bus           Varchar2 Default Null,
        p_pick_up_point    Varchar2 Default Null,
        p_mobile_off       Varchar2 Default Null,
        p_fax              Varchar2 Default Null,
        p_voip             Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin

        Select
            Count(*)
        Into
            v_exists
        From
            emp_details
        Where
            Trim(empno) = Trim(p_empno);

        If v_exists = 0 Then
            Insert Into emp_details
            (
                empno,
                blood_group,
                religion,
                marital_status,
                r_add_1,
                r_house_no,
                r_city,
                r_pincode,
                r_district,
                r_state,
                r_country,
                phone_res,
                mobile_res,
                ref_person_name,
                f_add_1,
                f_house_no,
                f_city,
                f_district,
                f_state,
                f_pincode,
                f_country,
                ref_person_phone,
                co_bus,
                pick_up_point,
                mobile_off,
                fax,
                voip,
                modified_on
            )

            Values
            (
                Trim(upper(p_empno)),
                Trim(upper(p_blood_group)),
                Trim(upper(p_religion)),
                Trim(p_marital_status),
                Trim(upper(p_r_add1)),
                Trim(upper(p_r_house_no)),
                Trim(upper(p_r_city)),
                p_r_pincode,
                Trim(upper(p_r_district)),
                Trim(upper(p_r_state)),
                Trim(upper(p_r_country)),
                Trim(p_phone_res),
                Trim(p_mobile_res),
                Trim(p_ref_person_name),
                Trim(upper(p_f_add1)),
                Trim(upper(p_f_house_no)),
                Trim(upper(p_f_city)),
                Trim(upper(p_f_district)),
                Trim(upper(p_f_state)),
                p_f_pincode,
                Trim(upper(p_f_country)),
                Trim(p_ref_person_phone),
                Trim(p_co_bus),
                Trim(p_pick_up_point),
                Trim(p_mobile_off),
                Trim(p_fax),
                Trim(p_voip),
                sysdate
            );

            Commit;

            p_message_type := ok;
            p_message_text := 'Employee secondary details added successfully..';
        Else
            Select
                Count(*)
            Into
                v_exists
            From
                emp_details
            Where
                Trim(empno) = Trim(p_empno);

            If v_exists = 1 Then

                Update
                    emp_details
                Set
                    blood_group = Trim(upper(p_blood_group)),
                    religion = Trim(upper(p_religion)),
                    marital_status = Trim(upper(p_marital_status)),
                    r_add_1 = Trim(upper(p_r_add1)),
                    r_house_no = Trim(upper(p_r_house_no)),
                    r_city = Trim(upper(p_r_city)),
                    r_pincode = p_r_pincode,
                    r_district = Trim(upper(p_r_district)),
                    r_state = Trim(upper(p_r_state)),
                    r_country = Trim(upper(p_r_country)),
                    phone_res = Trim(p_phone_res),
                    mobile_res = Trim(p_mobile_res),
                    ref_person_name = Trim(upper(p_ref_person_name)),
                    f_add_1 = Trim(upper(p_f_add1)),
                    f_house_no = Trim(upper(p_f_house_no)),
                    f_city = Trim(upper(p_f_city)),
                    f_district = Trim(upper(p_f_district)),
                    f_state = Trim(upper(p_f_state)),
                    f_pincode = p_f_pincode,
                    f_country = Trim(upper(p_f_country)),
                    ref_person_phone = Trim(p_ref_person_phone),
                    co_bus = Trim(p_co_bus),
                    pick_up_point = Trim(p_pick_up_point),
                    mobile_off = Trim(p_mobile_off),
                    fax = Trim(p_fax),
                    voip = Trim(p_voip),
                    modified_on = sysdate
                Where
                    Trim(empno) = Trim(p_empno);

                Commit;

                p_message_type := ok;
                p_message_text := 'Employee secondary details updated successfully.';
            Else
                p_message_type := not_ok;
                p_message_text := 'No matching Employee secondary details exists !!!';
            End If;

        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee secondary details already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_secondary_details;

    Procedure sp_delete_emp_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From emp_details
        Where
            empno = nvl(Trim(p_empno), v_empno);

        Commit;

        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_emp_details;

    Procedure sp_get_emp_primary_detail(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_empno                   Varchar2,
        p_first_name          Out Varchar2,
        p_surname             Out Varchar2,
        p_father_name         Out Varchar2,
        p_p_add               Out Varchar2,
        p_p_house_no          Out Varchar2,
        p_p_city              Out Varchar2,
        p_p_district          Out Varchar2,
        p_p_state             Out Varchar2,
        p_p_pincode           Out Varchar2,
        p_p_country           Out Varchar2,
        p_place_of_birth      Out Varchar2,
        p_country_of_birth    Out Varchar2,
        p_nationality         Out Varchar2,
        p_p_phone             Out Varchar2,
        p_no_of_child         Out Varchar2,
        p_personal_email      Out Varchar2,
        p_p_mobile            Out Varchar2,
        p_dob                 Out Varchar2,
        p_marital_status      Out Varchar2,
        p_religion            Out Varchar2,
        p_gender              Out Varchar2,
        p_no_dad_husb_in_name Out Varchar2,

        p_emp_name            Out Varchar2,
        p_parent              Out Varchar2,
        p_cost_name           Out Varchar2,
        p_assign              Out Varchar2,
        p_assign_name         Out Varchar2,
        p_emptype             Out Varchar2,
        p_desg_code           Out Varchar2,
        p_desg_name           Out Varchar2,
        p_doj                 Out Date,
        p_dol                 Out Date,
        p_doj_service         Out Varchar2,
        p_hod                 Out Varchar2,
        p_hod_name            Out Varchar2,
        p_secretary           Out Varchar2,
        p_secretary_name      Out Varchar2,
        p_grade               Out Varchar2,
        p_mngr_name           Out Varchar2,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            emp_details
        Where
            empno = Trim(p_empno);
        If v_count = 1 Then
            Select
                ed.name,
                ed.surname,
                ed.father_name,
                ed.p_add_1,
                ed.p_house_no,
                ed.p_city,
                ed.p_district,
                ed.p_state,
                ed.p_pincode,
                ed.p_country,
                ed.place_of_birth,
                ed.country_of_birth,
                ed.nationality,
                ed.p_phone,
                ed.no_of_child,
                ed.personal_email,
                ed.p_mobile,
                to_char(ove.dob, 'DD-Mon-YYYY') dob,
                ed.marital_status,
                ed.religion,
                ove.sex,
                to_char(nvl(ed.no_dad_husb_in_name, '0'))
            Into
                p_first_name,
                p_surname,
                p_father_name,
                p_p_add,
                p_p_house_no,
                p_p_city,
                p_p_district,
                p_p_state,
                p_p_pincode,
                p_p_country,
                p_place_of_birth,
                p_country_of_birth,
                p_nationality,
                p_p_phone,
                p_no_of_child,
                p_personal_email,
                p_p_mobile,
                p_dob,
                p_marital_status,
                p_religion,
                p_gender,
                p_no_dad_husb_in_name
            From
                emp_details                     ed, vu_emplmast ove
            Where
                ed.empno     = ove.empno
                And ed.empno = Trim(p_empno);
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vu_emplmast
        Where
            empno = Trim(p_empno);
        If v_count = 1 Then
            Select
                a.name,
                a.parent,
                b.name                                                                                                      As
                costname,
                a.assign,
                e.name                                                                                                      assignname,
                a.emptype,
                a.grade,
                a.desgcode,
                c.desg                                                                                                      As
                desgname,
                to_char(a.doj, 'DD-Mon-YYYY')                                                                               As
                doj,
                dol,
                fn_get_doj_4_report(p_person_id => p_person_id, p_meta_id => p_meta_id, p_empno => a.empno, p_doj => a.doj)
                As doj_service,
                b.hod,
                get_emp_name(b.hod)                                                                                         As
                hodname,
                b.secretary,
                get_emp_name(b.secretary)                                                                                   As
                sec_name,
                get_emp_name(a.mngr)                                                                                        mngr_name
            Into
                p_emp_name,
                p_parent,
                p_cost_name,
                p_assign,
                p_assign_name,
                p_emptype,
                p_grade,
                p_desg_code,
                p_desg_name,
                p_doj,
                p_dol,
                p_doj_service,
                p_hod,
                p_hod_name,
                p_secretary,
                p_secretary_name,
                p_mngr_name
            From
                vu_emplmast     a,
                ers_vu_costmast b,
                ers_vu_costmast e,
                ofb_vu_desgmast c
            Where
                a.parent       = b.costcode
                And a.assign   = e.costcode
                And a.desgcode = c.desgcode
                And a.empno    = Trim(p_empno);
        End If;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_get_emp_primary_detail;

    Procedure sp_get_emp_secondary_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2,

        p_blood_group      Out Varchar2,
        p_religion         Out Varchar2,
        p_marital_status   Out Varchar2,
        p_r_add            Out Varchar2,
        p_r_house_no       Out Varchar2,
        p_r_city           Out Varchar2,
        p_r_pincode        Out Varchar2,
        p_r_state          Out Varchar2,
        p_r_district       Out Varchar2,
        p_r_country        Out Varchar2,
        p_phone_res        Out Varchar2,
        p_mobile_res       Out Varchar2,
        p_ref_person_name  Out Varchar2,
        p_f_add            Out Varchar2,
        p_f_house_no       Out Varchar2,
        p_f_city           Out Varchar2,
        p_f_district       Out Varchar2,
        p_f_state          Out Varchar2,
        p_f_pincode        Out Varchar2,
        p_f_country        Out Varchar2,
        p_ref_person_phone Out Varchar2,
        p_co_bus_val       Out Varchar2,
        p_co_bus_text      Out Varchar2,
        p_pick_up_point    Out Varchar2,
        p_mobile_off       Out Varchar2,
        p_fax              Out Varchar2,
        p_voip             Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
        Distinct
            blood_group,
            religion,
            marital_status,
            r_add_1,
            r_house_no,
            r_city,
            r_pincode,
            r_state,
            r_district,
            r_country,
            phone_res,
            mobile_res,
            ref_person_name,
            f_add_1,
            f_house_no,
            f_city,
            f_district,
            f_pincode,
            f_state,
            f_country,
            ref_person_phone,
            co_bus,
            (
                Select
                Distinct bus.description
                From
                    emp_bus_master bus
                Where
                    bus.code = co_bus
            ) co_bus,
            pick_up_point,
            mobile_off,
            fax,
            voip
        Into
            p_blood_group,
            p_religion,
            p_marital_status,
            p_r_add,
            p_r_house_no,
            p_r_city,
            p_r_pincode,
            p_r_state,
            p_r_district,
            p_r_country,
            p_phone_res,
            p_mobile_res,
            p_ref_person_name,
            p_f_add,
            p_f_house_no,
            p_f_city,
            p_f_district,
            p_f_pincode,
            p_f_state,
            p_f_country,
            p_ref_person_phone,
            p_co_bus_val,
            p_co_bus_text,
            p_pick_up_point,
            p_mobile_off,
            p_fax,
            p_voip
        From
            emp_details
        Where
            Trim(empno) = Trim(p_empno);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_get_emp_secondary_detail;

    Procedure sp_emp_primary_detail(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,
        
        P_emp_no              Out Varchar2,
        p_first_name          Out Varchar2,
        p_surname             Out Varchar2,
        p_father_name         Out Varchar2,
        p_p_add               Out Varchar2,
        p_p_house_no          Out Varchar2,
        p_p_city              Out Varchar2,
        p_p_district          Out Varchar2,
        p_p_pincode           Out Varchar2,
        p_p_state             Out Varchar2,
        p_p_country           Out Varchar2,
        p_place_of_birth      Out Varchar2,
        p_country_of_birth    Out Varchar2,
        p_nationality         Out Varchar2,
        p_p_phone             Out Varchar2,
        p_no_of_child         Out Varchar2,
        p_personal_email      Out Varchar2,
        p_p_mobile            Out Varchar2,
        p_dob                 Out Varchar2,
        p_marital_status      Out Varchar2,
        p_religion            Out Varchar2,
        p_gender              Out Varchar2,
        p_no_dad_husb_in_name Out Varchar2,

        p_emp_name            Out Varchar2,
        p_parent              Out Varchar2,
        p_cost_name           Out Varchar2,
        p_assign              Out Varchar2,
        p_assign_name         Out Varchar2,
        p_emptype             Out Varchar2,
        p_desg_code           Out Varchar2,
        p_desg_name           Out Varchar2,
        p_doj                 Out Date,
        p_dol                 Out Date,
        p_doj_service         Out Varchar2,
        p_hod                 Out Varchar2,
        p_hod_name            Out Varchar2,
        p_secretary           Out Varchar2,
        p_secretary_name      Out Varchar2,
        p_grade               Out Varchar2,
        p_mngr_name           Out Varchar2,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
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
        
        P_emp_no := v_empno;
        
        pkg_emp_details.sp_get_emp_primary_detail(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,
            p_empno               => v_empno,
            p_first_name          => p_first_name,
            p_surname             => p_surname,
            p_father_name         => p_father_name,
            p_p_add               => p_p_add,
            p_p_house_no          => p_p_house_no,
            p_p_city              => p_p_city,
            p_p_district          => p_p_district,
            p_p_state             => p_p_state,
            p_p_pincode           => p_p_pincode,
            p_p_country           => p_p_country,
            p_place_of_birth      => p_place_of_birth,
            p_country_of_birth    => p_country_of_birth,
            p_nationality         => p_nationality,
            p_p_phone             => p_p_phone,
            p_no_of_child         => p_no_of_child,
            p_personal_email      => p_personal_email,
            p_p_mobile            => p_p_mobile,
            p_dob                 => p_dob,
            p_marital_status      => p_marital_status,
            p_religion            => p_religion,
            p_gender              => p_gender,
            p_no_dad_husb_in_name => p_no_dad_husb_in_name,
            p_emp_name            => p_emp_name,
            p_parent              => p_parent,
            p_cost_name           => p_cost_name,
            p_assign              => p_assign,
            p_assign_name         => p_assign_name,
            p_emptype             => p_emptype,
            p_desg_code           => p_desg_code,
            p_desg_name           => p_desg_name,
            p_doj                 => p_doj,
            p_dol                 => p_dol,
            p_doj_service         => p_doj_service,
            p_hod                 => p_hod,
            p_hod_name            => p_hod_name,
            p_secretary           => p_secretary,
            p_secretary_name      => p_secretary_name,
            p_grade               => p_grade,
            p_mngr_name           => p_mngr_name,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_primary_detail;

    Procedure sp_emp_secondary_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_blood_group      Out Varchar2,
        p_religion         Out Varchar2,
        p_marital_status   Out Varchar2,
        p_r_add            Out Varchar2,
        p_r_house_no       Out Varchar2,
        p_r_city           Out Varchar2,
        p_r_pincode        Out Varchar2,
        p_r_state          Out Varchar2,
        p_r_district       Out Varchar2,
        p_r_country        Out Varchar2,
        p_phone_res        Out Varchar2,
        p_mobile_res       Out Varchar2,
        p_ref_person_name  Out Varchar2,
        p_f_add            Out Varchar2,
        p_f_house_no       Out Varchar2,
        p_f_city           Out Varchar2,
        p_f_district       Out Varchar2,
        p_f_state          Out Varchar2,
        p_f_pincode        Out Varchar2,
        p_f_country        Out Varchar2,
        p_ref_person_phone Out Varchar2,
        p_co_bus_val       Out Varchar2,
        p_co_bus_text      Out Varchar2,
        p_pick_up_point    Out Varchar2,
        p_mobile_off       Out Varchar2,
        p_fax              Out Varchar2,
        p_voip             Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
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

        pkg_emp_details.sp_get_emp_secondary_detail(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,
            p_empno            => v_empno,
            p_blood_group      => p_blood_group,
            p_religion         => p_religion,
            p_marital_status   => p_marital_status,
            p_r_add            => p_r_add,
            p_r_house_no       => p_r_house_no,
            p_r_city           => p_r_city,
            p_r_pincode        => p_r_pincode,
            p_r_state          => p_r_state,
            p_r_district       => p_r_district,
            p_r_country        => p_r_country,
            p_phone_res        => p_phone_res,
            p_mobile_res       => p_mobile_res,
            p_ref_person_name  => p_ref_person_name,
            p_f_add            => p_f_add,
            p_f_house_no       => p_f_house_no,
            p_f_city           => p_f_city,
            p_f_district       => p_f_district,
            p_f_state          => p_f_state,
            p_f_pincode        => p_f_pincode,
            p_f_country        => p_f_country,
            p_ref_person_phone => p_ref_person_phone,
            p_co_bus_val       => p_co_bus_val,
            p_co_bus_text      => p_co_bus_text,
            p_pick_up_point    => p_pick_up_point,
            p_mobile_off       => p_mobile_off,
            p_fax              => p_fax,
            p_voip             => p_voip,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Err - Data not found.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_secondary_detail;

    Procedure sp_4hr_emp_primary_detail(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_empno                   Varchar2,
        P_emp_no              Out Varchar2,
        p_first_name          Out Varchar2,
        p_surname             Out Varchar2,
        p_father_name         Out Varchar2,
        p_p_add               Out Varchar2,
        p_p_house_no          Out Varchar2,
        p_p_city              Out Varchar2,
        p_p_district          Out Varchar2,
        p_p_state             Out Varchar2,
        p_p_pincode           Out Varchar2,
        p_p_country           Out Varchar2,
        p_place_of_birth      Out Varchar2,
        p_country_of_birth    Out Varchar2,
        p_nationality         Out Varchar2,
        p_p_phone             Out Varchar2,
        p_no_of_child         Out Varchar2,
        p_personal_email      Out Varchar2,
        p_p_mobile            Out Varchar2,
        p_dob                 Out Varchar2,
        p_marital_status      Out Varchar2,
        p_religion            Out Varchar2,
        p_gender              Out Varchar2,
        p_no_dad_husb_in_name Out Varchar2,

        p_emp_name            Out Varchar2,
        p_parent              Out Varchar2,
        p_cost_name           Out Varchar2,
        p_assign              Out Varchar2,
        p_assign_name         Out Varchar2,
        p_emptype             Out Varchar2,
        p_desg_code           Out Varchar2,
        p_desg_name           Out Varchar2,
        p_doj                 Out Date,
        p_dol                 Out Date,
        p_doj_service         Out Varchar2,
        p_hod                 Out Varchar2,
        p_hod_name            Out Varchar2,
        p_secretary           Out Varchar2,
        p_secretary_name      Out Varchar2,
        p_grade               Out Varchar2,
        p_mngr_name           Out Varchar2,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
    ) As
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
        
        P_emp_no :=  p_empno;
        
        pkg_emp_details.sp_get_emp_primary_detail(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,
            p_empno               => p_empno,
            p_first_name          => p_first_name,
            p_surname             => p_surname,
            p_father_name         => p_father_name,
            p_p_add               => p_p_add,
            p_p_house_no          => p_p_house_no,
            p_p_city              => p_p_city,
            p_p_district          => p_p_district,
            p_p_state             => p_p_state,
            p_p_pincode           => p_p_pincode,
            p_p_country           => p_p_country,
            p_place_of_birth      => p_place_of_birth,
            p_country_of_birth    => p_country_of_birth,
            p_nationality         => p_nationality,
            p_p_phone             => p_p_phone,
            p_no_of_child         => p_no_of_child,
            p_personal_email      => p_personal_email,
            p_p_mobile            => p_p_mobile,
            p_dob                 => p_dob,
            p_marital_status      => p_marital_status,
            p_religion            => p_religion,
            p_gender              => p_gender,
            p_no_dad_husb_in_name => p_no_dad_husb_in_name,
            p_emp_name            => p_emp_name,
            p_parent              => p_parent,
            p_cost_name           => p_cost_name,
            p_assign              => p_assign,
            p_assign_name         => p_assign_name,
            p_emptype             => p_emptype,
            p_desg_code           => p_desg_code,
            p_desg_name           => p_desg_name,
            p_doj                 => p_doj,
            p_dol                 => p_dol,
            p_doj_service         => p_doj_service,
            p_hod                 => p_hod,
            p_hod_name            => p_hod_name,
            p_secretary           => p_secretary,
            p_secretary_name      => p_secretary_name,
            p_grade               => p_grade,
            p_mngr_name           => p_mngr_name,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_4hr_emp_primary_detail;

    Procedure sp_4hr_emp_secondary_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2,

        p_blood_group      Out Varchar2,
        p_religion         Out Varchar2,
        p_marital_status   Out Varchar2,
        p_r_add            Out Varchar2,
        p_r_house_no       Out Varchar2,
        p_r_city           Out Varchar2,
        p_r_pincode        Out Varchar2,
        p_r_state          Out Varchar2,
        p_r_district       Out Varchar2,
        p_r_country        Out Varchar2,
        p_phone_res        Out Varchar2,
        p_mobile_res       Out Varchar2,
        p_ref_person_name  Out Varchar2,
        p_f_add            Out Varchar2,
        p_f_house_no       Out Varchar2,
        p_f_city           Out Varchar2,
        p_f_district       Out Varchar2,
        p_f_state          Out Varchar2,
        p_f_pincode        Out Varchar2,
        p_f_country        Out Varchar2,
        p_ref_person_phone Out Varchar2,
        p_co_bus_val       Out Varchar2,
        p_co_bus_text      Out Varchar2,
        p_pick_up_point    Out Varchar2,
        p_mobile_off       Out Varchar2,
        p_fax              Out Varchar2,
        p_voip             Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
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

        pkg_emp_details.sp_get_emp_secondary_detail(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,
            p_empno            => p_empno,
            p_blood_group      => p_blood_group,
            p_religion         => p_religion,
            p_marital_status   => p_marital_status,
            p_r_add            => p_r_add,
            p_r_house_no       => p_r_house_no,
            p_r_city           => p_r_city,
            p_r_state          => p_r_state,
            p_r_pincode        => p_r_pincode,
            p_r_district       => p_r_district,
            p_r_country        => p_r_country,
            p_phone_res        => p_phone_res,
            p_mobile_res       => p_mobile_res,
            p_ref_person_name  => p_ref_person_name,
            p_f_add            => p_f_add,
            p_f_house_no       => p_f_house_no,
            p_f_city           => p_f_city,
            p_f_district       => p_f_district,
            p_f_state          => p_f_state,
            p_f_pincode        => p_f_pincode,
            p_f_country        => p_f_country,
            p_ref_person_phone => p_ref_person_phone,
            p_co_bus_val       => p_co_bus_val,
            p_co_bus_text      => p_co_bus_text,
            p_pick_up_point    => p_pick_up_point,
            p_mobile_off       => p_mobile_off,
            p_fax              => p_fax,
            p_voip             => p_voip,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_4hr_emp_secondary_detail;

    Procedure sp_update_emp_primary_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_first_name          Varchar2 Default Null,
        p_surname             Varchar2 Default Null,
        p_father_name         Varchar2 Default Null,
        p_p_add1              Varchar2 Default Null,
        p_p_house_no          Varchar2 Default Null,
        p_p_city              Varchar2 Default Null,
        p_p_district          Varchar2 Default Null,
        p_p_state             Varchar2 Default Null,
        p_p_pincode           Number   Default Null,
        p_p_country           Varchar2 Default Null,
        p_place_of_birth      Varchar2 Default Null,
        p_country_of_birth    Varchar2 Default Null,
        p_nationality         Varchar2 Default Null,
        p_p_phone             Varchar2 Default Null,
        p_no_of_child         Number   Default Null,
        p_personal_email      Varchar2 Default Null,
        p_p_mobile            Varchar2 Default Null,
        p_no_dad_husb_in_name Number   Default Null,

        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
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

        pkg_emp_details.sp_add_primary_details(
            p_empno               => v_empno,
            p_first_name          => p_first_name,
            p_surname             => p_surname,
            p_father_name         => p_father_name,
            p_p_add1              => p_p_add1,
            p_p_house_no          => p_p_house_no,
            p_p_city              => p_p_city,
            p_p_district          => p_p_district,
            p_p_state             => p_p_state,
            p_p_pincode           => p_p_pincode,
            p_p_country           => p_p_country,
            p_place_of_birth      => p_place_of_birth,
            p_country_of_birth    => p_country_of_birth,
            p_nationality         => p_nationality,
            p_p_phone             => p_p_phone,
            p_no_of_child         => p_no_of_child,
            p_personal_email      => p_personal_email,
            p_no_dad_husb_in_name => p_no_dad_husb_in_name,
            p_p_mobile            => p_p_mobile,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_primary_details;

    Procedure sp_update_emp_secondary_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_blood_group      Varchar2 Default Null,
        p_religion         Varchar2 Default Null,
        p_marital_status   Varchar2 Default Null,
        p_r_add1           Varchar2 Default Null,
        p_r_house_no       Varchar2 Default Null,
        p_r_city           Varchar2 Default Null,
        p_r_pincode        Number   Default Null,
        p_r_district       Varchar2 Default Null,
        p_r_state          Varchar2 Default Null,
        p_r_country        Varchar2 Default Null,
        p_phone_res        Varchar2 Default Null,
        p_mobile_res       Varchar2 Default Null,
        p_ref_person_name  Varchar2 Default Null,
        p_f_add1           Varchar2 Default Null,
        p_f_house_no       Varchar2 Default Null,
        p_f_city           Varchar2 Default Null,
        p_f_district       Varchar2 Default Null,
        p_f_state          Varchar2 Default Null,
        p_f_pincode        Number   Default Null,
        p_f_country        Varchar2 Default Null,
        p_ref_person_phone Varchar2 Default Null,
        p_co_bus           Varchar2 Default Null,
        p_pick_up_point    Varchar2 Default Null,
        p_mobile_off       Varchar2 Default Null,
        p_fax              Varchar2 Default Null,
        p_voip             Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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

        pkg_emp_details.sp_add_secondary_details(
            p_empno            => v_empno,
            p_blood_group      => p_blood_group,
            p_religion         => p_religion,
            p_marital_status   => p_marital_status,
            p_r_add1           => p_r_add1,
            p_r_house_no       => p_r_house_no,
            p_r_city           => p_r_city,
            p_r_pincode        => p_r_pincode,
            p_r_district       => p_r_district,
            p_r_state          => p_r_state,
            p_r_country        => p_r_country,
            p_phone_res        => p_phone_res,
            p_mobile_res       => p_mobile_res,
            p_ref_person_name  => p_ref_person_name,
            p_f_add1           => p_f_add1,
            p_f_house_no       => p_f_house_no,
            p_f_city           => p_f_city,
            p_f_district       => p_f_district,
            p_f_state          => p_f_state,
            p_f_pincode        => p_f_pincode,
            p_f_country        => p_f_country,
            p_ref_person_phone => p_ref_person_phone,
            p_co_bus           => p_co_bus,
            p_pick_up_point    => p_pick_up_point,
            p_mobile_off       => p_mobile_off,
            p_fax              => p_fax,
            p_voip             => p_voip,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee secondary details already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_secondary_details;

    Procedure sp_update_4hr_emp_primary_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_empno               Varchar2,
        p_first_name          Varchar2 Default Null,
        p_surname             Varchar2 Default Null,
        p_father_name         Varchar2 Default Null,
        p_p_add1              Varchar2 Default Null,
        p_p_house_no          Varchar2 Default Null,
        p_p_city              Varchar2 Default Null,
        p_p_district          Varchar2 Default Null,
        p_p_state             Varchar2 Default Null,
        p_p_pincode           Number   Default Null,
        p_p_country           Varchar2 Default Null,
        p_place_of_birth      Varchar2 Default Null,
        p_country_of_birth    Varchar2 Default Null,
        p_nationality         Varchar2 Default Null,
        p_p_phone             Varchar2 Default Null,
        p_no_of_child         Number   Default Null,
        p_personal_email      Varchar2 Default Null,
        p_p_mobile            Varchar2 Default Null,
        p_no_dad_husb_in_name Number   Default Null,

        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
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

        pkg_emp_details.sp_add_primary_details(
            p_empno               => p_empno,
            p_first_name          => p_first_name,
            p_surname             => p_surname,
            p_father_name         => p_father_name,
            p_p_add1              => p_p_add1,
            p_p_house_no          => p_p_house_no,
            p_p_city              => p_p_city,
            p_p_district          => p_p_district,
            p_p_state             => p_p_state,
            p_p_pincode           => p_p_pincode,
            p_p_country           => p_p_country,
            p_place_of_birth      => p_place_of_birth,
            p_country_of_birth    => p_country_of_birth,
            p_nationality         => p_nationality,
            p_p_phone             => p_p_phone,
            p_no_of_child         => p_no_of_child,
            p_personal_email      => p_personal_email,
            p_no_dad_husb_in_name => p_no_dad_husb_in_name,
            p_p_mobile            => p_p_mobile,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_4hr_emp_primary_details;

    Procedure sp_update_4hr_emp_secondary_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_blood_group      Varchar2 Default Null,
        p_religion         Varchar2 Default Null,
        p_marital_status   Varchar2 Default Null,
        p_r_add1           Varchar2 Default Null,
        p_r_house_no       Varchar2 Default Null,
        p_r_city           Varchar2 Default Null,
        p_r_pincode        Number   Default Null,
        p_r_district       Varchar2 Default Null,
        p_r_state          Varchar2 Default Null,
        p_r_country        Varchar2 Default Null,
        p_phone_res        Varchar2 Default Null,
        p_mobile_res       Varchar2 Default Null,
        p_ref_person_name  Varchar2 Default Null,
        p_f_add1           Varchar2 Default Null,
        p_f_house_no       Varchar2 Default Null,
        p_f_city           Varchar2 Default Null,
        p_f_district       Varchar2 Default Null,
        p_f_state          Varchar2 Default Null,
        p_f_pincode        Number   Default Null,
        p_f_country        Varchar2 Default Null,
        p_ref_person_phone Varchar2 Default Null,
        p_co_bus           Varchar2 Default Null,
        p_pick_up_point    Varchar2 Default Null,
        p_mobile_off       Varchar2 Default Null,
        p_fax              Varchar2 Default Null,
        p_voip             Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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

        pkg_emp_details.sp_add_secondary_details(
            p_empno            => p_empno,
            p_blood_group      => p_blood_group,
            p_religion         => p_religion,
            p_marital_status   => p_marital_status,
            p_r_add1           => p_r_add1,
            p_r_house_no       => p_r_house_no,
            p_r_city           => p_r_city,
            p_r_pincode        => p_r_pincode,
            p_r_district       => p_r_district,
            p_r_state          => p_r_state,
            p_r_country        => p_r_country,
            p_phone_res        => p_phone_res,
            p_mobile_res       => p_mobile_res,
            p_ref_person_name  => p_ref_person_name,
            p_f_add1           => p_f_add1,
            p_f_house_no       => p_f_house_no,
            p_f_city           => p_f_city,
            p_f_district       => p_f_district,
            p_f_state          => p_f_state,
            p_f_pincode        => p_f_pincode,
            p_f_country        => p_f_country,
            p_ref_person_phone => p_ref_person_phone,
            p_co_bus           => p_co_bus,
            p_pick_up_point    => p_pick_up_point,
            p_mobile_off       => p_mobile_off,
            p_fax              => p_fax,
            p_voip             => p_voip,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee secondary details already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_4hr_emp_secondary_details;

    Function fn_get_doj_4_report(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_doj       Date) Return Varchar2 As
        v_dol Date;
    Begin
        Select
            dol
        Into
            v_dol
        From
            vu_prev_pf_no
        Where
            empno = Trim(p_empno);
        If v_dol < To_Date('01-APR-2011') Then
            Return Null;
        Else
            Return to_char(v_dol, 'Dd-Mon-YYYY');
        End If;
    Exception
        When Others Then
            Return to_char(p_doj, 'Dd-Mon-YYYY');
    End;

End pkg_emp_details;
/
 Grant Execute On   "TCMPL_HR"."PKG_EMP_DETAILS"  To "TCMPL_APP_CONFIG";