--------------------------------------------------------
--  DDL for Package Body EMP_GEN_INFO_QRY
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."EMP_GEN_INFO_QRY" As

    Function fn_emp_gratuity_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
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
                key_id,
                empno,
                nom_name,
                nom_add1,
                relation,
                to_char(nom_dob, 'DD-Mon-YYYY') nom_dob,
                to_char(share_pcnt)             As share_pcnt,
                '1'                             As is_editable,
                Row_Number() Over (Order By
                        nom_name Desc)          row_number,
                Count(*) Over ()                total_row
            From
                emp_gratuity
            Where
                empno = nvl(Trim(p_empno), v_empno)
            Order By
                nom_dob Desc;

        Return c;
    End fn_emp_gratuity_list;

    Procedure sp_emp_gratuity_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_empno        Out Varchar2,
        p_nom_name     Out Varchar2,
        p_nom_add1     Out Varchar2,
        p_relation     Out Varchar2,
        p_nom_dob      Out Date,
        p_share_pcnt   Out Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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
            eg.empno,
            eg.nom_name,
            eg.nom_add1,
            eg.relation,
            eg.nom_dob,
            eg.share_pcnt
        Into
            p_empno,
            p_nom_name,
            p_nom_add1,
            p_relation,
            p_nom_dob,
            p_share_pcnt
        From
            emp_gratuity eg
        Where
            eg.key_id = Trim(p_key_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_gratuity_detail;

    Function fn_emp_superannuation_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
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
                key_id,
                empno,
                nom_name,
                nom_add1,
                relation,
                to_char(nom_dob, 'DD-Mon-YYYY') nom_dob,
                to_char(share_pcnt)             As share_pcnt,
                '1'                             As is_editable,
                Row_Number() Over (Order By
                        nom_name Desc)          row_number,
                Count(*) Over ()                total_row
            From
                emp_sup_annuation
            Where
                empno = nvl(Trim(p_empno), v_empno)
            Order By
                nom_dob Desc;
        Return c;
    End fn_emp_superannuation_list;

    Procedure sp_emp_superannuation_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_empno        Out Varchar2,
        p_nom_name     Out Varchar2,
        p_nom_add1     Out Varchar2,
        p_relation     Out Varchar2,
        p_nom_dob      Out Date,
        p_share_pcnt   Out Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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
            esa.empno,
            esa.nom_name,
            esa.nom_add1,
            esa.relation,
            esa.nom_dob,
            esa.share_pcnt
        Into
            p_empno,
            p_nom_name,
            p_nom_add1,
            p_relation,
            p_nom_dob,
            p_share_pcnt
        From
            emp_sup_annuation esa
        Where
            esa.key_id = Trim(p_key_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_superannuation_detail;

    Function fn_emp_provident_fund_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
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
                key_id,
                empno,
                nom_name,
                nom_add1,
                relation,
                to_char(nom_dob, 'DD-Mon-YYYY') nom_dob,
                to_char(share_pcnt)             As share_pcnt,
                nom_minor_guard_name            As guardian_name,
                nom_minor_guard_add1            As guardian_address,
                nom_minor_guard_relation        As guardian_relation,
                '1'                             As is_editable,
                Row_Number() Over (Order By
                        nom_name Desc)          row_number,
                Count(*) Over ()                total_row
            From
                emp_epf
            Where
                empno = nvl(Trim(p_empno), v_empno)
            Order By
                nom_dob Desc;
        Return c;
    End fn_emp_provident_fund_list;

    Procedure sp_emp_provident_fund_detail(
        p_person_id                    Varchar2,
        p_meta_id                      Varchar2,

        p_key_id                       Varchar2,

        p_empno                    Out Varchar2,
        p_nom_name                 Out Varchar2,
        p_nom_add1                 Out Varchar2,
        p_relation                 Out Varchar2,
        p_nom_dob                  Out Date,
        p_share_pcnt               Out Number,
        p_nom_minor_guard_name     Out Varchar2,
        p_nom_minor_guard_add1     Out Varchar2,
        p_nom_minor_guard_relation Out Varchar2,

        p_message_type             Out Varchar2,
        p_message_text             Out Varchar2
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
            ee.empno,
            ee.nom_name,
            ee.nom_add1,
            ee.relation,
            ee.nom_dob,
            ee.share_pcnt,
            ee.nom_minor_guard_name,
            ee.nom_minor_guard_add1,
            ee.nom_minor_guard_relation
        Into
            p_empno,
            p_nom_name,
            p_nom_add1,
            p_relation,
            p_nom_dob,
            p_share_pcnt,
            p_nom_minor_guard_name,
            p_nom_minor_guard_add1,
            p_nom_minor_guard_relation
        From
            emp_epf ee
        Where
            ee.key_id = Trim(p_key_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_provident_fund_detail;

    Function fn_emp_gtli_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
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
                key_id,
                empno,
                nom_name,
                nom_add1,
                relation,
                to_char(nom_dob, 'DD-Mon-YYYY')      nom_dob,
                to_char(share_pcnt)                  As share_pcnt,
                nom_minor_guard_name,
                nom_minor_guard_relation,
                nom_minor_guard_add1,
                'Name - ' || nom_minor_guard_name || Chr(10) || Chr(13) ||
                'Relation - ' || nom_minor_guard_relation || Chr(10) || Chr(13) ||
                'Address - ' || nom_minor_guard_add1 As minor_details,
                '1'                                  As is_editable,
                Row_Number() Over (Order By
                        nom_name Desc)               row_number,
                Count(*) Over ()                     total_row
            From
                emp_gtli
            Where
                empno = nvl(Trim(p_empno), v_empno)
            Order By
                nom_dob Desc;
        Return c;
    End fn_emp_gtli_list;

    Procedure sp_emp_gtli_detail(
        p_person_id                    Varchar2,
        p_meta_id                      Varchar2,

        p_key_id                       Varchar2,

        p_empno                    Out Varchar2,
        p_nom_name                 Out Varchar2,
        p_nom_add1                 Out Varchar2,
        p_relation                 Out Varchar2,
        p_nom_dob                  Out Date,
        p_share_pcnt               Out Number,
        p_nom_minor_guard_name     Out Varchar2,
        p_nom_minor_guard_relation Out Varchar2,
        p_nom_minor_guard_add1     Out Varchar2,

        p_message_type             Out Varchar2,
        p_message_text             Out Varchar2
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
            eg.empno,
            eg.nom_name,
            eg.nom_add1,
            eg.relation,
            eg.nom_dob,
            eg.share_pcnt,
            eg.nom_minor_guard_name,
            eg.nom_minor_guard_relation,
            eg.nom_minor_guard_add1
        Into
            p_empno,
            p_nom_name,
            p_nom_add1,
            p_relation,
            p_nom_dob,
            p_share_pcnt,
            p_nom_minor_guard_name,
            p_nom_minor_guard_relation,
            p_nom_minor_guard_add1
        From
            emp_gtli eg
        Where
            eg.key_id = Trim(p_key_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_gtli_detail;

    Function fn_emp_eps_4_all_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
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
                *
            From
                (

                    Select
                    Distinct
                        a.key_id                              As "KEY_ID",           -- VARCHAR2 
                        a.empno                               As "EMPNO",           -- VARCHAR2 
                        a.nom_name                            As "NOM_NAME",           -- VARCHAR2 
                        a.nom_add1                            As "NOM_ADD1",           -- VARCHAR2 
                        a.relation                            As "RELATION",           -- VARCHAR2 
                        to_char(a.nom_dob, 'DD-Mon-YYYY')     As "NOM_DOB",           -- DATE 
                        to_char(a.modified_on, 'DD-Mon-YYYY') As "MODIFIED_ON",           -- DATE 

                        Row_Number() Over (Order By a.empno)  row_number,
                        Count(*) Over ()                      total_row
                    From
                        emp_eps_4_all a
                    Where
                        a.empno = nvl(Trim(p_empno), v_empno)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_emp_eps_4_all_list;

    Procedure sp_emp_eps_4_all_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_empno        Out Varchar2,
        p_nom_name     Out Varchar2,
        p_nom_add1     Out Varchar2,
        p_relation     Out Varchar2,
        p_nom_dob      Out Date,
        p_modified_on  Out Date,

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

        Select
            Count(*)
        Into
            v_exists
        From
            emp_eps_4_all
        Where
            key_id = p_key_id;

        If v_exists = 1 Then

            Select
            Distinct empno,
                nom_name,
                nom_add1,
                relation,
                nom_dob,
                modified_on
            Into
                p_empno,
                p_nom_name,
                p_nom_add1,
                p_relation,
                p_nom_dob,
                p_modified_on
            From
                emp_eps_4_all

            Where
                key_id = p_key_id;

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee pension fund exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_eps_4_all_details;

    Function fn_emp_eps_4_married_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
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
                *
            From
                (

                    Select
                    Distinct
                        a.key_id                              As "KEY_ID",           -- VARCHAR2 
                        a.empno                               As "EMPNO",           -- VARCHAR2 
                        a.nom_name                            As "NOM_NAME",           -- VARCHAR2 
                        a.nom_add1                            As "NOM_ADD1",           -- VARCHAR2 
                        a.relation                            As "RELATION",           -- VARCHAR2 
                        to_char(a.nom_dob, 'DD-Mon-YYYY')     As "NOM_DOB",           -- DATE 
                        to_char(a.modified_on, 'DD-Mon-YYYY') As "MODIFIED_ON",           -- DATE 

                        Row_Number() Over (Order By a.empno)  row_number,
                        Count(*) Over ()                      total_row
                    From
                        emp_eps_4_married a
                    Where
                        a.empno = nvl(Trim(p_empno), v_empno)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_emp_eps_4_married_list;

    Procedure sp_emp_eps_4_married_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_empno        Out Varchar2,
        p_nom_name     Out Varchar2,
        p_nom_add1     Out Varchar2,
        p_relation     Out Varchar2,
        p_nom_dob      Out Date,
        p_modified_on  Out Date,

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

        Select
            Count(*)
        Into
            v_exists
        From
            emp_eps_4_married
        Where
            key_id = p_key_id;

        If v_exists = 1 Then

            Select
            Distinct empno,
                nom_name,
                nom_add1,
                relation,
                nom_dob,
                modified_on
            Into
                p_empno,
                p_nom_name,
                p_nom_add1,
                p_relation,
                p_nom_dob,
                p_modified_on
            From
                emp_eps_4_married

            Where
                key_id = p_key_id;

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee pension fund exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_eps_4_married_details;

    Procedure sp_emp_primary_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2 Default Null,

        p_first_name       Out Varchar2,
        p_surname          Out Varchar2,
        p_father_name      Out Varchar2,
        p_p_add            Out Varchar2,
        p_p_house_no       Out Varchar2,
        p_p_city           Out Varchar2,
        p_p_district       Out Varchar2,
        p_p_pincode        Out Varchar2,
        p_p_country        Out Varchar2,
        p_place_of_birth   Out Varchar2,
        p_country_of_birth Out Varchar2,
        p_nationality      Out Varchar2,
        p_p_phone          Out Varchar2,
        p_no_of_child      Out Varchar2,
        p_personal_email   Out Varchar2,
        p_p_mobile         Out Varchar2,
        p_dob              Out Varchar2,
        p_marital_status   Out Varchar2,
        p_religion         Out Varchar2,
        p_gender           Out Varchar2,

        p_emp_name         Out Varchar2,
        p_parent           Out Varchar2,
        p_cost_name        Out Varchar2,
        p_assign           Out Varchar2,
        p_assign_name      Out Varchar2,
        p_emptype          Out Varchar2,
        p_desg_code        Out Varchar2,
        p_desg_name        Out Varchar2,
        p_doj              Out Varchar2,
        p_hod              Out Varchar2,
        p_hod_name         Out Varchar2,
        p_secretary        Out Varchar2,
        p_secretary_name   Out Varchar2,
        p_grade            Out Varchar2,
        p_mngr_name        Out Varchar2,

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
            ed.name,
            ed.surname,
            ed.father_name,
            ed.p_add_1,
            ed.p_house_no,
            ed.p_city,
            ed.p_district,
            ed.p_pincode,
            ed.p_country,
            ed.place_of_birth,
            ed.country_of_birth,
            ed.nationality,
            ed.p_phone,
            ed.no_of_child,
            ed.personal_email,
            ed.p_mobile,
            to_char(ed.dob, 'DD-Mon-YYYY') dob,
            ed.marital_status,
            ed.religion,
            ove.sex
        Into
            p_first_name,
            p_surname,
            p_father_name,
            p_p_add,
            p_p_house_no,
            p_p_city,
            p_p_district,
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
            p_gender
        From
            emp_details                     ed, ofb_vu_emplmast ove
        Where
            ed.empno     = ove.empno
            And ed.empno = nvl(Trim(p_empno), v_empno);

        Select
            a.name,
            a.parent,
            b.name                    As costname,
            a.assign,
            e.name                    assignname,
            a.emptype,
            a.grade,
            a.desgcode,
            c.desg                    As desgname,
            a.doj,
            b.hod,
            get_emp_name(b.hod)       As hodname,
            b.secretary,
            get_emp_name(b.secretary) As sec_name,
            get_emp_name(a.mngr)      mngr_name
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
            And a.empno    = nvl(Trim(p_empno), v_empno);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_primary_detail;

    Procedure sp_emp_secondary_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2 Default Null,

        p_blood_group      Out Varchar2,
        p_religion         Out Varchar2,
        p_marital_status   Out Varchar2,
        p_r_add            Out Varchar2,
        p_r_house_no       Out Varchar2,
        p_r_city           Out Varchar2,
        p_r_pincode        Out Varchar2,
        p_r_district       Out Varchar2,
        p_r_country        Out Varchar2,
        p_phone_res        Out Varchar2,
        p_mobile_res       Out Varchar2,
        p_ref_person_name  Out Varchar2,
        p_f_add            Out Varchar2,
        p_f_house_no       Out Varchar2,
        p_f_city           Out Varchar2,
        p_f_district       Out Varchar2,
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
            Trim(empno) = nvl(Trim(p_empno), v_empno);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_secondary_detail;



    Procedure sp_emp_family_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_key_id              Varchar2,

        p_empno           Out Varchar2,
        p_member          Out Varchar2,
        p_dob             Out Date,
        p_relation_val    Out Number,
        p_occupation_val  Out Number,
        p_relation_text   Out Varchar2,
        p_occupation_text Out Varchar2,
        p_remarks         Out Varchar2,
        p_modified_on     Out Date,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
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
            emp_family
        Where
            key_id = p_key_id;

        If v_exists = 1 Then

            Select
            Distinct empno,
                member,
                dob,
                relation,
                occupation,
                rel.description || '(' || rel.gender || ')' As "RELATION_TEXT",           -- VARCHAR2 
                oc.description                              As "OCCUPATION_TEXT",           -- VARCHAR2 
                remarks,
                modified_on
            Into
                p_empno,
                p_member,
                p_dob,
                p_relation_val,
                p_occupation_val,
                p_relation_text,
                p_occupation_text,
                p_remarks,
                p_modified_on
            From
                emp_family                      a, emp_relation_mast rel, emp_occupation oc
            Where
                key_id       = p_key_id
                And oc.code  = a.occupation
                And rel.code = a.relation;

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee family exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_family_details;

    Function fn_emp_passport_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
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
                *
            From
                (
                    Select
                    Distinct
                        a.key_id                             As key_id,           -- VARCHAR2 
                        a.empno                              As empno,           -- VARCHAR2 
                        a.has_passport                       As has_passport,           -- VARCHAR2 
                        a.surname                            As surname,           -- VARCHAR2 
                        a.given_name                         As given_name,           -- VARCHAR2 
                        a.issued_at                          As issued_at,           -- VARCHAR2 
                        a.issue_date                         As issue_date,           -- DATE 
                        a.expiry_date                        As expiry_date,           -- DATE 
                        a.modified_on                        As modified_on,           -- DATE 
                        a.modified_by                        As modified_by,           -- VARCHAR2 

                        Row_Number() Over (Order By a.empno) row_number,
                        Count(*) Over ()                     total_row
                    From
                        emp_passport a
                    Where
                        a.empno = nvl(Trim(p_empno), v_empno)

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_emp_passport_list;

    Procedure sp_emp_passport_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,

        p_key_id       Out Varchar2,
        p_has_passport Out Varchar2,
        p_surname      Out Varchar2,
        p_given_name   Out Varchar2,
        p_issued_at    Out Varchar2,
        p_issue_date   Out Date,
        p_expiry_date  Out Date,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,

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

        Select
            Count(*)
        Into
            v_exists
        From
            emp_passport
        Where
            empno = nvl(Trim(p_empno), v_empno);

        If v_exists = 1 Then

            Select
            Distinct
                key_id,
                has_passport,
                surname,
                given_name,
                issued_at,
                issue_date,
                expiry_date,
                modified_on,
                modified_by
            Into
                p_key_id,
                p_has_passport,
                p_surname,
                p_given_name,
                p_issued_at,
                p_issue_date,
                p_expiry_date,
                p_modified_on,
                p_modified_by
            From
                emp_passport
            Where
                empno = nvl(Trim(p_empno), v_empno);

            Commit;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee passport exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_passport_details;

    Procedure sp_emp_adhaar_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,

        p_key_id       Out Varchar2,
        p_adhaar_no    Out Varchar2,
        p_adhaar_name  Out Varchar2,
        p_modified_on  Out Date,

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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            emp_adhaar
        Where
            empno = nvl(Trim(p_empno), v_empno);

        If v_exists = 1 Then

            Select
            Distinct key_id,
                adhaar_no,
                adhaar_name,
                modified_on
            Into
                p_key_id,
                p_adhaar_no,
                p_adhaar_name,
                p_modified_on
            From
                emp_adhaar
            Where
                empno = nvl(Trim(p_empno), v_empno);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

        Else
            p_message_type := 'KO';
            p_message_text := 'No matching Employee adhaar exists !!!';
        End If;

    Exception

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_adhaar_details;

End emp_gen_info_qry;
/
Grant Execute On "TCMPL_HR"."EMP_GEN_INFO_QRY" To "TCMPL_APP_CONFIG";
/