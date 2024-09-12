--------------------------------------------------------
--  DDL for Package Body HR_PKG_EMPLMAST_MAIN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_EMPLMAST_MAIN" as

  Procedure add_employee (
        p_empno         Varchar2,
        p_abbr          Varchar2,
        p_emptype       Varchar2,
        p_email         Varchar2,
        p_parent        Varchar2,
        p_desgcode      Varchar2,
        p_dob           Date,
        p_doj           Date,
        p_office        Varchar2,
        p_sex           Varchar2,
        p_category      Varchar2,
        p_married       Varchar2,
        p_metaid        Varchar2,
        p_personid      Varchar2,
        p_grade         Varchar2,
        p_company       Varchar2,
        p_firstname	    Varchar2,
        p_middlename	Varchar2,
        p_lastname	    Varchar2,
        p_success   Out             Varchar2,
        p_message   Out             Varchar2
    ) as
    v_exists number := 0;
  begin
    Select
            Count(empno)
        Into
            v_exists
        From
            hr_emplmast_main
        Where
            empno = p_empno;
    if v_exists = 0 then
        insert into hr_emplmast_main (
            empno, name, abbr, emptype, email, parent, assign, desgcode,
            dob, doj, office, sex, category, married, metaid, personid,
            grade, company, status, firstname, middlename, lastname
        )
        values(
            p_empno, upper(trim(p_lastname||' '||p_firstname||' '||p_middlename)), p_abbr, p_emptype,
            p_email, p_parent, p_parent, p_desgcode,
            p_dob, p_doj, p_office, p_sex, p_category, p_married, p_metaid, p_personid,
            p_grade, p_company, 1, upper(p_firstname), upper(p_middlename), upper(p_lastname)
        );
        /* Update other employee master tables */
        insert into hr_emplmast_address(empno) values(p_empno);
        insert into hr_emplmast_applications(empno) values(p_empno);
        insert into hr_emplmast_misc(empno) values(p_empno);
        insert into hr_emplmast_organization(empno, mngr, emp_hod)
            values(p_empno, hr_pkg_common.get_costcenter_hod(p_parent),
                    hr_pkg_common.get_costcenter_hod(p_parent));
        insert into hr_emplmast_roles(empno) values(p_empno);

        /* Update EMPLMAST */
        insert into emplmast (
            empno, name, abbr, emptype, email, parent, assign, desgcode,
            dob, doj, office, sex, category, married, metaid, personid,
            grade, company, status, firstname, middlename, lastname
        )
        values(
            p_empno, upper(trim(p_lastname||' '||p_firstname||' '||p_middlename)), p_abbr, p_emptype,
            p_email, p_parent, p_parent, p_desgcode,
            p_dob, p_doj, p_office, p_sex, p_category, p_married, p_metaid, p_personid,
            p_grade, p_company, 1, upper(p_firstname), upper(p_middlename), upper(p_lastname)
        );

        Commit;

        --Process user
        Begin
            tcmpl_app_config.pkg_process_employee.sp_process_run(p_empno, 'ADD', p_success, p_message);
        Exception
            When Others Then
                Null;
        End;

        p_success   := 'OK';
        p_message   := 'Employee added successfully';
    else
        p_success   := 'KO';
        p_message   := 'Employee already exists';
    end if;

    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end add_employee;

  Procedure edit_employee_main(
        p_empno         Varchar2,
        p_abbr          Varchar2,
        p_emptype       Varchar2,
        p_email         Varchar2,
        p_parent        Varchar2,
        p_assign        Varchar2,
        p_desgcode      Varchar2,
        p_dob           Date,
        p_doj           Date,
        p_office        Varchar2,
        p_sex           Varchar2,
        p_category      Varchar2,
        p_married       Varchar2,
        p_metaid        Varchar2,
        p_personid      Varchar2,
        p_grade         Varchar2,
        p_company       Varchar2,
        p_doc           Date,
        p_firstname	    Varchar2,
        p_middlename	Varchar2,
        p_lastname	    Varchar2,
        p_success   Out             Varchar2,
        p_message   Out             Varchar2
    ) as

  begin
        update hr_emplmast_main
        set name = trim(p_lastname||' '||p_firstname||' '||p_middlename),
            abbr = p_abbr,
            emptype = p_emptype,
            email = p_email,
            parent = p_parent,
            assign = p_assign,
            desgcode = p_desgcode,
            dob = p_dob,
            doj = p_doj,
            office = p_office,
            sex = p_sex,
            category = p_category,
            married = p_married,
            metaid = p_metaid,
            personid = p_personid,
            grade = p_grade,
            company = p_company,
            firstname = p_firstname,
            middlename = p_middlename,
            lastname = p_lastname,
            doc = p_doc
        where empno = p_empno;

        /* Update EMPLMAST */
        update emplmast
        set name = trim(p_lastname||' '||p_firstname||' '||p_middlename),
            abbr = p_abbr,
            emptype = p_emptype,
            email = p_email,
            parent = p_parent,
            assign = p_assign,
            desgcode = p_desgcode,
            dob = p_dob,
            doj = p_doj,
            office = p_office,
            sex = p_sex,
            category = p_category,
            married = p_married,
            metaid = p_metaid,
            personid = p_personid,
            grade = p_grade,
            company = p_company,
            firstname = p_firstname,
            middlename = p_middlename,
            lastname = p_lastname
        where empno = p_empno;

        p_success   := 'OK';
        p_message   := 'Employee details updated successfully';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end edit_employee_main;

  procedure deactivate_employee (
        p_empno     varchar2,
        p_dol       Date,
        p_reason_id  varchar2,
        p_remarks   varchar2,
        p_success   out             varchar2,
        p_message   out             varchar2
    ) as
  begin
    update hr_emplmast_organization
        set dol = p_dol,
           reasonid = p_reason_id,
           remarks = p_remarks
    where empno = p_empno;

    update hr_emplmast_main
        set status = 0
    where empno = p_empno;

    update hr_emplmast_applications
        set payroll = 0
    where empno = p_empno;

    /* Update EMPLMAST */
    update emplmast
        set dol = p_dol,
        reasonid = p_reason_id,
        remarks = p_remarks,
        status = 0,
        payroll = 0
    where empno = p_empno;

    Commit;

        --Process user
        Begin
            tcmpl_app_config.pkg_process_employee.sp_process_run(p_empno, 'DEACTIVATE', p_success, p_message);
        Exception
            When Others Then
                Null;
        End;

        p_success   := 'OK';
        p_message   := 'Procedure executed';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;

  end deactivate_employee;

   procedure activate_employee (
        p_empno     varchar2,
        p_success   out             varchar2,
        p_message   out             varchar2
    ) as
  begin
    update hr_emplmast_main
        set status = 1
    where empno = p_empno;

    /* Update EMPLMAST */
    update emplmast
        set status = 1
    where empno = p_empno;

    Commit;

        --Process user
        Begin
            tcmpl_app_config.pkg_process_employee.sp_process_run(p_empno, 'ACTIVATE', p_success, p_message);
        Exception
            When Others Then
                Null;
        End;

        p_success   := 'OK';
        p_message   := 'Procedure executed';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;

  end activate_employee;

  Procedure clone_employee (
        p_empno         varchar2,
        p_emptype       Varchar2,
        p_empno_new     varchar2,
        p_parent        Varchar2,
        p_assign        Varchar2,
        p_doj           Date,
        p_office        Varchar2,
        p_success   Out             Varchar2,
        p_message   Out             Varchar2
    ) as
    v_exists number := 0;

    l_main_rec hr_emplmast_main%rowtype;
    l_organization_rec hr_emplmast_organization%rowtype;
    l_address_rec hr_emplmast_address%rowtype;
    l_applications_rec hr_emplmast_applications%rowtype;
    l_roles_rec hr_emplmast_roles%rowtype;
    l_misc_rec hr_emplmast_misc%rowtype;

    l_emplmast_rec emplmast%rowtype;
  begin
    select count(empno) into v_exists from hr_emplmast_main where empno = p_empno_new;
    if v_exists = 0 then
       /* Get existing employee master data */
       select * into l_main_rec from hr_emplmast_main where empno = p_empno;
       select * into l_organization_rec from hr_emplmast_organization where empno = p_empno;
       select * into l_address_rec from hr_emplmast_address where empno = p_empno;
       select * into l_applications_rec from hr_emplmast_applications where empno = p_empno;
       select * into l_roles_rec from hr_emplmast_roles where empno = p_empno;
       select * into l_misc_rec from hr_emplmast_misc where empno = p_empno;

       select * into l_emplmast_rec from emplmast where empno = p_empno;

       /* Update employee master tables */
       l_main_rec.empno := p_empno_new;
       l_main_rec.emptype := p_emptype;
       l_main_rec.parent := p_parent;
       l_main_rec.assign := p_assign;
       l_main_rec.doj := p_doj;
       l_main_rec.status := 1;
       insert into hr_emplmast_main values l_main_rec ;

       l_organization_rec.empno := p_empno_new;
       l_organization_rec.place := p_office;
       l_organization_rec.dol := null;
       l_organization_rec.remarks := '';
       insert into hr_emplmast_organization values l_organization_rec;
       insert into hr_emplmast_organization_qual select p_empno_new, qualification_id from hr_emplmast_organization_qual where empno = p_empno;

       l_address_rec.empno := p_empno_new;
       insert into hr_emplmast_address values l_address_rec;

       l_applications_rec.empno := p_empno_new;
       insert into hr_emplmast_applications values l_applications_rec ;

       l_roles_rec.empno := p_empno_new;
       insert into hr_emplmast_roles values l_roles_rec ;

       l_misc_rec.empno := p_empno_new;
       insert into hr_emplmast_misc values l_misc_rec ;

       /* Update emplmast table */
       l_emplmast_rec.empno := p_empno_new;
       l_emplmast_rec.emptype := p_emptype;
       l_emplmast_rec.parent := p_parent;
       l_emplmast_rec.assign := p_assign;
       l_emplmast_rec.doj := p_doj;
       l_emplmast_rec.status := 1;
       l_emplmast_rec.place := p_office;
       l_emplmast_rec.dol := null;
       l_emplmast_rec.remarks := '';
       insert into emplmast values l_emplmast_rec ;

       Commit;

        --Process user
        Begin
            tcmpl_app_config.pkg_process_employee.sp_process_run(p_empno, 'CLONE', p_success, p_message);
        Exception
            When Others Then
                Null;
        End;

       p_success   := 'OK';
       p_message   := 'Employee cloned successfully';
    else
       p_success   := 'KO';
       p_message   := 'Employee already exists';
    end if;
  end clone_employee;

  Procedure import_employees(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_employees            typ_tab_string,
        p_employees_errors Out typ_tab_string,
        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno             Varchar2(5);
        v_firstname         Varchar2(50);
        v_middlename        Varchar2(50);
        v_lastname          Varchar2(50);
        v_emptype           Varchar2(1);
        v_gender            Varchar2(1);
        v_category          Varchar2(1);
        v_grade             Varchar2(2);
        v_designation       Varchar2(6);
        v_dob               Date;
        v_doj               Date;
        v_contractenddate   Date;
        v_parent            Varchar2(4);
        v_assigned          Varchar2(4);
        v_office            Varchar2(2);
        v_subcontractagency Varchar2(3);
        v_location          Varchar2(1);
        v_place             Varchar2(3);

        v_valid_emp_cntr    Number := 0;
        tab_valid_employees typ_tab_employees;
        v_rec_employee      rec_employee;
        v_err_num           Number;
        is_error_in_row     Boolean;
        v_count             Number;
        v_reason            Varchar2(30);
        v_msg_text          Varchar2(200);
        v_msg_type          Varchar2(10);
    Begin
        v_err_num := 0;
        For i In 1..p_employees.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_employees(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1))                       empno,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1))                       firstname,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1))                       middlename,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 4, Null, 1))                       lastname,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 5, Null, 1))                       emptype,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 6, Null, 1))                       gender,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 7, Null, 1))                       category,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 8, Null, 1))                       grade,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 9, Null, 1))                       designation,
                to_date(Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 10, Null, 1)), 'yyyymmdd') dob,
                to_date(Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 11, Null, 1)), 'yyyymmdd') doj,
                to_date(Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 12, Null, 1)), 'yyyymmdd') contractenddate,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 13, Null, 1))                      parent,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 14, Null, 1))                      assigned,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 15, Null, 1))                      office,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 16, Null, 1))                      subcontractagency,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 17, Null, 1))                      location,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 18, Null, 1))                      place
            Into
                v_empno,
                v_firstname,
                v_middlename,
                v_lastname,
                v_emptype,
                v_gender,
                v_category,
                v_grade,
                v_designation,
                v_dob,
                v_doj,
                v_contractenddate,
                v_parent,
                v_assigned,
                v_office,
                v_subcontractagency,
                v_location,
                v_place
            From
                csv;

            --emptype
            Select
                Count(*)
            Into
                v_count
            From
                emptypemast
            Where
                emptype = v_emptype;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Emptype' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Emptype not found';    --Message
                is_error_in_row := true;
            End If;

            --Gender
            Select
                Count(*)
            Into
                v_count
            From
                hr_gender_master
            Where
                gender_id = v_gender;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Gender' || '~!~' ||    --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Gender not found';     --Message
                is_error_in_row := true;
            End If;

            --Category
            Select
                Count(*)
            Into
                v_count
            From
                hr_category_master
            Where
                categoryid = v_category;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Category' || '~!~' ||  --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Category not found';   --Message
                is_error_in_row := true;
            End If;

            --Grade
            Select
                Count(*)
            Into
                v_count
            From
                hr_grade_master
            Where
                grade_id = v_grade;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Grade' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Grade not found';      --Message
                is_error_in_row := true;
            End If;

            --Designation
            Select
                Count(*)
            Into
                v_count
            From
                desgmast
            Where
                desgcode = v_designation;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||       --ID
                    '' || '~!~' ||              --Section
                    i || '~!~' ||               --XL row number
                    'Designation' || '~!~' ||   --FieldName
                    '0' || '~!~' ||             --ErrorType
                    'Critical' || '~!~' ||      --ErrorTypeString
                    'Designation not found';    --Message
                is_error_in_row := true;
            End If;

            --Parent
            Select
                Count(*)
            Into
                v_count
            From
                costmast
            Where
                costcode = v_parent;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||    --ID
                    '' || '~!~' ||           --Section
                    i || '~!~' ||            --XL row number
                    'Parent' || '~!~' ||     --FieldName
                    '0' || '~!~' ||          --ErrorType
                    'Critical' || '~!~' ||   --ErrorTypeString
                    'Parent not found';      --Message
                is_error_in_row := true;
            End If;

            --Assigned
            Select
                Count(*)
            Into
                v_count
            From
                costmast
            Where
                costcode = v_assigned;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||    --ID
                    '' || '~!~' ||           --Section
                    i || '~!~' ||            --XL row number
                    'Assigned' || '~!~' ||   --FieldName
                    '0' || '~!~' ||          --ErrorType
                    'Critical' || '~!~' ||   --ErrorTypeString
                    'Assigned not found';    --Message
                is_error_in_row := true;
            End If;

            --Office
            Select
                Count(*)
            Into
                v_count
            From
                offimast
            Where
                office = v_office;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||    --ID
                    '' || '~!~' ||           --Section
                    i || '~!~' ||            --XL row number
                    'Office' || '~!~' ||     --FieldName
                    '0' || '~!~' ||          --ErrorType
                    'Critical' || '~!~' ||   --ErrorTypeString
                    'Office not found';      --Message
                is_error_in_row := true;
            End If;

            -- Subcontract

            If v_subcontractagency Is Not Null then
                Select
                    Count(*)
                Into
                    v_count
                From
                    subcontractmast
                Where
                    subcontract = v_subcontractagency;
                If v_count = 0 Then
                    v_err_num       := v_err_num + 1;
                    p_employees_errors(v_err_num) :=
                        v_err_num || '~!~' ||               --ID
                        '' || '~!~' ||                      --Section
                        i || '~!~' ||                       --XL row number
                        'SubcontractAgency' || '~!~' ||     --FieldName
                        '0' || '~!~' ||                     --ErrorType
                        'Critical' || '~!~' ||              --ErrorTypeString
                        'SubcontractAgency not found';      --Message
                    is_error_in_row := true;
                End If;
            End If;

            -- Location
            Select
                Count(*)
            Into
                v_count
            From
                hr_location_master
            Where
                locationid = v_location;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Location' || '~!~' ||  --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Location not found';   --Message
                is_error_in_row := true;
            End If;

            -- Place
            Select
                Count(*)
            Into
                v_count
            From
                hr_place_master
            Where
                place_id = v_place;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Place' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Place not found';      --Message
                is_error_in_row := true;
            End If;

            If is_error_in_row = false Then
                v_valid_emp_cntr                                  := nvl(v_valid_emp_cntr, 0) + 1;

                --v_rec_claim.empno := v_empno;

                tab_valid_employees(v_valid_emp_cntr).empno       := v_empno;
                tab_valid_employees(v_valid_emp_cntr).emptype     := v_emptype;
                tab_valid_employees(v_valid_emp_cntr).parent      := v_parent;
                tab_valid_employees(v_valid_emp_cntr).designation := v_designation;
                tab_valid_employees(v_valid_emp_cntr).dob         := v_dob;
                tab_valid_employees(v_valid_emp_cntr).doj         := v_doj;
                tab_valid_employees(v_valid_emp_cntr).office      := v_office;
                tab_valid_employees(v_valid_emp_cntr).gender      := v_gender;
                tab_valid_employees(v_valid_emp_cntr).category    := v_category;
                tab_valid_employees(v_valid_emp_cntr).grade       := v_grade;
                tab_valid_employees(v_valid_emp_cntr).firstname   := v_firstname;
                tab_valid_employees(v_valid_emp_cntr).middlename  := v_middlename;
                tab_valid_employees(v_valid_emp_cntr).lastname    := v_lastname;
                tab_valid_employees(v_valid_emp_cntr).contractenddate := v_contractenddate;     --added on 22-Apr-2022
                If v_subcontractagency Is Not Null then
                    tab_valid_employees(v_valid_emp_cntr).subcontractAgency := v_subcontractagency; --added on 13-Sep-2023
                End If;
                tab_valid_employees(v_valid_emp_cntr).location := v_location;                   --added on 22-Apr-2022
                tab_valid_employees(v_valid_emp_cntr).place := v_place;                         --added on 22-Apr-2022
            End If;

        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_emp_cntr
        Loop
            add_employee(
                p_empno      => tab_valid_employees(i).empno,
                p_abbr       => Null,
                p_emptype    => tab_valid_employees(i).emptype,
                p_email      => Null,
                p_parent     => tab_valid_employees(i).parent,
                p_desgcode   => tab_valid_employees(i).designation,
                p_dob        => tab_valid_employees(i).dob,
                p_doj        => tab_valid_employees(i).doj,
                p_office     => tab_valid_employees(i).office,
                p_sex        => tab_valid_employees(i).gender,
                p_category   => tab_valid_employees(i).category,
                p_married    => Null,
                p_metaid     => Null,
                p_personid   => Null,
                p_grade      => tab_valid_employees(i).grade,
                p_company    => 'TICB',
                p_firstname  => tab_valid_employees(i).firstname,
                p_middlename => tab_valid_employees(i).middlename,
                p_lastname   => tab_valid_employees(i).lastname,
                p_success    => v_msg_type,
                p_message    => v_msg_text
            );

            If v_msg_type <> 'OK' Then
                v_err_num := v_err_num + 1;
                p_employees_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    v_msg_text;             --Message
            Else
                Update
                    hr_emplmast_organization
                Set
                    contract_end_date = tab_valid_employees(i).contractenddate,
                    subcontract = nvl(tab_valid_employees(i).subcontractagency, subcontract),
                    location = tab_valid_employees(i).location,
                    place = tab_valid_employees(i).place
                Where
                    empno = tab_valid_employees(i).empno;

                --added on 22-Apr-2022
                Update
                    hr_emplmast_applications
                Set
                   payroll = 1,
                   submit = 1
                Where
                    empno = tab_valid_employees(i).empno;

                Update
                    emplmast
                Set
                    contract_end_date = tab_valid_employees(i).contractenddate,
                    subcontract = nvl(tab_valid_employees(i).subcontractagency, subcontract),
                    location = tab_valid_employees(i).location,
                    place = tab_valid_employees(i).place,
                    payroll = 1,
                    submit = 1,
                    company = 'TICB'
                Where
                    empno = tab_valid_employees(i).empno;
            End If;
        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_employees;

   procedure bulk_hod_mngr_change (
        p_hod_mngr_old  varchar2,
        p_hod_mngr_new  varchar2,
        p_type          varchar2,
        p_success       Out        Varchar2,
        p_message       Out        Varchar2
    ) as
    begin
      if p_type = 'H' then
          update
            hr_emplmast_organization heo
          set
            heo.emp_hod = p_hod_mngr_new
          where
            heo.emp_hod = p_hod_mngr_old
            and exists (select
                            1
                        from
                            hr_emplmast_main  hem
                        where
                            hem.status = 1
                            and hem.empno = heo.empno);

          update
            emplmast
          set
            emp_hod = p_hod_mngr_new
          where
            status = 1 and
            emp_hod = p_hod_mngr_old;
      elsif p_type = 'M' then
          update
            hr_emplmast_organization heo
          set
            heo.mngr = p_hod_mngr_new
          where
            heo.mngr = p_hod_mngr_old
            and exists (select
                            1
                        from
                            hr_emplmast_main  hem
                        where
                            hem.status = 1
                            and hem.empno = heo.empno);

          update
            emplmast
          set
            mngr = p_hod_mngr_new
          where
            status = 1 and
            mngr = p_hod_mngr_old;
      end if;
      p_success   := 'OK';
      p_message   := 'Employee master updated successfully';
   end bulk_hod_mngr_change;

Procedure import_custom_employee_master(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_employees_json        Blob,
        p_employees_errors  Out Sys_Refcursor,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_empno_remarks              Varchar2(200);
        v_category_remarks           Varchar2(200);
        v_desgcode_remarks           Varchar2(200);
        v_doc_remarks                Varchar2(200);
        v_grade_remarks              Varchar2(200);
        v_married_remarks            Varchar2(200);
        v_assign_remarks             Varchar2(200);
        v_abbrivation_remarks        Varchar2(200);
        v_email_remarks              Varchar2(200);
        v_personid_remarks           Varchar2(200);
        v_metaid_remarks             Varchar2(200);
        v_address1_remarks           Varchar2(200);
        v_address2_remarks           Varchar2(200);
        v_address3_remarks           Varchar2(200);
        v_address4_remarks           Varchar2(200);
        v_pin_remarks                Varchar2(200);
        v_aadharno_remarks           Varchar2(200);
        v_bankcode_remarks           Varchar2(200);
        v_dol_remarks                Varchar2(200);
        v_emphod_remarks             Varchar2(200);
        v_expbefore_remarks          Varchar2(200);
        v_gradyear_remarks           Varchar2(200);
        v_graduation_remarks         Varchar2(200);
        v_gratutityno_remarks        Varchar2(200);
        v_itno_remarks               Varchar2(200);
        v_mngr_remarks               Varchar2(200);
        v_pensionno_remarks          Varchar2(200);
        v_pfno_remarks               Varchar2(200);
        v_reasonid_remarks           Varchar2(200);
        v_remarks_remarks            Varchar2(200);
        v_qualgroup_remarks          Varchar2(200);
        v_superannuationno_remarks   Varchar2(200);
        v_uanno_remarks              Varchar2(200);
        v_place_remarks              Varchar2(200);
        v_payroll_remarks            Varchar2(200);
        v_submit_remarks             Varchar2(200);
        v_qualificationid_remarks    Varchar2(200);
        v_deptcode_remarks           Varchar2(200);
        v_jobcategory_remarks        Varchar2(200);
        v_jobgroupcode_remarks       Varchar2(200);
        v_jobdisciplinecode_remarks  Varchar2(200);
        v_jobtitlecode_remarks       Varchar2(200);

        v_exists_qualification_id Number := 0;
        v_err_num                 Number;
        v_xl_row_number           Number := 0;
        is_error_in_row           Boolean;
        v_count                   Number;

        v_success                 Varchar2(200);
        v_message                 Varchar2(200);

        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table(p_employees_json Format Json, '$[*]'
                    Columns (
                        Empno               Varchar2(5)   Path '$.Empno',
                        Category            Varchar2(1)   Path '$.Category',
                        Desgcode            Varchar2(6)   Path '$.Desgcode',
                        Doc                 Date          Path '$.Doc',
                        Grade               Varchar2(2)   Path '$.Grade',
                        Married             Varchar2(1)   Path '$.Married',
                        Assign              Varchar2(4)   Path '$.Assign',
                        Abbrivation	        Varchar2(5)   Path '$.Abbrivation',
                        Email               Varchar2(100) Path '$.Email',
                        Personid            Varchar2(8)   Path '$.Personid',
                        Metaid              Varchar2(20)  Path '$.Metaid',
                        Address1            Varchar2(50)  Path '$.Address1',
                        Address2            Varchar2(50)  Path '$.Address2',
                        Address3            Varchar2(50)  Path '$.Address3',
                        Address4            Varchar2(50)  Path '$.Address4',
                        Pin                 Number(6)     Path '$.Pin',
                        Aadharno            Varchar2(12)  Path '$.Aadharno',
                        Bankcode            Varchar2(3)   Path '$.Bankcode',
                        Dol                 Date          Path '$.Dol',
                        EmpHod              Varchar2(5)   Path '$.EmpHod',
                        Expbefore           Number        Path '$.Expbefore',
                        Gradyear            Varchar2(4)   Path '$.Gradyear',
                        Graduation          Varchar2(2)   Path '$.Graduation',
                        Gratutityno         Varchar2(18)  Path '$.Gratutityno',
                        Itno                Varchar2(10)  Path '$.Itno',
                        Mngr                Varchar2(5)   Path '$.Mngr',
                        Pensionno           Varchar2(20)  Path '$.Pensionno',
                        Pfno                Varchar2(22)  Path '$.Pfno',
                        Reasonid            Varchar2(3)   Path '$.Reasonid',
                        Remarks             Varchar2(200) Path '$.Remarks',
                        QualGroup           Number        Path '$.QualGroup',
                        Superannuationno    Varchar2(15)  Path '$.Superannuationno',
                        Uanno               Varchar2(12)  Path '$.Uanno',
                        Place               Varchar2(3)   Path '$.Place',
                        Payroll             Number        Path '$.Payroll',
                        Submit              Number        Path '$.Submit',
                        QualificationId     Varchar2(100) Path '$.QualificationId',
                        DeptCode            Varchar2(2)   Path '$.DeptCode',
                        Jobcategory         Varchar2(5)   Path '$.Jobcategory',
                        JobGroupCode	    Varchar2(8)   Path '$.JobGroupCode',
                        JobDisciplineCode   Varchar2(8)   Path '$.JobDisciplineCode',
                        JobtitleCode        Varchar2(15)  Path '$.JobtitleCode'
                    )
                ) As "JT";
   Begin
        v_err_num := 0;

        For c1 In cur_json
        Loop
            is_error_in_row              := false;
            v_empno_remarks              := Null;
            v_category_remarks           := Null;
            v_desgcode_remarks           := Null;
            v_doc_remarks                := Null;
            v_grade_remarks              := Null;
            v_married_remarks            := Null;
            v_assign_remarks             := Null;
            v_abbrivation_remarks        := Null;
            v_email_remarks              := Null;
            v_personid_remarks           := Null;
            v_metaid_remarks             := Null;
            v_address1_remarks           := Null;
            v_address2_remarks           := Null;
            v_address3_remarks           := Null;
            v_address4_remarks           := Null;
            v_pin_remarks                := Null;
            v_aadharno_remarks           := Null;
            v_bankcode_remarks           := Null;
            v_dol_remarks                := Null;
            v_emphod_remarks             := Null;
            v_expbefore_remarks          := Null;
            v_gradyear_remarks           := Null;
            v_graduation_remarks         := Null;
            v_gratutityno_remarks        := Null;
            v_itno_remarks               := Null;
            v_mngr_remarks               := Null;
            v_pensionno_remarks          := Null;
            v_pfno_remarks               := Null;
            v_reasonid_remarks           := Null;
            v_remarks_remarks            := Null;
            v_qualgroup_remarks          := Null;
            v_superannuationno_remarks   := Null;
            v_uanno_remarks              := Null;
            v_place_remarks              := Null;
            v_payroll_remarks            := Null;
            v_submit_remarks             := Null;
            v_qualificationid_remarks    := Null;
            v_deptcode_remarks           := Null;
            v_jobcategory_remarks        := Null;
            v_jobgroupcode_remarks       := Null;
            v_jobdisciplinecode_remarks  := Null;
            v_jobtitlecode_remarks       := Null;

            v_xl_row_number              := v_xl_row_number + 1;

            /**** Empno ****/

            validate_cell_values(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_datatype        => 'String',
                p_datasize        => 5,
                p_cell_value      => c1.empno,
                p_colname         => 'Empno',
                p_message_remarks => v_empno_remarks);

            If v_empno_remarks Is Not Null Then
                v_err_num           := v_err_num + 1;
                is_error_in_row     := true;

                tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,
                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Empno',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_empno_remarks,
                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            /**** Category ****/

            If c1.category Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 5,
                    p_cell_value      => c1.category,
                    p_colname         => 'Category',
                    p_message_remarks => v_category_remarks);

                If v_category_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Category',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_category_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Desgcode ****/

            If c1.desgcode Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 6,
                    p_cell_value      => c1.desgcode,
                    p_colname         => 'Desgcode',
                    p_message_remarks => v_desgcode_remarks);

                If v_desgcode_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Desgcode',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_desgcode_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Doc ****/

            If c1.doc Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'Date',
                    p_datasize        => null,
                    p_cell_value      => c1.doc,
                    p_colname         => 'Doc',
                    p_message_remarks => v_doc_remarks);

                If v_doc_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Doc',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_doc_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Grade ****/

            If c1.grade Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 2,
                    p_cell_value      => c1.grade,
                    p_colname         => 'Grade',
                    p_message_remarks => v_grade_remarks);

                If v_grade_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Grade',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_grade_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Married ****/

            If c1.married Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 1,
                    p_cell_value      => c1.married,
                    p_colname         => 'Married',
                    p_message_remarks => v_married_remarks);

                If v_married_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Married',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_married_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Assign ****/

            If c1.assign Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 4,
                    p_cell_value      => c1.assign,
                    p_colname         => 'Assign',
                    p_message_remarks => v_assign_remarks);

                If v_assign_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Assign',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_assign_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Abbrivation ****/

            If c1.abbrivation Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 5,
                    p_cell_value      => c1.abbrivation,
                    p_colname         => 'Abbrivation',
                    p_message_remarks => v_abbrivation_remarks);

                If v_abbrivation_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Abbrivation',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_abbrivation_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Email	****/

            If c1.email Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 100,
                    p_cell_value      => c1.email,
                    p_colname         => 'Email',
                    p_message_remarks => v_email_remarks);

                If v_email_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Email',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_email_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Personid	****/

            If c1.personid Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 8,
                    p_cell_value      => c1.personid,
                    p_colname         => 'Personid',
                    p_message_remarks => v_personid_remarks);

                If v_personid_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Personid',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_personid_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Metaid ****/

            If c1.metaid Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 20,
                    p_cell_value      => c1.metaid,
                    p_colname         => 'Metaid',
                    p_message_remarks => v_metaid_remarks);

                If v_metaid_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Metaid',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_metaid_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Address1 ****/

            If c1.address1 Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 50,
                    p_cell_value      => c1.address1,
                    p_colname         => 'Address1',
                    p_message_remarks => v_address1_remarks);

                If v_address1_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Address1',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_address1_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Address2 ****/

            If c1.address2 Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 50,
                    p_cell_value      => c1.address2,
                    p_colname         => 'Address2',
                    p_message_remarks => v_address2_remarks);

                If v_address2_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Address2',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_address2_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Address3 ****/

            If c1.address3 Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 50,
                    p_cell_value      => c1.address3,
                    p_colname         => 'Address3',
                    p_message_remarks => v_address3_remarks);

                If v_address3_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Address3',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_address3_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Address4 ****/

            If c1.address4 Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 50,
                    p_cell_value      => c1.address4,
                    p_colname         => 'Address4',
                    p_message_remarks => v_address4_remarks);

                If v_address4_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Address4',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_address4_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Pin ****/

            If c1.pin Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'Number',
                    p_datasize        => 6,
                    p_cell_value      => c1.pin,
                    p_colname         => 'Pin',
                    p_message_remarks => v_pin_remarks);

                If v_pin_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Pin',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_pin_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Aadharno ****/

            If c1.aadharno Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 12,
                    p_cell_value      => c1.aadharno,
                    p_colname         => 'Aadharno',
                    p_message_remarks => v_aadharno_remarks);

                If v_aadharno_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Aadharno',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_aadharno_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Bankcode ****/

            If c1.bankcode Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 3,
                    p_cell_value      => c1.bankcode,
                    p_colname         => 'Bankcode',
                    p_message_remarks => v_bankcode_remarks);

                If v_bankcode_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Bankcode',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_bankcode_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Dol ****/

            If c1.dol Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'Date',
                    p_datasize        => null,
                    p_cell_value      => c1.dol,
                    p_colname         => 'Dol',
                    p_message_remarks => v_dol_remarks);

                If v_dol_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Dol',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_dol_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** EmpHod ****/

            If c1.emphod Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 5,
                    p_cell_value      => c1.emphod,
                    p_colname         => 'EmpHod',
                    p_message_remarks => v_emphod_remarks);

                If v_emphod_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'EmpHod',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_emphod_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Expbefore ****/

            If c1.expbefore Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'Float',
                    p_datasize        => 5,
                    p_cell_value      => c1.expbefore,
                    p_colname         => 'Expbefore',
                    p_message_remarks => v_expbefore_remarks);

                If v_expbefore_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Expbefore',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_expbefore_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Gradyear ****/

            If c1.gradyear Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 4,
                    p_cell_value      => c1.gradyear,
                    p_colname         => 'Gradyear',
                    p_message_remarks => v_gradyear_remarks);

                If v_gradyear_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Gradyear',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_gradyear_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Graduation ****/

            If c1.graduation Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 2,
                    p_cell_value      => c1.graduation,
                    p_colname         => 'Graduation',
                    p_message_remarks => v_graduation_remarks);

                If v_graduation_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Graduation',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_graduation_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Gratutityno ****/

            If c1.gratutityno Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 18,
                    p_cell_value      => c1.gratutityno,
                    p_colname         => 'Gratutityno',
                    p_message_remarks => v_gratutityno_remarks);

                If v_gratutityno_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Gratutityno',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_gratutityno_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Itno ****/

            If c1.itno Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 10,
                    p_cell_value      => c1.itno,
                    p_colname         => 'Itno',
                    p_message_remarks => v_itno_remarks);

                If v_itno_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Itno',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_itno_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Mngr ****/

            If c1.mngr Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 10,
                    p_cell_value      => c1.mngr,
                    p_colname         => 'Mngr',
                    p_message_remarks => v_mngr_remarks);

                If v_mngr_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Mngr',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_mngr_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Pensionno ****/

            If c1.pensionno Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 20,
                    p_cell_value      => c1.pensionno,
                    p_colname         => 'Pensionno',
                    p_message_remarks => v_pensionno_remarks);

                If v_pensionno_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Pensionno',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_pensionno_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Pfno ****/

            If c1.pfno Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 22,
                    p_cell_value      => c1.pfno,
                    p_colname         => 'Pfno',
                    p_message_remarks => v_pfno_remarks);

                If v_pfno_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Pfno',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_pfno_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Reasonid ****/

            If c1.reasonid Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 3,
                    p_cell_value      => c1.reasonid,
                    p_colname         => 'Reasonid',
                    p_message_remarks => v_reasonid_remarks);

                If v_reasonid_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Reasonid',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_reasonid_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Remarks ****/

            If c1.remarks Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 200,
                    p_cell_value      => c1.remarks,
                    p_colname         => 'Remarks',
                    p_message_remarks => v_remarks_remarks);

                If v_remarks_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Remarks',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_remarks_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** QualGroup ****/

            If c1.qualgroup Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'Number',
                    p_datasize        => 1,
                    p_cell_value      => c1.qualgroup,
                    p_colname         => 'QualGroup',
                    p_message_remarks => v_qualgroup_remarks);

                If v_qualgroup_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'QualGroup',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_qualgroup_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Superannuationno ****/

            If c1.superannuationno Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 15,
                    p_cell_value      => c1.superannuationno,
                    p_colname         => 'Superannuationno',
                    p_message_remarks => v_superannuationno_remarks);

                If v_superannuationno_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Superannuationno',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_superannuationno_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Uanno ****/

            If c1.uanno Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 12,
                    p_cell_value      => c1.uanno,
                    p_colname         => 'Uanno',
                    p_message_remarks => v_uanno_remarks);

                If v_uanno_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Uanno',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_uanno_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Place ****/

            If c1.place Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 3,
                    p_cell_value      => c1.place,
                    p_colname         => 'Place',
                    p_message_remarks => v_place_remarks);

                If v_place_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Place',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_place_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Payroll ****/

            If c1.payroll Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'Number',
                    p_datasize        => 1,
                    p_cell_value      => c1.payroll,
                    p_colname         => 'Payroll',
                    p_message_remarks => v_payroll_remarks);

                If v_payroll_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Payroll',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_payroll_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Submit ****/

            If c1.submit Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'Number',
                    p_datasize        => 1,
                    p_cell_value      => c1.submit,
                    p_colname         => 'Submit',
                    p_message_remarks => v_submit_remarks);

                If v_submit_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Submit',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_submit_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** QualificationId ****/

            If c1.qualificationid Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 100,
                    p_cell_value      => c1.qualificationid,
                    p_colname         => 'QualificationId',
                    p_message_remarks => v_qualificationid_remarks);

                If v_qualificationid_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'QualificationId',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_qualificationid_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** DeptCode ****/

            If c1.deptcode Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 2,
                    p_cell_value      => c1.deptcode,
                    p_colname         => 'DeptCode',
                    p_message_remarks => v_deptCode_remarks);

                If v_deptcode_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'DeptCode',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_deptcode_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** Jobcategory ****/

            If c1.jobcategory Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 5,
                    p_cell_value      => c1.jobcategory,
                    p_colname         => 'Jobcategory',
                    p_message_remarks => v_deptCode_remarks);

                If v_jobcategory_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Jobcategory',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_jobcategory_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** JobGroupCode ****/

            If c1.jobgroupcode Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 8,
                    p_cell_value      => c1.jobgroupcode,
                    p_colname         => 'JobGroupCode',
                    p_message_remarks => v_jobgroupcode_remarks);

                If v_jobgroupcode_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'JobGroupCode',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_jobgroupcode_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** JobDisciplineCode ****/

            If c1.jobdisciplinecode Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 8,
                    p_cell_value      => c1.jobdisciplinecode,
                    p_colname         => 'JobDisciplineCode',
                    p_message_remarks => v_jobdisciplinecode_remarks);

                If v_jobdisciplinecode_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'JobDisciplineCode',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_jobdisciplinecode_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /**** JobtitleCode ****/

            If c1.jobtitlecode Is Not Null then
                validate_cell_values(
                    p_person_id       => p_person_id,
                    p_meta_id         => p_meta_id,
                    p_datatype        => 'String',
                    p_datasize        => 15,
                    p_cell_value      => c1.jobtitlecode,
                    p_colname         => 'JobtitleCode',
                    p_message_remarks => v_jobtitlecode_remarks);

                If v_jobtitlecode_remarks Is Not Null Then
                    v_err_num           := v_err_num + 1;
                    is_error_in_row     := true;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'JobtitleCode',
                        p_error_type        => 0,
                        p_error_type_string => 'Critical',
                        p_message           => v_jobtitlecode_remarks,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;
            End If;

            /*------ Update HR Master -------*/

            If is_error_in_row = false Then

                Update hr_emplmast_main
                    Set Category = nvl(c1.Category, Category),
                        Desgcode = nvl(c1.Desgcode, Desgcode),
                        Doc = nvl(c1.Doc, Doc),
                        Grade = nvl(c1.Grade, Grade),
                        Married = nvl(c1.Married, Married),
                        Assign = nvl(c1.Assign, Assign),
                        Abbr = nvl(c1.Abbrivation, Abbr),
                        Email = nvl(c1.Email, Email),
                        Personid = nvl(c1.Personid, Personid),
                        Metaid = nvl(c1.Metaid, Metaid)
                    where upper(Empno) = upper(c1.Empno);

                Update hr_emplmast_address
                    Set Add1 = nvl(c1.Address1, Add1),
                        Add2 = nvl(c1.Address2, Add2),
                        Add3 = nvl(c1.Address3, Add3),
                        Add4 = nvl(c1.Address4, Add4),
                        Pincode = nvl(c1.Pin, Pincode)
                    where upper(Empno) = upper(c1.Empno);

                Update hr_emplmast_organization
                    Set Aadharno = nvl(c1.Aadharno, Aadharno),
                        Bankcode = nvl(c1.Bankcode, Bankcode),
                        Dol = nvl(c1.Dol, Dol),
                        Emp_Hod = nvl(c1.EmpHod, Emp_Hod),
                        Expbefore = nvl(c1.Expbefore, Expbefore),
                        Gradyear = nvl(c1.Gradyear, Gradyear),
                        Graduation = nvl(c1.Graduation, Graduation),
                        Gratutityno = nvl(c1.Gratutityno, Gratutityno),
                        Itno = nvl(c1.Itno, Itno),
                        Mngr = nvl(c1.Mngr, Mngr),
                        Pensionno = nvl(c1.Pensionno, Pensionno),
                        Pfno = nvl(c1.Pfno, Pfno),
                        Reasonid = nvl(c1.Reasonid, Reasonid),
                        Remarks = nvl(c1.Remarks, Remarks),
                        Qual_Group = nvl(c1.QualGroup, Qual_Group),
                        Superannuationno = nvl(c1.Superannuationno, Superannuationno),
                        Uanno = nvl(c1.Uanno, Uanno),
                        Place = nvl(c1.Place, Place)
                     where upper(Empno) = upper(c1.Empno);

                Update hr_emplmast_applications
                    Set Payroll = nvl(c1.Payroll, Payroll),
                        Submit = nvl(c1.Submit, Submit)
                    where upper(Empno) = upper(c1.Empno);

                If c1.QualificationId Is Not Null Then
                    hr_pkg_emplmast_tabs.ins_del_emplmast_qualification(c1.empno, replace(c1.QualificationId,' ',''), v_success, v_message);
                    /*select
                        count(qualification_id)
                    Into
                        v_exists_qualification_id
                    from
                        hr_emplmast_organization_qual
                    where
                        upper(Empno) = upper(c1.Empno);

                    If v_exists_qualification_id = 0 Then
                        Insert into hr_emplmast_organization_qual(empno, qualification_id)
                            values(upper(c1.Empno), c1.QualificationId);
                    End If; */
                End If;

                Update hr_emplmast_misc
                    Set Dept_Code = nvl(c1.DeptCode, Dept_Code),
                        Jobcategory = nvl(c1.Jobcategory, Jobcategory),
                        Jobgroup = nvl(c1.JobGroupCode, Jobgroup),
                        Jobgroupdesc = nvl(hr_pkg_common.get_jobgroup_desc(c1.JobGroupCode), Jobgroupdesc),
                        Jobdiscipline = nvl(c1.JobDisciplineCode, Jobtitle_Code),
                        Jobdisciplinedesc = nvl(hr_pkg_common.get_jobdiscipline_desc(c1.JobDisciplineCode), Jobdisciplinedesc),
                        Jobtitle_Code = nvl(c1.JobtitleCode, Jobtitle_Code),
                        Jobtitledesc = nvl(hr_pkg_common.get_jobtitle_desc(c1.JobtitleCode), Jobtitledesc),
                        Jobgroupdesc_milan = nvl(hr_pkg_common.get_jobgroup_milan_desc(c1.JobGroupCode), Jobgroupdesc_milan)
                    where upper(Empno) = upper(c1.Empno);

                Update emplmast
                    Set Category = nvl(c1.Category, Category),
                        Desgcode = nvl(c1.Desgcode, Desgcode),
                        Doc = nvl(c1.Doc, Doc),
                        Grade = nvl(c1.Grade, Grade),
                        Married = nvl(c1.Married, Married),
                        Assign = nvl(c1.Assign, Assign),
                        Abbr = nvl(c1.Abbrivation, Abbr),
                        Email = nvl(c1.Email, Email),
                        Personid = nvl(c1.Personid, Personid),
                        Metaid = nvl(c1.Metaid, Metaid),
                        Add1 = nvl(c1.Address1, Add1),
                        Add2 = nvl(c1.Address2, Add2),
                        Add3 = nvl(c1.Address3, Add3),
                        Add4 = nvl(c1.Address4, Add4),
                        Pincode = nvl(c1.Pin, Pincode),
                        Aadharno = nvl(c1.Aadharno, Aadharno),
                        Bankcode = nvl(c1.Bankcode, Bankcode),
                        Dol = nvl(c1.Dol, Dol),
                        Emp_Hod = nvl(c1.EmpHod, Emp_Hod),
                        Expbefore = nvl(c1.Expbefore, Expbefore),
                        Gradyear = nvl(c1.Gradyear, Gradyear),
                        Graduation = nvl(c1.Graduation, Graduation),
                        Gratutityno = nvl(c1.Gratutityno, Gratutityno),
                        Itno = nvl(c1.Itno, Itno),
                        Mngr = nvl(c1.Mngr, Mngr),
                        Pensionno = nvl(c1.Pensionno, Pensionno),
                        Pfno = nvl(c1.Pfno, Pfno),
                        Reasonid = nvl(c1.Reasonid, Reasonid),
                        Remarks = nvl(c1.Remarks, Remarks),
                        Qual_Group = nvl(c1.QualGroup, Qual_Group),
                        Superannuationno = nvl(c1.Superannuationno, Superannuationno),
                        Uanno = nvl(c1.Uanno, Uanno),
                        Place = nvl(c1.Place, Place),
                        Payroll = nvl(c1.Payroll, Payroll),
                        Submit = nvl(c1.Submit, Submit),
                        Dept_Code = nvl(c1.DeptCode, Dept_Code),
                        Jobcategory = nvl(c1.Jobcategory, Jobcategory),
                        Jobgroup = nvl(c1.JobGroupCode, Jobgroup),
                        Jobgroupdesc = nvl(hr_pkg_common.get_jobgroup_desc(c1.JobGroupCode), Jobgroupdesc),
                        Jobdiscipline = nvl(c1.JobDisciplineCode, Jobtitle_Code),
                        Jobdisciplinedesc = nvl(hr_pkg_common.get_jobdiscipline_desc(c1.JobDisciplineCode), Jobdisciplinedesc),
                        Jobtitle_Code = nvl(c1.JobtitleCode, Jobtitle_Code),
                        Jobtitledesc = nvl(hr_pkg_common.get_jobtitle_desc(c1.JobtitleCode), Jobtitledesc),
                        Jobgroupdesc_milan = nvl(hr_pkg_common.get_jobgroup_milan_desc(c1.JobGroupCode), Jobgroupdesc_milan)
                    where upper(Empno) = upper(c1.Empno);

                commit;
            End If;

        End Loop;

        If v_err_num != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := ok;
            p_message_text := 'File imported successfully.';
        End If;

        p_employees_errors := tcmpl_app_config.pkg_process_excel_import_errors.fn_read_error_list(p_person_id => p_person_id,
                                                                                                  p_meta_id   => p_meta_id);
        Commit;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_custom_employee_master;

  Procedure validate_cell_values(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_datatype            Varchar2,
        p_datasize            Number Default Null,
        p_cell_value          Varchar2,
        p_colname             Varchar2,
        p_message_remarks Out Varchar2
    ) as
        v_datasize            Number;
        v_isdate              Number := 0;
        v_isflaot             Number := 0;
        v_float_cell_value    Number(5,2);
        --v_cellvalue           Number;
    Begin
        v_datasize := To_Number(nvl(p_datasize, 0));
        If p_datatype = 'Number' Then
            If length(p_cell_value) > v_datasize Then
                p_message_remarks := p_colname || ' should have max. ' || v_datasize || ' digits';
            End If;
        Elsif p_datatype = 'Float' Then
            v_float_cell_value := to_number(p_cell_value);
            --If v_float_cell_value >= to_number('0') and v_float_cell_value < to_number('100') Then
            --    p_message_remarks := p_colname || ' should be between 0.00 and 99.99';
            --End If;
            select
              case
                when v_float_cell_value >= 0 and v_float_cell_value < 100 then
                    1
                else
                    0
                end Into v_isflaot
            from dual;

            If v_isflaot = 0 Then
                p_message_remarks := p_colname || ' should be between 0.00 and 99.99';
            End If;
        Elsif p_datatype = 'Date' Then
            select
              case
                when to_timestamp(p_cell_value,'YYYY-MM-DD HH24:MI:SS.FF') is not null then
                --when regexp_substr(p_cell_value,'^[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{4}$') is not null then
                    1
                else
                    0
              end Into v_isdate
            from dual;

            If v_isdate = 0 Then
                p_message_remarks := p_colname || ' should be in correct date (dd-mm-yyyy) format';
            End If;
        Else
            If length(p_cell_value) > v_datasize Then
                p_message_remarks := p_colname || ' should have max. ' || v_datasize || ' characters';
            End If;
        End if;
    Exception
        When Others Then
            p_message_remarks := 'should be in correct format';

  end validate_cell_values;



  function fn_employee_master_list (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_generic_search       Varchar2 Default Null,
        p_status               Number Default 1,
        p_row_number           Number,
        p_page_length          Number
    ) Return Sys_Refcursor as
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
                *
            From
                (
                    Select
                        hem.*,
                        hr_pkg_common.get_costcenter_abbr(hem.parent)  parent_abbr,
                        hr_pkg_common.get_costcenter_abbr(hem.assign)  assign_abbr,
                        hr_pkg_common.get_sap_cc_name(hem.parent)      sap_parent,
                        hr_pkg_common.get_sap_cc_name(hem.assign)      sap_assign,
                        hr_pkg_common.is_editable_emplmast(v_empno)    is_editable,

                        Row_Number() Over (Order By hem.empno)                  row_number,
                        Count(*) Over ()                                        total_row
                    From
                        hr_emplmast_main hem
                    Where
                        hem.status = p_status And
                        (upper(hem.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                        upper(hem.name) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                        upper(hem.parent) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                        upper(hem.assign) Like '%' || upper(Trim(p_generic_search)) || '%')
                    Order by
                        hem.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    end fn_employee_master_list;

    function fn_employee_master_list_Excel (
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_generic_search       Varchar2 Default Null,
        p_status               Varchar2 Default 1

    ) Return Sys_Refcursor as
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
            select
                emm.empno,
                emm.personid,
                initcap(emm.name) name,
                decode(emm.status, 1, 'True', 'False') status,
                decode(ema.payroll, 1, 'True', 'False') payroll,
                emm.emptype ||'-'||
                  etm.empdesc emptype,
                emm.email,
                emm.parent,
                cmm1.abbr parent_name,
                hr_pkg_common.get_sap_cc_name(emm.parent) sap_parent,
                emm.assign,
                cmm2.abbr assign_name,
                hr_pkg_common.get_sap_cc_name(emm.assign) sap_assign,
                Case cmm1.engg_nonengg
                    When 'E' Then 'Engineering'
                    When 'N' Then 'Non engineering'
                    Else ''
                End As Engg_nonengg,
                dm.desgcode,
                dm.desg,
                dm.desg_new,
                emm.grade,
                gm.gender_desc gender,
                emm.category,
                emm.married,
                trunc(emm.dob) dob,
                trunc(emm.doj) doj,
                trunc(emm.doc) doc,
                trunc(emo.dol) dol,
                trunc(emo.dor) dor,
                hr_pkg_common.get_qualification(emo.empno) qualificationdesc,
                hr_pkg_common.get_graduation(emo.graduation) graduationdesc,
                emo.gradyear,
                emo.expbefore,
                emo.location,
                emo.subcontract ||'-'||
                  hr_pkg_common.get_subcontract_name(emo.subcontract) subcontractname,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(emm.empno)) officelocation,
                emm.office,
                emm.metaid,
                emm.company,
                emo.mngr,
                initcap(hr_pkg_common.get_employee_name(emo.mngr)) mngr_name,
                emo.emp_hod,
                initcap(hr_pkg_common.get_employee_name(emo.emp_hod)) emp_hod_name,
                trim(emad.add1) add1,
                trim(emad.add2) add2,
                trim(emad.add3) add3,
                trim(emad.add4) add4,
                emad.pincode,
                emo.itno,
                emsc.pfslno,
                emo.pfno,
                emo.gratutityno,
                emo.aadharno,
                emo.superannuationno,
                emo.uanno,
                emo.pensionno,
                emm.firstname,
                emm.middlename,
                emm.lastname,
                emsc.jobgroup,
                emsc.jobgroupdesc,
                emsc.jobdiscipline,
                emsc.jobdisciplinedesc,
                emsc.jobtitle_code,
                emsc.jobtitledesc,
                emsc.jobgroupdesc_milan,
                emo.diploma_year,
                emo.postgraduation_year
            from
                hr_emplmast_main emm,
                hr_emplmast_organization emo,
                hr_emplmast_applications ema,
                hr_emplmast_address emad,
                hr_emplmast_misc emsc,
                hr_costmast_main cmm1,
                hr_costmast_main cmm2,
                desgmast dm,
                offimast om,
                emptypemast etm,
                hr_gender_master gm
            where
                emo.empno = emm.empno and
                ema.empno = emm.empno and
                emm.empno = emsc.empno and
                emm.empno = emad.empno and
                emm.parent = cmm1.costcode and
                emm.assign = cmm2.costcode and
                emm.desgcode = dm.desgcode and
                emm.emptype = etm.emptype and
                emm.sex = gm.gender_id(+) and
                emm.office = om.office and
                emm.status = p_status and
                (upper(emm.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                upper(emm.name) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                upper(emm.parent) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                upper(cmm1.abbr) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                upper(emm.assign) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                upper(cmm2.abbr) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                upper(emm.desgcode) Like '%' || upper(Trim(p_generic_search)) || '%'  Or
                upper(dm.desg) Like '%' || upper(Trim(p_generic_search)) || '%')
            Order by
                emm.empno;
        Return c;
    end fn_employee_master_list_Excel;

end hr_pkg_emplmast_main;

/
