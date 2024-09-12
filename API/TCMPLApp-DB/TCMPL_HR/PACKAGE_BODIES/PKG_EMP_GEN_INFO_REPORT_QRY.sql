--------------------------------------------------------
--  DDL for Package Body PKG_EMP_GEN_INFO_REPORT_QRY
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_GEN_INFO_REPORT_QRY" As

    Function fn_emp_nominee_details_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                empno, nom_name, relation, share_pcnt
            From
                emp_epf
            Where
                empno In (
                    Select
                        empno
                    From
                        emp_nomination_status
                    Where
                        nvl(submitted, 'KO') = 'OK'
                        And empno In (
                            Select
                                empno
                            From
                                vu_emplmast
                            Where
                                status = 1
                        )
                )
            Order By
                empno;
        Return c;
    End fn_emp_nominee_details_list;

    Function fn_emp_family_details_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select
                empno,
                member,
                dob,
                remarks,
                relation_desc,
                Order_No,
                gender,
                occupation,
                name,
                grade,
                key_id,
                email,
                p_mobile mobile,
                p_phone  phone,
                mobile_res,
                phone_res

            From
                (
                    With
                        emp_mast As (
                            Select
                                empno,
                                name,
                                parent,
                                grade,
                                sex,
                                email
                            From
                                vu_emplmast
                            Where
                                status = 1
                                And parent != '0187'
                        ), emp_relation As (
                            Select
                                *
                            From
                                emp_relation_mast
                        ), occupation As (
                            Select
                                *
                            From
                                emp_occupation
                        )
                    Select
                        a.empno,
                        a.member,
                        a.dob,
                        a.remarks,
                        c.gender      gender,
                        c.description As relation_desc,
                        c.Order_No As Order_No,
                        b.description As occupation,
                        d.name,
                        d.grade,
                        a.key_id,
                        a.relation,
                        d.email,
                        ed.mobile_res,
                        ed.phone_res,
                        ed.p_mobile,
                        ed.p_phone
                    From
                        emp_family   a,
                        occupation   b,
                        emp_relation c,
                        emp_mast     d,
                        emp_details  ed
                    Where
                        (a.occupation   = b.code)
                        And (a.relation = c.code)
                        And (a.empno    = d.empno)
                        And a.empno     = ed.empno
                        And a.relation In (
                            3, 4
                        )
                        And (((trunc(sysdate) - a.dob) / 365) <= 25
                            And a.relation In (
                                3, 4
                            )) 
                    Union
                    Select
                        aa.empno,
                        aa.member,
                        aa.dob,
                        aa.remarks,
                        Case aa.relation
                            When 5 Then
                                dd.sex
                            Else
                                cc.gender
                        End            As gender,
                        cc.description As relation_desc,
                        cc.Order_No As Order_No,
                        bb.description As occupation,
                        dd.name,
                        dd.grade,
                        aa.key_id,
                        aa.relation,
                        dd.email,
                        ed.mobile_res,
                        ed.phone_res,
                        ed.p_mobile,
                        ed.p_phone
                    From
                        emp_family   aa,
                        occupation   bb,
                        emp_relation cc,
                        emp_mast     dd,
                        emp_details  ed
                    Where
                        (aa.occupation   = bb.code)
                        And (aa.relation = cc.code)
                        And (aa.empno    = dd.empno)
                        And aa.empno     = ed.empno
                        And aa.relation Not In (
                            3, 4
                        )
                )Order by  empno , Order_No ;
        Return c;
    End fn_emp_family_details_list;

    Function fn_emp_mediclaim_details_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_empno      Varchar2 Default Null,
        p_start_date Date,
        p_end_date   Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                a.empno,
                a.member,
                a.dob,
                a.remarks,
                a.chg_date,
                a.chg_type,
                c.description As relation,
                b.description As occupation,
                d.name,
                d.grade,
                a.key_id
            From
                emp_family_log    a,
                emp_occupation    b,
                emp_relation_mast c,
                vu_emplmast       d
            Where
                a.occupation   = b.code
                And a.relation = c.code
                And a.empno    = d.empno
                And a.chg_date >= p_start_date
                And a.chg_date <= p_end_date;

        Return c;
    End fn_emp_mediclaim_details_list;

    Function fn_emp_details_not_filled_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select
                empno, name, parent, assign, co_bus, doj, email
            From
                (
                    Select
                        a.empno,
                        a.name,
                        a.parent,
                        a.assign,
                        b.co_bus,
                        a.doj,
                        a.email
                    From
                        vu_emplmast a,
                        emp_details b
                    Where
                        a.empno      = b.empno (+)
                        And a.status = 1
                        And a.emptype In (
                            Select
                                emptype
                            From
                                emp_details_include_emptype
                        )
                ) c
            Where
                c.co_bus Is Null;

        Return c;
    End fn_emp_details_not_filled_list;

    Function fn_emp_details_all_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select
                empno,
                parent,
                email,
                replace(replace(replace(name, Chr(10), ''), Chr(13), ''), Chr(9), '')                name,
                replace(replace(replace(surname, Chr(10), ''), Chr(13), ''), Chr(9), '')             surname,
                replace(replace(replace(father_name, Chr(10), ''), Chr(13), ''), Chr(9), '')         father_name,
                replace(replace(replace(place_of_birth, Chr(10), ''), Chr(13), ''), Chr(9), '')      place_of_birth,
                replace(replace(replace(country_of_birth, Chr(10), ''), Chr(13), ''), Chr(9), '')    country_of_birth,
                replace(replace(replace(nationality, Chr(10), ''), Chr(13), ''), Chr(9), '')         nationality,
                replace(replace(replace(personal_email, Chr(10), ''), Chr(13), ''), Chr(9), '')      personal_email,
                replace(replace(replace(no_of_child, Chr(10), ''), Chr(13), ''), Chr(9), '')         no_of_child,
                replace(replace(replace(p_add_1, Chr(10), ''), Chr(13), ''), Chr(9), '')             p_add_1,
                replace(replace(replace(p_state, Chr(10), ''), Chr(13), ''), Chr(9), '')             p_state,
                replace(replace(replace(p_house_no, Chr(10), ''), Chr(13), ''), Chr(9), '')          p_house_no,
                replace(replace(replace(p_city, Chr(10), ''), Chr(13), ''), Chr(9), '')              p_city,
                replace(replace(replace(p_district, Chr(10), ''), Chr(13), ''), Chr(9), '')          p_district,
                replace(replace(replace(p_country, Chr(10), ''), Chr(13), ''), Chr(9), '')           p_country,
                replace(replace(replace(p_pincode, Chr(10), ''), Chr(13), ''), Chr(9), '')           p_pincode,
                replace(replace(replace(p_mobile, Chr(10), ''), Chr(13), ''), Chr(9), '')            p_mobile,
                replace(replace(replace(adhaar_no, Chr(10), ''), Chr(13), ''), Chr(9), '')           adhaar_no,
                replace(replace(replace(adhaar_name, Chr(10), ''), Chr(13), ''), Chr(9), '')         adhaar_name,

                replace(replace(replace(mobile_res, Chr(10), ''), Chr(13), ''), Chr(9), '')          mob_res,
                replace(replace(replace(phone_res, Chr(10), ''), Chr(13), ''), Chr(9), '')           phon_res,
                replace(replace(replace(mobile_off, Chr(10), ''), Chr(13), ''), Chr(9), '')          mob_off,

                Case
                    When ac_file Is Null Then
                        'No'
                    Else
                        'Yes'
                End                                                                                  adhar_uploaded,

                replace(replace(replace(passport_surname, Chr(10), ''), Chr(13), ''), Chr(9), '')    passport_surname,
                replace(replace(replace(passport_given_name, Chr(10), ''), Chr(13), ''), Chr(9), '') passport_given_name,
                replace(replace(replace(passport_no, Chr(10), ''), Chr(13), ''), Chr(9), '')         passport_no,
                replace(replace(replace(issue_date, Chr(10), ''), Chr(13), ''), Chr(9), '')          issue_date,
                replace(replace(replace(expiry_date, Chr(10), ''), Chr(13), ''), Chr(9), '')         expiry_date,

                Case
                    When pp_file Is Null Then
                        'No'
                    Else
                        'Yes'
                End                                                                                  passport_uploaded,

                replace(replace(replace(r_add_1, Chr(10), ''), Chr(13), ''), Chr(9), '')             r_add_1,
                replace(replace(replace(r_state, Chr(10), ''), Chr(13), ''), Chr(9), '')             r_state,
                replace(replace(replace(r_house_no, Chr(10), ''), Chr(13), ''), Chr(9), '')          r_house_no,
                replace(replace(replace(r_city, Chr(10), ''), Chr(13), ''), Chr(9), '')              r_city,
                replace(replace(replace(r_district, Chr(10), ''), Chr(13), ''), Chr(9), '')          r_district,
                replace(replace(replace(r_country, Chr(10), ''), Chr(13), ''), Chr(9), '')           r_country,
                replace(replace(replace(r_pincode, Chr(10), ''), Chr(13), ''), Chr(9), '')           r_pincode,
                replace(replace(replace(ref_person_name, Chr(10), ''), Chr(13), ''), Chr(9), '')     ref_person_name,
                replace(replace(replace(ref_person_phone, Chr(10), ''), Chr(13), ''), Chr(9), '')    ref_person_phone,
                replace(replace(replace(f_add_1, Chr(10), ''), Chr(13), ''), Chr(9), '')             f_add_1,
                replace(replace(replace(f_state, Chr(10), ''), Chr(13), ''), Chr(9), '')             f_state,
                replace(replace(replace(f_house_no, Chr(10), ''), Chr(13), ''), Chr(9), '')          f_house_no,
                replace(replace(replace(f_city, Chr(10), ''), Chr(13), ''), Chr(9), '')              f_city,
                replace(replace(replace(f_district, Chr(10), ''), Chr(13), ''), Chr(9), '')          f_district,
                replace(replace(replace(f_country, Chr(10), ''), Chr(13), ''), Chr(9), '')           f_country,
                replace(replace(replace(f_pincode, Chr(10), ''), Chr(13), ''), Chr(9), '')           f_pincode,
                co_bus_name,
                replace(replace(replace(pick_up_point, Chr(10), ''), Chr(13), ''), Chr(9), '')       bus_pick_up_point,
                replace(replace(replace(religion, Chr(10), ''), Chr(13), ''), Chr(9), '')            emp_religion

            From
                (

                    With
                        pp As (
                            Select
                                empno || Trim(ref_number)                  emp_pp_no,
                                file_type,
                                modified_on,
                                Max(modified_on) Over( Partition By empno) max_date
                            From
                                emp_scan_file esfp
                            Where
                                file_type = 'PP'
                                And Rowid In (
                                    Select
                                            Max(Rowid) Keep (Dense_Rank Last Order By modified_on)
                                    From
                                        emp_scan_file
                                    Where
                                        empno         = esfp.empno
                                        And file_type = esfp.file_type
                                    Group By empno
                                )
                        ), ac As (
                            Select
                                empno || Trim(ref_number)                  emp_ac_no,
                                file_type,
                                modified_on,
                                Max(modified_on) Over( Partition By empno) max_date
                            From
                                emp_scan_file esfa
                            Where
                                file_type = 'AC'
                                And Rowid In (
                                    Select
                                            Max(Rowid) Keep (Dense_Rank Last Order By modified_on)
                                    From
                                        emp_scan_file
                                    Where
                                        empno         = esfa.empno
                                        And file_type = esfa.file_type
                                    Group By empno
                                )
                        )
                    Select
                        emp_mast.empno,
                        emp_mast.parent,
                        emp_mast.email,
                        a.name,
                        a.surname,
                        a.father_name,
                        a.place_of_birth,
                        a.country_of_birth,
                        a.nationality,
                        a.personal_email,
                        a.no_of_child,
                        a.p_add_1,
                        a.p_state,
                        a.p_house_no,
                        a.p_city,
                        a.p_district,
                        a.p_country,
                        a.p_pincode,
                        a.p_mobile,
                        b.adhaar_no,
                        b.adhaar_name,
                        ac.file_type                             ac_file,
                        a.passport_surname,
                        a.passport_given_name,
                        a.passport_no,
                        a.issue_date,
                        a.expiry_date,
                        pp.file_type                             pp_file,
                        a.r_add_1,
                        a.r_state,
                        a.r_house_no,
                        a.r_city,
                        a.r_district,
                        a.r_country,
                        a.r_pincode,
                        a.ref_person_name,
                        a.ref_person_phone,
                        a.f_add_1,
                        a.f_state,
                        a.f_house_no,
                        a.f_city,
                        a.f_district,
                        a.f_country,
                        a.f_pincode,
                        Trim(a.co_bus) || ' - ' || c.description co_bus_name,
                        pick_up_point,
                        a.religion,
                        a.mobile_res,
                        a.phone_res,
                        a.mobile_off
                    From
                        vu_emplmast    emp_mast,
                        emp_details    a,
                        emp_adhaar     b,
                        ac,
                        pp,
                        emp_bus_master c
                    Where
                        emp_mast.empno                      = a.empno (+)
                        And emp_mast.empno                  = b.empno (+)
                        And b.empno || Trim(b.adhaar_no)    = ac.emp_ac_no(+)
                        And a.empno || Trim (a.passport_no) = pp.emp_pp_no (+)
                        And emp_mast.status                 = 1
                        And emp_mast.emptype In (
                            Select
                                emptype
                            From
                                emp_details_include_emptype
                        )
                        And a.co_bus                        = c.code(+)
                );
        --Where empno = nvl(Trim(p_empno), v_empno);

        Return c;
    End fn_emp_details_all_list;

    Function fn_emp_aadhaar_details_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                empno,
                adhaar_no,
                adhaar_name
            From
                emp_adhaar
            Where
                empno In (
                    Select
                        empno
                    From
                        vu_emplmast
                    Where
                        status = 1
                );

        Return c;
    End fn_emp_aadhaar_details_list;

    Function fn_ex_emp_nominee_details_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_year      Varchar2 Default Null,
        p_empno_csv Varchar2 Default Null,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                Row_Number() Over (Order By
                        1 Desc)  row_number,
                Count(*) Over () total_row
            From
                dual;
        --Where empno = nvl(Trim(p_empno), v_empno);

        Return c;
    End fn_ex_emp_nominee_details_list;

    Function fn_ex_emp_contact_info_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_year      Varchar2 Default Null,
        p_empno_csv Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_year Is Null And p_empno_csv Is Null Then
            Return Null;
        End If;
        If p_year Is Not Null Then
            Open c For

                Select
                    e.empno,
                    e.name                        employee_name,
                    e.parent || ' - ' || c.name   dept_name,
                    ed.personal_email             email,
                    e.dol,
                    r_add_1 || ' - ' || r_pincode residential_address,
                    phone_res                     residential_phone,
                    mobile_res                    residential_mobile,
                    p_add_1 || ' - ' || p_pincode permanent_address,
                    p_phone                       phone,
                    p_mobile                      mobile
                From
                    emp_details ed,
                    vu_emplmast e,
                    vu_costmast c
                Where
                    e.empno      = ed.empno
                    And e.parent = c.costcode
                    And e.dol Between trunc(To_Date(p_year, 'YYYY'), 'yy') And (trunc(To_Date(p_year + 1, 'YYYY'), 'yy') - 1);

        Else
            Open c For
                Select
                    e.empno,
                    e.name                        employee_name,
                    e.parent || ' - ' || c.name   dept_name,
                    ed.personal_email             email,
                    e.dol,
                    r_add_1 || ' - ' || r_pincode residential_address,
                    phone_res                     residential_phone,
                    mobile_res                    residential_mobile,
                    p_add_1 || ' - ' || p_pincode permanent_address,
                    p_phone                       phone,
                    p_mobile                      mobile
                From
                    emp_details ed,
                    vu_emplmast e,
                    vu_costmast c
                Where
                    e.empno      = ed.empno
                    And e.parent = c.costcode
                    And e.empno In (
                        Select
                            regexp_substr(p_empno_csv, '[^,]+', 1, level) value
                        From
                            dual
                        Connect By
                            level <=
                            length(Trim (Both ','
                                    From
                                    p_empno_csv)) - length(replace(p_empno_csv, ',')) + 1
                    );
        End If;
        Return c;
    End fn_ex_emp_contact_info_list;

End pkg_emp_gen_info_report_qry;
/
Grant Execute On "TCMPL_HR"."PKG_EMP_GEN_INFO_REPORT_QRY" To "TCMPL_APP_CONFIG";
/